default rel
global main

extern GetStdHandle
extern WriteConsoleA
extern ExitProcess

STD_OUTPUT_HANDLE equ -11

section .data
msgAnd db "Resultado AND: ",0
msgOr  db "Resultado OR: ",0
msgXor db "Resultado XOR: ",0
salto  db 13,10

section .bss
buffer resb 20
bytesEscritos resq 1

section .text
main:
    sub rsp,28h

    mov rcx,STD_OUTPUT_HANDLE
    call GetStdHandle
    mov r12,rax                ; guardar handle

; AND
    mov rcx,r12
    lea rdx,[msgAnd]
    mov r8,15
    call imprimirTexto

    mov rax,12
    mov rbx,10
    and rax,rbx

    mov rcx,r12
    call imprimirNumero

    mov rcx,r12
    lea rdx,[salto]
    mov r8,2
    call imprimirTexto

; OR
    mov rcx,r12
    lea rdx,[msgOr]
    mov r8,14
    call imprimirTexto

    mov rax,12
    mov rbx,10
    or rax,rbx

    mov rcx,r12
    call imprimirNumero

    mov rcx,r12
    lea rdx,[salto]
    mov r8,2
    call imprimirTexto

; XOR
    mov rcx,r12
    lea rdx,[msgXor]
    mov r8,15
    call imprimirTexto

    mov rax,12
    mov rbx,10
    xor rax,rbx

    mov rcx,r12
    call imprimirNumero

    mov rcx,r12
    lea rdx,[salto]
    mov r8,2
    call imprimirTexto

    add rsp, 28h
    xor ecx,ecx
    call ExitProcess

; imprimirTexto
; RCX = handle
; RDX = dirección texto
; R8  = longitud
imprimirTexto:
    sub rsp,20h
    lea r9,[bytesEscritos]
    call WriteConsoleA
    add rsp,20h
    ret

; imprimirNumero
; RAX = número a imprimir
; RCX = handle
imprimirNumero:
    sub rsp,20h
    mov rbx,10
    xor rdi,rdi
    lea rsi,[buffer+19]

convertir:
    xor rdx,rdx
    div rbx
    add dl,'0'
    mov [rsi],dl
    dec rsi
    inc rdi
    cmp rax,0
    jne convertir

    inc rsi
    mov rdx,rsi
    mov r8,rdi
    call imprimirTexto

    add rsp,20h
    ret