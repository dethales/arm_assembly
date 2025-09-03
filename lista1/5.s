/*
5) Faça um programa em Assembly/ARM de forma legível que imprime no stdout uma
string com os dizeres "Início de Programa", e em seguida, a multiplicação de um
valor inicial igual a 100 (definido como word na área de dados) pelo valor 20.
Deve-se usar operador soma (portanto, não deve usar opcode mul) para o cálculo.
Após nova string será impressa como os dizeres: "Impressão por Deslocamento".
Em seguida, imprime no stdout a multiplicação do valor 100 por 16 utilizando 
deslocamentos de bits. Usar comentários para uma melhor interface ao usuário.
*/
.global _start
.equ PRINT_STRING_STDOUT, 0x02
.equ EXIT, 0x11                 ; Código iterrupt para sair do programa

.text
_start:
    LDR R0, =start_msg
    SWI PRINT_STRING_STDOUT

    LDR R1, =start_value
    LDR R2, #20
    BL mult

mult:

.data
start_msg: .asciz "Início de Programa\n"
start_value: .word 100