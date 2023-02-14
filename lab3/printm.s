.globl printm
.type printm, @function

.section .data

efmt:
	.asciz "%ld\t"
nl:
	.asciz "\n"

.section .text

printm:
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15

	movq %rdi, %r12 # matrix
	movq %rsi, %r13 # matrix size (M)

	movq $0, %r14 # row counter

rloop:
	movq $0, %r15 # column counter

cloop:
	movq %r14, %rax
	imul %r13
	addq %r15, %rax # current index

	movq $efmt, %rdi
	movq (%r12, %rax, 8), %rsi
	xorq %rax, %rax
	call printf

	incq %r15
	cmpq %r15, %r13
	jg cloop

	movq $nl, %rdi
	xorq %rax, %rax
	call printf

	incq %r14
	cmpq %r14, %r13
	jg rloop

	popq %r15
	popq %r14
	popq %r13
	popq %r12

	xorq %rax, %rax
	ret
