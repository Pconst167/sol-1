.org 1024

.text


main:
  mov a, 1
  add a, 1

  syscall 11

.end


.data


table_power:
  .dw 1
  .dw 10
  .dw 100
  .dw 1000
  .dw 10000

.end

