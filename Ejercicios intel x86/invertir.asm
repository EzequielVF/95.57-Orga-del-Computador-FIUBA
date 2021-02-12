;******************************************************
; invertir.asm
; Ejercicio que calcula la longitud de un string y lo imprime invertido
;
;******************************************************
global main
extern gets
extern puts
extern	printf

section .data
    msjIngTexto db  "Ingrese un texto por teclado (max 99 caracteres)",0
    msjUdIngreso db "Usted ingreso: %s ",10,0
    msjLong db "La longitud es: %lli", 10,0
    msjInv db "El msj invertido se ve asi: %s",10,0

section .bss
    texto resb 100
    textoInv resb 100

section .text

main:
    mov	rcx,msjIngTexto
    call puts

    mov rcx,texto
    call gets

    mov rcx,msjUdIngreso
    mov rdx,texto
    call printf

    mov rsi,0

verFin:
    cmp byte[texto+rsi],0
    je finString
    inc rsi
    jmp verFin

finString:
    mov rcx,msjLong
    mov rdx,rsi
    call printf

    mov rdi, 0

verFinCopia:
    cmp rsi,0
    je finCopia

    mov al,[texto+rsi-1]
    mov [textoInv+rdi],al
    inc rdi
    dec rsi
    jmp verFinCopia

finCopia:
    mov byte[textoInv+rdi+1],0

    mov rcx,msjInv
    mov rdx,textoInv
    call printf
    ret