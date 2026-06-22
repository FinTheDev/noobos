global gdt_pointer
global gdt_start

section .rodata

align 8
gdt_start:
    dq 0x0000000000000000
    dq 0x00209A0000000000
    dq 0x0000920000000000
gdt_end:

align 8
gdt_pointer:
    dw gdt_end - gdt_start - 1
    dq gdt_start
