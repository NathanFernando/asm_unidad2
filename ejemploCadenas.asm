default rel

; API de Windows
extern GetStdHandle
extern ReadFile
extern WriteFile
extern ExitProcess

global main

; Constantes
SALIDA_ESTANDAR   equ -11
ENTRADA_ESTANDAR  equ -10

; Datos
section .bss
    bufferInput resb 100   ; espacio para la cadena (máx 100 bytes)
    bytesLeidos resq 1     ; variable para capturar número de bytes leídos
    bytesEscritos resq 1

section .data
    mensaje db "Escribe tu nombre: "
    lenMensaje equ $ - mensaje
    saltoLinea db 13,10    ; CR LF

; Código
section .text
main:
    sub rsp, 28h                     ; alineación x64
    ; Obtener handles de consola
    mov ecx, SALIDA_ESTANDAR
    call GetStdHandle
    mov r12, rax             ; handle de salida

    mov ecx, ENTRADA_ESTANDAR
    call GetStdHandle
    mov r13, rax             ; handle de entrada

    ; Mostrar mensaje
    mov rcx, r12             ; handle
    lea rdx, [mensaje]       ; buffer
    mov r8d, lenMensaje      ; longitud
    lea r9, [bytesEscritos]  ; bytes escritos
    call WriteFile

    ; Leer cadena del usuario
    mov rcx, r13             ; handle de entrada
    lea rdx, [bufferInput]   ; buffer destino
    mov r8d, 100             ; longitud máxima
    lea r9, [bytesLeidos]    ; bytes leídos
    call ReadFile

    ; Mostrar lo que capturó
    mov rcx, r12             ; handle de salida
    lea rdx, [bufferInput]   ; buffer capturado
    mov r8, qword [bytesLeidos] ; cantidad de bytes leídos
    lea r9, [bytesEscritos]
    call WriteFile

    ; Salto de línea final
    mov rcx, r12
    lea rdx, [saltoLinea]
    mov r8d, 2
    lea r9, [bytesEscritos]
    call WriteFile

    ; Terminar programa
    add rsp, 28h
    xor ecx, ecx
    call ExitProcess