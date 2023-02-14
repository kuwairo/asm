.globl main

.section .data

sfmt:
	.asciz "%ld"

.section .text

.equ M, -8
.equ Q, -16

main:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	# Get matrix size

	movq $sfmt, %rdi
	leaq M(%rbp), %rsi
	xorq %rax, %rax
	call scanf

	# Stop if it's less than 1

	cmpq $0, M(%rbp)
	jle stop

	# Calculate

	movq M(%rbp), %rax
	imul %rax
	movq %rax, Q(%rbp)
	imul $8, %rax

	# Allocate

	movq %rax, %rdi
	call malloc

	# Check for NULL, save

	cmpq $0, %rax
	je stop
	movq %rax, %r12

	# Fill the matrix

	movq $0, %r13

input:
	movq $sfmt, %rdi
	leaq (%r12, %r13, 8), %rsi
	xorq %rax, %rax
	call scanf

	incq %r13
	cmpq %r13, Q(%rbp)
	jg input

	# Print the matrix

	movq %r12, %rdi
	movq M(%rbp), %rsi
	xorq %rax, %rax
	call printm

	# Free

	movq %r12, %rdi
	call free

stop:
	xorq %rax, %rax
	leave
	ret
