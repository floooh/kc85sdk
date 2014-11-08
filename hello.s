; simple Hello World in z80 assembler

; KC programs usually start at address 0x200
	org 0x200

; the KC-specific program header
	db 0x7f
	db 0x7f
	dm "HELLO"
	db 01

; execution starts here
	call 0xf003		; CAOS system call
	db 0x23			; system call number (print string)
	dm "HELLO WORLD!"	; embedded string
	db 0xD, 0xA		; new-line
	db 0x0			; string terminated with 0-byte
	ret

