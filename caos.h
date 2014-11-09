#ifndef __CAOS_H
#define __CAOS_H
//------------------------------------------------------------------------------
/**
    @file chaos.h

    'System header' for writing KC85 C programs.
    CAOS is the name of the KC85/2, /3, /4 operating system
    (C)ASSETTE (A)IDED (O)PERATING (S)YSTEM

    http://www.mpm-kc85.de/dokupack/KC85_3_uebersicht.pdf    
    http://www.z80.info/z80inst.txt    

    NOTE: IX must not be touched!
*/

// special places in memory
#define CAOS_ARGC 0xB780
#define CAOS_ARGN 0xB781
#define CAOS_ARG1 0xB782
#define CAOS_ARG2 0xB784
#define CAOS_ARG3 0xB786

// color values
#define CAOS_BLACK      (0)
#define CAOS_BLUE       (1)
#define CAOS_RED        (2)
#define CAOS_PURPLE     (3)
#define CAOS_GREEN      (4)
#define CAOS_TURQUOIS   (5)
#define CAOS_YELLOW     (6)
#define CAOS_WHITE      (7)
#define CAOS_VIOLET         (9)
#define CAOS_ORANGE         (10)
#define CAOS_PURPLERED      (11)
#define CAOS_GREENBLUE      (12)
#define CAOS_BLUEGREEN      (13)
#define CAOS_YELLOWGREEN    (14)

//------------------------------------------------------------------------------
//  chaos_entry(name, func)
//  Defines a C function as an entry point callable from the 
//  CAOS command line.
//
#define caos_entry(name, func) \
void entry_##func() __naked { \
    __asm \
        .db 0x7F, 0x7F \
        .fcc name \
        .db 0x1 \
        __endasm; \
        func(); \
        __asm \
        .db 0xC9 \
        __endasm; \
}

//------------------------------------------------------------------------------
//  chaos_putl(string_literal)
//  Print embedded string literal ()
#define caos_putl(s) \
    __asm \
        call 0xf003 \
        .db 0x23 \
        .fcc s \
        .db 0x0 \
    __endasm;

//------------------------------------------------------------------------------
extern void caos_color(char background, char foreground);
extern void caos_clear();

//------------------------------------------------------------------------------
#endif