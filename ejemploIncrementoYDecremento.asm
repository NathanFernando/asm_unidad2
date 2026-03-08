default rel
global main

extern GetStdHandle
extern WriteConsoleA
extern ExitProcess

; Constantes
SALIDA_ESTANDAR equ -11

section .data
    valorInicial   db 9    ; valor a decrementar
    msgTexto       db "Valor actual: "
    lenTexto       equ $ - msgTexto
    saltoLinea     db 13, 10
    lenSalto       equ $ - saltoLinea
    bytesEscritos  dq 0

section .bss
    handleSalida   resq 1
    digitoASCII    resb 1

section .text
main:
    sub rsp, 28h
    ; Obtener handle de salida
    mov ecx, SALIDA_ESTANDAR
    call GetStdHandle
    mov [handleSalida], rax

inicio:
    ; Mostrar texto
    mov rcx, [handleSalida]
    lea rdx, [msgTexto]
    mov r8d, lenTexto
    lea r9, [bytesEscritos]
    call WriteConsoleA

    ; Convertir valor a ASCII (1 digito)
    mov al, byte [valorInicial]
    add al, '0'
    mov [digitoASCII], al

    ; Mostrar numero
    mov rcx, [handleSalida]
    lea rdx, [digitoASCII]
    mov r8d, 1
    lea r9, [bytesEscritos]
    call WriteConsoleA

    ; Salto de linea
    mov rcx, [handleSalida]
    lea rdx, [saltoLinea]
    mov r8d, lenSalto
    lea r9, [bytesEscritos]
    call WriteConsoleA

    ; Decrementar valor
    dec byte [valorInicial]

    ; Comparar con cero
    cmp byte [valorInicial], 0
    jge inicio       ; repetir mientras valor >= 0

fin:
    add rsp, 28h
    xor ecx, ecx
    call ExitProcess