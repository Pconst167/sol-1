u16_t
slipdev_poll(void)
{
  u8_t c;
  
  while(slipdev_char_poll(&c)) {

    switch(c) {
    case SLIP_ESC:
      lastc = c;
      break;
      
    case SLIP_END:
      lastc = c;
      /* End marker found, we copy our input buffer to the uip_buf
	 buffer and return the size of the packet we copied. */
      memcpy(uip_buf, slip_buf, len);
      tmplen = len;
      len = 0;
      return tmplen;
      
    default:     
      if(lastc == SLIP_ESC) {
	lastc = c;
	/* Previous read byte was an escape byte, so this byte will be
	   interpreted differently from others. */
	switch(c) {
	case SLIP_ESC_END:
	  c = SLIP_END;
	  break;
	case SLIP_ESC_ESC:
	  c = SLIP_ESC;
	  break;
	}
      } else {
	lastc = c;
      }
      
      slip_buf[len] = c;
      ++len;

      if(len > UIP_BUFSIZE) {
	len = 0;
      }
    
      break;
    }
  }
  return 0;
}
