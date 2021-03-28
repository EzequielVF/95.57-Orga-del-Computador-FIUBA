	.equ SWI_Print_Int, 0x6B
	.equ SWI_Exit, 0x11
	.equ SWI_Print_Str, 0x69
	.equ Stdout, 1

	.data
array:
	.word 2, 3, -4, 5, -6, 7, 9
array_length:
	.word 7
par_string:
	.asciz "- PAR \n"
eol:
    .asciz "\n"
	
	.text
	.global _start
_start:

    ldr r0, =array
    ldr r2, =array_length
    ldr r2, [r2]

loop:
    ldr r4, [r0]
    mov r1,r4
    mov r3,r4
    bl print_r1_int
    bl dejar_valor_absoluto
    bl imprimir_si_es_par
    add r0, r0, #4
    sub r2, r2, #1
    cmp r2, #0
    bne loop
    b exit

print_r1_int:
    stmfd sp!, {r0,r1,lr}
    ldr r0, =Stdout
    swi SWI_Print_Int
    ldmfd sp!, {r0,r1,pc}

dejar_valor_absoluto:
    stmfd sp!, {r0,r1,lr}
    mov r5, #0
    cmp r3, #0
    submi r3,r5,r3
    ldmfd sp!, {r0,r1,pc}

imprimir_si_es_par:
    stmfd sp!, {r0,r1,lr}
inicio:
    sub r3, r3, #2
    cmp r3, #0
    bmi no_es_par
    beq es_par
    b inicio

es_par:
    ldr r0, =Stdout
    ldr r1, =par_string
    swi SWI_Print_Str
    b exit_rev
no_es_par:
    ldr r0, =Stdout
    ldr r1, =eol
    swi SWI_Print_Str

exit_rev:
    ldmfd sp!, {r0,r1,pc}

exit:	
	swi SWI_Exit
	.end


