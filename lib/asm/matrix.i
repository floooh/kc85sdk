;-------------------------------------------------------------------------------
;   matrix.i
;
;   3x4 matrix functions.
;
;   Matrix layout in memory:
;
;   x0 x1 x2 xp
;   y0 y1 y2 yp
;   z0 z1 z2 zp
;
;   Each element is 1 byte as signed 0.7 fixed-point.
;

;-------------------------------------------------------------------------------
;   mx_ident
;
;   set matrix at address hl to identity
;
;   modifies: hl,b,a
mx_ident:
        ld a,$7f        ; ~1.0
        ld b,a
        xor a

        ld (hl),b       ; x0 = 1.0
        inc hl
        ld (hl),a       ; y0 = 0.0
        inc hl
        ld (hl),a       ; z0 = 0.0
        inc hl
        ld (hl),a       ; xp = 0.0
        inc hl
        
        ld (hl),a       ; y0 = 0.0
        inc hl
        ld (hl),b       ; y1 = 1.0
        inc hl
        ld (hl),a       ; y2 = 0.0
        inc hl
        ld (hl),a       ; yp = 0.0
        inc hl
        
        ld (hl),a       ; z0 = 0.0
        inc hl
        ld (hl),a       ; z1 = 0.0
        inc hl
        ld (hl),b       ; z2 = 1.0
        inc hl
        ld (hl),a       ; zp = 0.0
        ret

;-------------------------------------------------------------------------------
;   mx_roty
;
;   init matrix at addr hl to rotation matrix around y
;
;   x0=cos(a)   x1=0.0  x2=sin(a)   xp=0.0
;   y0=0.0      y1=1.0  y2=0.0      yp=0.0
;   z0=-sin(a)  z1=0.0  z2=cos(a)   zp=0.0
;
;   a: angle around y (0..255)
;   hl: matrix address
;   modifies: a,hl,de,bc
;
mx_roty:
        push hl
        call sincos8        ; d=sin(a), e=cos(a)
        pop hl
        
        ld a,$7f            ; ~1.0
        ld b,a
        ld a,d
        neg a
        ld c,a              ; c=-sin(a)
        xor a               ; a=0.0
        
        ld (hl),e           ; x0=cos(a)
        inc hl
        ld (hl),a           ; x1=0.0
        inc hl
        ld (hl),d           ; x2=sin(a)
        inc hl
        ld (hl),a           ; xp=0.0
        inc hl

        ld (hl),a           ; y0=0.0
        inc hl
        ld (hl),b           ; y1=1.0
        inc hl
        ld (hl),a           ; y2=0.0
        inc hl
        ld (hl),a           ; yp=0.0
        inc hl

        ld (hl),c           ; z0=-sin(a)
        inc hl
        ld (hl),a           ; z1=0.0
        inc hl
        ld (hl),e           ; z2=cos(a)
        inc hl
        ld (hl),a           ; zp=0.0

        ret

;-------------------------------------------------------------------------------
;   mx_dst_slot
;
;   set the destination vertex slot offset
;
mx_dst_slot:
        ld (mx_mulvec_setx+2),a
        inc a
        ld (mx_mulvec_sety+2),a
        inc a
        ld (mx_mulvec_setz+2),a
        ret

;-------------------------------------------------------------------------------
;   mx_mulvec
;
;   multiply 3D vect at addr iy with matrix at addr hl, store 
;   result at iy+4
;
;   iy: base pointer to input and output
;   hl: points to matrix
;
mx_mulvec:
        push hl
        ld a,(hl)
        ld h,(iy+0)     ; compute x
        call mul8       ; h = x * mx0
        ld a,h          ; result in a
        ex af,af'       ; store af
        pop hl
        inc hl
        push hl
        ld a,(hl)       
        ld h,(iy+1)
        call mul8       ; hl = x * mx1
        ex af,af'
        add a,h
        ex af,af'
        pop hl
        inc hl
        push hl
        ld a,(hl)
        ld h,(iy+2)
        call mul8       ; hl = x * mx2
        ex af,af'
        add a,h
        pop hl
        inc hl
        add a,(hl)      ; translation x
mx_mulvec_setx:
        ld (iy+4),a     ; store x result

        inc hl          ; compute y
        push hl
        ld a,(hl)
        ld h,(iy+0)
        call mul8       ; hl = y * my0
        ld a,h          ; result in a
        ex af,af'
        pop hl
        inc hl
        push hl
        ld a,(hl)
        ld h,(iy+1)
        call mul8       ; hl = y * my1
        ex af,af'
        add a,h
        ex af,af'
        pop hl
        inc hl
        push hl
        ld a,(hl)
        ld h,(iy+2)
        call mul8       ; hl = y * my2
        ex af,af'
        add a,h
        pop hl
        inc hl
        add a,(hl)      ; translation y
mx_mulvec_sety:
        ld (iy+5),a     ; store y

        inc hl
        push hl
        ld a,(hl)
        ld h,(iy+0)
        call mul8       ; hl = z * mz0
        ld a,h          ; result in a
        ex af,af'
        pop hl
        inc hl
        push hl
        ld a,(hl)
        ld h,(iy+1)
        call mul8       ; hl = z * mz1
        ex af,af'
        add a,h
        ex af,af'
        pop hl
        inc hl
        push hl
        ld a,(hl)
        ld h,(iy+2)
        call mul8      ; hl = z * mz2
        ex af,af'
        add a,h
        pop hl
        inc hl
        add a,(hl)      ; translation z
mx_mulvec_setz:
        ld (iy+6),a     ; store z

        ret
    
