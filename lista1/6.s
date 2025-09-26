/*
6) Faça um programa em Assembly/ARM de forma legível (com comentários) que 
imprime no stdout os resultados das operações (soma e subtração) de uma 
calculadora usando dois números. Os registradores deverão ler dois números 
quaisquer usando variáveis na área data.
*/

.equ PRINT_STRING_STDOUT,   0x02
.equ PRINT_CHAR_STDOUT,     0x00
.equ PRINT_INT,             0x6B
.equ STDOUT,                1
.equ EXIT,                  0x11

.text
_start:
; Carrega os valores do .data
    LDR     R2, =a
    LDR     R2, [R2]            ; R2 = a
    LDR     R3, =b
    LDR     R3, [R3]            ; R3 = b

; Realiza a soma e subtracao
    ADD     R4, R2, R3          ; soma = a + b
    SUB     R5, R2, R3          ; sub = a - b

; Imprime os resultados

; a + b = soma:
    MOV     R0, #STDOUT
    MOV     R1, R2
    SWI     PRINT_INT           ; Imprime a

    LDR     R0, =mais
    SWI     PRINT_STRING_STDOUT ; Imprime " + "

    MOV     R0, #STDOUT
    MOV     R1, R3
    SWI     PRINT_INT           ; Imprime b

    LDR     R0, =igual
    SWI     PRINT_STRING_STDOUT ; Imprime " = "

    MOV     R0, #STDOUT
    MOV     R1, R4
    SWI     PRINT_INT           ; Imprime soma

    MOV     R0, #'\n'
    SWI     PRINT_CHAR_STDOUT   ; Imprime a quebra de linha

; a - b = sub:
    MOV     R0, #STDOUT
    MOV     R1, R2
    SWI     PRINT_INT           ; Imprime a

    LDR     R0, =menos
    SWI     PRINT_STRING_STDOUT ; Imprime " + "

    MOV     R0, #STDOUT
    MOV     R1, R3
    SWI     PRINT_INT           ; Imprime b

    LDR     R0, =igual
    SWI     PRINT_STRING_STDOUT ; Imprime " = "

    MOV     R0, #STDOUT
    MOV     R1, R5
    SWI     PRINT_INT           ; Imprime sub

    SWI     EXIT

.data
    a:  .word 10                ; Primeiro número
    b:  .word 5                 ; Segundo número
    mais:   .asciz " + "
    menos:  .asciz " - "
    igual:  .asciz " = "

.end