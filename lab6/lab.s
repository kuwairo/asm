.globl main

.section .data

rowfmt:
	.asciz "@ row %ld: min = %ld, max = %ld\n"
colfmt:
	.asciz "@ col %ld: min = %ld, max = %ld\n"

.section .text

.equ RA, 64
.equ S1, 56
.equ S2, 48
.equ S3, 40
.equ S4, 32
.equ S5, 24
.equ S6, 16
.equ S7, 8
.equ S8, 0

main:
	addi sp, sp, -72
	sd ra, RA(sp)
	sd s1, S1(sp)
	sd s2, S2(sp)
	sd s3, S3(sp)
	sd s4, S4(sp)
	sd s5, S5(sp)
	sd s6, S6(sp)
	sd s7, S7(sp)
	sd s8, S8(sp)

	call readm

	beq a0, zero, stop
	addi s1, a0, 16
	ld s2, 0(a0) # N
	ld s3, 8(a0) # M

	mv s4, s2 # copy N
	mv s7, s3 # copy M

	# Convert N and M to row (s2) and column (s3) byte lengths
	li t0, 8
	mul s2, s2, t0 # s2 <- N * 8
	mul s3, s4, s7 # s3 <- N * M
	neg t1, s4     # t1 <- -N
	add s3, s3, t1 # s3 <- N * M - N
	addi s3, s3, 1 # s3 <- N * M - N + 1
	mul s3, s3, t0 # s3 <- (N * M - N + 1) * 8

	# Check all rows

	mv s5, s1 # current address
	li s6, 1  # row number

lrow:
	mv a0, s5
	mv a1, s2
	li a2, 8
	call checkv

	beq a0, zero, nrow
	ld t0, 0(s5) # head
	addi t1, s2, -8
	add t1, t1, s5
	ld t1, 0(t1) # tail

	blt t1, t0, trow
	mv a2, t0 # min
	mv a3, t1 # max
	j prow

trow:
	mv a2, t1 # min
	mv a3, t0 # max

prow:
	la a0, rowfmt
	mv a1, s6
	call printf

nrow:
	add s5, s5, s2
	addi s6, s6, 1
	ble s6, s7, lrow

	# Check all columns

	# Offset for the last row
	li t0, 8
	addi s8, s7, -1 # M - 1
	mul s8, s4, s8  # N * (M - 1)
	mul s8, s8, t0  # N * (M - 1) * 8

	mv s5, s1 # current address
	li s6, 1  # column number

lcol:
	mv a0, s5
	mv a1, s3
	mv a2, s2
	call checkv

	beq a0, zero, ncol
	ld t0, 0(s5) # head
	add t1, s5, s8
	ld t1, 0(t1) # tail

	blt t1, t0, tcol
	mv a2, t0 # min
	mv a3, t1 # max
	j pcol

tcol:
	mv a2, t1 # min
	mv a3, t0 # max

pcol:
	la a0, colfmt
	mv a1, s6
	call printf

ncol:
	addi s5, s5, 8
	addi s6, s6, 1
	ble s6, s4, lcol

stop:
	ld ra, RA(sp)
	ld s1, S1(sp)
	ld s2, S2(sp)
	ld s3, S3(sp)
	ld s4, S4(sp)
	ld s5, S5(sp)
	ld s6, S6(sp)
	ld s7, S7(sp)
	ld s8, S8(sp)
	addi sp, sp, 72
	ret
