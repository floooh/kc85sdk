//------------------------------------------------------------------------------
//  caos_line(x0, y0, x1, y1)
//  
//  Draw line from (x0, y0) to (x1, y1), limited to the left 256x256
//  screen area.
//------------------------------------------------------------------------------
#include "../../caos.h"

void set_pixel(short x, short y) {
    // note, the KC85/4 vidmem is vertically organized!
    unsigned char* addr = (unsigned char*) 0x8000;
    addr[((x>>3)<<8) + y] ^= 0x80 >> (x&7); 
}

void caos_line(short x0, short y0, short x1, short y1) {

    short dx, dy, sx, sy;
    short err, e2;
    dx = x1 - x0;
    if (dx > 0) {
        sx = 1;
    }
    else {
        dx = -dx;
        sx = -1;
    }
    dy = y1 - y0;
    if (dy > 0) {
        sy = 1;
    }
    else {
        dy = -dy;
        sy = -1;
    }
    err = (dx > dy ? dx : -dy) / 2;
    for (;;) {
        set_pixel(x0, y0);
        if (x0 == x1 && y0 == y1) break;
        e2 = err;
        if (e2 > -dx) {
            err -= dy;
            x0 += sx;
        }
        if (e2 < dy) {
            err += dx;
            y0 += sy;
        }
    }
// regular operating system line function
#if 0
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
#endif
}

