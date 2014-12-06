;===============================================================================
;   geom.i
;
;   Mesh utility functions
;
;   Data layouts:
;
;   vertex buffer
;   db num_vertices     -> number of following vertices
;   db stride           -> number of bytes until next pre-transform vertex
;   db x0,y0,z0,0       -> source (pre-transform) vertex
;   db x1,y1,z1,0       -> post-transform vertex set 1
;   db x2,y1,z1,0       -> post-transform vertex set 2
;   ...
;
;   edge buffer
;   db num_edges        -> number of edges
;   dw v0, v1           -> first edge, pointers to source vertices
;   ...
;
;===============================================================================

;-------------------------------------------------------------------------------
;   transform
;
;   Transform all vertices in a vertex buffer.
;
;   hl: pointer to transform matrix
;   iy: pointer to vertex buffer
;   a:  post-transform vertex set index (1..n), where to write the results
;
transform:
        rlca
        rlca
        push af
        call mx_dst_slot        ; set destination vertex offset
        pop af
        ld (tform_lx+2),a
        ld (tform_sx+2),a
        inc a
        ld (tform_ly+2),a
        ld (tform_sy+2),a
        inc a
        ld (tform_lz+2),a
        
        ld b,(iy+0)             ; vertex counter
        inc iy
        ld e,(iy+0)             ; vertex stride
        inc iy                  ; iy now points to first src vertex
        xor a
        ld d,a
transform_loop:
        push hl
        push de
        push bc
        call mx_mulvec          ; matrix*vec
        
tform_lz:                       ; persp divide and screen space transform 
        ld a,(iy+0)             ; code-patched to load post-transform z
        add 48
        ld h,a
        ld a,$7f
        sub h
tform_lx:                       ; code-patched to load post-transform x
        ld h,(iy+0)
        push af
        call mul8
        sla h
        ld a,$7f
        add h
tform_sx:
        ld (iy+0),a             ; code-patched to store screen-space x
        pop af
tform_ly:
        ld h,(iy+0)             ; code-patched to load screen-space y
        call mul8
        sla h
        ld a,$7f
        add h
tform_sy:
        ld (iy+0),a             ; code-patched to store screen-space y

        pop bc
        pop de
        pop hl
        add iy,de               ; next vertex
        djnz transform_loop     ; for each vertex...
        ret
        

        

