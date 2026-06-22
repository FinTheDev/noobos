global pml4_table
global setup_paging
global pml4_table
global pdpt_table
global pd_table

section .bss

align 4096
pml4_table:
    resq 512

align 4096
pdpt_table:
    resq 512

align 4096
pd_table:
    resq 512

section .text

setup_paging:
    mov eax, pdpt_table
    or eax, 0b11
    mov [pml4_table], eax

    mov eax, pd_table
    or eax, 0b11
    mov [pdpt_table], eax

    mov eax, 0
    or eax, 0b10000011
    mov [pd_table], eax

    ret
