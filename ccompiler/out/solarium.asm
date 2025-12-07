; --- FILENAME: ../solarium
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
