.globl checkv
.type checkv, @function

.section .text

.equ RA, 0

checkv:
	addi sp, sp, -8
	sd ra, RA(sp)

	# a0 <- numbers
	# a1 <- length
	# a2 <- step

	li t0, 8
	mul a1, a1, t0 # length (in bytes)
	mul a2, a2, t0 # step (in bytes)

	# a1 <- length (in bytes) + initial address
	add a1, a1, a0 

	mv t0, a0      # current address
	add t1, t0, a2 # next address

difscan:
	bge t1, a1, scpass

	ld t2, 0(t0)
	neg t2, t2
	ld t3, 0(t1)
	add t2, t2, t3 # difference

	mv t0, t1
	add t1, t0, a2
	beq t2, zero, difscan
	blt t2, zero, decscan

incscan:
	bge t1, a1, scpass

	ld t2, 0(t0)
	neg t2, t2
	ld t3, 0(t1)
	add t2, t2, t3 # difference

	mv t0, t1
	add t1, t0, a2
	bge t2, zero, incscan
	j scfail

decscan:
	bge t1, a1, scpass

	ld t2, 0(t0)
	neg t2, t2
	ld t3, 0(t1)
	add t2, t2, t3 # difference

	mv t0, t1
	add t1, t0, a2
	ble t2, zero, decscan
	j scfail

scpass:
	li a0, 1
	j stop

scfail:
	mv a0, zero

stop:
	ld ra, RA(sp)
	addi sp, sp, 8
	ret
