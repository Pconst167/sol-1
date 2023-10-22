#include <token.h>

char *transient_area;

void read_sect(char *dest, int initial_sect, char num_sect){
  asm{
    meta mov d, initial_sect
    mov d, [d]
    mov b, d
    inc b                        ; metadata sector
    
    mov c, 0                     ; reset LBA to 0
    
    meta mov d, num_sect
    mov d, [d]
    mov al, dl
    mov ah, al                   ; num sectors

    meta mov d, dest
    mov d, [d]
    mov d, transient_area
    call ide_read_sect           ; read directory
  }
}

void main(){
  char ls_count;
  char ls_filetype;
  char ls_file_attrib;

  prog = 0;
  ls_count = 0;
  transient_area = alloc(1536);

asm{
  ; dirID in B
  fs_ls:
    inc b                        ; metadata sector
    mov c, 0                     ; reset LBA to 0
    mov ah, $01                  ; disk read
    mov d, transient_area
    call ide_read_sect           ; read directory
    cla
    mov [index], a               ; reset entry index
    mov [ls_count], al           ; reset item count
  fs_ls_L1:
    cmp byte [d], 0              ; check for NULL
    je fs_ls_next
  fs_ls_non_null:
    mov al, [ls_count]
    inc al
    mov [ls_count], al           ; increment item count
    mov al, [d + 24]
    and al, %00111000
    shr al, 3
    mov [ls_file_type], al       ; save file type for formatting purposes
    mov ah, 0                    ; file type
    mov a, [a + file_type]      
    mov ah, al
    call _putchar
    mov al, [d + 24]
    and al, %00000001
    mov ah, 0
    mov a, [a + file_attrib]     ; read
    mov ah, al
    call _putchar
    mov al, [d + 24]
    and al, %00000010
    mov ah, 0
    mov a, [a + file_attrib]     ; write
    mov ah, al
    call _putchar
    mov al, [d + 24]
    and al, %00000100
    mov ah, 0
    mov [ls_file_attrib], al
    mov a, [a + file_attrib]     ; execute
    mov ah, al
    call _putchar
    mov ah, $20
    call _putchar  
    mov a, [d + 27]
    call print_u16d              ; filesize
    mov ah, $20
    call _putchar  
    mov a, [d + 25]
    call print_u16d              ; dirID / LBA
    mov ah, $20
    call _putchar
  ; print date
    mov bl, [d + 29]             ; day
    call print_u8x
    mov ah, $20
    call _putchar  
    mov al, [d + 30]             ; month
    shl al, 2
    push d
    mov d, s_months
    mov ah, 0
    add d, a
    call _puts
    pop d
    mov ah, $20
    call _putchar
    mov bl, $20
    call print_u8x
    mov bl, [d + 31]             ; year
    call print_u8x  
    mov ah, $20
    call _putchar  

  fs_ls_print:
    call _puts                   ; print filename  
  ; post-format the file name
    mov al, [ls_file_type]
    cmp al, 1
    je fs_ls_format_dir
  fs_ls_formatexe_test:
    mov al, [ls_file_attrib]
    cmp al, 4         ; 4 if bit 3 is set in the attributes, indicating "executable"
    je fs_ls_format_exe
  fs_ls_newline:
    call printnl
  fs_ls_next:
    mov a, [index]
    inc a
    mov [index], a
    cmp a, FST_FILES_PER_DIR
    je fs_ls_end
    add d, 32      
    jmp fs_ls_L1  
  fs_ls_end:
    mov d, s_ls_total
    call _puts
    mov al, [ls_count]
    call print_u8d
    call printnl
    sysret
  fs_ls_format_dir:
    mov ah, '/'
    call _putchar
    jmp fs_ls_formatexe_test
  fs_ls_format_exe:
    mov ah, '*'
    call _putchar
    jmp fs_ls_newline
  }
}






