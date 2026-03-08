default rel
global main

extern GetStdHandle
extern WriteConsoleA
extern ExitProcess

; Constantes
SALIDA_ESTANDAR equ -11

section .data
    msgInicio  db "Inicio del programa", 13, 10
    lenInicio  equ $ - msgInicio
    msgOmitido db "Este mensaje NO se muestra", 13, 10
    lenOmitido equ $ - msgOmitido
    msgFinal   db "Fin del programa", 13, 10
    lenFinal   equ $ - msgFinal
    bytesWrite dq 0

section .bss
    handleSalida resq 1

section .text
main:
    sub rsp, 28h
    ; Obtener handle de salida
    mov ecx, SALIDA_ESTANDAR
    call GetStdHandle
    mov [handleSalida], rax

    ; Mostrar mensaje de inicio
    mov rcx, [handleSalida]
    lea rdx, [msgInicio]
    mov r8d, lenInicio
    lea r9, [bytesWrite]
    call WriteConsoleA

    ; Salto incondicional
    jmp fin_programa

    ; CODIGO OMITIDO
codigo_omitido:
    mov rcx, [handleSalida]
    lea rdx, [msgOmitido]
    mov r8d, lenOmitido
    lea r9, [bytesWrite]
    call WriteConsoleA

fin_programa:
    ; Mostrar mensaje final
    mov rcx, [handleSalida]
    lea rdx, [msgFinal]
    mov r8d, lenFinal
    lea r9, [bytesWrite]
    call WriteConsoleA

    ; Salida del programa
    add rsp, 28h
    xor ecx, ecx
    call ExitProcess