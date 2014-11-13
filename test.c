#include "caos.h"

void test_clear_pixel_buf() {
    caos_clear(0);
}
caos_entry("CLRPIXELS", test_clear_pixel_buf)

void test_clear_color_buf() {
    caos_clear_color_buf((CAOS_GREEN<<3) | CAOS_RED);
}
caos_entry("CLRCOLOR", test_clear_color_buf)

void test_double_buf() {
    short i;

    caos_clear(0);
    for (i = 0; i < 32; i++) {
        caos_line(0, 0, 255, i<<3);
    }

#if 0
    // image0 pattern
    caos_irm_view_1();
    caos_irm_access_0();
    caos_irm_pixel_bank();
    caos_clear(0x0);
    caos_irm_color_bank();
    caos_clear(CAOS_RED<<3 | CAOS_GREEN);
    caos_line(10, 10, 120, 120);

    // image1 pattern
    caos_irm_view_0();
    caos_irm_access_1();
    caos_irm_pixel_bank();
    caos_clear(0x0);
    caos_irm_color_bank();
    caos_clear(CAOS_GREEN<<3 | CAOS_RED);
    caos_line(128, 128, 250, 250);

    for (i = 0; i < 10; i++) {
        caos_irm_view(i & 1);
        caos_wait(100); 
    }
#endif
}
caos_entry("DBLBUF", test_double_buf)
