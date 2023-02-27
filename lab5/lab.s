.globl main

.section .data

sfmt:
	.asciz "%ld %ld"
pfmt:
	.asciz "y = (%ld) + (%ld) = %ld\n"

.section .text

.equ RA, 24
.equ S1, 16
.equ S2, 8
.equ S3, 0

main:
	addi sp, sp, -32
	sd ra, RA(sp)
	sd s3, S3(sp)

	la a0, sfmt
	addi a1, sp, S1
	addi a2, sp, S2
	call scanf

	ld t0, S1(sp)
	ld t1, S2(sp)
	sd s1, S1(sp)
	sd s2, S2(sp)
	mv s1, t0
	mv s2, t1

	mv s3, s1
	addi s3, s3, 9

mloop:

	# t0 <- if x > a then x mod 4 else a

	mv t0, s2
	mv t1, s1
	bgt t1, t0, then1
	j cend1
then1:
	li t2, 4
	rem t0, t1, t2
cend1:

	# t1 <- if x / a > 3 then a * x else x

	mv t2, s1
	mv t3, s2
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

	addi s1, s1, 1
	ble s1, s3, mloop

	ld ra, RA(sp)
	ld s1, S1(sp)
	ld s2, S2(sp)
	ld s3, S3(sp)
	addi sp, sp, 32
	ret
