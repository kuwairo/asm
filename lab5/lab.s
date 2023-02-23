.globl _start

_start:
	addi a0, x0, 1
	la a1, msg
	addi a2, x0, 15
	addi a7, x0, 64
	ecall

	addi a0, x0, 0
	addi a7, x0, 93
	ecall

.data

msg:
	.ascii "Hello, RISC-V!\n"
