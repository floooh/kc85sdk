kc85sdk
=======

Experimental ASM and C SDK for KC85 home computers.

### Video Snippets

* assembly coding: http://floooh.github.io/kc85sdk/kc85_asm.webm
* C99 coding: http://floooh.github.io/kc85sdk/kc85_c.webm

### Getting Started (OSX)

```bash
> brew install z80asm
> brew install sdcc
> cd ~
> git clone git@github.com:mamedev/mame.git mame
> cd mame
> make SUBTARGET=mess
[mess executable is now '~/mame/mess64']
> cd ~
> git clone git@github.com:floooh/kc85sdk.git kc85sdk
> cd kc85sdk
> ./kc config
How to call 'mess': [type: ~/mame/mess64]
> ./kc test
> ./kc asm hello.s
> ./kc run hello
> ./kc make hello.c
> ./kc run hello
```
