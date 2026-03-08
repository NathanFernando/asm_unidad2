default rel
global main

extern GetStdHandle
extern WriteConsoleA
extern ExitProcess

; Constantes
SALIDA_ESTANDAR equ -11

section .data
    msgResultado db "Resultado de la suma: "
    lenResultado equ $ - msgResultado
    digito       db "0", 13, 10
    bytesEscritos dq 0

section .text
main:
    sub rsp, 28h

    ; Obtener handle de salida
    mov ecx, SALIDA_ESTANDAR
    call GetStdHandle
    mov rbx, rax                ; guardar handle

    ; USO DE LA PILA
    mov rax, 6
    push rax                    ; push primer número
    mov rax, 4
    push rax                    ; push segundo número
    
    pop rcx                     ; rcx = 6
    pop rdx                     ; rdx = 4
    add rcx, rdx                ; rcx = 10

    ; Convertir a ASCII (solo 1 dígito para el ejemplo)
    add cl, '0'
    mov [digito], cl

    ; Mostrar mensaje
    mov rcx, rbx
    lea rdx, [msgResultado]
    mov r8d, lenResultado
    lea r9, [bytesEscritos]
    call WriteConsoleA

    ; Mostrar resultado
    mov rcx, rbx
    lea rdx, [digito]
    mov r8d, 2
    lea r9, [bytesEscritos]
    call WriteConsoleA

    ; Salir
    add rsp, 28h
    xor ecx, ecx
    call ExitProcess