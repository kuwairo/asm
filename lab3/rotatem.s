.globl rotatem
.type rotatem, @function

.section .data

q2:
	.quad 2

.section .text

rotatem:
	# %rdi <- matrix
	# %rsi <- matrix size (M)

	# Mirroring #1 (main diagonal)

	movq $0, %r8 # row counter

rloop1:
	movq $0, %r9 # column counter

cloop1:
	movq %r8, %rax
	imul %rsi
	addq %r9, %rax # [%r8][%r9]

	movq %r9, %rcx
	imul %rsi, %rcx
	addq %r8, %rcx # [%r9][%r8]

	movq (%rdi, %rax, 8), %rdx
	xchgq %rdx, (%rdi, %rcx, 8)
	movq %rdx, (%rdi, %rax, 8)

	incq %r9
	cmpq %r9, %r8
	jg cloop1

	incq %r8
	cmpq %r8, %rsi
	jg rloop1

	# Mirroring #2 (middle column)

	movq %rsi, %rax
	cqo
	idivq q2 # %rax <- M / 2

	movq $0, %r8 # row counter

rloop2:
	movq $0, %r9 # column counter

cloop2:
	movq %r8, %rcx
	imul %rsi, %rcx
	addq %r9, %rcx # [%r8][%r9]

	movq %r8, %rdx
	imul %rsi, %rdx
	addq %rsi, %rdx
	subq %r9, %rdx
	decq %rdx # [%r8][M - %r9 - 1]

	movq (%rdi, %rcx, 8), %r10
	xchgq %r10, (%rdi, %rdx, 8)
	movq %r10, (%rdi, %rcx, 8)

	incq %r9
	cmpq %r9, %rax
	jg cloop2

	incq %r8
	cmpq %r8, %rsi
	jg rloop2

	xorq %rax, %rax
	ret
