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

	# %rax <- (xy + 1) div x^2
	# %rdx <- (xy + 1) rem x^2
	cqo
	idivq %rbx

	movq %rax, %r15
	imulq $1000, %rdx, %rax
	cqo
	idivq %rbx

	cmpq $0, %rax
	jge print3
	negq %rax

print3:
	movq $pfmtd3, %rdi
	movq %r15, %rsi
	movq %rax, %rdx
	xorq %rax, %rax
	call printf

	# (4) z = (x + y) / (x - y)

	# %rax <- x + y
	movq X(%rbp), %rax
	addq Y(%rbp), %rax

	# %rbx <- x - y
	movq X(%rbp), %rbx
	subq Y(%rbp), %rbx

	# %rax <- (x + y) div (x - y)
	# %rdx <- (x + y) rem (x - y)
	cqo
	idivq %rbx

	movq %rax, %r15
	imulq $1000, %rdx, %rax
	cqo
	idivq %rbx

	cmpq $0, %rax
	jge print4
	negq %rax

print4:
	movq $pfmtd4, %rdi
	movq %r15, %rsi
	movq %rax, %rdx
	xorq %rax, %rax
	call printf

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

	# %rax <- (3x^3 - 1) div x^3
	# %rdx <- (3x^3 - 1) rem x^3
	cqo
	idivq %rbx

	movq %rax, %r15
	imulq $1000, %rdx, %rax
	cqo
	idivq %rbx

	cmpq $0, %rax
	jge print5
	negq %rax

print5:
	movq $pfmtd5, %rdi
	movq %r15, %rsi
	movq %rax, %rdx
	xorq %rax, %rax
	call printf

	xorq %rax, %rax
	leave
	ret
