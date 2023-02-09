.globl main

.section .data

sfmtd:
	.asciz "%ld %ld"
pfmtd1:
	.asciz "z = (xy - 1) / (x + y) = %c%ld.%03ld\n"
pfmtd2:
	.asciz "z = x^3 + y - 1 = %ld.%03ld\n"
pfmtd3:
	.asciz "z = (xy + 1) / x^2 = %c%ld.%03ld\n"
pfmtd4:
	.asciz "z = (x + y) / (x - y) = %c%ld.%03ld\n"
pfmtd5:
	.asciz "z = (3x^3 - 1) / x^3 = %c%ld.%03ld\n"

.section .text

.equ X, -8
.equ Y, -16

main:
	pushq %rbp
	movq %rsp, %rbp
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

	movq %rax, %rdi
	movq %rbx, %rsi
	movq $pfmtd1, %rdx
	xorq %rax, %rax
	call printdiv

	# (2) z = x^3 + y - 1

	# %rax <- x^3 + y - 1
	movq X(%rbp), %rax
	imulq %rax
	imulq X(%rbp)
	addq Y(%rbp), %rax
	decq %rax

	movq $pfmtd2, %rdi
	movq %rax, %rsi
	movq $0, %rdx
	xorq %rax, %rax
	call printf

	# (3) z = (xy + 1) / x^2

	# %rbx <- x^2
	movq X(%rbp), %rax
	imulq %rax
	movq %rax, %rbx

	# %rax <- xy + 1
	movq X(%rbp), %rax
	imulq Y(%rbp)
	incq %rax

	movq %rax, %rdi
	movq %rbx, %rsi
	movq $pfmtd3, %rdx
	xorq %rax, %rax
	call printdiv

	# (4) z = (x + y) / (x - y)

	# %rax <- x + y
	movq X(%rbp), %rax
	addq Y(%rbp), %rax

	# %rbx <- x - y
	movq X(%rbp), %rbx
	subq Y(%rbp), %rbx

	movq %rax, %rdi
	movq %rbx, %rsi
	movq $pfmtd4, %rdx
	xorq %rax, %rax
	call printdiv

	# (5) z = (3x^3 - 1) / x^3

	# %rax <- x^3
	movq X(%rbp), %rax
	imulq %rax
	imulq X(%rbp)

	# %rax <- 3x^3 - 1
	# %rbx <- x^3
	movq %rax, %rbx
	imulq $3, %rax
	decq %rax

	movq %rax, %rdi
	movq %rbx, %rsi
	movq $pfmtd5, %rdx
	xorq %rax, %rax
	call printdiv

	xorq %rax, %rax
	leave
	ret
