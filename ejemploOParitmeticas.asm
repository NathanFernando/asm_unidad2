default rel
global main

extern GetStdHandle
extern WriteConsoleA
extern ExitProcess

; Constantes
SALIDA_ESTANDAR equ -11

; Datos
section .data
    msgSuma db "Suma: "
    lenSuma equ $ - msgSuma
    msgResta db "Resta: "
    lenResta equ $ - msgResta
    msgMult db "Multiplicacion: "
    lenMult equ $ - msgMult
    msgDiv db "Division: "
    lenDiv equ $ - msgDiv
    result db "00", 13, 10
    lenResult equ $ - result
    bytesEscritos dq 0

; Código
section .text
main:
    sub rsp, 28h        ; alineación x64
    ; Obtener handle de salida
    mov ecx, SALIDA_ESTANDAR
    call GetStdHandle
    mov r12, rax        ; Handle salida

    ; SUMA (9 + 5 = 14)
    mov al, 9
    mov bl, 5
    add al, bl
    call convertir_decimal

    mov rcx, r12
    lea rdx, [msgSuma]
    mov r8d, lenSuma
    lea r9, [bytesEscritos]
    call WriteConsoleA
    call mostrar_resultado

    ; RESTA (9 - 5 = 4)
    mov al, 9
    sub al, 5
    call convertir_decimal

    mov rcx, r12
    lea rdx, [msgResta]
    mov r8d, lenResta
    lea r9, [bytesEscritos]
    call WriteConsoleA
    call mostrar_resultado

    ; MULTIPLICACIÓN (9 * 5 = 45)
    mov al, 9
    mov bl, 5
    mul bl            ; AX = AL * BL  AL=45, AH=0
    call convertir_decimal

    mov rcx, r12
    lea rdx, [msgMult]
    mov r8d, lenMult
    lea r9, [bytesEscritos]
    call WriteConsoleA
    call mostrar_resultado

    ; DIVISIÓN (200 / 15 = 13)
    mov ax, 200       ; Dividendo
    mov bl, 15        ; bl será el divisor
    div bl            ; AL=13->cociente, AH=5->residuo
    call convertir_decimal

    mov rcx, r12
    lea rdx, [msgDiv]
    mov r8d, lenDiv
    lea r9, [bytesEscritos]
    call WriteConsoleA
    call mostrar_resultado

    ; Salir
    add rsp, 28h
    xor ecx, ecx
    call ExitProcess

; Convierte AL (0–99) a ASCII
convertir_decimal:
    xor ah, ah
    mov bl, 10
    div bl   ; AL=cociente->decenas, AH=residuo->unidades

    add al, '0'
    mov [result], al

    mov al, ah
    add al, '0'
    mov [result + 1], al
    ret

; mostrar resultado
mostrar_resultado:
    mov rcx, r12
    lea rdx, [result]
    mov r8d, lenResult
    lea r9, [bytesEscritos]
    sub rsp, 20h  ; espacio para parámetros adicionales
    call WriteConsoleA
    add rsp, 20h  ; limpiar pila
    ret