//------------------------------------------------------------------------------
//  caos_line(x0, y0, x1, y1)
//  
//  Draw line from (x0, y0) to (x1, y1), limited to the left 256x256
//  screen area.
//------------------------------------------------------------------------------
#include "../../caos.h"

unsigned char bit[8] = {
    0x80, 0x40, 0x20, 0x10, 0x8, 0x4, 0x2, 0x1
};

void set_pixel(unsigned char x, unsigned char y) {
    // note, the KC85/4 vidmem is vertically organized!
    unsigned char* addr = (unsigned char*) 0x8000;
    //addr[((x>>3)<<8) + y] ^= 0x80 >> (x&7); 
    addr[((x / 8) * 0x100) + y] ^= bit[x & 7];
}

// assume that y1 >= y0 and x1 >= x0
void caos_line_x0x1(unsigned char x0, unsigned char y0, unsigned char x1, unsigned char y1) {

    char dx, dy;
    char err, e2;
    
    dx = x1 - x0;
    dy = y1 - y0;
    err = (dx > dy ? dx : -dy) / 2;
    for (;;) {
        set_pixel(x0, y0);
        if (x0 == x1 && y0 == y1) break;
        e2 = err;
        if (e2 > -dx) {
            err -= dy;
            x0++;
        }
        if (e2 < dy) {
            err += dx;
            y0++;
        }
    }
}

// assume that y1 < y0 and x1 >= x0
void caos_line_x1x0(unsigned char x0, unsigned char y0, unsigned char x1, unsigned char y1) {

    char dx, dy;
    char err, e2;
    
    dx = x0 - x1;
    dy = y1 - y0;
    err = (dx > dy ? dx : -dy) / 2;
    for (;;) {
        set_pixel(x0, y0);
        if (x0 == x1 && y0 == y1) break;
        e2 = err;
        if (e2 > -dx) {
            err -= dy;
            x0--;
        }
        if (e2 < dy) {
            err += dx;
            y0++;
        }
    }
}

// assume that y1 >= y0
void caos_line_y0y1(unsigned char x0, unsigned char y0, unsigned char x1, unsigned char y1) {

    if (x0 < x1) {
        caos_line_x0x1(x0, y0, x1, y1);
    }
    else {
        caos_line_x1x0(x0, y0, x1, y1);
    }
}

void caos_line(unsigned char x0, unsigned char y0, unsigned char x1, unsigned char y1) {
    if (y0 < y1) {
        caos_line_y0y1(x0, y0, x1, y1);
    }
    else {
        caos_line_y0y1(x1, y1, x0, y0);
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

