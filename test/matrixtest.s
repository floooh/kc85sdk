;===============================================================================
;   matrixtest.s
;   Test matrix functions.
;===============================================================================

; where to put the lookup tables
sincos_data:    equ $2200
point_data:     equ $2400

        org $200
        include "mul8.i"
        include "sincos8.i"
        include "matrix.i"
        include "point.i"

data:   ds 12+4+4   ; space for matrix, src vector, dst vector
mx:     equ 0
v0:     equ 12
v1:     equ 16


        db $7f,$7f,"MXMULTEST",$1
start:  call sincos8_init
        call point_init

        ld a,$0
        ld b,$0
loop:
        push af
        push bc

        ld hl,data+mx   ; setup rotation matrix
        call mx_roty
        ld iy,data+v0
        ld (iy+0),$40
        ld (iy+1),$0
        ld (iy+2),$0
        ld hl,data+mx
        call mx_mulvec

        ld iy,data+v1
        ld a,(iy+0)
        add $7f
        ld h,a
        ld a,(iy+2)
        add $7f
        ld l,a
        call point

        pop bc
        pop af
        inc a
        djnz loop
        ret


        


