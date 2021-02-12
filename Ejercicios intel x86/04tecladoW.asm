;******************************************************
; teclado.asm
; Ejercicio para ingresar datos de por teclado con gets
; y transformarlos de formato con sscanf
; Objetivos
;	- usar sscanf para convertir de string a numerico
;
;******************************************************
global 	main
extern 	printf
extern  gets
extern	sscanf

section  		.data
	msjIngNum		db	'Ingrese un numero: ',0
	msjImpNum		db	'Usted ingreso %i !!',10,0
	numFormat		db	'%i',0	;%i 32 bits / %li 64 bits

section  		.bss
	buffer		resb	10
	numero		resq	1

section 		.text
main:
	sub  rsp,28h	
	
ingresoNumero:
; Ingrese numero
	mov		rcx,msjIngNum
	call	printf

	mov		rcx,buffer
	call	gets

	mov		rcx,buffer		;Parametro 1: campo donde están los datos a leer
	mov		rdx,numFormat	;Parametro 2: dir del string q contiene los formatos
	mov		r8,numero		;Parametro 3: dir del campo que recibirá el dato formateado
	call	sscanf

	cmp		rax,1			;rax tiene la cantidad de campos que pudo formatear correctamente
	jl		ingresoNumero

; Ud ingreso <numero>
	mov		rcx,msjImpNum
	mov		rdx,[numero]
	call	printf
fin:
	add  rsp,28h
	ret
