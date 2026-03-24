; NATHAN FERNANDO FERNANDEZ AREVALO 
; JORGE ARMANDO HERNANDEZ COHUO
; ARMAND LEONARDO RODRIGUEZ OLIVERA

default rel
global main

extern GetStdHandle
extern WriteConsoleA
extern ReadConsoleA
extern ExitProcess

SALIDA_ESTANDAR  equ -11
ENTRADA_ESTANDAR equ -10

section .data
msgMensaje      db "Ingresa un mensaje: ", 0
lenMensaje   equ $ - msgMensaje
msgRes      db "Resultado en minusculas: ", 0
lenRes      equ $ - msgRes

bytesEscritos dq 0
bytesLeidos   dq 0

section .bss
buffer      resb 64

section .text
main:
sub rsp, 28h
; 1. Obtener Handles
mov ecx, ENTRADA_ESTANDAR
call GetStdHandle
mov r12, rax

mov ecx, SALIDA_ESTANDAR
call GetStdHandle
mov r13, rax

; 2. Mostrar mensaje
mov rcx, r13
lea rdx, [msgMensaje]
mov r8d, lenMensaje
lea r9, [bytesEscritos]
call WriteConsoleA

; 3. Leer texto
mov rcx, r12
lea rdx, [buffer]
mov r8d, 64
lea r9, [bytesLeidos]
call ReadConsoleA


lea rsi, [buffer]       
mov rcx, [bytesLeidos]   

cmp rcx, 0
je finalizar_proceso

ciclo_manual:
mov al, [rsi]            

cmp al, 'A'
jb continuar             
cmp al, 'Z'
ja continuar             

; Convertir a minuscula
add al, 32
mov [rsi], al

continuar:
inc rsi                  
dec rcx                 
jnz ciclo_manual         

; 5. Mostrar resultados
mov rcx, r13
lea rdx, [msgRes]
mov r8d, lenRes
lea r9, [bytesEscritos]
call WriteConsoleA

mov rcx, r13
lea rdx, [buffer]
mov r8d, [bytesLeidos]
lea r9, [bytesEscritos]
call WriteConsoleA

finalizar_proceso:
add rsp, 28h
xor ecx, ecx
call ExitProcess