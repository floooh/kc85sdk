;-------------------------------------------------------------------------------
;   fast line drawing, second attempt
;
        org $200
        db $7f,$7f,"LINE2",$1
        
line_noclear:        
        ld hl,$0202         ; x0=0, y0=0
        ld de,$8011         ; x1=80, y1=11

line_loop:
;        push hl
;        push de
        call line_start
;        pop de
;        pop hl
;        inc e
;        ld a,$80
;        cp l
;        jp nz,line_loop
        ret
        
;-------------------------------------------------------------------------------
;   input:
;   hl: x0y0
;   de: x1y1
line_start:
        ld a,d      ; compute dx -> d
        sub h
        ld d,a

        ld a,e      ; compute dy -> e
        sub l
        ld e,a        

        ld a,h      ; patch initial jump target into unrolled loop
        and $7
        add a
        ld c,a      ; c = x*2
        add a       ; a = x*4
        add c       ; a = x*6
        ld (patch_jp+1),a   
       
        ld a,l          ; vidmem addr -> hl
        srl a
        srl a
        srl a
        add $80
        ld l,h
        ld h,a          ; hl: $8yxx

        xor a           ; clear initial pixel bitmask
        ld c,a

        ld a,d          ; compute initial error accumulator (dx / 2)
        srl a       
        
patch_jp:  
        jr pixel_loop   ; line-start jump target patched by above code

;   a: error accumulator
;   c: current pixel mask
;   d: dx
;   e: dy 
;  hl: vidmem address
;--- handle 8 pixel bits in unrolled loop
pixel_loop:
;--- bit7 (left-most)
        set 7,c             ; 2 bytes +
        sub e               ; 1 byte +
        call c, inc_y       ; 3 bytes = 6 bytes
;--- bit6
        set 6,c
        sub e
        call c, inc_y
;--- bit5
        set 5,c
        sub e
        call c,inc_y
;--- bit4
        set 4,c
        sub e
        call c,inc_y
;--- bit3
        set 3,c
        sub e
        call c,inc_y
;--- bit2
        set 2,c
        sub e
        call c,inc_y
;--- bit1
        set 1,c
        sub e
        call c,inc_y
;--- bit0 (right-most)
        set 0,c
        sub e
                            ; fallthrough: next x column on same line
        ex af,af'           ; store current error, AND carry flag(!)
        ld a,(hl)           ; write current pixel
        xor c
        ld (hl),a
        xor a               ; clear pixel mask for next 8 pixels
        ld c,a
        inc h               ; increment x
        ex af,af'           ; restore error AND carry flag (!)
        jp nc,pixel_loop    ; this was an end-of-column
        add d               ; carry flag was set: error correction, and increment y
        inc l
        jp pixel_loop
inc_y:  
        add d           ; error correction (err + dx)
        ex af,af'       ; store current error
        ld a,(hl)       ; write pixels
        xor c
        ld (hl),a
        inc l           ; increment y
        xor a           ; clear pixel mask
        ld c,a
        ex af,af'    
        ret             ; on to next pixel

