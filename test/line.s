;-------------------------------------------------------------------------------
;   Attempt at a fast line renderer, restricted 256x256 area of screen,
;   and max line length 128.
;
;   KC85 program entry: $207
;
        org 0x200
        db $7f,$7f,"LINE",$1
        jp start

;-------------------------------------------------------------------------------
;   clear pixel buffer
;
clear:
        ld hl,$8000
        ld de,$8001
        ld bc,$27ff
        ld (hl),0
        ldir
        ret

;-------------------------------------------------------------------------------
;   line
;
;   input:
;   de: x0y0
;   hl: x1y1
dx:     equ 0       ; x1-x0 (always > 0)
x1:     equ 1       ; last column (x1 / 8)

line_data:
        db 0        ; dx
        db 0        ; x1
line:
        ld iy,line_data
        
        ld (iy+x1),h
        ld a,h          ; dx=x1-x0 -> (iy+dx)
        sub d
        ld (iy+dx),a
        srl a           ; initial error accumulator
        ex af,af'       ; put error accumulator into a'
 
        ld a,l          ; dy=y1-y0 -> b
        sub e
        ld b,a

loop:
;   b:  dy
;   c:  pixel-mask
;   d:  current x-coord
;   e:  current y-coord
;   hl: scratch
;   a:  error accumulator

        ld a,d              ; compute jump into unrolled pixel loop from xcoord
        and $7
        add a
        ld l,a              ; l = x*2
        add a               ; a = x*4
        add l               ; a = x*6
        ld (patch+1),a      ; self-modifying code: patch jump into unrolled pixel mask loop
       
        xor a               ; clear pixel mask in c
        ld c,a 
        ex af,af'           ; restore current error accumulator into a
patch:  jr pix7             ; jump target patched by above code

pix7:   set 7,c             ; 2 bytes
        inc d               ; 1 byte
        sub b               ; 1 byte
        jr c,incr_y         ; 2 bytes   = 6 bytes
pix6:   set 6,c
        inc d
        sub b
        jr c,incr_y
pix5:   set 5,c
        inc d
        sub b
        jr c,incr_y
pix4:   set 4,c
        inc d
        sub b
        jr c,incr_y
pix3:   set 3,c
        inc d
        sub b
        jr c,incr_y
pix2:   set 2,c
        inc d
        sub b
        jr c,incr_y
pix1:   set 1,c
        inc d
        sub b
        jr c,incr_y
pix0:   set 0,c
        inc d
        sub b
        jr c,incr_y
                            ; end of current column-byte, remain on same line, don't reset error
        ex af,af'           ; store current error accumulator back into a'
        ld l,e              ; put y coordinate into l (will be screen address low-byte)        
        jp write_pixels

incr_y:                     ; error overflow happened, correct error and increment y
        add (iy+dx)         ; error correction
        ex af,af'           ; store error accumulator back into a'
        ld l,e              ; put y coor into l, and inc y (l is low-byte screen addr)
        inc e
        
write_pixels:               ; write the current pixel mask stored in c
        ld a,d              ; compute screen addr high-byte from x-coord in e
        cp (iy+x1)          ; check for done
        jp p, fini              

        dec a
        srl a
        srl a
        srl a
        or $80  
        ld h,a              ; hl now contains video memory address
        ld a,(hl)           ; write 8 pixel column with XOR
        xor c
        ld (hl),a
        
        jp loop             ; FIXME: check for done

fini:                       ; handle last column byte (todo: mask invalid pixels)
        dec a
        srl a
        srl a
        srl a
        or $80
        ld h,a
        ld a,(hl)
        xor c
        ld (hl),a    

        ret

;-------------------------------------------------------------------------------
;   execution starts here   
;
start:
        call clear
line_noclear:        
        ld de,$0000         ; x0=0, y0=0
        ld hl,$8000         ; x1=80, y1=11

line_loop:
        push hl
        push de
        call line
        pop de
        pop hl
        inc l
        ld a,$80
        cp l
        jp nz,line_loop
        ret

;-------------------------------------------------------------------------------
;   call OS line routine, for speed comparison
;
arg1:   equ $b782
arg2:   equ $b784
arg3:   equ $b786
arg4:   equ $b788 
farb:   equ $b7d6

        db $7f,$7f,"OSLINE",1
        
        call clear

os_line_noclear:
        ld hl,arg1          ; x0
        ld (hl),$0000        
        ld hl,arg2
        ld (hl),$0000       ; y0
        ld hl,arg3
        ld (hl),$007f       ; x1
        ld hl,arg4
        ld (hl),$0000       ; y1
        ld hl,farb
        ld (hl),7<<3|1

osline_loop:
        ld hl,(arg4)
        inc hl
        ld (arg4),hl
        push hl
        call 0xf003
        db $3e
        pop hl
        ld a,$80
        cp l
        jp nz, osline_loop
        ret

;-------------------------------------------------------------------------------
;   call both line tests
;
        db $7f,$7f,"BOTH",1
        call clear
        call os_line_noclear
        call line_noclear
        ret
