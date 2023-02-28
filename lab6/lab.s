.globl main

.section .data

pfmt:
	.asciz "%ld\n"

.section .text

.equ RA, 32
.equ S1, 24
.equ S2, 16
.equ S3, 8
.equ S4, 0

main:
	addi sp, sp, -40
	sd ra, RA(sp)
	sd s1, S1(sp)
	sd s2, S2(sp)
	sd s3, S3(sp)
	sd s4, S4(sp)

	call readm

	beq a0, zero, stop
	addi s1, a0, 16
	ld s2, 0(a0) # N
	ld s3, 8(a0) # M

rowl:
	# TODO

coll:
	# TODO

stop:
	ld ra, RA(sp)
	ld s1, S1(sp)
	ld s2, S2(sp)
	ld s3, S3(sp)
	ld s4, S4(sp)
	addi sp, sp, 40
	ret
