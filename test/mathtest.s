;===============================================================================
;   mathtest.s
;   Test math functions.
;===============================================================================

; where to put the mul8_table
sincos_data:    equ $2200
point_data:     equ $2400

        org $200
        include "mul8.i"
        include "sincos8.i"
        include "point.i"
        include "matrix.i"

vec0:   db $40,$0,$0
        db $0,$0,$0

mx0:    ds 12

data:   db 0,0,$60,0
x:      equ 0
y:      equ 1
rx:     equ 2
ry:     equ 3

        db $7f,$7f,"MATHTEST",$1
start:  call sincos8_init
        call point_init

        ld h,$7f
        ld a,$02
        call mul8

        ld iy,data
        ld b,$60
outer_loop:
        push bc
        ld a,$0
        ld b,$0
loop_circle:
        push af
        push bc
        call sincos8

        ld h,(iy+rx)    ; radius
        ld a,d          ; sin
        push de
        call mul8
        ld (iy+x),a
        pop de
        ld h,(iy+ry)    ; radius
        ld a,e          ; cos
        call mul8
        ld (iy+y),a

        ld a,(iy+x)
        add $7f
        ld h,a
        ld a,(iy+y)
        add $7f
        ld l,a
        call point

        pop bc
        pop af
        inc a
        djnz loop_circle
        dec (iy+rx)
        inc (iy+ry)
        pop bc
        djnz outer_loop

        ret

