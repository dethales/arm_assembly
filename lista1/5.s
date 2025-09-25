/*
5) Faça um programa em Assembly/ARM de forma legível que imprime no stdout uma
string com os dizeres "Início de Programa", e em seguida, a multiplicação de um
valor inicial igual a 100 (definido como word na área de dados) pelo valor 20.
Deve-se usar operador soma (portanto, não deve usar opcode mul) para o cálculo.
Após nova string será impressa como os dizeres: "Impressão por Deslocamento".
Em seguida, imprime no stdout a multiplicação do valor 100 por 16 utilizando 
deslocamentos de bits. Usar comentários para uma melhor interface ao usuário.
*/

.equ PRINT_STRING_STDOUT,   0x02
.equ PRINT_INT,             0x6B
.equ STDOUT,                1
.equ EXIT,                  0x11    ; Codigo interrupt para sair do programa

.text
_start:
; Imprime a string "Início de Programa\n"
LDR     R0, =start_msg
SWI     PRINT_STRING_STDOUT

; 100 * 20 por somas repetidas
LDR     R2, =start_value
LDR     R2, [R2]        ; R2 = 100
MOV     R3, #20         ; R3 = 20 (serve como contador decrescente do loop)
MOV     R1, #0          ; R1 = 0 (acumulador da soma)

loop:
    CMP     R3, #0      ; Verifica se o contador R3 ja chegou em zero
    ADDGT   R1, R1, R2  ; Se o contador > 0, então acumula R2=100 no acumulador
    SUBGT   R3, R3, #1  ; Se o contador > 0, decrementa o contador em 1
    BGT     loop        ; Se o contador > 0, repete o loop

; Imprime o resultado da multiplicacao
MOV     R0, #STDOUT     ; Configura impressao para o stdout
SWI     PRINT_INT       ; Imprime o resultado da multiplicacao (R1) no stdout

; Imprime a string "\nImpressão por Deslocamento\n"
LDR     R0, =shift_msg
SWI     PRINT_STRING_STDOUT

; 100 * 16 via deslocamento: 100 << 4
; R2 ainda é 1100 porque não foi mexido
MOV R1, R2, LSL #4      ; LSL = Left Shift Logical, shifta 4 vezes pra esquerda

; Imprime o resuldato de 100 * 16
MOV     R0, #STDOUT     ; Configura impressao para o stdout
SWI     PRINT_INT       ; Imprime o resultado da multiplicacao (R1) no stdout

; Saida do programa
SWI     EXIT


.data
start_msg: .asciz "Início de Programa\n"
shift_msg: .asciz "\nImpressão por Deslocamento\n"
start_value: .word 100

.end