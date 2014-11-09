#ifndef __CAOS_H
#define __CAOS_H
//------------------------------------------------------------------------------
/**
    @file chaos.h

    'System header' for writing KC85 C programs.
    CAOS is the name of the KC85/2, /3, /4 operating system
    (C)ASSETTE (A)IDED (O)PERATING (S)YSTEM
*/

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

#define caos_put(s) \
__asm \
call 0xf003 \
.db 0x23 \
.fcc s \
.db 0x0 \
__endasm;

//------------------------------------------------------------------------------
#endif