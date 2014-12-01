;-------------------------------------------------------------------------------
;   sincos8
;
;   8-bit sincos:
;
;   d = sin(a), 1.6 signed fixed-point
;   e = cos(a), 1.6 signed fixed-point
;   a: 0..255
;   modifies: hl
;
;   Call sincos8_init first to setup lookup table at user-defined 'sincos_data'.
;
sincos8:
    ld h, sincos_data/256
    ld l,a
    ld d,(hl)
    ld h,(sincos_data/256)+1
    ld e,(hl) 
    ret

;-------------------------------------------------------------------------------
;   sincos8_init
;   Initialize the sincos8 lookup table at address 'sincos_data'.
;
sincos8_init:
    ld hl,__sincos_table
    ld de,sincos_data
    ld bc,512
    ldir
    ret

__sincos_table:
    include 'sincos_table.i'

