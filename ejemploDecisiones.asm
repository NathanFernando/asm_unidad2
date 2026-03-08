; Ejemplo: Comparación con CMP y saltos

default rel
global main

extern ExitProcess
extern GetStdHandle
extern WriteFile

STD_OUTPUT_HANDLE equ -11

section .data
    numero      dq 4
    msgMayor    db "El numero es mayor a 5", 13, 10
    lenMayor    equ $ - msgMayor
    msgMenor    db "El numero es menor a 5", 13, 10
    lenMenor    equ $ - msgMenor
    msgIgual    db "El numero es igual a 5", 13, 10
    lenIgual    equ $ - msgIgual

section .bss
    bytesEscritos resq 1
    handleSalida  resq 1

section .text
main:
    sub rsp, 28h            ; alineación x64
    ; Obtener handle de salida
    mov rcx, STD_OUTPUT_HANDLE
    call GetStdHandle
    mov [handleSalida], rax

    ; Cargar numero y comparar
    mov rax, [numero]
    cmp rax, 5

    jg mayor
    jl menor
    je igual

mayor:
    mov rcx, [handleSalida]
    lea rdx, [msgMayor]
    mov r8, lenMayor
    lea r9, [bytesEscritos]
    call WriteFile
    jmp salir

menor:
    mov rcx, [handleSalida]
    lea rdx, [msgMenor]
    mov r8, lenMenor
    lea r9, [bytesEscritos]
    call WriteFile
    jmp salir

igual:
    mov rcx, [handleSalida]
    lea rdx, [msgIgual]
    mov r8, lenIgual
    lea r9, [bytesEscritos]
    call WriteFile

salir:
    add rsp, 28h
    xor ecx, ecx
    call ExitProcess