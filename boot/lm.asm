section .text

global check_long_mode_support
global enable_long_mode

check_long_mode_support:
    pushfd
    pop eax
    mov ecx, eax

    xor eax, 1 << 21
    push eax
    popfd

    pushfd
    pop eax

    push ecx
    popfd

    xor eax, ecx
    jz .no_cpuid

    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb .no_long_mode

    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz .no_long_mode

    ret

.no_cpuid:
    mov al, '1'
    jmp error

.no_long_mode:
    mov al, '2'
    jmp error

error:
    mov byte [0xb8000], al
    mov byte [0xb8001], 0x4f
    hlt
    jmp $

extern gdt_pointer
extern pml4_table
extern setup_paging
extern kernel_main

enable_long_mode:
    lgdt [gdt_pointer]
    
    call setup_paging

    mov eax, pml4_table
    mov cr3, eax

    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    jmp 0x08:long_mode_start

    bits 64

    long_mode_start:
        call kernel_main

    .hang:
        hlt
        jmp .hang
