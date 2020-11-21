global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
	matriz      dw 3,1,1
                dw 1,3,1
                dw 1,1,3
    msgMax      db "La traza es de: %hi.",10,0          

section		.bss
    traza   resw    1

section		.text
main:  
    mov word[traza],0

    mov rax,0

    mov ax,[matriz]
    add [traza],ax

    mov ax,[matriz+8]
    add [traza],ax

    mov ax,[matriz+16]
    add [traza],ax    

    mov rcx,msgMax
    mov rdx,[traza]
    sub rsp,32
    call    printf
    add rsp,32
ret