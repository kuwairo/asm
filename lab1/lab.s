.globl _start

.section .text

# TODO:
# z = (xy - 1) / (x + y)
# z = x^3 + y - 1
# z = (xy + 1) / x^2
# z = (x + y) / (x - y)
# z = (3x^3 - 1) / x^3

_start:
	movq $60, %rax
	movq $0, %rdi
	syscall
