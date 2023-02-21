.globl main

.section .text

main:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	call loadr

	xorq %rax, %rax
	leave
	ret
