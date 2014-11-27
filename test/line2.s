;-------------------------------------------------------------------------------
;   fast line drawing, second attempt
;
        org $200
end_mask:   
        db $80,$C0,$E0,$F0,$F8,$FC,$FE,$FF
start_mask:
        db $80,$40,$20,$10,$8,$4,$2,$1 

        db $7f,$7f,"LINE2",$1        
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


;-------------------------------------------------------------------------------
;   line
;   hl: x0y0
;   de: x1y1
;
line:           ; check if line_hori or line_vert must be called
        ld a,d  ; compute dx,dy and compare
        sub h
        jp nc,pos_dx
        neg a
pos_dx:
        ld b,a

        ld a,e
        sub l
        jp nc,pos_dy
        neg a
pos_dy:
        cp b    ; dy - dx
        jp nc, line_vert
        
;-------------------------------------------------------------------------------
;   line_hori
;   hl: x0y0
;   de: x1y1
line_hori:
        ld a,d      ; make sure that x1 >= x0
        cp h
        jp nc, line_x0x1

line_x1x0:
        ex de,hl    ; if x0 > x1, exchange x0y0 <-> x1y1

line_x0x1:
        ld a,d      ; patch last column into end-of-line-check code
        srl a
        srl a
        srl a
        or $80      ; vidmem start high-byte
        ld (p0+1),a
        ld (p2+1),a
        ld a,e      ; patch last y-coord into end-of-line check code
        ld (p1+1),a
        ld (p3+1),a

        ld a,d      ; compute and code-patch final column pixel mask
        and $7
        ld bc,end_mask
        add c
        ld c,a
        ld a,(bc)
        ld (p4+1),a

        ld a,d      ; compute dx -> d
        sub h
        ld d,a

        ld a,e      ; compute dy -> e
        sub l
        ld e,a    
        jp nc, dy_pos    ; dy is positive        
dy_neg:             ; line goes upward, neg dy and patch code to decrement y-coord
        ld a,e
        neg a
        ld e,a
        ld a,$2d    ; code patch y-bump: dec l -> 2D
        ld (p5),a   
        ld (p6),a
        jp dy_cont
dy_pos:             ; line goes download, patch code to increment y-coord
        ld a,$2c    ; code patch y-bumpL inc l -> 2C
        ld (p5),a
        ld (p6),a
dy_cont:
        ld a,h      ; patch initial jump target into unrolled loop
        and $7
        add a
        ld c,a      ; c = x*2
        add a       ; a = x*4
        add c       ; a = x*6
        ld (patch_jp+1),a   
       
        ld a,h          ; vidmem addr -> hl
        srl a
        srl a
        srl a
        add $80
        ld h,a          ; hl: $8xyy

        xor a           ; clear initial pixel bitmask
        ld c,a

        ld a,d          ; compute initial error accumulator (dx / 2)
        srl a       
        
patch_jp:  
        jr loop_x       ; line-start jump target patched by above code

;   a: error accumulator
;   c: current pixel mask
;   d: dx
;   e: dy 
;  hl: vidmem address
;--- handle 8 pixel bits in unrolled loop
loop_x:
;--- bit7 (left-most)
        set 7,c             ; 2 bytes +
        sub e               ; 1 byte +
        call c, bmp_y       ; 3 bytes = 6 bytes
;--- bit6
        set 6,c
        sub e
        call c, bmp_y
;--- bit5
        set 5,c
        sub e
        call c,bmp_y
;--- bit4
        set 4,c
        sub e
        call c,bmp_y
;--- bit3
        set 3,c
        sub e
        call c,bmp_y
;--- bit2
        set 2,c
        sub e
        call c,bmp_y
;--- bit1
        set 1,c
        sub e
        call c,bmp_y
;--- bit0 (right-most)
        set 0,c
        sub e
                            ; fallthrough: next x column on same line
        ex af,af'           ; store current error, AND carry flag(!)
p0:     ld a,$0             ; will be patched with last column
        cp h
        jp nz,cont0
p1:     ld a,$0             ; will be patched with last y-coord
        cp l 
        jp z,done1
cont0:  ld a,(hl)           ; write current pixel
        xor c
        ld (hl),a
        xor a               ; clear pixel mask for next 8 pixels
        ld c,a
        inc h               ; increment x
        ex af,af'           ; restore error AND carry flag (!)
        jp nc,loop_x        ; this was an end-of-column
        add d               ; carry flag was set: error correction, and increment y
p6:     inc l
        jp loop_x
bmp_y:  
        add d           ; error correction (err + dx)
        ex af,af'       ; store current error
p2:     ld a,$0         ; will be patched with last column
        cp h
        jp nz,cont1
p3:     ld a,$0         ; will be patched with last y-coord
        cp l
        jp z,done0
cont1:  ld a,(hl)       ; write pixels
        xor c
        ld (hl),a
p5:     inc l           ; increment y
        xor a           ; clear pixel mask
        ld c,a
        ex af,af'    
        ret             ; on to next pixel

done0:
        inc sp          ; clear return address from stack
        inc sp
done1:
        ld a,(hl)       ; fixme: and c with last-column-mask
        xor c
p4:     and $ff         ; final bitmask will be patched at start
        ld (hl),a
        ret
       
;------------------------------------------------------------------------------
;   line_vert
;   hl: x0y0
;   de: x1y1
line_vert:
        ld a,e      ; make sure that y1 >= y0
        cp l
        jp nc, line_y0y1

line_y1y0:
        ex de,hl    ; if y0 > y1, exchange x0y0 <-> x1y1

line_y0y1:
        push de     ; store x1y1 (we need y1 in b later)
        ld a,e      ; compute dy -> e
        sub l
        ld e,a
        
        ld a,d      ; compute dx -> d
        sub h
        ld d,a
        jp nc, dx_pos   ; dx is positive
dx_neg:             ; line goes to the left, neg dx and patch code to rotate pixel mask left
        neg a
        ld d,a
        ld a,$1     ; RLC c, second byte 
        ld (p7+1),a
        ld a,$25    ; dec h
        ld (p8),a
        jp dx_cont
dx_pos:             ; line goes to the right, patch code to rotate pixel mask right
        ld a,$9     ; RRC c, second byte
        ld (p7+1),a
        ld a,$24    ; inc h
        ld (p8),a
dx_cont:
        ld a,h      ; initial pixel mask
        and $7
        ld bc,start_mask
        add c
        ld c,a
        ld a,(bc)        
        pop bc      ; bc is x1y1
        ld b,c      ; b is y1 (for line end check)
        ld c,a      ; c is initial pixel mask

        ld a,h      ; compute vidmem address into hl
        srl a
        srl a
        srl a
        add $80
        ld h,a      ; hl: $8xyy

        ld a,e      ; compute initial error accumulator (dy / 2)
        srl a

;   a: error accumulator
;   c: current pixel mask
;   d: dx
;   e: dy
;  hl: vidmem address
loop_y:
        ex af,af'           ; store current error accumulator
        ld a,l              ; line-end check
        cp b                ; b is y1
        ret z               ; we're done
        ld a,(hl)           ; write current pixel
        xor c
        ld (hl),a
        inc l               ; increment y-coord
        ex af,af'           ; restore error accumulator
        sub d
        jp nc,loop_y
        add e               ; correct error
p7:     rrc c               ; rotate pixel mask, will be code patch for line to left/right
        jp nc,loop_y
p8:     inc h               ; increment (or decrement) x-column
        jp loop_y
               

        
 
