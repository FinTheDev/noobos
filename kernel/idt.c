#include "idt.h"

static struct IDTEntry idt[256];
static struct IDTPointer idt_ptr;

extern void load_idt(struct IDTPointer* idt_ptr);
extern void isr0(void);

static void idt_set_gate(
    int vector,
    uint64_t handler,
    uint16_t selector,
    uint8_t flags
) {
    idt[vector].offset_low = handler & 0xFFFF;
    idt[vector].selector = selector;
    idt[vector].ist = 0;
    idt[vector].type_attr = flags;
    idt[vector].offset_mid = (handler >> 16) & 0xFFFF;
    idt[vector].offset_high = (handler >> 32) & 0xFFFFFFFF;
    idt[vector].zero = 0;
}

void idt_init(void) {
    idt_ptr.limit = sizeof(idt) - 1;
    idt_ptr.base = (uint64_t)&idt;

    idt_set_gate(
        0,
        (uint64_t)isr0,
        0x08,
        0x8E
    );

    load_idt(&idt_ptr);
}
