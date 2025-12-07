.include "lib/kernel.exp"
.org text_org

; sys_fdc_restore
; sys_fdc_step
; sys_fdc_step_in
; sys_fdc_step_out
; sys_fdc_seek
; sys_fdc_format_128
; sys_fdc_format_512
; sys_fdc_read_addr
; sys_fdc_read_track
; sys_fdc_read_sect
; sys_fdc_write_sect
; sys_fdc_force_int

main:
  mov bp, $ffff
  mov sp, $ffff

  mov d, str0
  call _puts

menu:
  mov d, s_menu
  call _puts
  call getch
  cmp ah, '0'
  je step_in
  cmp ah, '1'
  je step_out
  cmp ah, '2'
  je restore
  cmp ah, '3'
  je status0
  cmp ah, '4'
  je status1
  cmp ah, '5'
  je format_128
  cmp ah, '6'
  je format_disk_128
  cmp ah, '7'
  je format_512
  cmp ah, '8'
  je format_disk_512
  cmp ah, '9'
  je read_track
  cmp ah, 'A'
  je read_sect_128
  cmp ah, 'B'
  je read_sect_512
  cmp ah, 'C'
  je fdc_options
  cmp ah, 'D'
  je fdc_write_sec_128
  cmp ah, 'E'
  je fdc_write_sec_512
  jmp menu

restore:
  mov al, fdc_al_restore
  syscall sys_fdc
  jmp menu
step:
  mov al, fdc_al_step
  syscall sys_fdc
  jmp menu
step_in:
  mov al, fdc_al_step_in
  syscall sys_fdc
  jmp menu
step_out:
  mov al, fdc_al_step_out
  syscall sys_fdc
  jmp menu
seek:
  mov al, fdc_al_seek
  syscall sys_fdc
  jmp menu

format_128:
  mov d, s_track
  call _puts
  call scan_u8x   ; in al
  mov bl, al      ; track needs to be in bl
  mov al, fdc_al_format_128
  syscall sys_fdc
  mov d, s_format_done
  call _puts
  jmp menu

format_disk_128:
  mov al, fdc_al_formatdisk_128
  syscall sys_fdc
  mov d, s_format_done
  call _puts
  jmp menu

format_512:
  mov d, s_track
  call _puts
  call scan_u8x   ; in al
  mov bl, al      ; track needs to be in bl
  mov al, fdc_al_format_512
  syscall sys_fdc
  mov d, s_format_done
  call _puts
  jmp menu

format_disk_512:
  mov al, fdc_al_formatdisk_512
  syscall sys_fdc
  mov d, s_format_done
  call _puts
  jmp menu

read_track:
  mov al, fdc_al_read_track
  mov di, transient_area
  syscall sys_fdc
  mov b, a   ; number of bytes to output
  mov d, transient_area
  call cmd_hexd
  jmp menu

read_addr:
  jmp menu

read_sect_128:
  mov d, s1
  call _puts
  call scan_u8x
  mov bh, al
  mov d, s2
  call _puts
  call scan_u8x ; in al 
  mov bl, al
  mov al, fdc_al_read_sect
  mov di, transient_area
  syscall sys_fdc
  mov d, transient_area
  mov b, 128
  call cmd_hexd
  jmp menu

read_sect_512:
  mov d, s1
  call _puts
  call scan_u8x
  mov bh, al
  mov d, s2
  call _puts
  call scan_u8x ; in al 
  mov bl, al
  mov al, fdc_al_read_sect
  mov di, transient_area
  syscall sys_fdc
  mov d, transient_area
  mov b, 512
  call cmd_hexd
  jmp menu

fdc_write_sec_128:
  mov d, s1
  call _puts
  call scan_u8x
  mov bh, al
  mov d, s2
  call _puts
  call scan_u8x ; in al
  mov bl, al
  mov al, fdc_al_write_sect
  mov si, fdc_sec_data_128
  mov c, 128
  syscall sys_fdc
  jmp menu

fdc_write_sec_512:
  mov d, s1
  call _puts
  call scan_u8x
  mov bh, al
  mov d, s2
  call _puts
  call scan_u8x ; in al
  mov bl, al
  mov al, fdc_al_write_sect
  mov si, fdc_sec_data_512
  mov c, 512
  syscall sys_fdc
  jmp menu

fdc_options:
  mov d, ss3
  call _puts
  call scan_u8x
  mov bl, al
  mov al, 2
  mov d, _fdc_config
  syscall sys_system
  jmp menu

status0:
  call printnl
  mov al, fdc_al_status0
  syscall sys_fdc
  mov bl, al
  call print_u8x   ; print bl
  call printnl
  jmp menu

status1:
  call printnl
  mov al, fdc_al_status1
  syscall sys_fdc
  mov bl, al
  call print_u8x   ; print bl
  call printnl
  jmp menu


; b : len
; d: data address
cmd_hexd:
  call printnl
  mov a, d
  mov [start], a
  mov [length], b

	mov a, [start]
  mov d, a        ; dump pointer in d
  mov c, 0
dump_loop:
  mov al, cl
  and al, $0f
  jz print_base
back:
  mov al, [d]        ; read byte
  mov bl, al
  call print_u8x
  mov a, $2000
  syscall sys_io      ; space
  mov al, cl
  and al, $0f
  cmp al, $0f
  je print_ascii
back1:
  inc d
  inc c
  mov a, [length]
  cmp a, c
  jne dump_loop
  call printnl
  ret

print_ascii:
  sub d, 16
  mov b, 16
print_ascii_l:
  inc d
  mov al, [d]        ; read byte
  cmp al, $20
  jlu dot
  cmp al, $7e
  jleu ascii
dot:
  mov a, $2e00
  syscall sys_io
  jmp ascii_continue
ascii:
  mov ah, al
  mov al, 0
  syscall sys_io
ascii_continue:
  loopb print_ascii_l
  jmp back1
print_base:
  call printnl
  mov b, d
  sub b, transient_area
  call print_u16x        ; display row
  add b, transient_area
  mov a, $2000
  syscall sys_io
  jmp back
  ret

.include "lib/stdio.asm"

start:   .dw 0
length:  .dw 1024


s_track: .db "\ntrack: ", 0

s_menu:  .db "\n0. step in\n"
         .db "1. step out\n", 
         .db "2. restore\n", 
         .db "3. read status 1\n", 
         .db "4. read status 2\n", 
         .db "5. format track 128\n", 
         .db "6. format disk 128\n", 
         .db "7. format track 512\n", 
         .db "8. format disk 512\n", 
         .db "9. read track\n", 
         .db "A. read sector 128\n", 
         .db "B. read sector 512\n", 
         .db "C. config\n", 
         .db "D. write 128 byte sector\n", 
         .db "E. write 512 byte sector\n", 
         .db "\nselect option: ", 0

s_format_done: .db "\nformat done.\n", 0
str0:    .db "\nselecting drive 0...\n", 0
str1:    .db "\nwaiting...\n", 0
s1:      .db "\ntrack: ", 0
s2:      .db "\nsector: ", 0
ss3:     .db "\nvalue: ", 0

fdc_sec_data_128:
  .db "Example data for a write sector instruction. There are 128 bytes "
  .db "per sector in this format, 40 tracks per disk. Single Density."

;  .db $ff, $ee, $e0, $55, $66, $33, $42, $aa, $ae, $67, $23, $11, $23, $56, $88, $99,
;  .db $1f, $2e, $40, $53, $63, $43, $52, $1a, $a4, $67, $03, $31, $43, $56, $48, $f9,
;  .db $2f, $3e, $50, $57, $62, $53, $21, $2a, $a3, $17, $73, $41, $53, $46, $38, $b9,
;  .db $6f, $4e, $20, $56, $67, $63, $20, $6a, $a2, $27, $53, $61, $23, $16, $28, $e9,
;  .db $af, $7e, $10, $52, $62, $73, $18, $5a, $a1, $37, $43, $51, $13, $26, $18, $a9,
;  .db $6f, $3e, $90, $51, $63, $03, $18, $4a, $a5, $67, $33, $41, $43, $36, $68, $c9,
;  .db $8f, $5e, $60, $55, $68, $23, $18, $3a, $a3, $57, $23, $31, $73, $36, $48, $b9,
;  .db $2f, $1e, $40, $53, $69, $13, $19, $3a, $a1, $48, $23, $21, $53, $46, $38, $a9
fdc_sec_data_512:
  .db $ff, $ee, $e0, $55, $66, $33, $42, $aa, $ae, $67, $23, $11, $23, $56, $88, $99,
  .db $1f, $2e, $40, $53, $63, $43, $52, $1a, $a4, $67, $03, $31, $43, $56, $48, $f9,
  .db $2f, $3e, $50, $57, $62, $53, $21, $2a, $a3, $17, $73, $41, $53, $46, $38, $b9,
  .db $6f, $4e, $20, $56, $67, $63, $20, $6a, $a2, $27, $53, $61, $23, $16, $28, $e9,
  .db $af, $7e, $10, $52, $62, $73, $18, $5a, $a1, $37, $43, $51, $13, $26, $18, $a9,
  .db $6f, $3e, $90, $51, $63, $03, $18, $4a, $a5, $67, $33, $41, $43, $36, $68, $c9,
  .db $8f, $5e, $60, $55, $68, $23, $18, $3a, $a3, $57, $23, $31, $73, $36, $48, $b9,
  .db $2f, $1e, $40, $53, $69, $13, $19, $3a, $a1, $48, $23, $21, $53, $46, $38, $a9,
  .db $ff, $ee, $e0, $55, $66, $33, $42, $aa, $ae, $67, $23, $11, $23, $56, $88, $99,
  .db $1f, $2e, $40, $53, $63, $43, $52, $1a, $a4, $67, $03, $31, $43, $56, $48, $f9,
  .db $2f, $3e, $50, $57, $62, $53, $21, $2a, $a3, $17, $73, $41, $53, $46, $38, $b9,
  .db $6f, $4e, $20, $56, $67, $63, $20, $6a, $a2, $27, $53, $61, $23, $16, $28, $e9,
  .db $af, $7e, $10, $52, $62, $73, $18, $5a, $a1, $37, $43, $51, $13, $26, $18, $a9,
  .db $6f, $3e, $90, $51, $63, $03, $18, $4a, $a5, $67, $33, $41, $43, $36, $68, $c9,
  .db $8f, $5e, $60, $55, $68, $23, $18, $3a, $a3, $57, $23, $31, $73, $36, $48, $b9,
  .db $2f, $1e, $40, $53, $69, $13, $19, $3a, $a1, $48, $23, $21, $53, $46, $38, $a9,
  .db $ff, $ee, $e0, $55, $66, $33, $42, $aa, $ae, $67, $23, $11, $23, $56, $88, $99,
  .db $1f, $2e, $40, $53, $63, $43, $52, $1a, $a4, $67, $03, $31, $43, $56, $48, $f9,
  .db $2f, $3e, $50, $57, $62, $53, $21, $2a, $a3, $17, $73, $41, $53, $46, $38, $b9,
  .db $6f, $4e, $20, $56, $67, $63, $20, $6a, $a2, $27, $53, $61, $23, $16, $28, $e9,
  .db $af, $7e, $10, $52, $62, $73, $18, $5a, $a1, $37, $43, $51, $13, $26, $18, $a9,
  .db $6f, $3e, $90, $51, $63, $03, $18, $4a, $a5, $67, $33, $41, $43, $36, $68, $c9,
  .db $8f, $5e, $60, $55, $68, $23, $18, $3a, $a3, $57, $23, $31, $73, $36, $48, $b9,
  .db $2f, $1e, $40, $53, $69, $13, $19, $3a, $a1, $48, $23, $21, $53, $46, $38, $a9,
  .db $ff, $ee, $e0, $55, $66, $33, $42, $aa, $ae, $67, $23, $11, $23, $56, $88, $99,
  .db $1f, $2e, $40, $53, $63, $43, $52, $1a, $a4, $67, $03, $31, $43, $56, $48, $f9,
  .db $2f, $3e, $50, $57, $62, $53, $21, $2a, $a3, $17, $73, $41, $53, $46, $38, $b9,
  .db $6f, $4e, $20, $56, $67, $63, $20, $6a, $a2, $27, $53, $61, $23, $16, $28, $e9,
  .db $af, $7e, $10, $52, $62, $73, $18, $5a, $a1, $37, $43, $51, $13, $26, $18, $a9,
  .db $6f, $3e, $90, $51, $63, $03, $18, $4a, $a5, $67, $33, $41, $43, $36, $68, $c9,
  .db $8f, $5e, $60, $55, $68, $23, $18, $3a, $a3, $57, $23, $31, $73, $36, $48, $b9,
  .db $2f, $1e, $40, $53, $69, $13, $19, $3a, $a1, $48, $23, $21, $53, $46, $38, $a9

transient_area: .db 0

.end
