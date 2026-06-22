CC = gcc
AS = nasm

CFLAGS = -m32 -ffreestanding -nostdlib -c
LDFLAGS = -m elf_i386 -T linker.ld

all: run

boot.o: boot/boot.asm
	nasm -f elf32 boot/boot.asm -o boot.o

gdt.o: boot/gdt.asm
	nasm -f elf32 boot/gdt.asm -o gdt.o

lm.o: boot/lm.asm
	nasm -f elf32 boot/lm.asm -o lm.o

paging.o: boot/paging.asm
	nasm -f elf32 boot/paging.asm -o paging.o

kernel.o: kernel/kernel.c
	gcc $(CFLAGS) kernel/kernel.c -o kernel.o

kernel.elf: boot.o gdt.o lm.o paging.o kernel.o
	ld $(LDFLAGS) boot.o gdt.o lm.o paging.o kernel.o -o kernel.elf

iso: kernel.elf
	mkdir -p iso/boot/grub
	cp kernel.elf iso/boot/kernel.elf
	cp grub.cfg iso/boot/grub/grub.cfg
	grub-mkrescue -o noobos.iso iso

run: iso
	qemu-system-x86_64 -cdrom noobos.iso

clean:
	rm -rf *.o *.elf noobos.iso iso/boot/kernel.elf
