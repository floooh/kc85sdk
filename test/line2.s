;-------------------------------------------------------------------------------
;   KC85/4 line drawing demo.
;
        org $200
        
        include "line.i"
        include "vidmem.i"

        db $7f,$7f,"LINE2",$1        
start:  
        ld a,$0
        call clear
        ld hl,$8080
        ld de,$ff00
line_l0:
        push hl
        push de
        call line
        pop de
        pop hl
        dec d
        xor a
        cp d 
        jp nz,line_l0

        ld hl,$807f
        ld de,$0000
line_l1:
        push hl
        push de
        call line
        pop de
        pop hl
        inc e
        ld a,$ff
        cp e
        jp nz,line_l1

        ld hl,$8080
        ld de,$00ff
line_l2:
        push hl
        push de
        call line
        pop de
        pop hl
        inc d
        ld a,$ff
        cp d
        jp nz,line_l2

        ld hl,$8080
        ld de,$ffff

line_l3:
        push hl
        push de
        call line
        pop de
        pop hl
        dec e
        xor a
        cp e
        jp nz,line_l3

        ret


