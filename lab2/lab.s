.globl main

.section .data

sfmt:
	.asciz "%ld %lf"
pfmt:
	.asciz "y(%ld, %.3lf) = %.3lf\n"

d2:
	.double 2.0
d4:
	.double 4.0
d7:
	.double 7.0

.section .text

.equ X, -8
.equ A, -16

main:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	movq $sfmt, %rdi
	leaq X(%rbp), %rsi
	leaq A(%rbp), %rdx
	xorq %rax, %rax
	call scanf

	movq X(%rbp), %r12
	movq X(%rbp), %r13
	addq $9, %r13

loop:
	movq A(%rbp), %xmm0
	cvtsi2sd %r12, %xmm1

	# (y1) %xmm1 <- if x <= 4 then 4 * x else x - a

	comisd d4, %xmm1
	ja diff
	mulsd d4, %xmm1
	jmp both
diff:
	subsd %xmm0, %xmm1
both:

	# (y2) %xmm2 <- if (1 & x) = 1 then 7 else x / 2 + a

	testq $1, %r12
	jz even
	movq d7, %xmm2
	jmp done
even:
	cvtsi2sd %r12, %xmm2
	divsd d2, %xmm2
	addsd %xmm0, %xmm2
done:

	# (y) %xmm1 <- %xmm1 + %xmm2

	addsd %xmm2, %xmm1

	movq $pfmt, %rdi
	movq %r12, %rsi
	movq $2, %rax
	call printf

	addq $1, %r12
	cmpq %r12, %r13
	jge loop

	xorq %rax, %rax
	leave
	ret
