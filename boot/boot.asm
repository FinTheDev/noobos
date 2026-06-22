bits 32

section .multiboot2
align 8

header_start:
    dd 0xE85250D6
    dd 0
    dd header_end - header_start
    dd -(0xE85250D6 + 0 + (header_end - header_start))

    dw 0
    dw 0
    dd 8

header_end:

section .text
global _start
extern check_long_mode_support
extern enable_long_mode
extern kernel_main

_start:
    call check_long_mode_support
    call enable_long_mode
    call kernel_main

.hang:
    cli
.loop:
    hlt
    jmp .hang
