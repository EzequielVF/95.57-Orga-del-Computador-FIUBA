global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
    fileListado     db  "archivoejercicio17.txt",0
    modeListado     db  "r",0
    
    regListado times 0  db ''
     nombre    times 20 db ' '
     resultado times 16 db ' '
     tanAFav   times 2  db ' '
     tanAEnc   times 2  db ' '
     EOL       times 2  db ' '

section		.bss
    
section		.text
main:  
    


fin:
ret