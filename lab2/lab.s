.globl main

.section .data

sfmt:
	.asciz "%ld %lf"
pfmt:
	.asciz "y = y1 + y2 = %lf\n"

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

	cvtsi2sd X(%rbp), %xmm0
	movq A(%rbp), %xmm1

	# (y1) %xmm0 <- if x <= 4 then 4 * x else x - a

	comisd d4, %xmm0
	ja diff
	mulsd d4, %xmm0
	jmp both
diff:
	subsd %xmm1, %xmm0
both:

	# (y2) %xmm2 <- if (1 & x) = 1 then 7 else x / 2 + a

	testq $1, X(%rbp)
	jz even
	movq d7, %xmm2
	jmp done
even:
	cvtsi2sd X(%rbp), %xmm2
	divsd d2, %xmm2
	addsd %xmm1, %xmm2
done:

	# (y) %xmm0 <- %xmm0 + %xmm2

	addsd %xmm2, %xmm0

	movq $pfmt, %rdi
	movq $1, %rax
	call printf

	xorq %rax, %rax
	leave
	ret
