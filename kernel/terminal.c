static int row = 0;
static int column = 0;
static volatile char* const vga = (volatile char*)0xb8000;

void terminal_clear(void) {
    for (int i = 0; i < 80 * 25; i++) {
        vga[i * 2] = ' ';
        vga[i * 2 + 1] = 0x0F;
    }
}

void terminal_putchar(char c, unsigned char color) {
    if (c == '\n') {
        row++;
        column = 0;
    } else {
        int index = (row * 80 + column) * 2;
        
        vga[index] = c;
        vga[index + 1] = color;
        
        column++;
        if (column >= 80) {
            column = 0;
            row++;
        }
    }

    if (row >= 25) {
        row = 0;
    }
}

void terminal_write(const char* data, unsigned char color) {
    for (int i = 0; data[i] != '\0'; i++) {
        terminal_putchar(data[i], color);
    }
}
