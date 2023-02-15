.globl printdiv
.type printdiv, @function

.section .data

pos:
	.quad 0 # ''
neg:
	.quad 45 # '-'

.section .text

.equ N, -8
.equ M, -16
.equ F, -24

printdiv:
	pushq %rbp
	movq %rsp, %rbp
	subq $32, %rsp # 16 byte S.A.

	movq %rdi, N(%rbp) # 1st op.
	movq %rsi, M(%rbp) # 2nd op.
	movq %rdx, F(%rbp) # fmt string

	# %r8 <- sign(%rdi / %rsi)
	shrq $63, %rdi
	shrq $63, %rsi
	xorq %rsi, %rdi
	cmovzq pos, %r8
	cmovnzq neg, %r8

	# %r9 <- abs M(%rbp)
	movq M(%rbp), %rax
	cqo
	xorq %rdx, %rax
	subq %rdx, %rax
	movq %rax, %r9

	# %rax <- abs N(%rbp)
	movq N(%rbp), %rax
	cqo
	xorq %rdx, %rax
	subq %rdx, %rax

	# %rax <- %rax div %r9
	# %rdx <- %rax rem %r9
	cqo
	idivq %r9

	movq %rax, %r10
	imulq $1000, %rdx, %rax
	cqo
	idivq %r9

	movq F(%rbp), %rdi
	movq %r8, %rsi
	movq %r10, %rdx
	movq %rax, %rcx
	xorq %rax, %rax
	call printf

	leave
	ret
