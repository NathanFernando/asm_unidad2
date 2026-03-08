default rel

; Funciones externas (API Windows)
extern GetStdHandle
extern WriteFile
extern ExitProcess

global main

; Constantes
SALIDA_ESTANDAR equ -11

; Sección de datos
section .data
    saltoLinea   db 13,10
    bytesEscritos  dq 0

section .bss
    digitoASCII    resb 1

; Sección de código
section .text
main:
    ; Alinear pila (Windows x64)
    sub rsp, 28h
    ; Obtener handle de salida estándar
    mov ecx, SALIDA_ESTANDAR
    call GetStdHandle
    mov r12, rax       ; guardar handle consola

    ; Inicializar contador = 0
    mov rcx, 0

ciclo_numeros:
    cmp rcx, 9         ; ¿contador > 9?
    jg fin_programa

    mov r13, rcx       ;guardar el contador en r13
    ; Convertir número a ASCII (1 dígito)
    add cl, '0'
    mov [digitoASCII], cl

    ; Imprimir dígito
    mov rcx, r12                ; handle
    lea rdx, digitoASCII        ; buffer
    mov r8, 1                   ; tamaño
    lea r9, bytesEscritos
    call WriteFile

    ; Imprimir salto de línea
    mov rcx, r12
    lea rdx, saltoLinea
    mov r8, 2
    lea r9, bytesEscritos
    call WriteFile

    mov rcx, r13
    inc rcx             ; contador++
    jmp ciclo_numeros

fin_programa:
    add rsp, 28h
    xor ecx, ecx
    call ExitProcess