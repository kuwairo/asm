.globl main

.section .bss

buf:
	.zero 16777216 // 16 MiB

.section .data

sfmt:
	.asciz "%16777215[^\n]"
efmt:
	.asciz "The input buffer is blank\n"
pfmts:
	.asciz "The shortest word is '%.*s'\n"

.section .text

.equ DELIM, 32 // ASCII space character

main:
	stp x29, x30, [sp, -16]!

	ldr x0, =sfmt
	ldr x1, =buf
	bl scanf

	ldr x0, =buf // character array
	mov x1, 0    // index

	mov x2, -1   // shortest word index
	mov x3, 1024 // shortest word length

	mov x4, -1   // current word index
	mov x5, 1024 // current word length

sscan:
	ldrb w6, [x0, x1]
	sxtw x6, w6
	cmp x6, DELIM
	bne wscan

	add x1, x1, 1
	b sscan

wscan:
	cmp x6, 0
	beq escan

winit:
	// New word
	mov x4, x1
	mov x5, 1
	add x1, x1, 1

wloop:
	ldrb w6, [x0, x1]
	sxtw x6, w6
	cmp x6, 0
	beq escan

	// Is it the end of the current word?
	// If not, increment the length and move forward
	cmp x6, DELIM
	bne wnext

	// Check if the current word is the shortest one
	// If not, consume the space characters
	cmp x5, x3
	bgt sscan

	// If it is the shortest, then save it
	mov x2, x4
	mov x3, x5
	b sscan

wnext:
	add x5, x5, 1 // current_length++
	add x1, x1, 1
	b wloop

escan:
	// Check if the last word is the shortest one
	// If not, check if there's a saved word
	cmp x5, x3
	bgt eswrd

	// If the last word is the shortest one, then save it
	mov x2, x4
	mov x3, x5

eswrd:
	// Check if there was the shortest word in the input buffer
	// If so, print it
	cmp x2, -1
	bne wshow

	// If the input buffer is blank, inform the user and stop
	ldr x0, =efmt
	bl printf
	b stop

wshow:
	// Calculate the address of the shortest word
	ldr x7, =buf
	add x7, x7, x2

	// Print the shortest word
	ldr x0, =pfmts
	mov x1, x3
	mov x2, x7
	bl printf

stop:
	ldp x29, x30, [sp], 16
	ret
