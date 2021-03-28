	.equ SWI_Print_String, 0x02
	.equ SWI_Exit, 0x11

	.data
first_string:
	.asciz "Organizacion "
second_string:
	.asciz "del "
third_string:
	.asciz "Computador\n"

	.text
	.global _start
_start:
	bl 	print_tres_cadenas
	b 	fin

print_tres_cadenas:
	stmfd sp!, {r0,lr}

	ldr r3, =first_string
	mov r0, r3
	swi SWI_Print_String

	ldr r3, =second_string
	mov r0, r3
	swi SWI_Print_String

	ldr r3, =third_string
	mov r0, r3
	swi SWI_Print_String

	ldmfd sp!, {r0,pc}

fin:
	swi SWI_Exit
	.end
