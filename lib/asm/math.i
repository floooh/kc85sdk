;===============================================================================
;   math.i
;
;   Math helper functions.
;===============================================================================

;-------------------------------------------------------------------------------
;   mul8
;   hl = h * e
;
;   see:
;   http://sgate.emt.bme.hu/patai/publications/z80guide/part4.html
;   http://z80-heaven.wikidot.com/advanced-math#toc2

mul8:
        ld d,0
        ld l,d
        ld b,8
mul8_loop:
        add hl,hl
        jp nc,mul8_skip
        add hl,de
mul8_skip:
        djnz mul8_loop
        ret

