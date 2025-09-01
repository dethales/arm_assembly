/*
Parte 2
Depois do programa anterior realizado, iremos incorporar mais funcionalidades
a este programa. Para isto faça:
1. Para cada linha de comando abaixo colocar labels BCOM1, BCOM2, BCOM3,
   e assim por diante.
2. Antes da escrita da mensagem "Fim do programa" e depois da segunda impressão
   da string retorno de carro soma dois valores em hexadecimal e imprime no
   stdout a soma, e em seguida imprime uma string retorno de carro.
3. Em seguida imprime uma mensagem com os dizeres “Soma em bytes”. Após,
   imprime uma string retorno de carro. Logo, imprime em stdout a soma de dois
   valores em bytes. Após, imprime uma string retorno de carro.
4. O programa alterado, arquivo fonte (*.s) não está mostrado abaixo.
*/

.global _start

.equ PRINT_STRING_STDOUT,   0x02
.equ PRINT_INT,             0x6B
.equ PRINT_CHAR_STDOUT,     0x00
.equ EXIT,                  0x11
.equ STDOUT,                1

.text


_start:
    ; "Início do programa\n"
    LDR R0, =start_program_msg
    SWI PRINT_STRING_STDOUT

    ; "Linha textual\n"
    LDR R0, =line_text_msg
    SWI PRINT_STRING_STDOUT

    ; Realiza soma de dois inteiros
    MOV R1, #5
    MOV R2, #6
    ADD R1, R1, R2

    ; Imprime o resultado da soma
    MOV R0, #STDOUT
    SWI PRINT_INT

    MOV R0, #'\n'
    SWI PRINT_CHAR_STDOUT
    SWI PRINT_CHAR_STDOUT

BCOM1:
    ; Soma dois valores em hexadecimal
    MOV R1, #0xA
    MOV R2, #0xB
    ADD R1, R1, R2

    ; Imprime o resultado da soma
    MOV R0, #STDOUT
    SWI PRINT_INT

    MOV R0, #'\n'
    SWI PRINT_CHAR_STDOUT

BCOM2:
    ; "Soma em bytes\n"
    LDR R0, =byte_sum_msg
    SWI PRINT_STRING_STDOUT

    ; Soma dois valores em bytes
    LDR R1, =byte1
    LDRB R1, [R1] ; LDRB é a instrução de carregar byte da memória
    LDR R2, =byte2
    LDRB R2, [R2]
    ADD R1, R1, R2

    ; Imprime o resultado da soma
    MOV R0, #STDOUT
    SWI PRINT_INT

    MOV R0, #'\n'
    SWI PRINT_CHAR_STDOUT

    ; "Fim do programa\n"
    LDR R0, =end_program_msg
    SWI PRINT_STRING_STDOUT

    SWI EXIT

.data
start_program_msg: .asciz "Inicio do programa\n"
line_text_msg: .asciz "Linha textual\n"
end_program_msg: .asciz "Fim do programa\n"
byte_sum_msg: .asciz "Soma em bytes\n"
byte1: .byte 0x1F
byte2: .byte 0x0C
newline: .asciz "\n"

.end