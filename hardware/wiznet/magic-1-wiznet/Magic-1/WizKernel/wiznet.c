/* This file contains the Magic-1 Wiznet 5300 support task.
 *
 * The file contains one entry point:
 *
 *   pager_task:	main entry when system is brought up
 *
 */

#include "kernel.h"
#include "driver.h"


FORWARD _PROTOTYPE( void wiznet_init, (void) );
_PROTOTYPE( int wiznet_handler, (void) );

/*===========================================================================*
 *				wiznet_handler				     *
 *===========================================================================*/
extern unsigned char switching;
int wiznet_handler(void)
{
#if 0
  if (wiznet_proc != NULL) {
    register struct proc *rp = proc_addr(wiznet_proc->p_nr);
    printf("\nHandler before, k_reenter: %d, p_getfrom: %d, p_int_blocked: %d, p_int_held: %d\n",
        k_reenter, rp->p_getfrom, rp->p_int_blocked, rp->p_int_held);
    interrupt(wiznet_proc->p_nr);
    printf("\nHandler after, p_int_blocked: %d, p_int_held: %d\n",
        rp->p_int_blocked, rp->p_int_held);
  }
#endif
  interrupt(WIZNET);
  // lost_wiznet_interrupts = 1;
  return 0;
}

/*===========================================================================*
 *				wiznet_task				     *
 *===========================================================================*/
PUBLIC void wiznet_task()
{
  /* Main program of wiznet task.
  */

  message mc;			/* message buffer for both input and output */
  int opcode;
  struct proc *p;		// Proc pointer for target proc
  int r;

  wiznet_init();			/* initialize pager task */

  /* Main loop of the wiznet task.  Get work, process it, sometimes reply. */
  while (TRUE) {
    receive(HARDWARE, &mc);		/* wait for an interrupt */
    opcode = mc.m_type;	/* extract the function code */

    switch (opcode) {
      case HARD_INT:
        mc.m_type = HARD_INT;
        mc.PROC_NR = HARDWARE;
        r = send(wiznet_proc->p_nr, &mc);
        if (r != OK) {
          printf("WIZNET proc %d got HARD_INT, task send result is 0x%x\n", wiznet_proc->p_nr, r);
          printf("..was expecting result of 0x%x\n", OK);
          printf("..lost wiznet interrupts: %d\n", lost_wiznet_interrupts);
        }
        break;
      default:
        printf("Error: wiznet task got message %d from %d", mc.m_type,mc.m_source);
    }
    /* No reply */
  }
}

/*===========================================================================*
 *				wiznet_init				     *
 *===========================================================================*/
PRIVATE void wiznet_init()
{
  /* Initialize this task. */
  enable_interrupt(WIZNET_IRQ);
}

