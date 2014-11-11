//------------------------------------------------------------------------------
//  caos_irm_view(0 or 1) - display image 0 or 1
//  caos_irm_access(0 or 1) - cpu-access image 0 or 1
//  caos_irm_pixel_bank() - switch to pixel buffer memory bank
//  caos_irm_color_bank() - switch to color buffer memory bank
//  caos_irm_color_hires(bool) - color-hires mode on/off (per-pixel color mode)
//
//  Control KC85/4 video memory.
//  See: http://www.kc85emu.de/Download/KC854-Systemhandbuch.pdf, page 67
//------------------------------------------------------------------------------

// make image0 visible
void caos_irm_view_0() __naked {
__asm
    push af
    in a,(#0x84)
    and #~1
    out (#0x84),a
    pop af
    ret
__endasm;
}

// make image1 visible
void caos_irm_view_1() __naked {
__asm
    push af
    in a,(#0x84)
    or #1
    out (#0x84),a
    pop af
    ret
__endasm;
}

// make image0 or image1 visible
void caos_irm_view(char img) {
    if (0 == img) {
        caos_irm_view_0();
    }
    else {
        caos_irm_view_1();
    }
}

// cpu-access image0
void caos_irm_access_0() __naked {
__asm
    push af
    in a,(#0x84)
    and #~(1<<2)
    out (#0x84),a
    pop af
    ret
__endasm;
}

// cpu-access image1
void caos_irm_access_1() __naked {
__asm
    push af
    in a,(#0x84)
    or #(1<<2)
    out (#0x84),a    
    pop af
    ret
__endasm;
}

// cpu-access image0 or image1
void caos_irm_access(char img) {
    if (0 == img) {
        caos_irm_access_0();
    }
    else {
        caos_irm_access_1();
    }
}

// access color bank 
// NOTE: the system manual (http://www.kc85emu.de/Download/KC854-Systemhandbuch.pdf)
// says that color access is bit1=ZERO, so either MESS is wrong, or the manual...
void caos_irm_color_bank() {
__asm
    push af
    in a,(#0x84)
    or #(1<<1)
    out (#0x84),a
    pop af
    ret
__endasm;
}

// access pixel bank
void caos_irm_pixel_bank() {
__asm
    push af
    in a,(#0x84)
    and #~(1<<1)
    out (#0x84),a
    pop af
__endasm;
}
