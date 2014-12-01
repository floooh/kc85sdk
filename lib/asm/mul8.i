;-------------------------------------------------------------------------------
;   mul8
;   HL = H * DE
;
;   Define mul8_table with address where 512 byte lookup table goes to. 
;   Call mul8_init first!
;   see http://map.grauw.nl/sources/external/z80bits.html
;
;   Interesting: http://www.cemetech.net/forum/viewtopic.php?t=10897 
;
;
mul8:
;A*H, signed, to signed HL  
;First, get the sign of the product. Basically if the sign of A and E are the same, positive, else negative. So XOR the two, and the sign bit is appropriate.  
   xor h  
   ld b,a  
;Now check the sign of A. XOR with H again to get A, leaving the sign flag to match bit 7 of A. We want abs(A).  
   xor h  
   jp p,$+5  
      neg  
   ld e,a  
;abs(H)->A  
   ld a,h  
   add a,a  
   jr nc,$+4  
      neg  
;this will be like a modified H*E=HL  
;Right now, the upper 7 bits of A are what we need to use for this 7*7 multiply (the sign bits are taken care of and out of the picture until later).  
;So we need 7 multiplication steps, but the first can be optimized using A since there is no concern of overflow  
   ld l,0  
   ld d,l  
   add a,a 
   ld h,a
   jr nc,$+3
   ld l,e  
   add hl,hl
   jr nc,$+3
   add hl,de  
   add hl,hl
   jr nc,$+3
   add hl,de  
   add hl,hl
   jr nc,$+3
   add hl,de  
   add hl,hl
   jr nc,$+3
   add hl,de  
   add hl,hl
   jr nc,$+3
   add hl,de  
   add hl,hl
   jr nc,$+3
   add hl,de  
   sla b   ;get the sign of the result in the c flag  
   ret nc      ;if positive, all is good  
;if negative, neg(HL)  
   xor a \ sub l \ ld l,a  
   sbc a,a \ sub h \ ld h,a  
   ret  
;        ld h,mul8_data/256
;        ld l,b
;        ld a,b
;        ld e,(hl)       ; de = a^2
;        inc h
;        ld d,(hl)
;        ld l,c
;        ld b,(hl)
;        dec h
;        ld c,(hl)       ; bc = b^2
;        add a,l         ; try (a+b)
;        jp pe,mul8_plus ; jump if no overflow
;
;        sub l
;        sub l
;        ld l,a
;        ld a,(hl)
;        inc h
;        ld h,(hl)
;        ld l,a          ; hl = (a - b) ^ 2
;        ex de,hl
;        add hl,bc
;        sbc hl,de       ; hl = a^2 + b^2 - (a - b)^2
;
;;        sra h           ; uncomment to get real product
;;        rr l
;        ret
;
;mul8_plus:
;        ld l,a
;        ld a,(hl)
;        inc h
;        ld h,(hl)
;        ld l,a          ; hl = (a + b)^2
;        or a
;        sbc hl,bc
;        or a
;        sbc hl,de       ; hl = (a + b)^2 - a^2 - b^2
;
;;        sra h           ; uncomment to get real product
;;        rr l
;        ret

;-------------------------------------------------------------------------------
;   mul8_init
;
;   generates the lookup table for mul8
;
mul8_init:
        ld hl,__mul8_sqrtable
        ld de,mul8_data
        ld bc,512
        ldir
        ret
        


;        ld hl,mul8_data     ; must be multiple of 256
;        ld b,l
;        ld c,l              ; bc holds odd numbers
;        ld d,l
;        ld e,l              ; de holds squares
;
;mul8_init_0:
;        ld (hl),e
;        inc h
;        ld (hl),d           ; store x^2
;        ld a,l
;        neg
;        ld l,a
;        ld (hl),d
;        dec h
;        ld (hl),e           ; store -x^2
;        ex de,hl
;        inc c
;        add hl,bc           ; add next odd number
;        inc c
;        ex de,hl
;
;        cpl                 ; one-byte replacement for NEG, DEC A
;        ld l,a
;        rla
;        jr c,mul8_init_0
;
        ret

__mul8_sqrtable:
        include "mul8_sqrtable.i"

