default rel

global main

extern GetStdHandle ; son funciones de libreria externas
extern ReadConsoleA 
extern WriteConsoleA
extern ExitProcess

;Constantes
SALIDA_ESTANDAR equ -11      
ENTRADA_ESTANDAR equ -10     

section .data
    msgSaludo   db "Hola, escribe tu nombre: "
    longSaludo  equ $ - msgSaludo ;son constantes donde se calcular la longitud a la hora de ver le mensaje?
    msgHola     db 13,10,"Hola "
    longHola    equ $ - msgHola
    bytesRead   dq 0 ; cuantos bites se estan leyendo a traves del teclado
    bytesWrite  dq 0 ; es donde se va a mostrar el texto completo en la pantalla

section .bss
    nombre      resb 40 ;Aqui es donde se va a almancer el nombre
; Ademas se apartan 40 bits en la memoria
section .text
main:
    sub rsp, 28h                     ; alineación x64 

    ; Obtener handle de entrada (teclado)
    mov ecx, ENTRADA_ESTANDAR   ; regresa el resultado de el manejador en la pantalla?
    call GetStdHandle ; llamamos la funcion
    mov r12, rax

    ; Obtener handle de salida (pantalla)
    mov ecx, SALIDA_ESTANDAR     
    call GetStdHandle
    mov r13, rax

    ; Mostrar mensaje inicial
    mov rcx, r13
    lea rdx, [msgSaludo]
    mov r8d, longSaludo
    lea r9, [bytesWrite]
    call WriteConsoleA

    ; Leer nombre
    mov rcx, r12
    lea rdx, [nombre] ; direccion de memoria donde se guarda el nombre que se ingreso con el telcado
    mov r8d, 40 ;logitud maxima de bites que se ingrea con el telcado o la logitud del texto
    lea r9, [bytesRead] ; direcion de memoria del identificador, aqui se guarda la cadidad de datos que vimos en la memoria?
    call ReadConsoleA ; 

    ; Mostrar "Hola "
    mov rcx, r13
    lea rdx, [msgHola]
    mov r8d, longHola
    lea r9, [bytesWrite]
    call WriteConsoleA

    ; Mostrar nombre capturado
    mov rcx, r13
    lea rdx, [nombre]
    mov r8, [bytesRead]
    lea r9, [bytesWrite]
    call WriteConsoleA

    ; Salir
    add rsp, 28h ;liberamos el rsp
    xor ecx, ecx
    call ExitProcess