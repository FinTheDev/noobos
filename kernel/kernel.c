void kernel_main(void) {
    volatile char *vga = (volatile char *)0xB8000;

    for (int i = 0; i < 80 * 25; i++) {
        vga[i * 2] = ' ';
        vga[i * 2 + 1] = 0x0F;
    }

    vga[0] = 'H';
    vga[1] = 0x0F;
    vga[2] = 'i';
    vga[3] = 0x0F;

    while (1) {}
}
