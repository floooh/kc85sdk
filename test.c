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
    short j;

    // image0 pattern
    caos_irm_view_1();
    caos_irm_access_0();
    caos_irm_pixel_bank();
    caos_clear(0x88);
    caos_irm_color_bank();
    caos_clear(CAOS_RED<<3 | CAOS_GREEN);

    // image1 pattern
    caos_irm_view_0();
    caos_irm_access_1();
    caos_irm_pixel_bank();
    caos_clear(0x44);
    caos_irm_color_bank();
    caos_clear(CAOS_GREEN<<3 | CAOS_RED);

    for (i = 0; i < 10; i++) {
        caos_irm_view(i & 1);
        for (j = 0; j < 20000; j++) {
            ;
        }
    }
}
caos_entry("DBLBUF", test_double_buf)