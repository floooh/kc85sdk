//------------------------------------------------------------------------------
//  caos_clear_color_buf(value)
//
//  NOTE: on KC85/4, use the generic caos_clear(), together
//  the video RAM bank switch functions!
//
//  Clear the color buffer with a byte value:
//  
//  | BL | XX | FG | FR |  FB | BG | BR | BB |
//
//  BL: blink bit
//  XX: select mixed foreground colors
//  FG: foreground green
//  FR: foreground red
//  FB: foreground blue
//  BG: background green
//  BR: background red
//  BB: background blue
//
//  e.g. for white-on-blue:
//
//  caos_clear_color_buf(CAOS_WHITE<<3 | CAOS_BLUE)
//
//  see: http://www.kc85emu.de/Download/KC854-Systemhandbuch.pdf, page 114
//------------------------------------------------------------------------------
void caos_clear_color_buf(unsigned char value) __naked {
    value;
#if KC85_3
__asm
    push af
    push hl
    push de
    push bc

    ld hl, #10          ; load argument from stack into A
    add hl, sp

    ld a, (hl)
    ld hl, #0xa800
    ld (hl), a          ; seed value
    ld de, #0xa801
    ld bc, #0x9ff       
    ldir
    
    pop bc
    pop de
    pop hl
    pop af
    ret
__endasm;
#endif
}
