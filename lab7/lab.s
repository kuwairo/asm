.globl main

.section .bss

buf:
	.zero 16777216 // 16 MiB

.section .data

sfmt:
	.asciz "%16777215[^\n]"
pfmt:
	.asciz "%s\n"

.section .text

main:
	stp x29, x30, [sp, -16]!

	ldr x0, =sfmt
	ldr x1, =buf
	bl scanf

	ldr x0, =pfmt
	ldr x1, =buf
	bl printf

	ldp x29, x30, [sp], 16
	ret
