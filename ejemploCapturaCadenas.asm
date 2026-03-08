default rel
global main

extern GetStdHandle
extern ReadConsoleA
extern WriteConsoleA
extern ExitProcess

SALIDA_ESTANDAR  equ -11
ENTRADA_ESTANDAR equ -10

section .data
    msgNombre   db "Nombre: "
    lenNombre   equ $ - msgNombre
    msgCarrera  db "Carrera: "
    lenCarrera  equ $ - msgCarrera
    lineaSep    db 13,10,"----------------------",13,10
    lenLinea    equ $ - lineaSep
    lblNombre   db "Nombre  : "
    lenLblNom   equ $ - lblNombre
    lblCarrera  db 13,10,"Carrera : "
    lenLblCar   equ $ - lblCarrera
    bytesRead   dq 0
    bytesWrite  dq 0

section .bss
    nombre      resb 40
    carrera     resb 40
    handleEntrada    resq 1
    handleSalida     resq 1

section .text
main:
    sub rsp, 28h

    ; Obtener handles
    mov ecx, ENTRADA_ESTANDAR
    call GetStdHandle
    mov [handleEntrada], rax

    mov ecx, SALIDA_ESTANDAR
    call GetStdHandle
    mov [handleSalida], rax

    ; Solicitar nombre
    mov rcx, [handleSalida]
    lea rdx, [msgNombre]
    mov r8d, lenNombre
    lea r9, [bytesWrite]
    call WriteConsoleA

    mov rcx, [handleEntrada]
    lea rdx, [nombre]
    mov r8d, 40
    lea r9, [bytesRead]
    call ReadConsoleA

    mov rax, [bytesRead]
    sub rax, 2
    mov [bytesRead], rax

    ; Solicitar carrera
    mov rcx, [handleSalida]
    lea rdx, [msgCarrera]
    mov r8d, lenCarrera
    lea r9, [bytesWrite]
    call WriteConsoleA

    mov rcx, [handleEntrada]
    lea rdx, [carrera]
    mov r8d, 40
    lea r9, [bytesRead]
    call ReadConsoleA

    mov rax, [bytesRead]
    sub rax, 2
    mov [bytesRead], rax

    ; Mostrar ficha formateada
    mov rcx, [handleSalida]
    lea rdx, [lineaSep]
    mov r8d, lenLinea
    lea r9, [bytesWrite]
    call WriteConsoleA

    mov rcx, [handleSalida]
    lea rdx, [lblNombre]
    mov r8d, lenLblNom
    lea r9, [bytesWrite]
    call WriteConsoleA

    mov rcx, [handleSalida]
    lea rdx, [nombre]
    mov r8, [bytesRead]
    lea r9, [bytesWrite]
    call WriteConsoleA

    mov rcx, [handleSalida]
    lea rdx, [lblCarrera]
    mov r8d, lenLblCar
    lea r9, [bytesWrite]
    call WriteConsoleA

    mov rcx, [handleSalida]
    lea rdx, [carrera]
    mov r8, [bytesRead]
    lea r9, [bytesWrite]
    call WriteConsoleA

    mov rcx, [handleSalida]
    lea rdx, [lineaSep]
    mov r8d, lenLinea
    lea r9, [bytesWrite]
    call WriteConsoleA

    add rsp, 28h
    xor ecx, ecx
    call ExitProcess