global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
	mensaje		db			"Ingrese Nombre y Apellido",0		;campo con el string a imprimir.  Debe finalizar con 0 binario
    mensaje2    db          "Ingrese N° de padron",0
    mensaje3    db          "Ingrese fecha de nacimiento",0
    mensajeFinal    db          "El alumno %s de Padron Numero: %s tiene: %s anios.",10,0

section		.bss
    inputNomyApe    resb 50
    padron      resq 1
    edad        resq 1

section		.text
main:
	sub     rsp, 32        
	mov		rcx,mensaje		
	call	puts					
	add     rsp, 32            

    mov     rcx,inputNomyApe
    sub     rsp,32
    call    gets
    add     rsp,32

    sub     rsp, 32        
	mov		rcx,mensaje2		
	call	puts					
	add     rsp, 32 

    mov     rcx,padron
    sub     rsp,32
    call    gets
    add     rsp,32

    sub     rsp, 32        
	mov		rcx,mensaje3		
	call	puts					
	add     rsp, 32  

    mov     rcx,edad
    sub     rsp,32
    call    gets
    add     rsp,32

    mov     rcx,mensajeFinal
    mov     rdx,inputNomyApe
    mov     r8,padron
    mov     r9,edad
    sub     rsp,32
    call    printf
    add     rsp,32    

ret