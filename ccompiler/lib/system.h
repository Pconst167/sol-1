int file_exists(char *filename){
  int file_exists;
  asm{
    @filename
    mov d, [d]
    mov al, 21
    syscall sys_filesystem
    @file_exists
    mov [d], a
  }
  return file_exists;
}

void cd_to_dir(char *dir){
  int dirID;
  asm{
    @dir
    mov d, [d]
    mov al, 19
    syscall sys_filesystem ; get dirID in 'A'
    @dirID
    mov d, [d]
    mov [d], a ; set dirID
  }
  if(dirID != -1){
    asm{
      mov b, a
      mov al, 3
      syscall sys_filesystem
    }
  }
}

void print_cwd(){
  asm{
    mov al, 18
    syscall sys_filesystem        ; print current directory
  }
}

int spawn_new_proc(char *executable_path, char *args){
  asm{
    @args
    mov b, [d]
    @executable_path
    mov d, [d]
    syscall sys_spawn_proc
  }
}