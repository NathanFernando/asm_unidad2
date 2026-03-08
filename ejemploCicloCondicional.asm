default rel
global main

extern GetStdHandle
extern WriteConsoleA
extern ExitProcess

; Constantes
SALIDA_ESTANDAR equ -11

section .data
    contador        dq 1
    msgNumero       db "Valor del contador: "
    lenMsgNumero    equ $ - msgNumero
    saltoLinea      db 13, 10
    lenSaltoLinea   equ $ - saltoLinea
    bytesEscritos   dq 0

section .bss
    handleSalida    resq 1
    digitoASCII     resb 1

section .text
main:
    sub rsp, 28h
    ; Obtener handle de salida
    mov ecx, SALIDA_ESTANDAR
    call GetStdHandle
    mov [handleSalida], rax

inicio_ciclo:
    ; Comparar contador con 5
    mov rax, [contador]
    cmp rax, 5     ; aqui hacemos cambios para experimentar
    jg fin_ciclo    ; si contador > 5, salir

    ; Mostrar texto
    mov rcx, [handleSalida]
    lea rdx, [msgNumero]
    mov r8d, lenMsgNumero
    lea r9, [bytesEscritos]
    call WriteConsoleA

    ; Convertir contador (1 digito) a ASCII
    mov al, byte [contador]
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
    mov r8d, lenSaltoLinea
    lea r9, [bytesEscritos]
    call WriteConsoleA

    ; Incrementar contador
    inc qword [contador]

    ; Repetir ciclo
    jmp inicio_ciclo

fin_ciclo:
    ; Salir del programa
    add rsp, 28h
    xor ecx, ecx
    call ExitProcess