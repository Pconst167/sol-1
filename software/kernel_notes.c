
 enum file_type {
     FILE_NONE,
     FILE_REG,
     FILE_PIPE,
     FILE_CHARDEV,    // like tty
     FILE_BLOCKDEV
 };
 
 
 struct file {
     int refcount;
     int flags;
     enum file_type type;
     void *target; // pointer to inode entry, or tty buffer, etc
     int offset;   // ignored for char devices
     struct file_ops *ops; // this defines the read/write/close etc functions
 };
 
 
 struct tty {
     int id;
     struct process *owner;
     char inbuf[128];
 };

struct process {
    pid_t pid;                 // process ID
    enum proc_state state;     // RUNNING, READY, BLOCKED, ZOMBIE

    struct file *fd[MAX_FD];
    struct tty *tty;

    struct cpu_context ctx;    // saved registers
};

 // this is for the device level. 
 struct chardev {
     int major;
     int minor;
     int (*read)(...);
     int (*write)(...);
 };
 struct blockdev {
     int major;
     int minor;
     int (*read_block)(...);
     int (*write_block)(...);
 };

/*
 | File type     | `target` points to |
 | ------------- | ------------------ |
 | FILE_REG      | inode              |
 | FILE_PIPE     | pipe buffer        |
 | FILE_CHARDEV  | device instance    |
 | FILE_BLOCKDEV | device instance    |
 example:
 file->type = FILE_CHARDEV;
 file->target = &tty0_device;
 
 How /dev fits in (very important)
 /dev/tty0 is just a filename.
 Filesystem resolves it to:
 inode
 inode contains major and minor numbers
 Kernel then does:
 major = inode->major;
 minor = inode->minor;
 device = dev_table[major][minor];
 Then creates a struct file pointing to that device.
*/
 
// Operations table is the real polymorphism
 
// Instead of switch(file->type) everywhere, use:
 
 struct file_ops {
     int (*read)(struct file *, ...);
     int (*write)(struct file *, ...);
     int (*seek)(struct file *, ...);
 };
 
 
// Then:
 
 file->ops->read(file, buf, n);
 
/*
 TTY, pipe, disk, regular file — all plug in.
 
 Why ops exist (the core reason)
 
 Different things behave differently:
 
 Object	How read/write behaves
 Regular file	reads disk blocks
 Pipe	reads FIFO buffer
 TTY	reads keyboard buffer
 Serial port	reads UART
 Disk device	reads raw sectors
*/

 read(fd, buf, n);
 write(fd, buf, n);
 
 struct file_ops {
     int (*read)(struct file *, void *buf, int n);
     int (*write)(struct file *, const void *buf, int n);
     int (*seek)(struct file *, int offset, int whence);
     int (*close)(struct file *);
 };
 
 int reg_read(struct file *f, void *buf, int n) {
     struct inode *ino = f->target;
     return disk_read(ino, f->offset, buf, n);
 }
 
 int reg_write(struct file *f, const void *buf, int n) {
     struct inode *ino = f->target;
     return disk_write(ino, f->offset, buf, n);
 }
 
 struct file_ops reg_ops = {
     .read  = reg_read,
     .write = reg_write,
     .seek  = reg_seek,
     .close = reg_close,
 };
 
 int reg_read(struct file *f, void *buf, int n) {
     struct inode *ino = f->target;
     return disk_read(ino, f->offset, buf, n);
 }
 
 int reg_write(struct file *f, const void *buf, int n) {
     struct inode *ino = f->target;
     return disk_write(ino, f->offset, buf, n);
 }
 
 struct file_ops reg_ops = {
     .read  = reg_read,
     .write = reg_write,
     .seek  = reg_seek,
     .close = reg_close,
 };

 // Example: TTY ops

 int tty_read(struct file *f, void *buf, int n) {
     struct tty *t = f->target;
     return tty_get_input(t, buf, n);
 }
 
 int tty_write(struct file *f, const void *buf, int n) {
     struct tty *t = f->target;
     return tty_put_output(t, buf, n);
 }
 
 struct file_ops tty_ops = {
     .read  = tty_read,
     .write = tty_write,
     .seek  = NULL,     // not supported
     .close = tty_close,
 };

// Example: pipe ops
 struct file_ops pipe_ops = {
     .read  = pipe_read,
     .write = pipe_write,
     .seek  = NULL,
     .close = pipe_close,
 };
 
// What happens on read(fd, ...)
 
// Kernel syscall handler:
 
 int sys_read(int fd, void *buf, int n) {
     struct file *f = current->fd[fd];
     return f->ops->read(f, buf, n);
 }
 
 
// That’s it.
 
 
// file allocation:
 struct file *alloc_file(void) {
     for (int i = 0; i < MAX_FILES; i++) {
         if (file_table[i].refcount == 0) {
             memset(&file_table[i], 0, sizeof(struct file));
             file_table[i].refcount = 1;
             return &file_table[i];
         }
     }
     return NULL;  // ENFILE
 }