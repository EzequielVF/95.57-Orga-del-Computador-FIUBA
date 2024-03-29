global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
extern fopen
extern fread
extern fclose
extern fgets
;-----------------------------------------------------------------------------------------
section		.data
    msjInvEl            db  "Elemento invalido",10,0
    fileName            db  "tp12.txt",0
    mode                db  "r",0;modo lectura de archivo binario
    msgErrorOpen        db  "Error al abrir el archivo.",0
    msgErrorOpcion      db  "Numero de opcion invalida, pruebe nuevamente.",10,0
    msgErrorElemento    db  "Elemento Invalido, pruebe nuevamente.",10,0
    msgErrorConjunto    db  "Numero de conjunto invalido, pruebe nuevamente",10,0
    msjPrueba           db  "El elemento es: %s",10,0
    msjPertenece        db  "El elemento: %s pertenece al conjunto: %hi.",10,0
    msjNoPertenece      db  "El elemento: %s no pertenece al conjunto: %hi.",10,0
    msjSeparador        db  "------------------------------------",10,0
    formatoNumero       db  "%hi",0
    formatoString       db  "%s",0
    elemento            db  "%c",0
    saltoDeLinea        db  "",10,0
    msjInfoPertenencia  db  "El Conjunto 1 sera el conjunto en el que se verificara si el elemento se encuentra.",10,0
    msjInfoInclusion    db  "El Conjunto 1 sera el base y el Conjunto 2 es el que se verificara si esta incluido en el conjunto base.",10,0
    msjCantidadInv      db  "La cantidad de conjuntos es nula y/o invalida.",10,0
    msjCantValida       db  "La cantidad de conjuntos es valida.",10,0
    msjInformativo1     db  "La Cantidad de conjuntos leida es: %hi",10,0
    msjConjuntoEstaInc  db  "El conjunto: %hi esta incluido en el conjunto: %hi.",10,0
    msjConjuntoNoEstaInc   db  "El conjunto: %hi no esta incluido en el conjunto: %hi.",10,0
    msjConjuntoDiferentes  db  "El conjunto: %hi y el conjunto: %hi no son iguales.",10,0
    msjConjuntoIguales  db  "El conjunto: %hi y el conjunto: %hi son iguales.",10,0
    msjMostrarUnion     db  "El conjunto que proviene de la union de los conjuntos %hi y %hi es: { %s }",10,0
    msjOpciones         db  "Opciones:",10,0
    msjPertenecia       db  "1- Pertenencia de un elemento a un conjunto.",10,0
    msjIgualdad         db  "2- Igualdad de dos conjuntos.",10,0
    msjInclusion        db  "3- Inclusion de un conjunto en otro.",10,0
    msjUnion            db  "4- Union entre conjuntos.",10,0
    msjFin              db  "5- Terminar Programa.",10,0
    msjPedirOpcion      db  "La opcion elejida es: ",0
    msjInserElemento    db  "Inserte elemento (Si es un solo caracter alfanumerico acompanielo con un espacio. Ej: 'A '): ",0
    msjInserNumDeConj   db  "Inserte el numero del conjunto 1: ",0
    msjInserNumDeConj2  db  "Inserte el numero del conjunto 2: ",0
    msjConjA            db  "Conjunto 1: { %s }",10,0
    msjConjB            db  "Conjunto 2: { %s }",10,0
    msjConjC            db  "Conjunto 3: { %s }",10,0
    msjConjD            db  "Conjunto 4: { %s }",10,0
    msjConjE            db  "Conjunto 5: { %s }",10,0
    msjConjF            db  "Conjunto 6: { %s }",10,0
    espacioVacio        db  "  ",0
    auxElemento         db  "  ",0 
    minElemento         db  "0",0
    maxElemento         db  "Z",0
    exepcionElemento    db  " ",0
    vectorAux           db  '                                        ',0
    vectorParaUniones   db  '                                                                                ',0

    registro            times 0  db ''
     conjunto           times 40 db ' '
     EOL                times 2  db ' '

    Conjuntos           times 0  db ''
    ConjuntoA           db  '                                        ',0
    ConjuntoB           db  '                                        ',0
    ConjuntoC           db  '                                        ',0
    ConjuntoD           db  '                                        ',0
    ConjuntoE           db  '                                        ',0
    ConjuntoF           db  '                                        ',0
;-----------------------------------------------------------------------------------------
section		.bss
    fileHandle          resq    1 
    buffer              resb    100
    cantidadConjuntos   resw    1
    opcionSel           resw    1
    numDeConjunto       resw    1
    numDeConjuntoAux    resw    1
    estaIncluido        resb    1
;-----------------------------------------------------------------------------------------
section		.text
main:
    call    abrirArch

    cmp     qword[fileHandle],0 ;Error en apertura?
    jle     errorOpen

    call    leerArch
    cmp     word[cantidadConjuntos],1
    jl      cantidadInvalida
    cmp     word[cantidadConjuntos],6
    jg      cantidadInvalida

ciclo:
    call    imprimirConjuntos
    call    mostrarOpciones
    call    obtenerOpcionValida

    cmp     word[opcionSel],1
    je      opcionPertenencia

    cmp     word[opcionSel],2
    je      opcionIgualdad

    cmp     word[opcionSel],3
    je      opcionInclusion
    
    cmp     word[opcionSel],4
    je      opcionUnion

    cmp     word[opcionSel],5
    je      endProg

endProg:
ret
;-----------------------------------------------------------------------------------------
errorOpen:
    mov     rcx,msgErrorOpen
    sub     rsp,32
    call    printf
    add     rsp,32

    jmp     endProg
;-----------------------------------------------------------------------------------------
cantidadInvalida:
    mov     rcx,msjCantidadInv
    sub     rsp,32
    call    printf
    add     rsp,32

    jmp     endProg
;-----------------------------------------------------------------------------------------
opcionPertenencia:
    mov     rcx,msjInfoPertenencia
    sub     rsp,32
    call    printf
    add     rsp,32

    call    pertenencia
    jmp     ciclo
;-----------------------------------------------------------------------------------------
opcionInclusion:
    mov     rcx,msjInfoInclusion
    sub     rsp,32
    call    printf
    add     rsp,32
    
    call    elejirConjuntos
    call    inclusion

    cmp     byte[estaIncluido],'S'
    je      decirQueEstaIncluido

    call    invocarLineasSeparadoras
    mov     rcx,msjConjuntoNoEstaInc
    mov     rdx,[numDeConjuntoAux]
    mov     r8,[numDeConjunto]
    sub     rsp,32
    call    printf
    add     rsp,32
    jmp     ciclo

decirQueEstaIncluido:
    call    invocarLineasSeparadoras
    mov     rcx,msjConjuntoEstaInc
    mov     rdx,[numDeConjuntoAux]
    mov     r8,[numDeConjunto]
    sub     rsp,32
    call    printf
    add     rsp,32
    jmp     ciclo
;-----------------------------------------------------------------------------------------
opcionIgualdad:
    call    elejirConjuntos
    call    inclusion
    cmp     byte[estaIncluido],'N'
    je      decirQueNoSonIguales

    mov     ax,[numDeConjunto]
    mov     bx,[numDeConjuntoAux]
    mov     word[numDeConjuntoAux],ax
    mov     word[numDeConjunto],bx

    call    inclusion
    cmp     byte[estaIncluido],'N'
    je      decirQueNoSonIguales

    call    invocarLineasSeparadoras
    mov     rcx,msjConjuntoIguales
    mov     rdx,[numDeConjuntoAux]
    mov     r8,[numDeConjunto]
    sub     rsp,32
    call    printf
    add     rsp,32
    jmp     ciclo

decirQueNoSonIguales:
    call    invocarLineasSeparadoras
    mov     rcx,msjConjuntoDiferentes
    mov     rdx,[numDeConjuntoAux]
    mov     r8,[numDeConjunto]
    sub     rsp,32
    call    printf
    add     rsp,32
    jmp     ciclo
;-----------------------------------------------------------------------------------------
opcionUnion:
    call    elejirConjuntos
    call    ordenarConjuntos
    call    hacerLaUnion

    jmp     ciclo
;-----------------------------------------------------------------------------------------
;Rutinas Internas
;-----------------------------------------------------------------------------------------
abrirArch:
    mov     rcx,fileName
    mov     rdx,mode
    sub     rsp,32
    call    fopen
    add     rsp,32
    mov     qword[fileHandle],rax

ret
;-----------------------------------------------------------------------------------------
leerArch:
    mov     rcx,buffer
    mov     rdx,80
    mov     r8,[fileHandle]
    sub     rsp, 32        
    call    fgets					
    add     rsp, 32

    cmp     rax,0
    jle     closeFile

    mov     rcx,buffer
    mov     rdx,formatoNumero
    mov     r8,cantidadConjuntos
    sub     rsp, 32        
    call    sscanf					
    add     rsp, 32

    cmp     rax,1
    jl      closeFile

    cmp     word[cantidadConjuntos],1
    jl      closeFile
    cmp     word[cantidadConjuntos],6
    jg      closeFile

    mov     r12,0
leerConjuntos:
    mov     rcx,registro
    mov     rdx,42
    mov     r8,[fileHandle]
    sub     rsp, 32        
    call    fgets					
    add     rsp, 32

    cmp     rax,0
    jle     closeFile

    mov     rcx,40
    lea     rsi,[conjunto]
    lea     rdi,[Conjuntos+r12]
    rep     movsb

    add     r12,41
    jmp     leerConjuntos
    
closeFile:
    mov     rcx,[fileHandle]
    sub     rsp, 32 
    call    fclose
    add     rsp, 32 
ret
;-----------------------------------------------------------------------------------------
imprimirConjuntos:
    call    invocarLineasSeparadoras
    
    mov		rcx,msjInformativo1
    mov     rdx,[cantidadConjuntos]
	sub     rsp, 32        
	call	printf					
	add     rsp, 32 

    mov     rcx,msjConjA
    mov     rdx,ConjuntoA
    sub     rsp,32
    call    printf
    add     rsp,32

    cmp     word[cantidadConjuntos],2
    jl      fin

    mov     rcx,msjConjB
    mov     rdx,ConjuntoB
    sub     rsp,32
    call    printf
    add     rsp,32

    cmp     word[cantidadConjuntos],3
    jl      fin

    mov     rcx,msjConjC
    mov     rdx,ConjuntoC
    sub     rsp,32
    call    printf
    add     rsp,32

    cmp     word[cantidadConjuntos],4
    jl      fin

    mov     rcx,msjConjD
    mov     rdx,ConjuntoD
    sub     rsp,32
    call    printf
    add     rsp,32

    cmp     word[cantidadConjuntos],5
    jl      fin

    mov     rcx,msjConjE
    mov     rdx,ConjuntoE
    sub     rsp,32
    call    printf
    add     rsp,32

    cmp     word[cantidadConjuntos],6
    jl      fin

    mov     rcx,msjConjF
    mov     rdx,ConjuntoF
    sub     rsp,32
    call    printf
    add     rsp,32
fin:
ret
;-----------------------------------------------------------------------------------------
mostrarOpciones:
    call    invocarLineasSeparadoras

    mov     rcx,msjOpciones
    sub     rsp,32
    call    printf
    add     rsp,32

    mov     rcx,msjPertenecia
    sub     rsp,32
    call    printf
    add     rsp,32

    mov     rcx,msjIgualdad
    sub     rsp,32
    call    printf
    add     rsp,32

    mov     rcx,msjInclusion
    sub     rsp,32
    call    printf
    add     rsp,32

    mov     rcx,msjUnion
    sub     rsp,32
    call    printf
    add     rsp,32

    mov     rcx,msjFin
    sub     rsp,32
    call    printf
    add     rsp,32

ret
;-----------------------------------------------------------------------------------------
obtenerOpcionValida:
pedirOpcion:
    call    invocarLineasSeparadoras

    mov     rcx,msjPedirOpcion
    sub     rsp,32
    call    printf
    add     rsp,32

    mov		rcx,buffer
	sub     rsp,32
    call    gets
    add     rsp,32

    mov		rcx,buffer		
	mov		rdx,formatoNumero
	mov		r8,opcionSel		
	sub     rsp,32
    call    sscanf
    add     rsp,32

    cmp     rax,1
    jl      pedirOpcion

    cmp     word[opcionSel],1
    jl      opcionInvalida
    cmp     word[opcionSel],5
    jg      opcionInvalida
ret

opcionInvalida:
    mov     rcx,msgErrorOpcion
    sub     rsp,32
    call    printf
    add     rsp,32

    jmp     pedirOpcion
;-----------------------------------------------------------------------------------------
pertenencia:
    call    invocarLineasSeparadoras
invalido:
    mov     rcx,msjInserElemento
    sub     rsp,32
    call    printf
    add     rsp,32

    mov		rcx,buffer
	sub     rsp,32
    call    gets
    add     rsp,32

    mov     rcx,2
    lea     rsi,[buffer]
    lea     rdi,[auxElemento]
    rep     movsb

    mov     rcx,1
    lea     rsi,[auxElemento]
    lea     rdi,[minElemento]
    rep     cmpsb
    jl      elementoInvalido

    mov     rcx,1
    lea     rsi,[auxElemento]
    lea     rdi,[maxElemento]
    rep     cmpsb
    jg      elementoInvalido

    mov     rcx,1
    lea     rsi,[auxElemento+1]
    lea     rdi,[exepcionElemento]
    rep     cmpsb
    je      elementoValidado

    mov     rcx,1
    lea     rsi,[auxElemento+1]
    lea     rdi,[minElemento]
    rep     cmpsb
    jl      elementoInvalido

    mov     rcx,1
    lea     rsi,[auxElemento+1]
    lea     rdi,[maxElemento]
    rep     cmpsb
    jg      elementoInvalido

    jmp     elementoValidado

elementoInvalido:
    mov     rcx,msgErrorElemento
    sub     rsp,32
    call    printf
    add     rsp,32
    jmp     invalido

elementoValidado:
    call    invocarLineasSeparadoras
    
    mov     rcx,msjPrueba
    mov     rdx,auxElemento
    sub     rsp,32
    call    printf
    add     rsp,32
numDeConjInvalido:
    mov     rcx,msjInserNumDeConj
    sub     rsp,32
    call    printf
    add     rsp,32

    mov		rcx,buffer
	sub     rsp,32
    call    gets
    add     rsp,32

    mov     rcx,buffer
    mov     rdx,formatoNumero
    mov     r8,numDeConjunto
    sub     rsp, 32        
    call    sscanf					
    add     rsp, 32

    cmp     rax,1
    jl      errorNumConj

    mov     ax,word[cantidadConjuntos]

    cmp     word[numDeConjunto],1
    jl      errorNumConj
    cmp     word[numDeConjunto],ax
    jg      errorNumConj

    jmp     calcDesplaz

errorNumConj:
    mov     rcx,msgErrorConjunto
    sub     rsp,32
    call    printf
    add     rsp,32
    jmp     numDeConjInvalido

calcDesplaz:
    mov     rbx,0

    mov     bx,[numDeConjunto]
    sub     bx,1
    imul    bx,bx,41

    mov     r10,rbx
    add     r10,41
verSiElementoPertenece:
    cmp     r10,rbx
    je      noPertenece

    mov     rcx,2
    lea     rsi,[Conjuntos+rbx]
    lea     rdi,[espacioVacio]
    rep     cmpsb
    je      noPertenece

    mov     rcx,2
    lea     rsi,[auxElemento]
    lea     rdi,[Conjuntos+rbx]
    rep     cmpsb
    je      pertenece

    add     rbx,2
    jmp     verSiElementoPertenece
final:
ret

pertenece:
    call    invocarLineasSeparadoras

    mov     rcx,msjPertenece
    mov     rdx,auxElemento
    mov     r8,[numDeConjunto]
    sub     rsp,32
    call    printf
    add     rsp,32

    call    invocarLineasSeparadoras
    jmp     final
noPertenece:
    call    invocarLineasSeparadoras

    mov     rcx,msjNoPertenece
    mov     rdx,auxElemento
    mov     r8,[numDeConjunto]
    sub     rsp,32
    call    printf
    add     rsp,32

    call    invocarLineasSeparadoras
    jmp     final
;-----------------------------------------------------------------------------------------
elejirConjuntos:
    numDeCon1:
    call    invocarLineasSeparadoras

    mov     rcx,msjInserNumDeConj
    sub     rsp,32
    call    printf
    add     rsp,32

    mov		rcx,buffer
	sub     rsp,32
    call    gets
    add     rsp,32

    mov     rcx,buffer
    mov     rdx,formatoNumero
    mov     r8,numDeConjunto
    sub     rsp, 32        
    call    sscanf					
    add     rsp, 32

    cmp     rax,1
    jl      errorConj1

    mov     ax,word[cantidadConjuntos]

    cmp     word[numDeConjunto],1
    jl      errorConj1
    cmp     word[numDeConjunto],ax
    jg      errorConj1

    numDeCon2:
    call    invocarLineasSeparadoras

    mov     rcx,msjInserNumDeConj2
    sub     rsp,32
    call    printf
    add     rsp,32

    mov		rcx,buffer
	sub     rsp,32
    call    gets
    add     rsp,32

    mov     rcx,buffer
    mov     rdx,formatoNumero
    mov     r8,numDeConjuntoAux
    sub     rsp, 32        
    call    sscanf					
    add     rsp, 32

    cmp     rax,1
    jl      errorConj2

    mov     ax,word[cantidadConjuntos]

    cmp     word[numDeConjuntoAux],1
    jl      errorConj2
    cmp     word[numDeConjuntoAux],ax
    jg      errorConj2
ret

errorConj1:
    mov     rcx,msgErrorConjunto
    sub     rsp,32
    call    printf
    add     rsp,32
    jmp     numDeCon1

errorConj2:
    mov     rcx,msgErrorConjunto
    sub     rsp,32
    call    printf
    add     rsp,32
    jmp     numDeCon2
;-----------------------------------------------------------------------------------------
inclusion:
    mov     byte[estaIncluido],'N'
    mov     rax,0
    mov     rbx,0

    mov     bx,[numDeConjunto]
    sub     bx,1
    imul    bx,bx,41

    mov     ax,[numDeConjuntoAux]
    sub     ax,1
    imul    ax,ax,41

    mov     r10,rbx
    add     r10,40
    mov     r11,rax
    add     r11,40
verSiElConjuntoEstaIncluido:
    cmp     rax,r11
    jge     elConjEstaIncluido

    cmp     rbx,r10
    jge     end

    mov     rcx,2
    lea     rsi,[Conjuntos+rbx]
    lea     rdi,[espacioVacio]
    rep     cmpsb
    je      end

    mov     rcx,2
    lea     rsi,[espacioVacio]
    lea     rdi,[Conjuntos+rax]
    rep     cmpsb
    je      elConjEstaIncluido

    mov     rcx,2
    lea     rsi,[Conjuntos+rbx]
    lea     rdi,[Conjuntos+rax]
    rep     cmpsb
    je      elementoEncontrado

    add     rbx,2
    jmp     verSiElConjuntoEstaIncluido

end:
ret

elementoEncontrado:
    mov     rbx,r10
    sub     rbx,40
    add     rax,2
    jmp     verSiElConjuntoEstaIncluido

elConjEstaIncluido:
    mov     byte[estaIncluido],'S'
    jmp     end
;-----------------------------------------------------------------------------------------
invocarLineasSeparadoras:
    mov     rcx,msjSeparador
    sub     rsp,32
    call    printf
    add     rsp,32
ret
;-----------------------------------------------------------------------------------------
ordenarConjuntos:
    mov     rbx,0

    mov     bx,[numDeConjunto]
    sub     bx,1
    imul    bx,bx,41

    mov     rcx,40
    lea     rsi,[Conjuntos+rbx]
    lea     rdi,[vectorAux]
    rep     movsb
    push    rbx

    call    ordenamiento

    pop     rbx
    mov     rcx,40
    lea     rsi,[vectorAux]
    lea     rdi,[Conjuntos+rbx]
    rep     movsb

    mov     rbx,0

    mov     bx,[numDeConjuntoAux]
    sub     bx,1
    imul    bx,bx,41

    mov     rcx,40
    lea     rsi,[Conjuntos+rbx]
    lea     rdi,[vectorAux]
    rep     movsb
    push    rbx

    call    ordenamiento

    pop     rbx
    mov     rcx,40
    lea     rsi,[vectorAux]
    lea     rdi,[Conjuntos+rbx]
    rep     movsb
ret
;-----------------------------------------------------------------------------------------
ordenamiento:
    mov     rbx,0
    mov     r10,0

primerfor:
    cmp     rbx,38
    jge     finOrdenamiento

segundofor:
    cmp     r10,38 ;(cada numero = 2 bits * (cant(20) - 1))
    jge     reiniciarJ

    mov     rcx,1
    lea     rsi,[espacioVacio]
    lea     rdi,[vectorAux+r10+2]
    rep     cmpsb
    je      reiniciarJ

    mov     rcx,1
    lea     rsi,[vectorAux+r10]
    lea     rdi,[vectorAux+r10+2]
    rep     cmpsb
    jg      swap ;jl de mayor a menor, jg de menor a mayor

    mov     rcx,1
    lea     rsi,[vectorAux+r10]
    lea     rdi,[vectorAux+r10+2]
    repe    cmpsb
    je      verificarSegundoCaracter

    jmp     incrementarIndice
swap:
    mov     rcx,2
    lea     rsi,[vectorAux+r10]
    lea     rdi,[auxElemento]
    rep     movsb

    mov     rcx,2
    lea     rsi,[vectorAux+r10+2]
    lea     rdi,[vectorAux+r10]
    rep     movsb

    mov     rcx,2
    lea     rsi,[auxElemento]
    lea     rdi,[vectorAux+r10+2]
    rep     movsb
incrementarIndice:
    add     r10,2
    jmp     segundofor

reiniciarJ:
    mov     r10,0
    add     rbx,2
    jmp     primerfor

finOrdenamiento:
ret

verificarSegundoCaracter:
    mov     rcx,1
    lea     rsi,[vectorAux+r10+1]
    lea     rdi,[vectorAux+r10+3]
    repe    cmpsb
    jg      swap

    jmp     incrementarIndice
;-----------------------------------------------------------------------------------------
hacerLaUnion:
    mov     rax,0
    mov     rbx,0

    mov     bx,[numDeConjunto]
    sub     bx,1
    imul    bx,bx,41

    mov     ax,[numDeConjuntoAux]
    sub     ax,1
    imul    ax,ax,41
    
    mov     r10,rbx
    add     r10,40
    mov     r11,rax
    add     r11,40
    mov     r12,0
union:
    cmp     rax,r11
    jge     llegueAlFinalSegundoVector

    cmp     rbx,r10
    jge     llegueAlfinalPrimerVector

    mov     rcx,2
    lea     rsi,[Conjuntos+rbx]
    lea     rdi,[espacioVacio]
    rep     cmpsb
    je      llegueAlfinalPrimerVector

    mov     rcx,2
    lea     rsi,[espacioVacio]
    lea     rdi,[Conjuntos+rax]
    rep     cmpsb
    je      llegueAlFinalSegundoVector

    mov     rcx,2
    lea     rsi,[Conjuntos+rbx]
    lea     rdi,[Conjuntos+rax]
    rep     cmpsb
    je      agregoAlVectoryAvanzoAmbos

    mov     rcx,2
    lea     rsi,[Conjuntos+rbx]
    lea     rdi,[Conjuntos+rax]
    rep     cmpsb
    jg      agregoAlVectoryAvanzoElSegundo

    mov     rcx,2
    lea     rsi,[Conjuntos+rbx]
    lea     rdi,[Conjuntos+rax]
    rep     cmpsb
    jl      agregoAlVectoryAvanzoElPrimero
ret
agregoAlVectoryAvanzoAmbos:
    mov     rcx,2
    lea     rsi,[Conjuntos+rbx]
    lea     rdi,[vectorParaUniones+r12]
    rep     movsb
    
    add     r12,2
    add     rbx,2
    add     rax,2
    jmp     union
agregoAlVectoryAvanzoElSegundo:
    mov     rcx,2
    lea     rsi,[Conjuntos+rax]
    lea     rdi,[vectorParaUniones+r12]
    rep     movsb

    add     r12,2
    add     rax,2
    jmp     union
agregoAlVectoryAvanzoElPrimero:
    mov     rcx,2
    lea     rsi,[Conjuntos+rbx]
    lea     rdi,[vectorParaUniones+r12]
    rep     movsb

    add     r12,2
    add     rbx,2
    jmp     union
llegueAlfinalPrimerVector:
    cmp     rax,r11
    jge     finUnion

    mov     rcx,2
    lea     rsi,[Conjuntos+rax]
    lea     rdi,[vectorParaUniones+r12]
    rep     movsb
    
    add     r12,2
    add     rax,2
    jmp     llegueAlfinalPrimerVector

llegueAlFinalSegundoVector:
    cmp     rbx,r10
    jge     finUnion

    mov     rcx,2
    lea     rsi,[Conjuntos+rbx]
    lea     rdi,[vectorParaUniones+r12]
    rep     movsb
    
    add     r12,2
    add     rbx,2
    jmp     llegueAlFinalSegundoVector

finUnion:
    call    invocarLineasSeparadoras
    mov     rcx,msjMostrarUnion
    mov     rdx,[numDeConjuntoAux]
    mov     r8,[numDeConjunto]
    mov     r9,vectorParaUniones
    sub     rsp,32
    call    printf
    add     rsp,32
ret
;-----------------------------------------------------------------------------------------