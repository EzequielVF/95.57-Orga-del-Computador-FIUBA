global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
	vector      dw 1,2,3,4,5,6,7,8,9,10
                dw 11,12,13,14,15,16,17,18,19,20
    cantidad    dw  20
    msgMax      db "El maximo es: %hi.",10,0 
    msgMin      db "El minimo es: %hi.",10,0 
    msgProm     db "El promedio es: %hi.",10,0

section		.bss
    promedio    resw    1
    acumulador  resw    1
    maximo      resw    1
    minimo      resw    1

section		.text
main:
    mov rsi,2
    mov rbx,0
    mov word[acumulador],0
    mov word[promedio],0

    mov bx,[vector]
    mov [maximo],bx
    mov [minimo],bx
    add [acumulador],rbx
recorrerVector:
    cmp rsi,40
    jge  fin

    mov bx,[vector+rsi]
revisarMaximo:
    cmp bx,[maximo]
    jg swapMaximo
revisarMinimo:
    cmp bx,[minimo]
    jl swapMinimo
sumarAcumulador:
    add [acumulador],bx
    add rsi,2
    jmp recorrerVector

swapMaximo:
    mov [maximo],bx
    jmp revisarMinimo

swapMinimo:
    mov [minimo],bx
    jmp sumarAcumulador

fin:

    mov rcx,msgMax
    mov rdx,[maximo]
    sub rsp,32
    call    printf
    add rsp,32

    mov rcx,msgMin
    mov rdx,[minimo]
    sub rsp,32
    call    printf
    add rsp,32
    
    mov rax,0
    mov rbx,0

    mov ax,word[acumulador]
    cwd  ;para cosas en 16 bits;
    mov bx,word[cantidad]
    idiv bx

    mov word[promedio],ax

    mov rcx,msgProm
    mov rdx,[promedio]
    sub rsp,32
    call    printf
    add rsp,32
ret