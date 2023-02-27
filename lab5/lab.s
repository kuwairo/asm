.globl main

.section .data

sfmt:
	.asciz "%ld %ld"
pfmt:
	.asciz "y = %ld + %ld = %ld\n"

.section .text

.equ RA, 16
.equ X, 8
.equ A, 0

main:
	addi sp, sp, -24
	sd ra, RA(sp)

	la a0, sfmt
	addi a1, sp, X
	addi a2, sp, A
	call scanf

	# TODO: loop

	# t0 <- if x > a then x mod 4 else a

	ld t0, A(sp)
	ld t1, X(sp)
	bgt t1, t0, then1
	j cend1
then1:
	li t2, 4
	rem t0, t1, t2
cend1:

	# t1 <- if x / a > 3 then a * x else x

	ld t2, X(sp)
	ld t3, A(sp)
	div t4, t2, t3
	rem t5, t2, t3

	li t6, 3
	bgt t4, t6, then2
	blt t4, t6, else2
	beq t5, zero, else2
then2:
	mul t1, t2, t3
	j cend2
else2:
	mv t1, t2
cend2:

	add t2, t1, t0

	la a0, pfmt
	mv a1, t0
	mv a2, t1
	mv a3, t2
	call printf

	ld ra, RA(sp)
	addi sp, sp, 24
	ret
