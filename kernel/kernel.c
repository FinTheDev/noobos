#include "terminal.h"
#include "colors.h"

void kernel_main(void) {
    terminal_clear();
    terminal_write("NoobOS", light_red);
    terminal_write(" Kernel ", white);
    terminal_write("v0.1\n\n", dark_grey);

    terminal_write("[", dark_grey);
    terminal_write("OK", light_green);
    terminal_write("] ", dark_grey);
    terminal_write("Boot successful\n", white);

    while (1) {
        __asm__ volatile("hlt");
    }
}
