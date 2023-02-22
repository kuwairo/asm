.globl loadr
.type loadr, @function

.section .data

sfmt:
	.asciz "%100[^,],%100[^,],%10[^,],%ld\n"
rmode:
	.asciz "r"

.section .text

.globl RSIZE

.equ GFACT, 2
.equ RQUAN, 4
.equ RSIZE, 221 # 2 * (100 + 1) + (10 + 1) + 8
.equ BSIZE, 884 # 4 * 221

.globl DSTOFF, SRCOFF, DTEOFF, PRCOFF

.equ DSTOFF, 0
.equ SRCOFF, DSTOFF + 101
.equ DTEOFF, SRCOFF + 101
.equ PRCOFF, DTEOFF + 11

.equ FPT, -8
.equ ARR, -16
.equ LEN, -24
.equ CAP, -32

loadr:
	pushq %rbp
	movq %rsp, %rbp
	subq $32, %rsp

	# %rdi <- filepath

	movq $rmode, %rsi
	call fopen

	cmpq $0, %rax
	je ecode
	movq %rax, FPT(%rbp)

	movq $BSIZE, %rdi
	call malloc

	cmpq $0, %rax
	je ecode

	movq %rax, ARR(%rbp)
	movq $0, LEN(%rbp)
	movq $RQUAN, CAP(%rbp)

rloop:
	movq ARR(%rbp), %rax
	imulq $RSIZE, LEN(%rbp), %r10

	movq FPT(%rbp), %rdi
	movq $sfmt, %rsi
	leaq DSTOFF(%rax, %r10), %rdx
	leaq SRCOFF(%rax, %r10), %rcx
	leaq DTEOFF(%rax, %r10), %r8
	leaq PRCOFF(%rax, %r10), %r9
	xorq %rax, %rax
	call fscanf

	cmpq $4, %rax
	jne scode

	incq LEN(%rbp)
	movq CAP(%rbp), %rax
	cmpq LEN(%rbp), %rax
	jg rloop

	imulq $GFACT, %rax, %rax
	movq %rax, CAP(%rbp)

	movq ARR(%rbp), %rdi
	movq %rax, %rsi
	call realloc

	cmpq $0, %rax
	je ecode

	movq %rax, ARR(%rbp)
	jmp rloop

ecode:
	xorq %rax, %rax
	xorq %rdx, %rdx
	jmp final

scode:
	movq ARR(%rbp), %rax
	movq LEN(%rbp), %rdx

final:
	leave
	ret
