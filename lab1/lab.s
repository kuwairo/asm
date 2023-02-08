.globl main

.section .data

sfmtd:
	.asciz "%ld %ld"
pfmtd1:
	.asciz "z = (xy - 1) / (x + y) = %ld.%03ld\n"
pfmtd2:
	.asciz "z = x^3 + y - 1 = %ld.%03ld\n"
pfmtd3:
	.asciz "z = (xy + 1) / x^2 = %ld.%03ld\n"
pfmtd4:
	.asciz "z = (x + y) / (x - y) = %ld.%03ld\n"
pfmtd5:
	.asciz "z = (3x^3 - 1) / x^3 = %ld.%03ld\n"

.section .text

.equ X, -8
.equ Y, -16

main:
	pushq %rbp
	mov %rsp, %rbp
	subq $16, %rsp

	movq $sfmtd, %rdi
	leaq X(%rbp), %rsi
	leaq Y(%rbp), %rdx
	xorq %rax, %rax
	call scanf

	# (1) z = (xy - 1) / (x + y)

	# %rax <- xy - 1
	movq X(%rbp), %rax
	imulq Y(%rbp)
	decq %rax

	# %rbx <- x + y
	movq X(%rbp), %rbx
	addq Y(%rbp), %rbx

	# %rax <- (xy - 1) div (x + y)
	# %rdx <- (xy - 1) rem (x + y)
	cqo
	idivq %rbx

	movq %rax, %r15
	imulq $1000, %rdx, %rax
	cqo
	idivq %rbx

	cmpq $0, %rax
	jge print1
	negq %rax

print1:
	movq $pfmtd1, %rdi
	movq %r15, %rsi
	movq %rax, %rdx
	xorq %rax, %rax
	call printf

	# (2) z = x^3 + y - 1
	# TODO

	# (3) z = (xy + 1) / x^2
	# TODO

	# (4) z = (x + y) / (x - y)
	# TODO

	# (5) z = (3x^3 - 1) / x^3
	# TODO

	xorq %rax, %rax
	leave
	ret
