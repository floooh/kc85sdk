;===============================================================================
;   cube.s
;
;   draw a wireframe 3d cube
;
        org $200
        
; where to put the lookup tables
sincos_data:    equ $2200
point_data:     equ $2400

        org $200

mx:     ds 12       ; the rotation matrix
frame:  db 0

vbuf:               ; the 'vertex buffer'
        db 8        ; 8 vertices
        db 12       ; vertex stride
        
        db 32,-32,-32,0,    0,0,0,0,    0,0,0,0     ; top vertices
        db 32,-32,32,0,     0,0,0,0,    0,0,0,0
        db -32,-32,32,0,    0,0,0,0,    0,0,0,0
        db -32,-32,-32,0,   0,0,0,0,    0,0,0,0

        db 32,32,-32,0,     0,0,0,0,    0,0,0,0    ; bottom vertices
        db 32,32,32,0,      0,0,0,0,    0,0,0,0
        db -32,32,32,0,     0,0,0,0,    0,0,0,0
        db -32,32,-32,0,    0,0,0,0,    0,0,0,0
        
        include "mul8.i"
        include "sincos8.i"
        include "matrix.i"
        include "line.i"
        include "geom.i"
        include "vidmem.i"

        db $7f,$7f,"CUBE",$1
start:  call sincos8_init
        xor a
        call clear

        call access_irm_1
loop:
        ld a,(frame)
        ld hl,mx        ; setup rotation matrix
        call mx_roty       

        call show_irm_1
        call access_irm_0
        call draw1      ; clear previus lines (buffer0)

        ld hl,mx        ; transform vertices
        ld a,$1
        ld iy,vbuf      ; pointer to vertex buffer
        call transform

        call draw1      ; draw new lines (buffer0)
        
        ld a,(frame)    ; next frame
        add 4
        ld (frame),a


        ld a,(frame)
        ld hl,mx        ; setup rotation matrix
        call mx_roty       

        call show_irm_0
        call access_irm_1
        call draw2      ; clear previus lines (buffer1)

        ld hl,mx        ; transform vertices
        ld a,$2
        ld iy,vbuf      ; pointer to vertex buffer
        call transform

        call draw2      ; draw new lines
        
        ld a,(frame)    ; next frame
        add 4
        ld (frame),a
        jp loop

draw1:
        ld b,4
        ld iy,vbuf+2
        ld de,12
draw1_loop:
        push de
        push bc
        ld h,(iy+4)
        ld l,(iy+5)
        ld d,(iy+4+48)
        ld e,(iy+5+48)
        call line
        pop bc
        pop de
        add iy,de
        djnz draw1_loop
        
        ld iy,vbuf+2
        ld h,(iy+4)
        ld l,(iy+5)
        ld d,(iy+4+12)
        ld e,(iy+5+12)
        call line
        ld h,(iy+4+12)
        ld l,(iy+5+12)
        ld d,(iy+4+24)
        ld e,(iy+5+24)
        call line
        ld h,(iy+4+24)
        ld l,(iy+5+24)
        ld d,(iy+4+36)
        ld e,(iy+5+36)
        call line
        ld h,(iy+4+36)
        ld l,(iy+5+36)
        ld d,(iy+4)
        ld e,(iy+5)
        call line

        ld h,(iy+48+4)
        ld l,(iy+48+5)
        ld d,(iy+48+4+12)
        ld e,(iy+48+5+12)
        call line
        ld h,(iy+48+4+12)
        ld l,(iy+48+5+12)
        ld d,(iy+48+4+24)
        ld e,(iy+48+5+24)
        call line
        ld h,(iy+48+4+24)
        ld l,(iy+48+5+24)
        ld d,(iy+48+4+36)
        ld e,(iy+48+5+36)
        call line
        ld h,(iy+48+4+36)
        ld l,(iy+48+5+36)
        ld d,(iy+48+4)
        ld e,(iy+48+5)
        call line
        ret

draw2:
        ld b,4
        ld iy,vbuf+2
        ld de,12
draw2_loop:
        push de
        push bc
        ld h,(iy+8)
        ld l,(iy+9)
        ld d,(iy+8+48)
        ld e,(iy+9+48)
        call line
        pop bc
        pop de
        add iy,de
        djnz draw2_loop

        ld iy,vbuf+2
        ld h,(iy+8)
        ld l,(iy+9)
        ld d,(iy+8+12)
        ld e,(iy+9+12)
        call line
        ld h,(iy+8+12)
        ld l,(iy+9+12)
        ld d,(iy+8+24)
        ld e,(iy+9+24)
        call line
        ld h,(iy+8+24)
        ld l,(iy+9+24)
        ld d,(iy+8+36)
        ld e,(iy+9+36)
        call line
        ld h,(iy+8+36)
        ld l,(iy+9+36)
        ld d,(iy+8)
        ld e,(iy+9)
        call line
        
        ld h,(iy+48+8)
        ld l,(iy+48+9)
        ld d,(iy+48+8+12)
        ld e,(iy+48+9+12)
        call line
        ld h,(iy+48+8+12)
        ld l,(iy+48+9+12)
        ld d,(iy+48+8+24)
        ld e,(iy+48+9+24)
        call line
        ld h,(iy+48+8+24)
        ld l,(iy+48+9+24)
        ld d,(iy+48+8+36)
        ld e,(iy+48+9+36)
        call line
        ld h,(iy+48+8+36)
        ld l,(iy+48+9+36)
        ld d,(iy+48+8)
        ld e,(iy+48+9)
        call line
        ret
