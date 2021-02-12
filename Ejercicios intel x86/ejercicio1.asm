global	main
extern	puts
section		.data
	mensaje		db			"Organizacion del Computador",0		;campo con el string a imprimir.  Debe finalizar con 0 binario

section		.text
main:
	sub     rsp, 28h             ; Reserva espacio para el Shadow Space

	mov			rcx,mensaje		;Parametro 1: direccion del mensaje a imprimir
	call		puts					;puts: imprime hasta el 0 binario y agrega fin de linea

	add     rsp, 28h             ; Libera el espacio reservado del Shadow Space
	ret