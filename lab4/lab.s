.globl main

.section .data

pfmt:
	.asciz "Filepath: "
sfmt:
	.asciz "%4096[^\n]"

rfmt:
	.asciz "DST: '%s'\nSRC: '%s'\nDate: '%s'\nPrice: %ld\n\n"

mode:
	.asciz "r"

.section .text

.equ PATHLIM, 4096 + 1

main:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	movq $PATHLIM, %rdi
	call malloc

	cmpq $0, %rax
	je stop
	movq %rax, %r12

	movq $pfmt, %rdi
	xorq %rax, %rax
	call printf

	movq $sfmt, %rdi
	movq %r12, %rsi
	xorq %rax, %rax
	call scanf

	movq %r12, %rdi
	movq $mode, %rsi
	call fopen

	cmpq $0, %rax
	je fmem
	movq %rax, %r13

	movq %r13, %rdi
	call loadr

	# TODO: update data

	movq %rax, %r14 # array pointer
	movq %rdx, %r15 # array length

	movq %r14, %rbx

wloop:
	movq $rfmt, %rdi
	leaq DSTOFF(%rbx), %rsi
	leaq SRCOFF(%rbx), %rdx
	leaq DTEOFF(%rbx), %rcx
	movq PRCOFF(%rbx), %r8
	xorq %rax, %rax
	call printf

	addq $RSIZE, %rbx
	decq %r15
	jnz wloop

fmem:
	movq %r12, %rdi
	call free

stop:
	xorq %rax, %rax
	leave
	ret
