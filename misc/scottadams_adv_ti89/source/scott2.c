// A launcher for ScottFree driver on AMS 2.03 (C) 2000 by Zeljko Juric
// You need TIGCC crosscompiler with library 2.22 or greater to compile it.
// Type "tigcc -O2 scott2.c" to compile

#define OPTIMIZE_ROM_CALLS

#include <alloc.h>
#include <mem.h>
#include <vat.h>
#include <statline.h>
#include <system.h>

int _ti89,_ti92plus;         // Produce both .89z and .9xz files

#define fatal(s) {ST_showHelp(s); return;}

void _main(void)
{
  char *fptr,*cptr;
  unsigned plen;
  SYM_ENTRY *SymPtr=DerefSym(SymFind($(scott)));
  if(!SymPtr) fatal("Program not found");
  plen=*(int*)(cptr=fptr=HLock(SymPtr->handle))+3;
  if(SymPtr->flags.bits.archived)
    {
      if(!(cptr=malloc(plen))) fatal("Out of memory");
      memcpy(cptr,fptr,plen);
    }
  enter_ghost_space();
  EX_patch(cptr+0x40002,cptr+plen-2);
  ASM_call(cptr+0x40002);
  if(cptr!=fptr) free(cptr);
}

// If you have any comment, suggestions, questions or bug reports, mail me at:
// zjuric@utic.net.ba

// Zeljko Juric
// Sarajevo
// Bosnia & Herzegovina

