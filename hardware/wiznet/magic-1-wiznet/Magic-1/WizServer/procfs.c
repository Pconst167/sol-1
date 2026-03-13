#include "common.h"

#define PROCFS_SUSP (kSuspForRead | kSuspForData | kSuspForIoctl)
/*
 * open() is called on the master socket, and then allocate_socket
 * will return a non-wnet socket to use.
 */
void procfs_open(socket_t* sock, message* m) {
  int r;
  // This should be the master socket (allocate socket will check)
  r = allocate_socket(sock->sock_num);
  assert(sockets[r].linked_socket == NO_SOCKET);
  if (verbose > 0) {
    printf("procfs_open allocated fd %s\n", pr_fd(r));
  }
  wnet_reply(sock, m, r);
}

/*
 * close() should never be called on the master socket.
 */
void procfs_close(socket_t* sock, message* m) {
  if (verbose > 0) {
    printf("procfs_close for fd %s\n", pr_fd(sock->fd));
  }
  assert((sock->sock_num >= FIRST_PROCFS_SOCKET) && (sock->sock_num < NUM_SOCKETS));
  if (sock->linked_socket != NO_SOCKET) {
    socket_t* backlink_sock = &sockets[sock->linked_socket];
    assert(!(backlink_sock->flags & PROCFS_SUSP));  // Shouldn't happen? If it does, EINTR.
    backlink_sock->linked_socket = NO_SOCKET;
  }
  init_socket(sock->sock_num);
  wnet_reply(sock, m, OK);
}

void transfer_data(socket_t* writer, socket_t* reader) {
  message* readm = &reader->suspended_message;
  message* writem = &writer->suspended_message;
  u16_t chunk = min(readm->COUNT, writer->unread_bytes);
  assert(!(writer->flags & kSuspForRead));
  chunk = min(chunk, BIG_BUF_BYTE_SIZE);
  assert(chunk > 0);
  if (verbose > 0) {
    printf("transfer_data: Writing %u bytes\n", chunk);
  }
  copy_from_user(writem->PROC_NR,
      (vir_bytes)writem->ADDRESS + (writem->COUNT - writer->unread_bytes),
      (vir_bytes)big_buf, chunk);
  copy_to_user((vir_bytes)big_buf, readm->PROC_NR, (vir_bytes)readm->ADDRESS,
      chunk);
  writer->unread_bytes -= chunk;
  wnet_reply(reader, readm, chunk);
  if (writer->unread_bytes == 0) {
    // Writer is done with this call, let it resume.
    wnet_reply(writer, writem, (int)writem->COUNT);
  }
}

/*
 * If waiting on data from same proc_nr, then we either have more data to
 * pass, or we've reached the end.
 *
 * If no linked socket, this is a new request.
 */
void procfs_read(socket_t* sock, message* m) {
  socket_t* linked_socket = (sock->linked_socket == NO_SOCKET) ? NULL :
    &sockets[sock->linked_socket];
  assert(!(sock->flags & kSuspForIoctl));
  assert(!(sock->flags & kSuspForData));
  if (verbose > 0) {
    printf("procfs_read %u bytes from proc %u using fd %u\n",
        m->COUNT, m->PROC_NR, sock->sock_num);
  }
  if (sock->flags & kEOF) {
    if (verbose > 0) {
      printf("procfs_read EOF fd %u\n", sock->sock_num);
    }
    wnet_reply(sock, m, 0);
    return;
  }
  if (linked_socket == NULL) {
    // This is a new request.  See if writer is hanging on an ioctl.  If not,
    // block and wait.  FIXME: in this case, we must rely on caller to manage
    // timeout.
    int i;
    for (i = FIRST_PROCFS_SOCKET; i < NUM_SOCKETS; i++) {
      if ((sockets[i].flags & kSuspForRead) && (sock->protocol == sockets[i].protocol) &&
          (sockets[i].linked_socket == NO_SOCKET)) {
        // Got one, unblock writer and link our two sockets together.
        if (verbose > 0) {
          printf("procfs_read: unblock writer, report fd %d\n", sock->sock_num);
        }
        sockets[i].linked_socket = sock->sock_num;
        sock->linked_socket = i;
        // Writer is blocked. Unblock with our fd and wait for data.
        sockets[i].flags &= ~kSuspForRead;
        // Unblock writer
        wnet_reply(&sockets[i], &sockets[i].suspended_message, OK);
        // Now, wait for the writer to write.
        sock->flags |= kSuspForData;
        sock->suspended_message = *m;
        wnet_reply(sock, m, SUSPEND);
        return;
      }
    }
    // OK - the writer is busy with other things.  Need to wait for him to
    // ioctl.
    if (verbose > 0) {
      printf("procfs_read: no writer; kSuspForIoctl\n");
    }
    // Writer not currently waiting.  We must wait for ioctl.
    sock->flags |= kSuspForIoctl;
    sock->suspended_message = *m;
    wnet_reply(sock, m, SUSPEND);
    return;
  } else if (linked_socket->flags & kSuspForRead) {
    // We got the read we were waiting for.  Clear the flag.
    linked_socket->flags &= ~kSuspForRead;
  }
  // Now we have a linked socket.   Is any data available?
  if (linked_socket->unread_bytes > 0) {
    // Note: transfer_data will handle reply.
    transfer_data( /*writer*/ linked_socket, /*reader*/ sock);
  } else {
    // Suspend until writer has something for us to consume.
    sock->flags |= kSuspForData;
    sock->suspended_message = *m;
    wnet_reply(sock, m, SUSPEND);
  }
}

/*
 * On write, writer should have a linked socket (possibly) waiting for data and
 * some amount of ready data.
 */
void procfs_write(socket_t* sock, message* m) {
  socket_t* linked_socket = (sock->linked_socket == NO_SOCKET) ? NULL :
    &sockets[sock->linked_socket];
  if (verbose > 0) {
    printf("procfs_write %u bytes from proc %u using socket %u to socket %u\n",
        m->COUNT, m->PROC_NR, sock->sock_num, sock->linked_socket);
  }
  if (sock->linked_socket == NO_SOCKET) {
    if (verbose > 0) {
      printf("procfs_write: error - no waiting receiver\n");
    }
    wnet_reply(sock, m, EBADF);
    return;
  } else if (linked_socket->linked_socket != sock->sock_num) {
    if (verbose > 0) {
      printf("procfs_write: error - mismatched linked socket: %d != %d\n",
          sock->linked_socket, linked_socket->linked_socket);
    }
    wnet_reply(sock, m, EBADF);
    return;
  }
  if (sock->flags & kEOF) {
    if (verbose > 0) {
      printf("procfs_write: error - write to closed file\n");
    }
    wnet_reply(sock, m, EPERM);
  }
  sock->unread_bytes = m->COUNT;
  sock->suspended_message = *m;
  if (linked_socket->flags & kSuspForData) {
    if (verbose > 0) {
      printf("procfs_write - reader is waiting, transfer data\n");
    }
    linked_socket->flags &= ~kSuspForData;
    transfer_data( /*writer*/ sock, /*reader*/ linked_socket);
  } else {
    /*
     * Channel is open, but reader isn't ready (probably not back from the
     * last read.  We wait.
     */
    if (verbose > 0) {
      printf("procfs_write - no reader, suspending\n");
    }
    wnet_reply(sock, m, SUSPEND);
  }
}

/*
 * kSuspForRead for the writer means that we're waiting for someone to care about
 * the data we're going to produce.  Once we have a reader, that triggers us to
 * generate and write the data.  It's a one-shot flag, and is triggered by the first
 * read call.
 */
void procfs_ioctl(socket_t* sock, message* m) {
  int res = OK;
  int i;
  socket_t* backlink_socket;
  if (verbose > 0) {
    printf("procfs_ioctl from proc %u\n", m->PROC_NR);
  }
  switch(m->REQUEST) {
    case PROCSETEOF:
      /*
       * Writer is done.  Set kEOF on reader and unlink the two sockets so
       * the writer can move on to the next request.
       */
      if (trace || (verbose > 0)) {
        printf("PROCSETEOF\n");
      }
      backlink_socket = &sockets[sock->linked_socket];
      backlink_socket->flags |= kEOF;
      backlink_socket->linked_socket = NO_SOCKET;
      sock->linked_socket = NO_SOCKET;
      res = OK;
      break;
    case PROCGETEOF:
      if (trace || (verbose > 0)) {
        printf("PROCGETEOF\n");
      }
      res = (sock->flags & kEOF) ? true : false;
      break;
    case PROCPSWAITREAD:
      /*
       * A writer announces availability.  In general, the writer will suspend until
       * a reader appears.  Once one does, the writer returns from this ioctl call and
       * follows with a write.
       */
      if (trace || (verbose > 0)) {
        printf("PROCPSWAITREAD\n");
      }
      assert(sock->linked_socket == NO_SOCKET);
      // Assume we'll suspend and wait for read request.
      sock->flags |= kSuspForRead;
      sock->suspended_message = *m;
      if (verbose > 0) {
        printf("Setting res = SUSPEND\n");
      }
      res = SUSPEND;
      // Any readers already waiting?
      // Need a timeouts here - or perhaps just make that the responsibilty of the caller.
      for (i = FIRST_PROCFS_SOCKET; i < NUM_SOCKETS; i++) {
        // Also make sure it's waiting on the correct master device.
        if ((sockets[i].flags & kSuspForIoctl) && (sockets[i].protocol == sock->protocol)) {
          if (1 || (verbose > 0)) {
            printf("procfs_ioctl found kSusForIoctl fd %d, resuming\n", i);
          }
          // OK - convert this to a read wait.  Keep it suspended, though, the writer will
          // unblock it when some data has been transferred.
          sockets[i].flags &= ~kSuspForIoctl;
          sockets[i].flags |= kSuspForData;
          if (verbose > 0) {
            printf("procfs_ioctl: linked socket %d to %d\n", sock->sock_num, i);
          }
          // Link the reading and writing sockets.
          sockets[i].linked_socket = sock->sock_num;
          sock->linked_socket = i;
          // Change the return value from SUSPEND to OK so that writer will continue while
          // reader remains blocked awaiting data.
          sock->flags &= ~kSuspForRead;
          if (verbose > 0) {
            printf("Setting res = OK\n");
          }
          res = OK;
          break;
        }
      }
      break;
    default:
      if (verbose > 0) {
        printf("procfs_ioctl: illegal ioctl 0x%x\n", m->REQUEST);
      }
      if (verbose > 0) {
        printf("Setting res = EINVAL\n");
      }
      res = EINVAL;
      break;
  }
  wnet_reply(sock, m, res);
}

void procfs_cancel(socket_t* sock, message* m) {
  if (verbose > 0) {
    printf("procfs_cancel fd %s, REQUEST 0x%x\n", pr_fd(sock->fd),
        m->REQUEST);
  }
  if (sock->linked_socket != NO_SOCKET) {
    socket_t* backlink_sock = &sockets[sock->linked_socket];
    backlink_sock->linked_socket = NO_SOCKET;
    backlink_sock->flags &= ~(PROCFS_SUSP);
    wnet_reply(backlink_sock, &backlink_sock->suspended_message, EINTR);
  }
  sock->linked_socket = NO_SOCKET;
  sock->flags &= ~(PROCFS_SUSP);
  if (verbose > 0) {
    printf("procfs_cancel: was suspended, resuming.\n");
  }
  wnet_reply(sock, &sock->suspended_message, EINTR);
  wnet_reply(sock, m, OK);
}

