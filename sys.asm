; This file contains functions to make various operations less tedious.
; These mainly include printing strings and integers to the screen,
; but there are a couple of other miscellaneous functions.

; List of all defined functions:
;	print_str
;	print
;	printi
;	strlen
;	atoi

print_str:
	; DESCRIPTION
	; 	Invokes the system call to output a string, while keeping register values intact.
	; STACK ARGUMENTS
	; 	Start address of string
	; 	String length

	; Save registers
	push rax
	push rdx
	push rdi
	push rsi

	; Prepare syscall
	mov rsi, [rsp+48] ; Start address of string
	mov rax, 1 ; System call for writing to output
	mov rdi, 1 ; Select stdout
	mov rdx, [rsp+40] ; String length
	;Run the syscall
	syscall

	; Restore registers and return
	pop rsi
	pop rdi
	pop rdx
	pop rax
	ret

print:
	; DESCRIPTION
	; 	Prints a string while automatically determining the length.
	; STACK ARGUMENTS
	; 	Start address of string

	; Save register
	push rax

	; Find string length
	mov rax, [rsp+16] ;String address
	push rax
	call strlen
	;Length is now in RAX

	;Print it
	push rax ; String address already on the stack, just provide the length now
	call print_str
	add rsp, 16

	; Restore register and return
	pop rax
	ret

strlen:
	; DESCRIPTION
	; 	Counts the number of characters in a given string, up until its null-terminator.
	; STACK ARGUMENTS
	; 	Start address of string
	; RETURN VALUE IN RAX
	; 	String length

	; Save register
	push rbx

	xor rax, rax ; Set counter to 0
	mov rbx, [rsp+24] ; String location
	strlen_loop:
		; Nullbyte check, end of string
		mov cl, byte [rbx]
		cmp cl, 0
		jz strlen_exit
		; Increment counter and character address
		inc rax
		inc rbx
		jmp strlen_loop
	strlen_exit:
	; Done - restore register and return
	pop rbx
	ret

printi:
	; STACK ARGUMENTS
	; 	Integer value to output

	; Save registers
	push rax
	push rbx
	push rcx
	push rdx
	push rbp

	mov rax, [rsp+48] ; Value of integer
	mov rbx, 10 ; Divide by 10 each iteration
	xor rcx, rcx ; Set RCX to 0
	mov rbp, rsp ; Make note of current stack pointer

	printi_extract_digits:
		; Divide value by 10, remainder is put into RDX. This gets the digits in reverse order.
		xor rdx, rdx ; Set RDX to 0
		div rbx

		; Add the remainder to the stack
		push rdx

		;printi_skip_zero:
		; Have we exhausted RAX?
		cmp rax, 0
		jg printi_extract_digits

	printi_output_digits:
		;Sequentially print each digit that got extracted
		pop rax
		add rax, "0" ; Convert to Ascii

		; Call print_str
		mov [printi_char], rax
		push printi_char
		push 1 ; String length is 1 byte
		call print_str
		add rsp, 16

		; Exit condition
		cmp rbp, rsp
		jg printi_output_digits

	; Restore registers and return
	pop rbp
	pop rdx
	pop rcx
	pop rbx
	pop rax
	ret

; While this routine isn't currently used in this file,
; it would be useful if an integer input routine was ever required.
; Future update perhaps?
atoi:
	; STACK ARGUMENTS
	; 	Start address of string
	; RETURN VALUE IN RAX
	; 	Integer version of string

	; Save registers
	push rbx
	push rsi

	; Initialise registers. Setting to zero is done with xor because it is very fast and uses less memory.
	xor rax, rax ; Output
	xor rbx, rbx ; Current character
	mov rsi, [rsp+24] ; String start address
	atoi_loop:
		mov bl, [rsi] ; Read character
		cmp bl, 0
		jz atoi_done

		cmp bl, 48 ; Character less than 0?
		jl atoi_err
		cmp bl, 57 ; Character greater than 9?
		jg atoi_err

		sub bl, 48 ; Ascii to decimal conversion
		imul rax, 10 ; Multiply by 10
		add rax, rbx

		inc rsi ; Advance to next character
		jmp atoi_loop ;Repeat

	atoi_err:
	; Invalid character, set RAX to -1
	mov rax, -1

	atoi_done:
	; Restore registers and return
	pop rsi
	pop rbx
	ret


SECTION .data
printi_char db 0 ; Temporary variable used by printi, since print_str needs an address to some data.
