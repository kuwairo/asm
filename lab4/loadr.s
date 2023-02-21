.globl loadr
.type loadr, @function

.section .data

sfmt:
	.asciz "%100[^,],%100[^,],%10[^,],%ld\n"

gfact:
	.quad 2
bsize:
	.quad 4
rsize:
	.quad 221 # 2 * (100 + 1) + (10 + 1) + 8

.section .text

.equ DSTOFF, 0
.equ SRCOFF, DSTOFF + 101
.equ DTEOFF, SRCOFF + 101
.equ PRCOFF, DTEOFF + 11

.equ ARR, -8
.equ LEN, -16
.equ CAP, -24

loadr:
	pushq %rbp
	movq %rsp, %rbp
	subq $32, %rsp

	movq rsize, %rax
	imulq bsize

	movq %rax, %rdi
	call malloc

	cmpq $0, %rax
	je ecode

	movq %rax, ARR(%rbp)
	movq $0, LEN(%rbp)

	movq bsize, %rcx
	movq %rcx, CAP(%rbp)

rloop:
	movq ARR(%rbp), %rax
	movq LEN(%rbp), %r10

	movq $sfmt, %rdi
	leaq DSTOFF(%rax, %r10), %rsi
	leaq SRCOFF(%rax, %r10), %rdx
	leaq DTEOFF(%rax, %r10), %rcx
	leaq PRCOFF(%rax, %r10), %r8
	xorq %rax, %rax
	call scanf

	cmpq $4, %rax
	jne scode

	incq LEN(%rbp)
	movq CAP(%rbp), %rax
	cmpq LEN(%rbp), %rax
	jg rloop

	imulq gfact
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
