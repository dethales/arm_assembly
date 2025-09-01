/*
Parte 3
Depois do programa alterado iremos incorporar mais um exemplo do uso de label.
Para isto faça:
1. Antes do final do programa use um label de nome FIM e em seguida a mensagem:
   “Fim do programa Alterado”.
2. Altere o valor do registrador r2 de modo que a soma em r1 seja menor que 60.
3. Depois da adição faça uma comparação com o valor do registrador r1 e
   verifica se este valor é menor ou igual ao valor de 60 (valor da soma
   anterior na Parte 1). Caso o valor de r1 seja menor que 60 realizar o 
   branch (desvio) para o label FIM. Ver Nota abaixo para diferenciar tipos
   de desvios.
4. Trechos do programa solicitados da Parte 3 estão mostrados abaixo.
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

    ; Se R1 < 60 (R1 = 37 no exemplo) faz o branch (desvio) para o label FIM
    CMP R1, #60
    BLT FIM

    ; "Fim do programa\n"
    LDR R0, =end_program_msg
    SWI PRINT_STRING_STDOUT
    SWI EXIT

FIM:
    ; "Fim do programa Alterado\n"
    LDR R0, =end_program_change_msg
    SWI PRINT_STRING_STDOUT
    SWI EXIT

.data
start_program_msg: .asciz "Inicio do programa\n"
line_text_msg: .asciz "Linha textual\n"
end_program_msg: .asciz "Fim do programa\n"
end_program_change_msg: .asciz "Fim do programa Alterado\n"
byte_sum_msg: .asciz "Soma em bytes\n"
byte1: .byte 0b00011001
byte2: .byte 0b00001100
newline: .asciz "\n"

.end