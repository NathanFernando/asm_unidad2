default rel
global main

extern GetStdHandle
extern WriteConsoleA
extern ExitProcess

OUTPUT_HANDLE equ -11

section .data
msgHex db "Hexadecimal: ",0
salto db 13,10

section .bss
buffer resb 32
bytesEscritos resq 1

section .text
; imprimirTexto
; RCX = handle
; RDX = dirección
; R8  = longitud
imprimirTexto:
    sub rsp,20h
    lea r9,[bytesEscritos]
    call WriteConsoleA
    add rsp,20h
    ret

; convertirHexa
; RAX = número a convertir
; RCX = handle consola
convertirHex:
    lea rsi,[buffer+31]
    xor rdi,rdi
conversion:
    mov rbx,16
    xor rdx,rdx
    div rbx
    cmp dl,9
    jbe digito
    add dl,55        ; A-F
    jmp guardar
digito:
    add dl,'0'
guardar:
    mov [rsi],dl
    dec rsi
    inc rdi
    cmp rax,0
    jne conversion
    inc rsi

    mov rdx,rsi
    mov r8,rdi
    call imprimirTexto

    add rsp, 20h
    ret

; MAIN
main:
    sub rsp,28h

    mov rcx,OUTPUT_HANDLE
    call GetStdHandle
    mov r12,rax

; imprimir etiqueta
    mov rcx,r12
    lea rdx,[msgHex]
    mov r8,13
    call imprimirTexto
; número de ejemplo
    mov rax,305441741
    mov rcx,r12
    call convertirHex
; salto de línea
    mov rcx,r12
    lea rdx,[salto]
    mov r8,2
    call imprimirTexto

    add rsp,28h
    xor ecx,ecx
    call ExitProcess