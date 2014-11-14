#include "caos.h"

void hello() {
    char i;
    for (i = 0; i < 16; i++) {
        // set background and foreground color
        caos_color(CAOS_WHITE, i);
        // print string literal
        caos_putl("Hello World!\n\r");
    }
    // set color to black on gray
    caos_color(CAOS_WHITE, CAOS_BLACK);
}
// define func 'hello' as CAOS shell command 'HELLO'
caos_entry("HELLO", hello)

