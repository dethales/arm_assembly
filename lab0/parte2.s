/*
Parte 2
Depois do programa anterior realizado, iremos incorporar mais funcionalidades a este
programa. Para isto faça:

1. Na continuação do programa em Assembly/ARM imprime uma string retorno de carro e
depois imprime no stdout uma string com os dizeres "New Information" e em seguida imprime
uma string retorno de carro.

2. Em seguida imprime um caractere ‘A’. Após isto imprime o caractere ‘B’, depois a string “...”
e depois o caractere ‘Z’. Após, imprime uma string retorno de carro. Logo a isto imprime em
stdout um inteiro de valor 80 sendo definido em (word) no formato hexadecimal (0x50). Após,
imprime uma string retorno de carro. No final imprime uma string com os dizeres “Stop
Program”.

3. O programa alterado, arquivo fonte (*.s) não está mostrado abaixo.
*/

.global _start

.equ PRINT_STRING_STDOUT,   0x02
.equ PRINT_INT,             0x6B
.equ PRINT_CHAR_STDOUT,     0x00
.equ EXIT,                  0x11
.equ STDOUT,                1

.text

@ subrotina: imprime '\n'
print_nl:
    MOV R0, #'\n
    SWI PRINT_CHAR_STDOUT
    BX  LR

_start:
    @ "Hello, World!"
    LDR R0, =hello_msg
    SWI PRINT_STRING_STDOUT
    BL  print_nl

    @ número 100
    MOV R0, #STDOUT
    LDR R1, =num100
    LDR R1, [R1]
    SWI PRINT_INT
    BL  print_nl

    @ número 3
    MOV R0, #STDOUT
    LDR R1, =num3
    LDR R1, [R1]
    SWI PRINT_INT
    BL  print_nl

    @ "New Information"
    LDR R0, =new_info_msg
    SWI PRINT_STRING_STDOUT
    BL  print_nl

    @ 'A' 'B' "..." 'Z'
    MOV R0, #'A
    SWI PRINT_CHAR_STDOUT
    MOV R0, #'B
    SWI PRINT_CHAR_STDOUT
    LDR R0, =dots_msg
    SWI PRINT_STRING_STDOUT
    MOV R0, #'Z
    SWI PRINT_CHAR_STDOUT
    BL  print_nl

    @ número 80 (0x50)
    MOV R0, #STDOUT
    LDR R1, =num80
    LDR R1, [R1]
    SWI PRINT_INT
    BL  print_nl

    @ "Stop Program"
    LDR R0, =stop_msg
    SWI PRINT_STRING_STDOUT
    BL  print_nl

    SWI EXIT

.data
hello_msg:     .asciz "Hello, World!"
new_info_msg:  .asciz "New Information"
dots_msg:      .asciz "..."
stop_msg:      .asciz "Stop Program"
num100:        .word 100
num3:          .byte 0b00000011
num80:         .word 0x50
.end