.globl main

.section .text

.equ RA, 0

main:
	addi sp, sp, -8
	sd ra, RA(sp)

	call readm

	ld ra, RA(sp)
	addi sp, sp, 8
	ret
