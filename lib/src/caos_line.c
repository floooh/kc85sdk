//------------------------------------------------------------------------------
//  caos_line(x0, y0, x1, y1)
//  
//  Draw line from (x0, y0) to (x1, y1), limited to the left 256x256
//  screen area.
//------------------------------------------------------------------------------
#include "../../caos.h"

void caos_line(unsigned char x0, unsigned char y0, unsigned char x1, unsigned char y1) __naked {
    x0, y0, x1, y1;
    __asm
    push af
    push bc
    push de
    push hl

    ld h,#0
    ld iy,#10
    add iy,sp
    ld l,0(iy)
    ld (#CAOS_ARG1),hl
    ld l,1(iy)
    ld (#CAOS_ARG2),hl
    ld l,2(iy)
    ld (#CAOS_ARG3),hl
    ld l,3(iy)
    ld (#CAOS_ARG4),hl
    ld a,#(CAOS_WHITE<<3) | 1
    ld (#CAOS_FARB),a
    call 0xf003
    .db 0x3e

    pop hl
    pop de
    pop bc
    pop af
    ret
    __endasm;
}

