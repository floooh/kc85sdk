;-------------------------------------------------------------------------------
;   point.i
;
;   Simple point rendering, limited to (x,y) 256x256 
;   Call point_init first.
;
;   h=x, l=y
;
point:
        ex de,hl
        ld a,d
        and $7
        ld hl,point_data
        add l
        ld l,a
        ld c,(hl)   ; c is now pixel bit mask
        ex de,hl
        srl h
        srl h
        srl h
        set 7,h     ; hl is now vidmem address
        ld a,(hl)
        xor c
        ld (hl),a
        ret

;-------------------------------------------------------------------------------
;   point_init
;
__point_data:   db $80,$40,$20,$10,$8,$4,$2,$1

point_init:
        ld hl,__point_data
        ld de,point_data
        ld bc,$8
        ldir
        ret
    
    
