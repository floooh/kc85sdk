//------------------------------------------------------------------------------
//  caos_color.c
//
//  void caos_color(char background, char foreground);
//
//  http://www.mpm-kc85.de/dokupack/KC85_3_uebersicht.pdf:
//
//  Name:   COLOR UP-Nr.: «FH
//  FKT.:   Farbe einstellen
//  PE:     RegisterE = Hintergrundfarbe(«...7)
//          Register L = Vordergrundfarbe (« . . . 1 F)
//          (ARGN) = 1 = Nur Vordergrundfarbe
//          2 = Vorder- u. Hintergrundfarbe
//  VR: AF, L STACK: «
//------------------------------------------------------------------------------
void caos_color(char bg, char fg) __naked {
    bg, fg;
    __asm 
        push af
        push hl
        push de
        push iy
        ld a,#2
        ld (0xB781),a
        ld iy,#10
        add iy,sp
        ld e,0(iy)
        ld l,1(iy)
        call 0xf003
        .db 0xf
        pop iy
        pop de
        pop hl
        pop af
        ret
    __endasm;
}
