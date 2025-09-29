/*
Parte 1
1. Antes de começar o programa em Assembly/ARM, defina as seguintes constantes para as
interrupções de saída no stdout: uma constante para escrever as strings, uma para escrever
inteiros e uma para designar o modo de saída padrão (mode is Stdout).
2. Em seguida, faça um programa em Assembly/ARM que encontra o maior de dois números
definidos como word na área de dados. Não se esquecer de usar comandos de desvios para o
caso de encontrar o maior número.
3. A seguir, imprime no stdout o maior número.
4. Em seguida, imprime uma string retorno de carro e logo após escreve no stdout uma string
com os dizeres “Fim do programa”.
5. O programa solicitado com o arquivo fonte (*.s) está mostrado logo a seguir.
6. Identifique no seu projeto (Laboratório 3) a diferença entre acessar endereços nos
registradores e valores nos registradores. Ainda neste projeto, na aba General Purpose, ver
Figura 1, comutar entre os botões Hexadecimal, Unsigned Decimal e Signed Decimal para ver
os valores nos registradores em diversos formatos.
7. Uma boa forma de aprendizado e memorização é praticar e tentar fazer o programa e
somente depois ver os resultados no arquivo fonte.

Parte 2
Depois do programa anterior realizado, iremos incorporar mais funcionalidades a este
programa. Para isto faça:
1. Antes da escrita da mensagem "Fim do programa" e depois da impressão da string retorno
de carro encontre e imprime no stdout o menor de dois números (menor_valor).
2. Em seguida, imprime uma string de retorno de carro.
3. Após isto, imprime o menor valor encontrado menor_valor, mas deslocando o valor do
número a esquerda de um bit.
4. Em seguida, imprime uma string de retorno de carro.
5. Agora imprime um valor qualquer e em seguida faça um loop repetido quatro vezes e a cada
loop deslocar este valor a esquerda de um bit e imprimir. O que observou? Qual conclusão
encontrou? Em que situação pode utilizar esta propriedade de deslocar bits?
6. O programa alterado, arquivo fonte (*.s) não está mostrado abaixo.
 */

; Aluno: Thales Coutinho Layber

.equ PRINT_STRING_STDOUT,   0x02
.equ PRINT_INT,             0x6B
.equ PRINT_CHAR_STDOUT,     0x00
.equ STDOUT,                1
.equ EXIT,                  0x11

.text
_start:
    ; Carrega os números
    LDR     R0, =num1
    LDR     R0, [R0]            ; R0 = num0
    LDR     R1, =num2
    LDR     R1, [R1]            ; R1 = num1

    BL      ordenar             ; Ordena os numeros R0 e R1

    MOV     R4, R0              ; menor = R4
    MOV     R5, R1              ; maior = R5

    MOV     R1, R5              ; Imprime maior
    BL      print_num

    MOV     R1, R4              ; Imprime menor
    BL      print_num

    MOV     R1, R4, LSL #1      ; Imprime menor << 1
    BL      print_num

    LDR     R1, =num3
    LDR     R1, [R1]            ; R1 = num3

    BL      print_num           ; Imprime num3

    MOV     R7, #4              ; contador = 4 e vai descrescendo
loop:
    MOV     R1, R1, LSL #1      ; R1 deslocado 1 bit à esquerda
    BL      print_num           ; Imprime o valor deslocado
    
    SUBS    R7, R7, #1          ; Decrementa contador (atualiza flags)
    BNE     loop           

    LDR     R0, =msg_end
    SWI     PRINT_STRING_STDOUT ; Imprime "Fim do programa"

    SWI     EXIT

/*
Subrotina: ordenar
    ordena R0 e R1 de forma que R0 <= R1
    Entrada:    R0 = primeiro número, R1 = segundo número
    Saída:      R0 = menor número, R1 = maior número
    Modifica:   R0, R1, R2
*/
ordenar:
    CMP     R0, R1              ; Compara R0 com R1
    MOVGT   R2, R0              ; Se R0 > R1, troca as duas variaveis
    MOVGT   R0, R1
    MOVGT   R1, R2
    MOV     PC, LR              ; Retorna da subrotina

/*
Subrotina: print_num
    Imprime o numero inteiro em R1 e um '\n'
    Entrada:    R1 = número
    Saída:      (nenhuma)
    Preserva:   R1
    Modifica:   R0
*/
print_num:
    MOV     R0, #STDOUT
    SWI     PRINT_INT           ; Imprime o inteiro

    MOV     R0, #'\n'
    SWI     PRINT_CHAR_STDOUT   ; Imprime '\n'

    MOV     PC, LR              ; Retorna da subrotina


.data
num1: .word 41
num2: .word 33
num3: .word 13
msg_end: .asciz "Fim do programa"
.end