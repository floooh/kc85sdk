#include "caos.h"

void hello() {
    char i;
    for (i = 0; i < 10; i++) {
        caos_put("Hello World!\n\r");
    }
}
caos_entry("HELLO", hello)

