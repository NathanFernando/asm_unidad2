default rel
global main

extern GetStdHandle
extern WriteConsoleA
extern ReadConsoleA
extern ExitProcess

IN_HANDLE  equ -10
OUT_HANDLE equ -11

section .data
msgEntrada db "Ingresa un numero: "
lenMsgEntrada equ $ - msgEntrada
msgSalida  db "Numero capturado * 2: "
lenMsgSalida equ $ - msgSalida
salto db 13,10

section .bss
buffer resb 16
numero resq 1
bytesLeidos resq 1
bytesEscritos resq 1

section .text

; Mostrar un texto
; rcx = handle
; rdx = dirección
; r8  = longitud
mostrarTexto:
    sub rsp,20h
    lea r9,[bytesEscritos]
    call WriteConsoleA
    add rsp,20h
    ret

; convertir ASCII → número
; rdx = dirección cadena
asciiToNumero:
    xor rax,rax
    xor rcx,rcx
sigte:
    mov bl,[rdx+rcx]
    cmp bl,13
    je fin
    sub bl,'0'
    mul rax,10
    add rax,rbx
    inc rcx
    jmp sigte
fin:
    ret

; convertir número a ASCII para imprimir
; rax = numero a convertir
numeroToAscii:
    mov rbx,10
    xor rdi,rdi
    lea rsi,[buffer+31]
conversion:
    xor rdx,rdx
    div rbx
    add dl,'0'
    mov [rsi],dl
    dec rsi
    inc rdi ;cuenta dígitos
    cmp rax,0
    jne conversion
    ret

; MAIN
main:
    sub rsp,28h

; obtener handle salida
; rax --> r12
    mov rcx,OUT_HANDLE
    call GetStdHandle
    mov r12,rax

; obtener handle entrada
; rax --> r13
    mov rcx,IN_HANDLE
    call GetStdHandle
    mov r13,rax

; mostrar mensaje
    mov rcx,r12
    lea rdx,[msgEntrada]
    mov r8, lenMsgEntrada
    call mostrarTexto

; capturar cadena
    mov rcx,r13
    lea rdx,[buffer]
    mov r8,16
    lea r9,[bytesLeidos]
    call ReadConsoleA

; convertir a número
; rax tendrá el valor numérico
    lea rdx,[buffer]
    call asciiToNumero
; guardar número
    mov [numero],rax

; mostrar mensaje de salida
    mov rcx,r12
    lea rdx,[msgSalida]
    mov r8,lenMsgSalida
    call mostrarTexto

    mov rax,[numero]
    shl rax, 1
    call numeroToAscii
    inc rsi ;indica dónde inicia el valor en ascii
; imprimir número
    mov rcx,r12
    mov rdx,rsi
    mov r8,rdi
    call mostrarTexto
; salto línea
    mov rcx,r12
    lea rdx,[salto]
    mov r8,2
    call mostrarTexto

    add rsp, 28h
    xor ecx,ecx
    call ExitProcess