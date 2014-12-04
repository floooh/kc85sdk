;-------------------------------------------------------------------------------
;   mul8
;
;   H = H * A
;
;   H is signed int, A is signed fractional, A is integer result.
;
mul8:   
        xor h           ; get sign of result
        ld b,a          ; store result sign in bit 7 into b, needed at end
        xor h           ; restore a, and set a = abs(a)
        jp p,mul8_p0
        neg
mul8_p0: 
        ld e,a          ; de will start with 00aa
        ld a,h          ; a = abs(h)
        or a
        jp p,mul8_p1
        neg
mul8_p1: 
        ld h,a
        ld l,0          ; hl = hh00
        ld d,l          ; de = 00aa

        add hl,hl
        jp nc,mul8_step0
        add hl,de
mul8_step0:
        add hl,hl
        jp nc,mul8_step1
        add hl,de
mul8_step1:
        add hl,hl
        jp nc,mul8_step2
        add hl,de
mul8_step2:
        add hl,hl
        jp nc,mul8_step3
        add hl,de
mul8_step3:
        add hl,hl
        jp nc,mul8_step4
        add hl,de
mul8_step4:
        add hl,hl
        jp nc,mul8_step5
        add hl,de
mul8_step5:
        add hl,hl
        jp nc,mul8_step6
        add hl,de
mul8_step6:
        add hl,hl
        jp nc,mul8_step7
        add hl,de
mul8_step7:
        add hl,hl
        jp nc,mul8_step8
        add hl,de
mul8_step8:        
        sla b           ; test result sign (computed at start)
        ret nc          ; result remains positive, all done
        
        ld a,h
        neg             ; result must be negative
        ld h,a
        ret

