global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
	mensaje		    db		"Ingrese X:",0
    mensaje2		db		"Ingrese Y:",0
    formatInputXeY  db      "%lli",0
    msjPositivo     db      "El resultado es: %lli.",10,0
    msjNegativo     db      "El resultado es 1 / %lli.",10,0
    msjDeALaCero    db      "El Resultado es 1.",10,0
section		.bss
    inputX      resb 50
    inputY      resb 50
    numero      resq 1
    veces       resq 1
    inputValido     resb 1  ;'P' Positivo 'N' Negativo
    resultado   resq 1 

section		.text
main:
invalidoX:
	sub     rsp, 32        
	mov		rcx,mensaje		
	call	printf					
	add     rsp, 32            

    mov     rcx,inputX
    sub     rsp,32
    call    gets
    add     rsp,32

    mov rcx,inputX
    mov rdx,formatInputXeY
    mov r8,numero
    sub rsp,32
    call sscanf
    add rsp,32

    cmp rax,1
    jl invalidoX

invalidoY:
    sub     rsp, 32        
	mov		rcx,mensaje2		
	call	printf					
	add     rsp, 32            

    mov     rcx,inputY
    sub     rsp,32
    call    gets
    add     rsp,32

    mov rcx,inputY
    mov rdx,formatInputXeY
    mov r8,veces
    sub rsp,32
    call sscanf
    add rsp,32

    cmp rax,1
    jl invalidoY

    mov byte[inputValido],'P'

    cmp qword[veces],0
    jl  esNegativo

    cmp qword[veces],0
    jg  preparacion

    jmp aLaCero

esNegativo:
    mov byte[inputValido],'N'

    neg qword[veces]

preparacion:
    mov rcx,qword[numero]

    cmp qword[veces],1
    jle  escribirResultado

    dec qword[veces]

potenciacion:
    cmp qword[veces],0
    jle escribirResultado

    imul rcx,qword[numero]
    
    dec qword[veces]
    jmp potenciacion

escribirResultado:
    mov qword[resultado],rcx
    cmp byte[inputValido],'N'
    je potencianegativa

    mov     rcx,msjPositivo
    mov     rdx,[resultado]
    sub     rsp,32
    call    printf
    add     rsp,32
    jmp     fin 

potencianegativa:
    mov     rcx,msjNegativo
    mov     rdx,[resultado]
    sub     rsp,32
    call    printf
    add     rsp,32
    jmp     fin

aLaCero:
    mov     rcx,msjDeALaCero
    sub     rsp,32
    call    printf
    add     rsp,32
fin:
ret

