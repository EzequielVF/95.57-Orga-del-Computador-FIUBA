global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
        fecha       db      "22/04/2010"
        msgValido   db      "La fecha ingresada es valida.",10,0
        msgInvalido db      "La fecha ingresada no es valida.",10,0
        
        formatoDiayMes  db  '%hi'
        formatoAnio     db  '%hi'
        pruebaNum          db  '%hi',10,0
section		.bss
        RESULT  resb    1
        dia     resb    10
        mes     resb    10
        anio    resb    10
        diaNum  resw    1
        mesNum  resw    1
        anioNum resw    1
section		.text
main: 
    call validar
    cmp byte[RESULT],'S'
    je mensajeValido

    mov rcx,msgInvalido
    sub rsp,32
    call    printf
    add rsp,32
    jmp final

mensajeValido:
    mov rcx,msgValido
    sub rsp,32
    call    printf
    add rsp,32
final:
ret
validar:
    mov byte[RESULT],'N'
extraccion:
    mov rcx,2
    lea rsi,[fecha]
    lea rdi,[dia]
    rep movsb

    mov rcx,2
    lea rsi,[fecha+3]
    lea rdi,[mes]
    rep movsb

    mov rcx,4
    lea rsi,[fecha+6]
    lea rdi,[anio]
    rep movsb
conversion:
    mov rcx,dia
    mov rdx,formatoDiayMes
    mov r8,diaNum
    sub rsp,32
    call sscanf
    add rsp,32

    cmp rax,1
    jl fin

    mov rcx,mes
    mov rdx,formatoDiayMes
    mov r8,mesNum
    sub rsp,32
    call sscanf
    add rsp,32

    cmp rax,1
    jl fin

    mov rcx,anio
    mov rdx,formatoAnio
    mov r8,anioNum
    sub rsp,32
    call sscanf
    add rsp,32

    cmp rax,1
    jl fin

validacion:
    cmp word[diaNum],1
    jl fin
    cmp word[diaNum],31
    jg fin

    cmp word[mesNum],1
    jl fin
    cmp word[mesNum],12
    jg fin

    cmp word[anioNum],1
    jl fin
    cmp word[anioNum],2020
    jg fin
valido:
    mov byte[RESULT],'S'
fin:
ret
