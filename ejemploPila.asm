default rel
global main

extern GetStdHandle
extern WriteConsoleA
extern ExitProcess

; Constantes
SALIDA_ESTANDAR equ -11

; Datos
section .data
    msgInicio db "Inicio del programa", 13, 10
    lenInicio equ $ - msgInicio
    msgDentro db "Dentro de la subrutina", 13, 10
    lenDentro equ $ - msgDentro
    msgFin db "Regreso al programa principal", 13, 10
    lenFin equ $ - msgFin
    bytesEscritos dq 0

; Código
section .text
main:
    sub rsp, 28h                ; alineación x64
    ; Obtener handle de salida
    mov ecx, SALIDA_ESTANDAR
    call GetStdHandle
    mov r12, rax                ; handle de Salida

    ; Mostrar mensaje inicial
    call imprimir_inicio

    ; Guardar valores en la pila
    mov rax, 111
    mov rbx, 222
    push rax
    push rbx

    ; Llamar a subrutina
    call subrutina

    ; Recuperar valores (orden inverso)
    pop rbx
    pop rax

    ; Mostrar mensaje final
    call imprimir_fin

    add rsp, 28h
    xor ecx, ecx
    call ExitProcess

; Subrutina
subrutina:
    ; Preservar registros no volátiles
    push rbx
    ; Mostrar mensaje
    mov rcx, r12
    lea rdx, [msgDentro]
    mov r8d, lenDentro
    lea r9, [bytesEscritos]
    sub rsp, 20h
    call WriteConsoleA
    add rsp, 20h
    ; Restaurar registro
    pop rbx
    ret

; Rutinas de impresión
imprimir_inicio:
    mov rcx, r12
    lea rdx, [msgInicio]
    mov r8d, lenInicio
    lea r9, [bytesEscritos]
    sub rsp, 20h
    call WriteConsoleA
    add rsp, 20h
    ret

imprimir_fin:
    mov rcx, r12
    lea rdx, [msgFin]
    mov r8d, lenFin
    lea r9, [bytesEscritos]
    sub rsp, 20h
    call WriteConsoleA
    add rsp, 20h
    ret
    