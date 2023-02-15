.globl rotatem
.type rotatem, @function

.section .text

rotatem:
	# %rdi <- matrix
	# %rsi <- matrix size (M)

	movq $0, %r8 # row counter

rloop1:
	movq $0, %r9 # column counter

cloop1:
	movq %r8, %rax
	imul %rsi
	addq %r9, %rax # [%r8][%r9] i, j

	movq %r9, %rcx
	imul %rsi, %rcx
	addq %r8, %rcx # [%r9][%r8] j, i

	movq (%rdi, %rax, 8), %rdx
	xchgq %rdx, (%rdi, %rcx, 8)
	movq %rdx, (%rdi, %rax, 8)

	incq %r9
	cmpq %r9, %r8
	jg cloop1

	incq %r8
	cmpq %r8, %rsi
	jg rloop1

	xorq %rax, %rax
	ret
