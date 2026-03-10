default rel
global main

extern GetStdHandle
extern WriteConsoleA
extern ExitProcess

STD_OUTPUT_HANDLE equ -11

section .data
msgShl db "SHL resultado: ",0
msgShr db "SHR resultado: ",0
msgRol db "ROL resultado: ",0
msgRor db "ROR resultado: ",0
salto db 13,10

section .bss
buffer resb 20
bytesEscritos resq 1

section .text
; imprimirTexto
imprimirTexto:
    sub rsp,20h
    lea r9,[bytesEscritos]
    call WriteConsoleA
    add rsp,20h
    ret

; imprimirNumero
; RAX = número
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

; MAIN
main:
    sub rsp,28h

    mov rcx,STD_OUTPUT_HANDLE
    call GetStdHandle
    mov r12,rax

; SHL
    mov rcx,r12
    lea rdx,[msgShl]
    mov r8,16
    call imprimirTexto

    mov rax,9
    shl rax,1

    mov rcx,r12
    call imprimirNumero
; salto
    mov rcx,r12
    lea rdx,[salto]
    mov r8,2
    call imprimirTexto

; SHR
    mov rcx,r12
    lea rdx,[msgShr]
    mov r8,16
    call imprimirTexto

    mov rax,9
    shr rax,1

    mov rcx,r12
    call imprimirNumero

    mov rcx,r12
    lea rdx,[salto]
    mov r8,2
    call imprimirTexto

; ROL
    mov rcx,r12
    lea rdx,[msgRol]
    mov r8,16
    call imprimirTexto

    mov rax,9
    rol rax,1

    mov rcx,r12
    call imprimirNumero

    mov rcx,r12
    lea rdx,[salto]
    mov r8,2
    call imprimirTexto

; ROR
    mov rcx,r12
    lea rdx,[msgRor]
    mov r8,16
    call imprimirTexto

    mov rax,9
    ror rax,1

    mov rcx,r12
    call imprimirNumero

    mov rcx,r12
    lea rdx,[salto]
    mov r8,2
    call imprimirTexto

    add rsp,28h
    xor ecx,ecx
    call ExitProcess