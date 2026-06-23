bits 64

global load_idt

section .text

load_idt:
    lidt [rdi]
    ret
