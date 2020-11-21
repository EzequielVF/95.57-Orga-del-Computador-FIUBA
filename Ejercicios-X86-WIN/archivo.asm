;Marca: 10 caracteres
;Modelo: 15 caracteres
;Año de fabricacion: 4 caracteres
;Patente: 7 caracteres
;Precio: 7 caracteres
global	main
extern	printf
extern	puts
extern  gets
extern  fgets
extern  sscanf
extern  fopen
extern  fclose
extern  fwrite
section		.data	
    msjInicio       db  "Iniciando...",0
    msjAperturaOk   db  "Apertura Ok.",0
    msjLeyendo      db  "Elemento leido.",0
    msjMarcaErr     db  "Marca Invalida.",0
    msjanioErr      dq  "Anio Invalido.",0
    fileListado     db  "listado.txt",0
    modeListado     db  "r",0
    msjErrOpenLis   db  "Error al abrir el archivo listado.",0
    handleListado   dq  0
    fileSeleccion   db  "seleccion.dat",0
    modeSeleccion   db  "ab+",0
    msjErrOpenSel   db  "Error al abrir el archivo seleccion.",0
    handleSeleccion dq  0

    regListado times 0  db ''
     marca     times 10 db ' '
     modelo    times 15 db ' '
     anio      times 4  db ' '
     patente   times 7  db ' '
     precio    times 7  db ' '
     EOL       times 2  db ' '

    vecMarcas       db  'Peugeot   Fiat      Ford      Chevrolet '
    anioStr         db  '****',0
    anioFormat      db  '%hi',0
    anioNum         dw  0
    
    regSeleccion    times 0 db ''
     patenteS       times 7 db ' '

section		.bss
    datoValido      resb 1
    resgistroValido resb 1
section		.text
main:
mov rcx,msjInicio
sub     rsp, 32        
call puts					
add     rsp, 32

    mov rcx,fileListado
    mov rdx,modeListado
    sub     rsp, 32 
    call fopen
    add     rsp, 32

    cmp rax,0
    jle errorOpenLis
    mov [handleListado],rax

mov rcx,msjAperturaOk
sub     rsp, 32        
call puts					
add     rsp, 32

    mov rcx,fileSeleccion
    mov rdx,modeSeleccion
    sub     rsp, 32 
    call fopen
    add     rsp, 32

    cmp rax,0
    jle errorOpenSel
    mov [handleSeleccion],rax

mov rcx,msjAperturaOk
sub     rsp, 32        
call puts					
add     rsp, 32
leer:
    ;Leo el archivo listado
    mov rcx,regListado
    mov rdx,45
    mov r8,[handleListado]
    sub     rsp, 32        
    call fgets					
    add     rsp, 32

    cmp rax,0
    jle closeFiles

mov rcx,msjLeyendo
sub     rsp, 32        
call puts					
add     rsp, 32

    ;Valido lo que lei
    call validarRegistro

    cmp byte[resgistroValido],'N'
    je leer
    ;Convierto año a numerico
    mov rcx,4
    mov rsi,anio
    mov rdi,anioStr
    rep movsb

    mov rcx,anioStr
    mov rdx,anioFormat
    mov r8,anioNum
    sub     rsp, 32        
    call sscanf					
    add     rsp, 32

    ;Copio Patente al campo del registro del Archivo
    mov rcx,7
    mov rsi,patente
    mov rdi,patenteS
    rep movsb

    ;Guardo registro en archivo Seleccion
    mov rcx,regSeleccion    ;Direccion area de memoria con los datos a copiar
    mov rdx,7               ;Longitud registro
    mov r8,1                ;Cantidad de registros
    mov r9,[handleSeleccion];Handle del archivo
    sub     rsp, 32        
    call fwrite			    ;Devuelve en rax la cant de bytes leidos
    add     rsp, 32

    jmp leer 

errorOpenLis:
    mov rcx,msjErrOpenLis
    sub     rsp, 32 
    call puts
    add     rsp, 32
    jmp endProg

errorOpenSel:
    mov rcx,msjErrOpenSel
    sub     rsp, 32 
    call puts
    add     rsp, 32
    ;Cierro el archivo abierto
    mov rcx,[handleListado]
    sub     rsp, 32 
    call fclose
    add     rsp, 32 
    jmp endProg    

closeFiles:
    mov rcx,[handleListado]
    sub     rsp, 32 
    call fclose
    add     rsp, 32 
    mov rcx,[handleSeleccion]
    sub     rsp, 32 
    call fclose
    add     rsp, 32 
endProg:
ret
;-----------------------------------------------------------------------------------------
;Rutinas Internas
;-----------------------------------------------------------------------------------------
validarRegistro:
     mov byte[resgistroValido],'N'

    call validarMarca
    cmp byte[datoValido],'N'
    je  finValidarRegistro

    call validarAnio
    cmp byte[datoValido],'N'
    je  finValidarRegistro

    mov byte[resgistroValido],'S'

finValidarRegistro:
ret

validarMarca:
    mov byte[datoValido],'S'
    
    mov rbx,0
    mov rcx,4 ;indica la cantidad de vueltas del loop
nextMarca:
    push rcx
    mov rcx,10
    lea rsi,[marca];mov rsi,marca
    lea rdi,[vecMarcas+rbx]
    rep cmpsb
    
    pop rcx
    je marcaOK
    add rbx,10
    loop nextMarca

    mov byte[datoValido],'N'
    
mov rcx,msjMarcaErr
sub     rsp, 32 
call puts
add     rsp, 32
marcaOK:
ret

validarAnio:
    mov byte[datoValido], 'S'

    mov rcx,4
    mov rbx,0
nextDigito:
    cmp byte[anio+rbx],'0'
    jl anioError
    cmp byte[anio+rbx],'9'
    jg anioError

    inc rbx
    loop nextDigito
    jmp anioOk
anioError:
    mov byte[datoValido],'N'
mov rcx,msjanioErr
sub     rsp, 32 
call puts
add     rsp, 32
anioOk:
ret