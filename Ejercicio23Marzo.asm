; NATHAN FERNANDO FERNANDEZ AREVALO 
; JORGE ARMANDO HERNANDEZ COHUO
; ARMAND LEONARDO RODRIGUEZ OLIVERA

default rel
global main

extern GetStdHandle
extern WriteConsoleA
extern ReadConsoleA
extern ExitProcess

SALIDA_ESTANDAR equ -11
ENTRADA_ESTANDAR equ -10

section .data
    msgMult db "Multiplicacion: "
    lenMult equ $ - msgMult
    ; Dejamos espacio para 3 dígitos: "000"
    result db "000", 13, 10
    lenResult equ $ - result
    
    bytesEscritos dq 0
    bytesLeidos dq 0

section .bss
    numero resb 10    ; Aquí se guarda lo que el usuario teclea

section .text
main:
    sub rsp, 28h        

    ; --- Obtener Handles ---
    mov ecx, ENTRADA_ESTANDAR
    call GetStdHandle 
    mov r12, rax

    mov ecx, SALIDA_ESTANDAR     
    call GetStdHandle
    mov r13, rax
    
    ; --- Leer del teclado ---
    mov rcx, r12
    lea rdx, [numero] 
    mov r8d, 10         
    lea r9, [bytesLeidos] 
    call ReadConsoleA 

    ; --- CONVERTIR ASCII A NÚMERO (Manual, sin bucles) ---
    ; Ejemplo: Si el usuario teclea "123"
    
    ; 1. Centenas ('1')
    movzx ax, byte [numero]
    sub al, '0'
    mov bl, 100
    mul bl              ; AX = 100
    mov r14w, ax        ; Guardamos 100 en R14w

    ; 2. Decenas ('2')
    movzx ax, byte [numero + 1]
    sub al, '0'
    mov bl, 10
    mul bl              ; AX = 20
    add r14w, ax        ; 100 + 20 = 120

    ; 3. Unidades ('3')
    movzx ax, byte [numero + 2]
    sub al, '0'
    add r14w, ax        ; 120 + 3 = 123 (Ya tenemos el número real)

    ; --- MULTIPLICACIÓN (123 * 2) ---
    mov ax, r14w
    mov bl, 2
    mul bl              ; AX = 246

    ; --- CONVERTIR NÚMERO A ASCII (Manual, para 3 dígitos) ---
    ; Para el número 246:
    
    ; 1. Sacar Centenas (246 / 100)
    mov bl, 100
    div bl              ; AL = 2 (cociente), AH = 46 (residuo)
    add al, '0'
    mov [result], al    ; Guardamos '2'
    
    ; 2. Sacar Decenas y Unidades del residuo (46 / 10)
    mov al, ah          ; Pasamos el 46 a AL
    xor ah, ah          ; Limpiar AH
    mov bl, 10
    div bl              ; AL = 4 (decenas), AH = 6 (unidades)
    
    add al, '0'
    mov [result + 1], al ; Guardamos '4'
    
    add ah, '0'
    mov [result + 2], ah ; Guardamos '6'

    ; --- MOSTRAR RESULTADO ---
    mov rcx, r13
    lea rdx, [msgMult]
    mov r8d, lenMult
    lea r9, [bytesEscritos]
    call WriteConsoleA
    
    call mostrar_resultado

    add rsp, 28h
    xor ecx, ecx
    call ExitProcess

; Subrutina de mostrar mensaje (como la tenías tú)
mostrar_resultado:
    mov rcx, r13
    lea rdx, [result]
    mov r8d, lenResult
    lea r9, [bytesEscritos]
    sub rsp, 20h  
    call WriteConsoleA
    add rsp, 20h  
    ret