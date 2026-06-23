#include "terminal.h"

void kernel_main(void) {
    terminal_clear();
    terminal_write("Hello");

    while (1) {
        __asm__ volatile("hlt");
    }
}
