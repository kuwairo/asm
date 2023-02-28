.globl readm
.type readm, @function

.section .bss

buf:
	.zero 16777216 # 16 MiB

.section .data

ifmt:
	.asciz "%ld\n"
name:
	.asciz "input"
rmode:
	.asciz "r"

.section .text

.equ RA, 24
.equ S1, 16
.equ S2, 8
.equ S3, 0

readm:
	addi sp, sp, -32
	sd ra, RA(sp)
	sd s1, S1(sp)
	sd s2, S2(sp)
	sd s3, S3(sp)

	la a0, name
	la a1, rmode
	call fopen

	beq a0, zero, stop
	mv s1, a0

	la s2, buf
	mv s3, zero # byte index

rloop:
	mv a0, s1
	la a1, ifmt
	add a2, s2, s3
	call fscanf

	li t0, 1
	bne a0, t0, rend
	addi s3, s3, 8
	j rloop

rend:
	mv a0, s1
	call fclose

	mv a0, s2

stop:
	ld ra, RA(sp)
	ld s1, S1(sp)
	ld s2, S2(sp)
	ld s3, S3(sp)
	addi sp, sp, 32
	ret
