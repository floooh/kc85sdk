//------------------------------------------------------------------------------
//  caos_clear()
//  Generic clear function, on KC85/3 used to clear the pixel buffer,
//  on KC85/4 used to clear pixel or color buffer.
//------------------------------------------------------------------------------
void caos_clear(unsigned char val) __naked {
    val;
__asm
    push af
    push hl
    push de
    push bc

    ld hl, #10          ; load argument from stack into A
    add hl, sp

    ld a, (hl)
    ld hl, #0x8000
    ld (hl), a
    ld de, #0x8001
    ld bc, #0x27ff
    ldir

    pop bc
    pop de
    pop hl
    pop af
    ret
__endasm;
}