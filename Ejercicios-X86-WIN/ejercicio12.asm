global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
        msgValido   db      "El mes ingresado es valido.",10,0
        msgInvalido db      "El mes ingresado no es valido.",10,0
        mes         db      1
section		.bss
        RESULT  resb    1

section		.text
main:  
    call validar

    cmp byte[RESULT],'S'
    je mensajeValido

    mov rcx,msgInvalido
    sub rsp,32
    call    printf
    add rsp,32
    jmp fin

mensajeValido:
    mov rcx,msgValido
    sub rsp,32
    call    printf
    add rsp,32
fin:
ret

validar:
    mov byte[RESULT],'N'
    
    cmp byte[mes],1
    jl  fin
    cmp byte[mes],12
    jg  fin
diaValido:
    mov byte[RESULT],'S'
final:
ret