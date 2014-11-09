#include "caos.h"

void hello() {
    char i;
    caos_clear();
    for (i = 0; i < 16; i++) {
        caos_color(CAOS_BLUE, i);
        caos_putl("Hello World!\n\r");
    }
    caos_color(CAOS_BLUE, CAOS_WHITE);
}
caos_entry("HELLO", hello)

