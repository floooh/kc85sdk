//-------------------------------------------------------------------------------
//  caos_wait(unsigned char t)
//  Wait for t*6ms.
//-------------------------------------------------------------------------------

void caos_wait(unsigned char t) __naked {
    t;
    __asm
    push af
    push iy
    ld iy, #6
    add iy, sp
    ld a, (iy)
    call 0xf003
    .db 0x14
    pop iy
    pop af
    ret
    __endasm;
}
