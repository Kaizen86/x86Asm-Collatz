%include "sys.asm"

SECTION .text
global _start

_start:
	; Goal: Calculate Collatz conjecture sequence for a hardcoded number

	mov rax, startmsg
	push rax
	call print
	add rsp, 8

	; Load n from RAM
	mov rax, [startvalue]

	collatz_loop:
		; Output rax
		push rax
		call printi
		add rsp, 8
		; And also a newline.
		mov rbx, newline
		push rbx
		push 1
		call print_str
		add rsp, 16

		; Is n 1 or lower?
		cmp rax,1
		jle collatz_end_loop

		; Bitwise AND to check for even/odd
		mov rbx, rax
		and rbx, 1
		cmp rbx, 1 	; Selection based on the result
		jne collatz_even

		; It's odd - triple n then add 1
		mov rbx, 3
		mul rbx
		inc rax
		jmp collatz_loop ; Repeat

		collatz_even:
		; Else (even) - divide n by 2
		mov rbx, 2
		div rbx
		jmp collatz_loop	;Repeat

	collatz_end_loop:

	; System call for clean exit
	mov rax, 60
	syscall


SECTION .data
startmsg: db "Collatz Conjecture Algorithm, written entirely in x86 assembly.",0xa,0
newline: db 0xa ; '\n' character code
startvalue: dd 529 ; 'dd' because this could be a doubleword value.
