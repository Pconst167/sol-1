
#include "uip.h"

/**
 * Put a character on the serial device.
 *
 * This function is used by the SLIP implementation to put a character
 * on the serial device. It must be implemented specifically for the
 * system on which the SLIP implementation is to be run.
 *
 * \param c The character to be put on the serial device.
 */

void slipdev_char_put(u8_t c) {
    kputc(c,AUX);
}

/**
 * Poll the serial device for a character.
 *
 * This function is used by the SLIP implementation to poll the serial
 * device for a character. It must be implemented specifically for the
 * system on which the SLIP implementation is to be run.
 *
 * The function should return immediately regardless if a character is
 * available or not. If a character is available it should be placed
 * at the memory location pointed to by the pointer supplied by the
 * arguement c.
 *
 * \param c A pointer to a byte that is filled in by the function with
 * the received character, if available.
 *
 * \retval 0 If no character is available.
 * \retval Non-zero If a character is available.
 */
u8_t slipdev_char_poll(u8_t *c) {
    u16_t res = kgetc(AUX);
    if (res) {
	*c = res;
	return 1;
    }
    return 0;
}

