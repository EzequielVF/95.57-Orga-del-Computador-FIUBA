;******************************************************
; sumatriz.asm
; Dada una matriz cuyos elementos son numeros enteros de 2 bytes (word)
; se pide solicitar por teclado un nro de fila y columna y realizar
; la sumatoria de los elementos de la fila elegida a partir de la
; columna elegida y mostrar el resultado por pantalla.
; Se debera validad mediante una rutina interna que los datos ingresados por
; teclado sean validos.
;******************************************************
global main
extern printf
extern puts
extern gets
extern sscanf

section		.data
    msjIngFilCol db "Ingrese fila (1 a 5) y columna (1 a 5): ",10,0
    formatInputFilCol db "%hi %hi",0
    msjSumatoria db "La sumatoria es: %i",10,0
    msgError db "Llegue hasta aca.",10,0
    matriz      dw 1,1,1,1,1
                dw 2,2,2,2,2
                dw 3,3,3,3,3
                dw 4,4,4,4,4
                dw 5,5,5,5,5


section		.bss
    inputFilCol     resb 50
    inputValido     resb 1  ;'S' valido 'N' invalido
    fila            resw 1
    columna         resw 1
    desplaz         resw 1
    sumatoria       resd 1

section		.text
main:
ingresoDatos:
    mov rcx,msjIngFilCol
    sub rsp,32
    call printf
    add rsp,32

    mov rcx,inputFilCol
    sub rsp,32
    call gets
    add rsp,32

    call validarFyC

    cmp byte[inputValido],'N'
    je ingresoDatos

    call calcDesplaz

    call calcSumatoria

    mov rcx,msjSumatoria 
    mov rdx,0
    mov edx,dword[sumatoria]
    sub rsp,32
    call printf
    add rsp,32

ret

validarFyC:
    mov byte[inputValido],'N'
    
    mov rcx,inputFilCol
    mov rdx,formatInputFilCol
    mov r8,fila
    mov r9,columna
    sub rsp,32
    call sscanf
    add rsp,32

    cmp rax,2
    jl invalido

    cmp word[fila],1
    jl  invalido
    cmp word[fila],5
    jg  invalido

    cmp word[columna],1
    jl  invalido
    cmp word[columna],5
    jg  invalido

    mov byte[inputValido],'S'
invalido:

ret

calcDesplaz:
    
    mov bx,[fila]
    sub bx,1; dec bx
    imul bx,bx,10 ;long elemento*cant columnas

    mov [desplaz],bx

    mov bx,[columna]
    sub bx,1
    imul bx,bx,2

    add [desplaz],bx

ret

calcSumatoria:
    mov dword[sumatoria],0

    sub rcx,rcx; mov rcx,0
    mov cx,6
    sub cx,[columna]

    sub rbx,rbx; mov rbx,0
    mov bx,[desplaz]

sumarSgte:
    sub rax,rax; mov rax,0
    mov ax,[matriz + ebx]

    add [sumatoria],eax

    add bx,2

    loop sumarSgte

ret