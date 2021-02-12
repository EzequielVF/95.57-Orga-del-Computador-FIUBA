global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
        DIR1                dw      0Bh
        DIR2                dw      0Bh
        formatonumero       db      '%hi'
        msgResultado        db      'El Resultado es:%hi',10,0
    
section		.bss
        RESULT  resw    1
    
section		.text
main:  
    mov word[RESULT],0
    call sumar

    mov rcx,msgResultado
    mov rdx,[RESULT]
    sub rsp,32
    call    printf
    add rsp,32
fin:
ret

sumar:
    mov rax,0
    mov rbx,0

    mov ax,[DIR1]
    mov bx,[DIR2]
    add ax,bx
    
    mov word[RESULT],ax
    
final:
ret