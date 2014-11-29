;===============================================================================
;   video.i
;   KC85/4 video memory utility function.
;===============================================================================


;-------------------------------------------------------------------------------
;   clear
;   clear pixel or color buffer with value in 'a'
;   modifies: hl,de,bc
;
clear:
    ld hl,$8000
    ld de,$8001
    ld bc,$27ff
    ld (hl),a
    ldir
    ret

;-------------------------------------------------------------------------------
;   show_irm_0
;   Make video memory buffer 0 visible.
;   modifies: a
;
show_irm_0:
    in a,($84)
    res 0,a
    out ($84),a
    ret

;-------------------------------------------------------------------------------
;   show_irm_1
;   Make video memory buffer 1 visible.
;   modifies: a
;
show_irm_1:
    in a,($84)
    set 0,a
    out ($84),a
    ret

;-------------------------------------------------------------------------------
;   access_irm_0
;   Make video memory buffer 0 cpu-accessible.
;   modifies: a
;
access_irm_0:
    in a,($84)
    res 2,a
    out ($84),a
    ret

;-------------------------------------------------------------------------------
;   access_irm_1
;   Make video memory buffer 0 cpu-accessible.
;   modifies: a
;
access_irm_1:
    in a,($84)
    set 2,a
    out ($84),a
    ret

;-------------------------------------------------------------------------------
;   access_pixels
;   Map pixel buffer for cpu access to $8000.
;
access_pixels:
    in a,($84)
    res 1,a
    out ($84),a
    ret

;-------------------------------------------------------------------------------
;   access_colors
;   Map color buffer for cpu access to $8000.
;
access_colors:
    in a,($84)
    set 1,a
    out ($84),a
    ret

