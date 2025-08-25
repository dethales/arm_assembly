/*
Parte 1
1. Faça um programa em Assembly/ARM que imprime no stdout uma string com os dizeres
"Hello World!" e em seguida imprime uma string retorno de carro. Após isto imprime em
stdout um inteiro de valor 100 sendo definido em (word) no formato decimal (100).

2. Em seguida imprime uma string retorno de carro e logo a seguir, imprime em stdout um
inteiro de valor 3 sendo definido em (byte) no formato binário (0b00000011).

3. O programa solicitado com o arquivo fonte (*.s) está mostrado logo a seguir, com nome de
hello.s.

4. Uma boa forma de aprendizado e memorização é praticar e tentar fazer o programa e
somente depois ver os resultados no arquivo fonte.
*/

.global _start

.equ PRINT_STRING_STDOUT, 0x02
.equ PRINT_INT, 0x6B
.equ PRINT_CHAR_STDOUT, 0x00
.equ EXIT, 0x11
.equ STDOUT, 1

.text
_start:
    ; Imprime a mensagem "Hello, World!\n"
    LDR R0, =hello_msg
    SWI PRINT_STRING_STDOUT

    ; Imprime o número 100
    MOV R0, #STDOUT     ; Define o arquivo de saída como stdout
    LDR R1, =num100     ; Carrega o endereço de num100 em R1
    LDR R1, [R1]        ; Carrega o valor 100 em R1
    SWI PRINT_INT

    ; Imprime o \n
    MOV R0, #'\n
    SWI PRINT_CHAR_STDOUT

    ; Imprime o número 3
    MOV R0, #STDOUT     ; Define o arquivo de saída como stdout
    LDR R1, =num3       ; Carrega o endereço de num3 em R1
    LDR R1, [R1]        ; Carrega o valor 3 em R1
    SWI PRINT_INT

.data
hello_msg: .asciz "Hello, World!\n"
num100: .word 100
num3: .byte 0b00000011