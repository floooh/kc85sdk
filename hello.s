; simple KC85 Hello World in Z80 assembler

; KC programs usually start at address 0x200
	org 0x200

; the KC-specific program header
	db 0x7F,0x7F,"HELLO",1 

; execution starts here
	call 0xF003			; CAOS system call
	db 0x23				; system call number (print string)
	db "HELLO WORLD!\r\n",0		; embedded 0-terminated string
	ret

