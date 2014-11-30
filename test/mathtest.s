;===============================================================================
;   mathtest.s
;   Test math functions.
;===============================================================================

        org $200
        include "math.i"

        db $7f,$7f,"MATH",$1
start:  call gen_sqr_table
        ld b,$f0
        ld c,$f0
        call mul8
        ret

