// ScottFree game driver for TI-89/92+ V1.5 (C) 2000 by Zeljko Juric
// You need TIGCC crosscompiler with library 2.22 or greater to compile it
// Type "tigcc -O2 scott.c" to compile

#define OPTIMIZE_ROM_CALLS

#include <alloc.h>
#include <string.h>
#include <ctype.h>
#include <stdarg.h>
#include <stdlib.h>
#include <setjmp.h>
#include <compat.h>
#include <graph.h>
#include <wingraph.h>
#include <kbd.h>
#include <menus.h>
#include <statline.h>
#include <system.h>
#include <events.h>
#include <error.h>
#include <vat.h>

int _ti89,_ti92plus;     // Produce both .89z and .9xz files

#define LIGHT_SOURCE 9
#define CARRIED 255
#define DESTROYED 0
#define DARKBIT	15
#define LIGHTOUTBIT 16

#define HIST_LEN 40
#define HIST_SIZE (30*HIST_LEN)

int Width=0;
int TopHeight=42;
int BottomHeight=48;

typedef struct
  {
    int Unknown,NumItems,NumActions,NumWords,NumRooms,MaxCarry,PlayerRoom;
    int Treasures,WordLength,LightTime,NumMessages,TreasureRoom;
  } Header;

typedef struct
  {
    unsigned int Vocab,Condition[5],Action[2];
  } Action;

typedef struct
  {
    char *Text;
    unsigned int Exits[6];
  } Room;

typedef struct
  {
    char *Text;
    unsigned char Location,InitialLoc;
    char *AutoGet;
  } Item;

// Note that all globals MUST have initializers in "nostub" mode

JMP_BUF jmp_buf={};

// The full initializer is written below instead of {} just to suppress
// a warning message

WINDOW Upper={0,0,0,0,0,0,0,0,0,{.l=0},{.l=0},{.l=0},{.l=0},0,NULL,NULL};
WINDOW Lower={0,0,0,0,0,0,0,0,0,{.l=0},{.l=0},{.l=0},{.l=0},0,NULL,NULL};

Header GameHeader={0,0,0,0,0,0,0,0,0,0,0,0};

int menuopt=0;

Item *Items=NULL;
Room *Rooms=NULL;
char **Verbs=NULL,**Nouns=NULL,**Messages=NULL;
Action *Actions=NULL;

int LightRefill=0,CurrentCounter=0,SavedRoom=0,OldLoc=0;
int Counters[16]={},RoomSaved[16]={};
char NounText[60]="";
long BitFlags=0;
int Redraw=0,ScrCt=0,OutFlag=0;
char *fptr=NULL,*fpbase=NULL,*savebase=NULL;

char *History=NULL;

// The game "Seas of Blood" originally used a bit modified interpreter. These
// extra features are also implemented adhoc in this release of the ScottFree
// interpreter, so you can play this game. The following flag is set if the
// interpreter detects "Seas of Blood" database.

int isSeasOfBlood=0;
int LogFlag=0;               // Adhoc flag for "Seas of Blood"

#define MyLoc (GameHeader.PlayerRoom)

int Q89_92(int val89,int val92)
{
  return TI92PLUS?val92:val89;
}

void *MemAlloc(int size)
{
  void *t=malloc(size);
  if (t==NULL)
    {
      ST_showHelp("Out of memory");
      ngetchx();
      longjmp(jmp_buf,2);
    }
  return t;
}

int RandomPercent(unsigned int n)
{
  return (unsigned)random(100)<n;
}

int CountCarried(void)
{
  int ct,n=0;
  for(ct=0;ct<=GameHeader.NumItems;ct++)
    if(Items[ct].Location==CARRIED) n++;
  return n;
}

char *MapSynonym(char *word)
{
  int n;
  char *tp;
  static char lastword[16]="\0              ";   // Last non synonym
  for(n=1;n<=GameHeader.NumWords;n++)
    {
      tp=Nouns[n];
      if(*tp=='*') tp++;
      else strcpy(lastword,tp);
      if(!(int)strncmp(word,tp,GameHeader.WordLength)) return lastword;
    }
  return NULL;
}

int MatchUpItem(char *text, int loc)
{
  char *word=MapSynonym(text);
  int ct;
  if(word==NULL) word=text;
  for(ct=0;ct<=GameHeader.NumItems;ct++)
    if (Items[ct].AutoGet&&Items[ct].Location==loc&&
      !(int)strncmp(Items[ct].AutoGet,word,GameHeader.WordLength))
        return ct;
  return -1;
}

char *ReadString(void)
{
  char *t=fptr;
  while(*fptr++);
  return t;
}

void ReadInt(int n,...)
{
  va_list vptr;
  unsigned char c1,c2;
  int i;
  va_start(vptr,n);
  for(i=1;i<=n;i++)
    {
      c1=*fptr++;
      c2=*fptr++;
      *va_arg(vptr,int*)=c1+256*c2;
    }
  va_end(vptr);
}

void WriteInt(unsigned int n,...)
{
  va_list vptr;
  unsigned int i,x;
  va_start(vptr,n);
  for(i=1;i<=n;i++)
    {
      x=va_arg(vptr,unsigned int);
      *fptr++=x%256;
      *fptr++=x/256;
    }
  va_end(vptr);
}

void LoadDatabase(char *name)
{
  unsigned int ni,na,nw,nr,mc,pr,tr,wl,lt,mn,trm,ct,lo;
  Action *ap;
  Room *rp;
  Item *ip;
  static char symname[20]="\0advint\\";
  SYM_ENTRY *sym_entry=DerefSym(SymFind(strcpy(symname+8,name)+strlen(name)));
  char *sptr=HLock(sym_entry->handle);
  memcpy(fpbase=fptr=MemAlloc(*(int*)sptr),sptr+3,*(int*)sptr);
  ReadInt(12,&ct,&ni,&na,&nw,&nr,&mc,&pr,&tr,&wl,&lt,&mn,&trm);
  GameHeader.NumItems=ni;
  Items=MemAlloc(sizeof(Item)*(ni+1));
  GameHeader.NumActions=na;
  Actions=MemAlloc(sizeof(Action)*(na+1));
  GameHeader.NumWords=nw;
  GameHeader.WordLength=wl;
  Verbs=MemAlloc(sizeof(char*)*(nw+1));
  Nouns=MemAlloc(sizeof(char*)*(nw+1));
  GameHeader.NumRooms=nr;
  Rooms=MemAlloc(sizeof(Room)*(nr+1));
  GameHeader.MaxCarry=mc;
  GameHeader.PlayerRoom=pr;
  GameHeader.Treasures=tr;
  GameHeader.LightTime=lt;
  LightRefill=lt;
  GameHeader.NumMessages=mn;
  Messages=MemAlloc(sizeof(char*)*(mn+1));
  GameHeader.TreasureRoom=trm;
  ap=Actions;
  for(ct=0;ct<=na;ct++)
    {
      ReadInt(8,&ap->Vocab,&ap->Condition[0],&ap->Condition[1],
        &ap->Condition[2],&ap->Condition[3],&ap->Condition[4],
        &ap->Action[0],&ap->Action[1]);
      ap++;
    }
  for(ct=0;ct<=nw;ct++)
    {
      Verbs[ct]=ReadString();
      Nouns[ct]=ReadString();
    }
  rp=Rooms;
  for(ct=0;ct<=nr;ct++)
    {
      ReadInt(6,&rp->Exits[0],&rp->Exits[1],&rp->Exits[2],&rp->Exits[3],
        &rp->Exits[4],&rp->Exits[5]);
      rp->Text=ReadString();
      rp++;
    }
  for(ct=0;ct<=mn;ct++)
    Messages[ct]=ReadString();
  ip=Items;
  for(ct=0;ct<=ni;ct++)
    {
      ip->Text=ReadString();
      ip->AutoGet=strchr(ip->Text,'/');
      if(ip->AutoGet&&strcmp(ip->AutoGet,"//")&&strcmp(ip->AutoGet,"/*"))
	{
	  char *t;
	  *ip->AutoGet++=0;
	  t=strchr(ip->AutoGet,'/');
	  if(t!=NULL) *t=0;
	}
      ReadInt(1,&lo);
      ip->Location=(unsigned char)lo;
      ip->InitialLoc=ip->Location;
      ip++;
    }
  isSeasOfBlood=!strcmp(fptr+1,"Seas of Blood");    // This is adhoc
  HeapUnlock(sym_entry->handle);
}

void OutReset(void)
{
  WinMoveTo(&Lower,0,BottomHeight-6);
  ScrCt=0;
}

int GetCh(void)
{
  int ch=ngetchx();
  memset(LCD_MEM+(LCD_HEIGHT-5)*30,0,150);     // Erase status line
  return ch;
}

void ScrollUp(void)
{
  if(ScrCt++==Q89_92(7,10))
    {
      ST_busy(ST_PAUSE);
      GetCh();
      ST_busy(ST_CLEAR);
      ScrCt=0;
    }
  WinScrollV(&Lower,MakeWinRect(0,0,Width-1,BottomHeight-1),6);
  WinMoveTo(&Lower,0,BottomHeight-6);
}

int IsSpace(int ch)
{
  return (ch>=9&&ch<=13)||ch==' ';
}

void Output(char *buffer)
{
  char word[80];
  int wp;
  OutFlag=1;
  while(*buffer)
    {
      if(Lower.CurX<2)
	{
          while(*buffer&&IsSpace(*buffer))
	    {
	      if(*buffer=='\n') ScrollUp();
	      buffer++;
	    }
	}
      if(!*buffer) return;
      wp=0;
      while(*buffer&&!IsSpace(*buffer))
	word[wp++]=*buffer++;
      word[wp]=0;
      if(Lower.CurX+DrawStrWidth(word,F_4x6)>Width-2) ScrollUp();
      WinStr(&Lower,word);
      if(!*buffer) return;
      if(*buffer++=='\n'||Lower.CurX>=Width-3) ScrollUp();
      else WinStr(&Lower," ");
    }
}

void OutputNumber(int a)
{
  char buf[16];
  sprintf(buf,"%d ",a);
  Output(buf);
}

void Delay(int n)
{
  OSFreeTimer(USER_TIMER);
  OSRegisterTimer(USER_TIMER,n);
  while(!OSTimerExpired(USER_TIMER));
}

int pos=0;

void Lprint(char *s)
{
  char buf[80];
  while(1)
    {
      int i=0;
      if(!*s) return;
      while(IsSpace(*s)) s++;
      if(!*s) return;
      while(!IsSpace(*s)) buf[i++]=*s++;
      buf[i]=0;
      if(Upper.CurX+DrawStrWidth(buf,F_4x6)>Width-2) WinStr(&Upper,"\n");
      WinStr(&Upper,buf);
      if(*s++==' '&&Upper.CurX<Width-3) WinStr(&Upper," ");
      else WinStr(&Upper,"\n");
    }
}

void Look(void)
{
  static char *ExitNames[6]={"North","South","East","West","Up","Down"};
  static char *ExitShort[6]={"N","S","E","W","U","D"};
  char buf[500];
  Room *r;
  int ct,f,LongDisp=1;
  do
    {
      WinClr(&Upper);
      if((BitFlags&(1L<<DARKBIT))&&Items[LIGHT_SOURCE].Location!=CARRIED&&
        Items[LIGHT_SOURCE].Location!=MyLoc)
          {
            Lprint("I can't see. It is too dark!\n");
            return;
          }
      r=&Rooms[MyLoc];
      if(*r->Text=='*')
        strcpy(buf,r->Text+1);
      else
        {
          strcpy(buf,"I'm in a ");
          strcat(buf,r->Text);
        }
      strcat(buf,LongDisp?".\n":". ");
      Lprint(buf);
      f=0;
      strcpy(buf,LongDisp?"Obvious exits: ":"Exits: ");
      for(ct=0;ct<6;ct++)
        if(r->Exits[ct])
          {
            if(f++) strcat(buf,", ");
            strcat(buf,LongDisp?ExitNames[ct]:ExitShort[ct]);
          }
      if(!f) strcat(buf,"none");
      strcat(buf,LongDisp?".\n":". ");
      Lprint(buf);
      f=0;
      buf[0]=0;
      for(ct=0;ct<=GameHeader.NumItems;ct++)
        if(Items[ct].Location==MyLoc)
          {
            if(!f++) strcpy(buf,LongDisp?"I can also see: ":"I see: ");
            strcat(buf,Items[ct].Text);
            strcat(buf,". ");
          }
      Lprint(buf);
      if(!LongDisp) LongDisp=1;
      else if(Upper.CurY>TopHeight-1) LongDisp=0;
    } while(!LongDisp);
}

int WhichWord(char *word, char **list)
{
  int n=1,ne;
  char *tp;  
  for(ne=1;ne<=GameHeader.NumWords;ne++)
    {
      tp=list[ne];
      if(*tp=='*') tp++;
      else n=ne;
      if(!(int)strncmp(word,tp,GameHeader.WordLength)) return n;
    }
  return -1;
}

void DispCursor(void)
{
  int SaveX=Lower.CurX,SaveY=Lower.CurY;
  WinChar(&Lower,'_');
  WinMoveTo(&Lower,SaveX,SaveY);
}

void ClrEol(void)                      // This function is ad hoc
{
  int SaveX=Lower.CurX,SaveY=Lower.CurY;
  while(Lower.CurX<=Width-4) WinChar(&Lower,' ');
  WinMoveTo(&Lower,SaveX,SaveY);
}

int Captured=0;

void CaptureHandler(EVENT *ev)
{
  if(ev->Type==CM_STRING) Captured=*(unsigned char*)(ev->extra.pasteText);
}

void LineInput(char *buf)
{
  int pos=0,hflag=0,InitX=Lower.CurX,InitY=Lower.CurY,SaveX,SaveY,ch;
  char *hptr=History-HIST_LEN;
  EVENT ev;
  LCD_BUFFER scrbuf;
  DispCursor();
  while(TRUE)
    {
      switch(ch=toupper(GetCh()))
	{
          case KEY_ENTER:
            if (pos)
              {
                buf[pos]=0;
                WinStr(&Lower,"  ");
                ScrCt=0;
                ScrollUp();
                ScrCt=0;
                OutFlag=0;
                memmove(History+HIST_LEN,History,HIST_SIZE-HIST_LEN);
                strncpy(History,buf,HIST_LEN-1);
                return;
              }
          case KEY_BACKSPACE:
	    if(pos)
	      {
                buf[pos--]=0;
                WinMoveTo(&Lower,Lower.CurX-FontCharWidth(buf[pos]),
                  Lower.CurY);
                SaveX=Lower.CurX; SaveY=Lower.CurY;
                WinStr(&Lower,"     ");
                WinMoveTo(&Lower,SaveX,SaveY);
                DispCursor();
	      }
	    break;
          case KEY_CLEAR:
            WinMoveTo(&Lower,InitX,InitY);
            ClrEol();
            DispCursor();
            pos=0; buf[0]=0;
            break;
          case KEY_CHAR:
            ev.Type=CM_KEYPRESS;
            ev.extra.Key.Code=KEY_CHAR;
            EV_captureEvents(CaptureHandler);
            LCD_save(scrbuf);
            EV_defaultHandler(&ev);
            LCD_restore(scrbuf);
            EV_captureEvents(NULL);
            ch=Captured;
	  default:
            if(ch==KEY_DOWN&&hptr>History)
              hptr-=HIST_LEN,hflag=-1;
            if(ch==KEY_UP&&hptr<History+HIST_SIZE&&*(hptr+HIST_LEN))
              hptr+=HIST_LEN,hflag=1;
            if(hflag)
              {
                WinMoveTo(&Lower,InitX,InitY);
                ClrEol();
                strcpy(buf,hptr);
                pos=strlen(buf);
                WinStr(&Lower,buf);
                DispCursor();
                hflag=0;
                break;
              }
            if((ch>' '&&ch<256&&pos<50)||(ch==' '&&pos))
              if(Lower.CurX+FontCharWidth(ch)<Width-5)
                {
                  buf[pos++]=ch;
                  WinChar(&Lower,ch);
                  DispCursor();
                }
	}
    }
}

void GetInput(int *vb,int *no)
{
  char buf[150],verb[55],noun[55],*bptr;
  int vc,nc,i;
  do
    {
      do
	{
          bptr=buf; *verb=0; *noun=0;
          if(Lower.CurX>2) Output("\n");
          Output("\nTell me what to do? ");
          memset(buf,0,150);
	  LineInput(buf);
	  OutReset();
          while(*bptr&&IsSpace(*bptr)) bptr++;
          i=0;
          while(*bptr&&!IsSpace(*bptr)) verb[i++]=*bptr++;
          verb[i]=0;
          while(*bptr&&IsSpace(*bptr)) bptr++;
          i=0;
          while((*bptr)&&(!IsSpace(*bptr))) noun[i++]=*bptr++;
          noun[i]=0;
        } while(!*verb);
      if(!*noun&&strlen(verb)==1)
	{
          switch(*verb)
	    {
              case 'N':strcpy(verb,"NORTH");break;
              case 'E':strcpy(verb,"EAST");break;
              case 'S':strcpy(verb,"SOUTH");break;
              case 'W':strcpy(verb,"WEST");break;
              case 'U':strcpy(verb,"UP");break;
              case 'D':strcpy(verb,"DOWN");break;
              case 'I':strcpy(verb,"INVENTORY");
	    }
	}
      if(!strcmp(verb,"PANIC")) longjmp(jmp_buf,2);
      nc=WhichWord(verb,Nouns);
      if(nc>=1&&nc<=6)
        vc=1;
      else
	{
	  vc=WhichWord(verb,Verbs);
	  nc=WhichWord(noun,Nouns);
	}
      *vb=vc;
      *no=nc;
      if(vc==-1)
	{
          strcpy(buf,"\"");
          strcat(buf,verb);
          strcat(buf,"\" is a verb I don't know...sorry!\n");
          Output(buf);
	}
    } while(vc==-1);
  strcpy(NounText,noun);        // Needed by GET/DROP hack
}

void SaveGame(void)
{
  char buf[256];
  int ct,failed=0;
  SYM_ENTRY *sym_entry=NULL;
  Output("\nFilename: ");
  buf[0]=0;
  LineInput(buf+1);
  TRY
    sym_entry=DerefSym(SymAdd(buf+1+strlen(buf+1)));
  ONERR
    failed=1;
  ENDTRY
  if(!sym_entry) failed=1;
  ST_busy(ST_CLEAR);
  FontSetSys(F_4x6); // SymAdd may open CreateFolder dialog, which may change
  if(!failed)        // system font!
    {
      sym_entry->handle=HeapAlloc(100+2*GameHeader.NumItems);
      savebase=HeapDeref(sym_entry->handle);
      if(!sym_entry->handle) failed=1;
    }
  if(failed)
    {
      Output("Unable to create save file.");
      SymDel(buf+1+strlen(buf+1));
      return;
    }
  if(isSeasOfBlood) RoomSaved[15]=OldLoc;
  fptr=savebase+2;
  *fptr++=0;
  for(ct=0;ct<16;ct++) WriteInt(2,Counters[ct],RoomSaved[ct]);
  WriteInt(7,(int)(BitFlags%65536),(int)(BitFlags>>16),
    (BitFlags&(1L<<DARKBIT))?1:0,MyLoc,CurrentCounter,SavedRoom,
    GameHeader.LightTime);
  for(ct=0;ct<=GameHeader.NumItems;ct++) WriteInt(1,(int)Items[ct].Location);
  *fptr++=0;
  memcpy(fptr,"SAV\0\xF8",5);
  fptr+=5;
  *(int*)savebase=fptr-savebase-2;
  Output("Saved.\n");
}

void LoadGame(char *name)
{
  int ct,lo,bflo,bfhi,DarkFlag;
  static char symname[30]="\0";
  SYM_ENTRY *sym_entry=DerefSym(SymFind(strcpy(symname+1,name)+strlen(name)));
  if(!sym_entry)
    {
      Output("Unable to restore game.");
      GetCh();
      return;
    }
  fptr=(char*)HeapDeref(sym_entry->handle)+3;
  for(ct=0;ct<16;ct++) ReadInt(2,&Counters[ct],&RoomSaved[ct]);
  ReadInt(7,&bflo,&bfhi,&DarkFlag,&MyLoc,&CurrentCounter,&SavedRoom,
    &GameHeader.LightTime);
  BitFlags=((unsigned long)bfhi<<16)+bflo;
  if(DarkFlag) BitFlags|=(1L<<15);
  for(ct=0;ct<=GameHeader.NumItems;ct++)
    {
      ReadInt(1,&lo);
      Items[ct].Location=(unsigned char)lo;
    }
  if(memcmp(fptr+1,"SAV\0\xF8",5)&&strcmp(fptr+1,"Savefile"))
    {
      Output("Invalid or wrong save file!");
      longjmp(jmp_buf,1);
    }
  if(isSeasOfBlood) OldLoc=RoomSaved[15];
}

int NeedsCR(int c)
{
  return OutFlag&&(IsSpace(c)||isupper(c)||c==34);
}

void StartCombat(void);     // Fighting Fantasy combat for "Seas of Blood"

int PerformLine(int ct)
{
  int cc,continuation=0,pptr=0,param[5],act[4];
  char buf[1024];
  for(cc=0;cc<5;cc++)
    {
      int cv=Actions[ct].Condition[cc],dv=cv/20;
      cv%=20;
      switch(cv)
	{
	  case 0:
	    param[pptr++]=dv;
            break;
	  case 1:
	    if(Items[dv].Location!=CARRIED) return 0;
	    break;
	  case 2:
	    if(Items[dv].Location!=MyLoc) return 0;
	    break;
	  case 3:
            if(Items[dv].Location!=CARRIED&&Items[dv].Location!=MyLoc)
              return 0;
	    break;
	  case 4:
	    if(MyLoc!=dv) return 0;
	    break;
	  case 5:
	    if(Items[dv].Location==MyLoc) return 0;
	    break;
	  case 6:
	    if(Items[dv].Location==CARRIED) return 0;
	    break;
	  case 7:
	    if(MyLoc==dv) return 0;
	    break;
	  case 8:
	    if(!(BitFlags&(1L<<dv))) return 0;
	    break;
	  case 9:
	    if(BitFlags&(1L<<dv)) return 0;
	    break;
	  case 10:
	    if(!CountCarried()) return 0;
	    break;
	  case 11:
	    if(CountCarried()) return 0;
	    break;
	  case 12:
	    if(Items[dv].Location==CARRIED||Items[dv].Location==MyLoc)
	      return 0;
	    break;
	  case 13:
	    if(!Items[dv].Location) return 0;
	    break;
	  case 14:
	    if(Items[dv].Location) return 0;
	    break;
	  case 15:
	    if(CurrentCounter>dv) return 0;
	    break;
	  case 16:
	    if(CurrentCounter<=dv) return 0;
	    break;
	  case 17:
	    if(Items[dv].Location!=Items[dv].InitialLoc) return 0;
	    break;
	  case 18:
	    if(Items[dv].Location==Items[dv].InitialLoc) return 0;
	    break;
          case 19:
	    if(CurrentCounter!=dv) return 0;
	    break;
	}
    }
  act[0]=Actions[ct].Action[0];
  act[2]=Actions[ct].Action[1];
  act[1]=act[0]%150;
  act[3]=act[2]%150;
  act[0]/=150;
  act[2]/=150;
  pptr=0;
  for(cc=0;cc<4;cc++)
    {
      if(act[cc]>=1&&act[cc]<52)
	{
          if(NeedsCR(Messages[act[cc]][0])) Output("\n");
          strcpy(buf,Messages[act[cc]]);
          strcat(buf," ");
          Output(buf);
	}
      else if(act[cc]>101)
	{
          if(NeedsCR(Messages[act[cc]-50][0])) Output("\n");
          strcpy(buf,Messages[act[cc]-50]);
          strcat(buf," ");
          Output(buf);
	}
      else switch(act[cc])
	{
          case 0:
            break; // NOP
	  case 52:
	    if(CountCarried()==GameHeader.MaxCarry)
	      {
		Output("I've too much to carry!\n");
		break;
	      }
	    if(Items[param[pptr]].Location==MyLoc) Redraw=1;
	    Items[param[pptr++]].Location=CARRIED;
	    break;
	  case 53:
	    Redraw=1;
	    Items[param[pptr++]].Location=MyLoc;
	    break;
	  case 54:
	    Redraw=1;
            OldLoc=MyLoc;
	    MyLoc=param[pptr++];
	    break;
	  case 55:
	    if(Items[param[pptr]].Location==MyLoc) Redraw=1;
	    Items[param[pptr++]].Location=0;
	    break;
	  case 56:
	    BitFlags|=1L<<DARKBIT;
	    break;
	  case 57:
	    BitFlags&=~(1L<<DARKBIT);
	    break;
	  case 58:
	    BitFlags|=(1L<<param[pptr++]);
	    break;
	  case 59:
	    if(Items[param[pptr]].Location==MyLoc) Redraw=1;
	    Items[param[pptr++]].Location=0;
	    break;
	  case 60:
	    BitFlags&=~(1L<<param[pptr++]);
	    break;
	  case 61:
            Output("\nI am dead.\n");
	    BitFlags&=~(1L<<DARKBIT);
            MyLoc=GameHeader.NumRooms;
	    Look();
	    break;
	  case 62:
	    {
	      int i=param[pptr++];
	      Items[i].Location=param[pptr++];
	      Redraw=1;
	      break;
	    }
	  case 63:
            Output("\nThe game is now over.");
            longjmp(jmp_buf,1);
	  case 64:
	    Look();
	    break;
	  case 65:
	    {
	      int n=0;
	      for(ct=0;ct<=GameHeader.NumItems;ct++)
		if(Items[ct].Location==GameHeader.TreasureRoom &&
		  *Items[ct].Text=='*')
		    n++;
	      Output("I've stored ");
	      OutputNumber(n);
              Output("treasures. On a scale of 0 to 100, that rates ");
	      OutputNumber((n*100)/GameHeader.Treasures);
              Output("\n");
	      if(n==GameHeader.Treasures)
		{
                  Output("Well done.\nThe game is now over.");
                  longjmp(jmp_buf,1);
		}
	      break;
	    }
	  case 66:
	    {
	      int ct,f=0;
              if(isSeasOfBlood)    // Extra informations for "Seas of Blood"
                {
                  char buf[5];
                  int bp=BottomHeight-6;
                  OutReset();
                  Output("\n");
                  WinStrXY(&Lower,0,bp,"Skill:");
                  WinStrXY(&Lower,30,bp,"9");
                  WinStrXY(&Lower,43,bp,"Provisions:");
                  sprintf(buf,"%d",Counters[5]);
                  WinStrXY(&Lower,81,bp,buf);
                  WinStrXY(&Lower,94,bp,"Crew strike:");
                  WinStrXY(&Lower,148,bp,"9");
                  ScrollUp();
                  WinStrXY(&Lower,0,bp,"Stamina:");
                  sprintf(buf,"%d",Counters[3]);
                  WinStrXY(&Lower,30,bp,buf);
                  WinStrXY(&Lower,43,bp,"Log:");
                  sprintf(buf,"%d",Counters[6]);
                  WinStrXY(&Lower,81,bp,buf);
                  WinStrXY(&Lower,94,bp,"Crew strength:");
                  sprintf(buf,"%d",Counters[7]);
                  WinStrXY(&Lower,148,bp,buf);
                  ScrollUp();
                  Output("\nInventory: ");
                }
              else Output("I'm carrying: ");
	      for(ct=0;ct<=GameHeader.NumItems;ct++)
		{
		  if(Items[ct].Location==CARRIED)
		    {
                      f=1;
                      strcpy(buf,Items[ct].Text);
                      strcat(buf,". ");
                      Output(buf);
		    }
		}
	      if(!f) Output("Nothing.\n");
	      break;
	    }
	  case 67:
	    BitFlags|=(1L<<0);
	    break;
	  case 68:
	    BitFlags&=~(1L<<0);
	    break;
	  case 69:
	    GameHeader.LightTime=LightRefill;
	    if(Items[LIGHT_SOURCE].Location==MyLoc)
	    Redraw=1;
	    Items[LIGHT_SOURCE].Location=CARRIED;
	    BitFlags&=~(1L<<LIGHTOUTBIT);
	    break;
	  case 70:
            WinClr(&Lower);
	    OutReset();
	    break;
	  case 71:
	    SaveGame();
	    break;
	  case 72:
	    {
	      int i1=param[pptr++];
	      int i2=param[pptr++];
	      int t=Items[i1].Location;
              if(t==MyLoc||Items[i2].Location==MyLoc) Redraw=1;
	      Items[i1].Location=Items[i2].Location;
	      Items[i2].Location=t;
	      break;
	    }
	  case 73:
	    continuation=1;
	    break;
	  case 74:
	    if(Items[param[pptr]].Location==MyLoc) Redraw=1;
	    Items[param[pptr++]].Location=CARRIED;
	    break;
	  case 75:
	    {
	      int i1=param[pptr++];
	      int i2=param[pptr++];
	      if(Items[i1].Location==MyLoc) Redraw=1;
	      Items[i1].Location=Items[i2].Location;
	      if(Items[i2].Location==MyLoc) Redraw=1;
	      break;
	    }
          case 76:
	    Look();
	    break;
	  case 77:
	    if(CurrentCounter>=0) CurrentCounter--;
            if(isSeasOfBlood&&LogFlag) Counters[6]++;
	    break;
	  case 78:
	    OutputNumber(CurrentCounter);
	    break;
	  case 79:
	    CurrentCounter=param[pptr++];
	    break;
	  case 80:
	    {
	      int t=MyLoc;
	      MyLoc=SavedRoom;
	      SavedRoom=t;
	      Redraw=1;
	      break;
	    }
	  case 81:
	    {
              int t=param[pptr++],c1=CurrentCounter;              
	      CurrentCounter=Counters[t];
	      Counters[t]=c1;
              if(isSeasOfBlood&&t==5) LogFlag=!LogFlag;
	      break;
	    }
	  case 82:
	    CurrentCounter+=param[pptr++];
	    break;
	  case 83:
	    CurrentCounter-=param[pptr++];
	    if(CurrentCounter<-1) CurrentCounter= -1;
	    break;
	  case 84:
	    Output(NounText);
	    break;
	  case 85:
	    Output(NounText);
	    Output("\n");
	    break;
	  case 86:
	    Output("\n");
	    break;
	  case 87:
	    {
	      int p=param[pptr++],sr=MyLoc;
	      MyLoc=RoomSaved[p];
	      RoomSaved[p]=sr;
	      Redraw=1;
	      break;
	    }
	  case 88:
            Delay(40);
	    break;
	  case 89:
            {
              int i=param[pptr++];                    // SAGA draw picture n
              if(isSeasOfBlood&&i==2) StartCombat();  // n=2 starts combat in
              break;                                  // "Seas of Blood"
            }
	  default:
	    break;
	}
    }
  return 1+continuation;
}

int PerformActions(int vb,int no)
{
  static int disable_sysfunc=0;                 // Recursion lock
  int ct,fl,doagain=0,d=BitFlags&(1L<<DARKBIT);
  char buf[128];
  if(vb==1&&no==-1)
    {
      Output("Give me a direction too.\n");
      return 0;
    }
  if(vb==1&&no>=1&&no<=6)
    {
      int nl;
      if(Items[LIGHT_SOURCE].Location==MyLoc ||
	Items[LIGHT_SOURCE].Location==CARRIED)
	  d=0;
      if(d) Output("Dangerous to move in the dark!\n");
      nl=Rooms[MyLoc].Exits[no-1];
      if(nl)
	{
          OldLoc=MyLoc;
	  MyLoc=nl;
          Output("OK\n");
	  Look();
	  return 0;
	}
      if(d)
	{
	  Output("I fell down and broke my neck.\n");
          longjmp(jmp_buf,1);
	}
      Output("I can't go in that direction.\n");
      return 0;
    }
  fl=-1;
  for(ct=0;ct<=GameHeader.NumActions;ct++)
    {
      int nv,vv=Actions[ct].Vocab;
      if(vb&&(doagain&&vv)) break;
      if(vb&&!doagain&&!fl) break;
      nv=vv%150;
      vv/=150;
      if((vv==vb)||(doagain&&!Actions[ct].Vocab))
	{
	  if((!vv&&RandomPercent(nv))||doagain||(vv&&(nv==no||!nv)))
	    {
	      int f2;
	      if(fl==-1) fl=-2;
	      if((f2=PerformLine(ct))>0)
	        {
	          fl=0;
	          if(f2==2) doagain=1;
                  if(vb&&!doagain) return 0;
	        }
	    }
	}
      if(Actions[ct+1].Vocab) doagain=0;
    }
  if(fl&&!disable_sysfunc)
    {
      int i;
      if(Items[LIGHT_SOURCE].Location==MyLoc||
        Items[LIGHT_SOURCE].Location==CARRIED)
	  d=0;
      if(vb==10||vb==18)   // hardcoded values
	{
	  if(vb==10)
	    {
              if(!strcmp(NounText,"ALL"))
		{
		  int ct,f=0;
                  if(d)
		    {
		      Output("It is dark.\n");
		      return 0;
		    }
		  for(ct=0;ct<=GameHeader.NumItems;ct++)
		    {
		      if(Items[ct].Location==MyLoc&&Items[ct].AutoGet!=NULL
                        && Items[ct].AutoGet[0]!='*')
			  {
			    no=WhichWord(Items[ct].AutoGet,Nouns);
                            disable_sysfunc=1;
                            PerformActions(vb,no);  // Recursion
			    disable_sysfunc=0;
			    if(CountCarried()==GameHeader.MaxCarry)
			      {
				Output("I've too much to carry.\n");
				return 0;
			      }
			    Items[ct].Location=CARRIED;
			    Redraw=1;
                            strcpy(buf,Items[ct].Text);
                            strcat(buf,": OK\n");
                            Output(buf);
			    f=1;
			  }
		    }
		  if(!f) Output("Nothing taken.\n");
		  return 0;
		}
	      if(no==-1)
		{
                  Output("What?\n");
		  return 0;
		}
	      if(CountCarried()==GameHeader.MaxCarry)
		{
		  Output("I've too much to carry.\n");
		  return 0;
		}
	      i=MatchUpItem(NounText,MyLoc);
	      if(i==-1)
		{
		  Output("It's beyond my power to do that.\n");
		  return 0;
		}
	      Items[i].Location= CARRIED;
              Output("OK\n");
	      Redraw=1;
	      return 0;
	    }
	  if(vb==18)
	    {
              if(!strcmp(NounText,"ALL"))
		{
		  int ct,f=0;
		  for(ct=0;ct<=GameHeader.NumItems;ct++)
		    {
		      if(Items[ct].Location==CARRIED&&Items[ct].AutoGet&&
                        Items[ct].AutoGet[0]!='*')
			  {
			    no=WhichWord(Items[ct].AutoGet,Nouns);
			    disable_sysfunc=1;
			    PerformActions(vb,no);
			    disable_sysfunc=0;
			    Items[ct].Location=MyLoc;
                            strcpy(buf,Items[ct].Text);
                            strcat(buf,": OK\n");
                            Output(buf);
			    Redraw=1;
			    f=1;
			  }
		    }
		  if(!f) Output("Nothing dropped.\n");
		  return 0;
		}
	      if(no==-1)
		{
                  Output("What?\n");
		  return 0;
		}
	      i=MatchUpItem(NounText,CARRIED);
	      if(i==-1)
		{
		  Output("It's beyond my power to do that.\n");
		  return 0;
		}
	      Items[i].Location=MyLoc;
              Output("OK\n");
	      Redraw=1;
	      return 0;
	    }
	}
    }
  return fl;
}

void InitScrVars(void)
{
  if(TI89)
    {
      TopHeight=42;
      BottomHeight=48;
    }
  else
    {
      TopHeight=54;
      BottomHeight=66;
    }
}

char* MenuSelect(void)
{
  int i,select,SHandle,index=1,ng=0;
  int MHandle=PopupNew("SELECT THE GAME",Q89_92(53,69));
  SYM_ENTRY *SymPtr=SymFindFirst($(advint),1);
  char *fptr;
  DrawClipRect(ScrToWin(ScrRect),ScrRect,A_NORMAL);
  while(SymPtr)
    {
      fptr=HLock(SHandle=SymPtr->handle);
      fptr+=*(int*)fptr-1;
      while(*fptr--);
      if(!memcmp(fptr+2,"SDBF\0\xF8",5)||!strcmp(fptr+2,"ScottFree database"))
        {
          while(*fptr--);
          PopupAddText(MHandle,-1,fptr+2,index);
          if(!menuopt) menuopt=index;
          ng++;
        }
      index++;
      HeapUnlock(SHandle);
      SymPtr=SymFindNext();
    }
  FontSetSys(F_8x10);
  DrawStr(Width/2-56,3,"SCOTTFREE V1.5",A_REPLACE);
  FontSetSys(Q89_92(F_4x6,F_6x8));
  DrawStr(14,Q89_92(71,92),"ScottFree, a Scott Adams game driver",A_REPLACE);
  DrawStr(Q89_92(38,50),Q89_92(78,101),"PC version by Alan Cox",A_REPLACE);
  if(TI89) DrawStr(21,85,"Adapted for TI-89 by Zeljko Juric",A_REPLACE);
  else DrawStr(20,110,"Adapted for TI-92+ by Zeljko Juric",A_REPLACE);
  if(ng) select=PopupDo(MHandle,CENTER,(ng>4)?15:(35-4*ng),menuopt);
  else
    {
      FontSetSys(F_6x8);
      DrawStr(26,30,"No games loaded!!!",A_REPLACE);
      select=0;
      ngetchx();
    }
  ClrScr();
  HeapFree(MHandle);
  if(!select) longjmp(jmp_buf,2);
  menuopt=select;
  SymPtr=SymFindFirst($(advint),1);
  for(i=1;i<select;i++) SymPtr=SymFindNext();
  return SymPtr->name;
}

void Free(void *ptr)
{
  if(ptr) free(ptr);
}

void FreeAll(void)
{
  Free(fpbase); fpbase=NULL;
  Free(Items); Items=NULL;
  Free(Actions); Actions=NULL;
  Free(Verbs); Verbs=NULL;
  Free(Nouns); Nouns=NULL;
  Free(Rooms); Rooms=NULL;
  Free(Messages); Messages=NULL;
}
	
void _main(void)
{
  int vb,no,jmp_res;
  LCD_BUFFER buffer;
  char *fname;
  char restname[30];
  menuopt=1;
  Width=LCD_WIDTH;
  while((jmp_res=setjmp(jmp_buf)))
    {
      if(jmp_res==1) ngetchx();
      FreeAll();
      WinClose(&Upper);
      WinClose(&Lower);
      LCD_restore(buffer);
      if(jmp_res==2) return;
    }
  BitFlags=0;
  ScrCt=0;
  LogFlag=0;
  randomize();
  LCD_save(buffer);
  ClrScr();
  InitScrVars();
  FontSetSys(F_4x6);
  WinOpen(&Upper,MakeWinRect(0,0,Width-1,TopHeight-1),WF_TTY|WF_NOBORDER);
  WinOpen(&Lower,MakeWinRect(0,TopHeight+4,Width-1,TopHeight+BottomHeight+3),
    WF_TTY|WF_NOBORDER);
  fname=MenuSelect();
  WinFont(&Upper,F_4x6);
  WinFont(&Lower,F_4x6);
  WinAttr(&Lower,A_REPLACE);
  DrawLine(0,TopHeight+2,Width-1,TopHeight+2,A_NORMAL);
  OutReset();
  History=MemAlloc(HIST_SIZE);
  memset(History,0,HIST_SIZE);
  LoadDatabase(fname);
  Look();
  Output("Restore a previously saved game (Y/N)?");
  if((GetCh()|32)=='y')
    {
      Output("\nFilename: ");
      LineInput(restname);
      LoadGame(restname);
    }
  WinClr(&Lower);
  OutReset();
  OutFlag=0;
  Look();
  while(1)
    {
      if(Redraw)
        {
          Look();
          Redraw=0;
        }
      PerformActions(0,0);
      if(Redraw)
        {
          Look();
	  Redraw=0;
        }
      GetInput(&vb,&no);
      switch(PerformActions(vb,no))
        {
          case -1:
            Output("I don't understand your command.\n");
	    break;
          case -2:
            Output("I can't do that yet.\n");
	    break;
	}
      if(Items[LIGHT_SOURCE].Location!=DESTROYED&&GameHeader.LightTime!=-1)
	{
	  GameHeader.LightTime--;
	  if(GameHeader.LightTime<1)
	    {
	      BitFlags|=(1L<<LIGHTOUTBIT);
	      if(Items[LIGHT_SOURCE].Location==CARRIED ||
	        Items[LIGHT_SOURCE].Location==MyLoc)
		  Output("Light has run out! ");
	    }
	  else if(GameHeader.LightTime<25)
	    {
	      if(Items[LIGHT_SOURCE].Location==CARRIED ||
		Items[LIGHT_SOURCE].Location==MyLoc)
                  if(!(GameHeader.LightTime%5))
		    Output("Your light is growing dim. ");
	    }
        }
    }
}

// The following procedure is adhoc procedure used only in "Seas of Blood".
// Nothing similar does not exist in any other "Adventure International" game.

void StartCombat(void)
{
  static char *goodmsg[]={"You give a heavy blow.","You slash your enemy.",
    "You give a lethal swipe.","You hit hard.","You wound your opponent."};
  static char *badmsg[]={"You are wounded.","You receive a heavy blow.",
    "You are hit.","You take a solid hit.","You are struck."};
  static char *nmsg[]={"You duck a heavy swipe.","Drat. Missed him.",
    "You avoid his blow.","Phew. That was close.","Missed."};
  static char *cgoodmsg[]={"Your cannonfire smashes into the enemy.",
    "A broadside smashes into the enemy vessel.","Good shot.","Direct hit.",
    "Their rigging is shot away."};
  static char *cbadmsg[]={"The Banshee is hit.","Your rigging is hit.",
    "The Banshee takes a broadside.","A cannonball smashes into the deck.",
    "A salvo hits the Banshee."};
  static char *cnmsg[]={"Sack the gunners.","Missed.","You fired wide.",
    "Too short.","No effect."};
  static unsigned char enemies[]={92,93,94,89,79,85,19,54,61,80,75,73,71,58,
    59,56,95,67,100,103,111,108,107,22,91,69,42};
  static unsigned skills[]={8,6,8,8,8,8,8,6,8,8,8,8,7,9,9,9,7,9,9,10,7,12,9,
    10,7,9,10};
  static unsigned char staminas[]={6,8,7,7,7,7,6,12,6,6,8,10,8,4,6,8,9,6,4,3,
    4,12,4,6,6,8,6};
  char buf[100];
  int key,i,r1,r2,r3=1,r4=1,rm,crew=FALSE,eskill=8,estam=6,ystam;
  BitFlags|=64L;
  for(i=0;i<27;i++)
    if(Items[enemies[i]].Location==MyLoc)
      {
        eskill=skills[i];
        estam=staminas[i];
        crew=(i<7);
        break;
      }
  ystam=crew?Counters[7]:Counters[3];
  Output("You are attacked!");
  ngetchx();
  Look();
  do
    {
      WinClr(&Lower);
      WinStrXY(&Lower,0,2,"ENEMY");
      WinStrXY(&Lower,80,2,"YOU");
      sprintf(buf,crew?"Strike:  %d":"Skill:  %d",eskill);
      WinStrXY(&Lower,0,12,buf);
      WinStrXY(&Lower,80,12,crew?"Strike:  9":"Skill:  9");
      sprintf(buf,crew?"Crew strength:  %d":"Stamina:  %d",estam);
      WinStrXY(&Lower,0,18,buf);
      sprintf(buf,crew?"Crew strength:  %d":"Stamina:  %d",ystam);
      WinStrXY(&Lower,80,18,buf);
      for(i=1;i<=15;i++)
        {
          r1=1+random(6); r2=1+random(6);
          sprintf(buf,"%d + %d + %d    ",r1,r2,eskill);
          WinStrXY(&Lower,0,26,buf);
          Delay(5);
        }
      sprintf(buf,"%d + %d + %d = %d",r1,r2,eskill,r1+r2+eskill);
      WinStrXY(&Lower,0,26,buf);
      if(kbhit()) ngetchx();
      while(!kbhit())
        {
          r3=1+random(6); r4=1+random(6);
          sprintf(buf,"%d + %d + 9    ",r3,r4);
          WinStrXY(&Lower,80,26,buf);
          Delay(5);
        }
      key=ngetchx();
      if(key==4139) r3=r4=6;
      if(key==4141) r3=r4=1;
      sprintf(buf,"%d + %d + 9 = %d",r3,r4,r3+r4+9);
      WinStrXY(&Lower,80,26,buf);
      rm=random(5);
      if(r1+r2+eskill>r3+r4+9)
        {
          WinStrXY(&Lower,0,35,(crew?cbadmsg:badmsg)[rm]);
          ystam-=2;
        }
      else if(r1+r2+eskill<r3+r4+9)
        {
          WinStrXY(&Lower,0,35,(crew?cgoodmsg:goodmsg)[rm]);
          estam-=2;
        }
      else WinStrXY(&Lower,0,35,(crew?cnmsg:nmsg)[rm]);
      if(estam>0&&ystam>0)
        {
          WinStrXY(&Lower,0,43,"[ENTER] to continue");
          if(!crew) WinStrXY(&Lower,73,43,"[ESC] to run");
          key=ngetchx();
        }
      if(!crew&&key==KEY_ESC) estam=0;
    } while(estam>0&&ystam>0);
  (crew?Counters[7]:Counters[3])=ystam;
  if(!crew&&key==KEY_ESC)
    {
      MyLoc=OldLoc; Redraw=1;
    }
  else
    {
      WinStrXY(&Lower,0,43,(ystam>0)?"YOU HAVE WON!":
        (crew?"THE BANSHEE HAS BEEN SUNK!":"YOU HAVE BEEN KILLED"));
      BitFlags&=~64L;
      ngetchx();
    }
  WinClr(&Lower);
  OutReset();
}

// If you have any comment, suggestions, questions or bug reports, mail me at:
// zjuric@utic.net.ba

// Zeljko Juric
// Sarajevo
// Bosnia & Herzegovina
