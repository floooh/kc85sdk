kc85sdk
=======

Experimental C-SDK for KC85 home computers.

### Cheat Sheet

* **Z80 C compiler:** http://sdcc.sourceforge.net/
* **MAME/MESS:** https://github.com/mamedev/mame
* **SDL2:** brew install sdl2_gfx

```bash
Compile MESS:
> make TARGET=mess
```

```c
KCC file header format (see mame/src/mess/machine/kc.c):

struct kcc_header
{
    UINT8   name[10];
    UINT8   reserved[6];
    UINT8   number_addresses;
    UINT8   load_address_l;
    UINT8   load_address_h;
    UINT8   end_address_l;
    UINT8   end_address_h;
    UINT8   execution_address_l;
    UINT8   execution_address_h;
    UINT8   pad[128-2-2-2-1-16];
};
```

```bash
Starting mess with roms and .kcc file:

> mess64 kc85_3 -quik test.kcc -window -rompath bios -resolution 640x512 
```



