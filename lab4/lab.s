.globl main

.section .data

pfmt:
	.asciz "Filepath: "
sfmt:
	.asciz "%4096[^\n]"

ofmt:
	.asciz "%s,%s,%s,%ld\n"
name:
	.asciz "output"
wmode:
	.asciz "w"

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
	call loadr

	movq %rax, %r14 # array pointer
	movq %rdx, %r15 # array length

	movq $name, %rdi
	movq $wmode, %rsi
	call fopen

	cmpq $0, %rax
	je fmem
	movq %rax, %r13

	movq %r14, %rbx

wloop:
	movq PRCOFF(%rbx), %r9
	addq $99, %r9

	movq %r13, %rdi
	movq $ofmt, %rsi
	leaq DSTOFF(%rbx), %rdx
	leaq SRCOFF(%rbx), %rcx
	leaq DTEOFF(%rbx), %r8
	xorq %rax, %rax
	call fprintf

	addq $RSIZE, %rbx
	decq %r15
	jnz wloop

	movq %r13, %rdi
	call fclose

fmem:
	movq %r12, %rdi
	call free

	movq %r14, %rdi
	call free

stop:
	xorq %rax, %rax
	leave
	ret
