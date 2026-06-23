bits 64

global isr0

section .text

isr0:
    cli
.loop:
    hlt
    jmp .loop
