;===============================================================================
;   mathtest.s
;   Test math functions.
;===============================================================================

; where to put the mul8_table
mul8_data:      equ $2000
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

x:      db 0
y:      db 0

        db $7f,$7f,"MATH",$1
start:  call mul8_init
        call sincos8_init
        call point_init

        ld a,$40
        ld h,$ff
        call mul8

        ld a,$0
        ld b,$0
loop_point:
        push af
        push bc
        call sincos8

        ld a,d
        ld (x),a
        ld a,e
        ld (y),a

;        ld b,$40
;        ld c,d
;        push de
;        call mul8
;        ld a,h
;        ld (x),a
;        pop de
;        ld b,$40
;        ld c,e
;        call mul8
;        ld a,h
;        ld (y),a

        ld a,(x)
        add $7f
        ld h,a
        ld a,(y)
        add $7f
        ld l,a
        call point

        pop bc
        pop af
        inc a
        djnz loop_point

        ret

