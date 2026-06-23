CC = gcc
AS = nasm

CFLAGS = -m64 -ffreestanding -nostdlib -mno-red-zone -c
LDFLAGS = -m elf_x86_64 -T linker.ld

C_SOURCES = \
	kernel/idt.c \
	kernel/kernel.c \
	kernel/terminal.c

C_OBJECTS = $(C_SOURCES:.c=.o)

all: run

rebuild: clean run

boot.o: boot/boot.asm
	nasm -f elf64 boot/boot.asm -o boot.o

gdt.o: boot/gdt.asm
	nasm -f elf64 boot/gdt.asm -o gdt.o

idt.o: boot/idt.asm
	nasm -f elf64 boot/idt.asm -o idt.o

isr.o: boot/isr.asm
	nasm -f elf64 boot/isr.asm -o isr.o

lm.o: boot/lm.asm
	nasm -f elf64 boot/lm.asm -o lm.o

paging.o: boot/paging.asm
	nasm -f elf64 boot/paging.asm -o paging.o

%.o: %.c
	gcc $(CFLAGS) $< -o $@

kernel.elf: boot.o gdt.o idt.o isr.o lm.o paging.o $(C_OBJECTS)
	ld $(LDFLAGS) $^ -o kernel.elf

iso: kernel.elf
	mkdir -p iso/boot/grub
	cp kernel.elf iso/boot/kernel.elf
	cp grub.cfg iso/boot/grub/grub.cfg
	grub-mkrescue -o noobos.iso iso

run: iso
	qemu-system-x86_64 -cdrom noobos.iso -boot d

clean:
	rm -rf *.o kernel/*.o *.elf noobos.iso iso/boot/kernel.elf
