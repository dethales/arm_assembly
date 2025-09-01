/*
Parte 1
1. Faça um programa em Assembly/ARM que imprime no stdout uma string com os
   dizeres "Inicio do programa\n” e em seguida imprime outra string “Linha
   textual\n”. Após isto imprime em stdout a soma de dois inteiros no formato
   decimal. Observe o que ocorre no stdout devido a introdução de “\n” dentro
   das definições das strings anteriores.
2. Em seguida imprime duas strings de retorno de carro e logo a seguir
   escreve no stdout uma string com os dizeres “Fim do programa”
3. O programa solicitado com o arquivo fonte (*.s) está mostrado logo a
   seguir.
4. Uma boa forma de aprendizado e memorização é praticar e tentar fazer o
   programa e somente depois ver os resultados no arquivo fonte.
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

    ; Imprime uma soma
    MOV R1, #5
    MOV R2, #6
    ADD R1, R1, R2

    MOV R0, #STDOUT
    SWI PRINT_INT

    MOV R0, #'\n'
    SWI PRINT_CHAR_STDOUT
    SWI PRINT_CHAR_STDOUT

    ; "Fim do programa\n"
    LDR R0, =end_program_msg
    SWI PRINT_STRING_STDOUT

    SWI EXIT


.data
start_program_msg: .asciz "Inicio do programa\n"
line_text_msg: .asciz "Linha textual\n"
end_program_msg: .asciz "Fim do programa\n"
newline: .asciz "\n"

.end