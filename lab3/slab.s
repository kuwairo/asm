.globl main

.section .data

sfmt:
	.asciz "%1000[^\n]"
pfmt:
	.asciz "Word count: %ld\nAverage word length: %.2lf\n"

sep:
	.byte 32 # ' '

.section .text

main:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	movq $1024, %rdi
	call malloc

	cmpq $0, %rax
	je stop
	movq %rax, %r12

	movq $sfmt, %rdi
	movq %r12, %rsi
	xorq %rax, %rax
	call scanf

	movq $0, %rcx
	movq $0, %r8 # sep-count
	movq $0, %r9 # all-count

loopb:
	movb (%r12, %rcx, 1), %al

	cmpb $0, %al
	je break

	cmpb sep, %al
	jne count
	incq %r8

count:
	incq %r9
	incq %rcx
	jmp loopb

break:
	movq %r8, %r10
	incq %r10 # word count

	movq %r9, %r11
	subq %r8, %r11 # characters count

	cvtsi2sd %r11, %xmm0
	cvtsi2sd %r10, %xmm1
	divsd %xmm1, %xmm0 # average word length

	movq $pfmt, %rdi
	movq %r10, %rsi
	movq $1, %rax
	call printf

	movq %r12, %rdi
	call free

stop:
	xorq %rax, %rax
	leave
	ret
