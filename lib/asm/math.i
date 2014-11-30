;===============================================================================
;   math.i
;
;   Math helper functions.
;===============================================================================

; put multiplication table at address $2000, must be at a 00 address
sqr_table: equ $2000

;-------------------------------------------------------------------------------
;   mul8
;   HL = B * C
;
;   Call gen_sqr_table first!
;   see http://map.grauw.nl/sources/external/z80bits.html
;
mul8:   ld h,sqr_table/256
        ld l,b
        ld a,b
        ld e,(hl)       ; de = a^2
        inc h
        ld d,(hl)
        ld l,c
        ld b,(hl)
        dec h
        ld c,(hl)       ; bc = b^2
        add a,l         ; try (a+b)
        jp pe,mul8_plus ; jump if no overflow

        sub l
        sub l
        ld l,a
        ld a,(hl)
        inc h
        ld h,(hl)
        ld l,a          ; hl = (a - b) ^ 2
        ex de,hl
        add hl,bc
        sbc hl,de       ; hl = a^2 + b^2 - (a - b)^2

        sra h           ; uncomment to get real product
        rr l
        ret

mul8_plus:
        ld l,a
        ld a,(hl)
        inc h
        ld h,(hl)
        ld l,a          ; hl = (a + b)^2
        or a
        sbc hl,bc
        or a
        sbc hl,de       ; hl = (a + b)^2 - a^2 - b^2

        sra h           ; uncomment to get real product
        rr l
        ret

;-------------------------------------------------------------------------------
;   gen_sqr_table
;
;   generates the lookup table for mul8
;
gen_sqr_table:
        ld hl,sqr_table     ; must be multiple of 256
        ld b,l
        ld c,l              ; bc holds odd numbers
        ld d,l
        ld e,l              ; de holds squares

sqr_gen:
        ld (hl),e
        inc h
        ld (hl),d           ; store x^2
        ld a,l
        neg
        ld l,a
        ld (hl),d
        dec h
        ld (hl),e           ; store -x^2
        ex de,hl
        inc c
        add hl,bc           ; add next odd number
        inc c
        ex de,hl

        cpl                 ; one-byte replacement for NEG, DEC A
        ld l,a
        rla
        jr c,sqr_gen

        ret

