/*
Parte 1
1. Antes de começar o programa em Assembly/ARM, defina as seguintes constantes para as
interrupções de saída no stdout: uma constante para escrever as strings, uma para escrever
inteiros, uma para escrever caracteres ASCII e uma para designar o modo de saída padrão
(mode is Stdout).
2. Em seguida, faça um programa em Assembly/ARM que imprime no stdout 10 valores
inteiros começando por a=150 (definido como word na área de dados) e a cada valor seguinte
será deslocado a esquerda por 1 bit. Para fazer o loop 10 vezes deve-se definir uma variável
inicial i=0 definida como word. Entre as impressões dos inteiros, imprime no stdout uma string
vazia.
3. A seguir, imprime no stdout 10 caracteres ASCII começando por b=’C’ (onde, b é definido
como byte na área de dados) e a cada valor ASCII seguinte será deslocado a esquerda por 2
bits. Para fazer o loop 10 vezes deve-se definir um valor inicial para um registrador igual a zero
(0). Entre as impressões dos caracteres ASCII, deve-se imprimir no stdout uma string vazia.
4. Em seguida, imprime uma string retorno de carro e logo após escreve no stdout uma string
com os dizeres “Fim do programa”.
5. O programa solicitado com o arquivo fonte (*.s) está mostrado logo a seguir.
6. Compare seu projeto (Laboratório 2) com o projeto hello.s compilado no Dev-C++, mostrado
abaixo. Na comparação do Laboratório 2 com hello.s, verifica a definição das constantes,
nomes dos registradores, instrução de comandos, labels, formato do programa principal, nome
dos mnemônicos, sintaxe dos comandos, dentre outros. Qual conclusão podemos chegar?
7. Observe o uso de labels em ambos os projetos para realizar conjunto de instruções de forma
iterativa.
8. Ainda como parte da comparação no item 6, investigue os tipos e os nomes de registradores
na arquitetura x86 através de uma ferramenta de pesquisa (Internet, livros, apostilas, dentre
outras).
8. Uma boa forma de aprendizado e memorização é praticar e tentar fazer o programa e
somente depois ver os resultados no arquivo fonte.
Parte 2
Depois do programa anterior realizado, iremos incorporar mais funcionalidades a este
programa. Para isto faça:
1. Antes da escrita da mensagem "Fim do programa" e depois da impressão da string retorno
de carro imprima 20 valores deslocando cada um a esquerda de um bit começando por
11111111 definido por byte na área de dados. Entre as impressões dos valores imprimir no
stdout uma string vazia.
2. Em seguida, imprime uma string de retorno de carro.
3. Após, imprima 20 valores deslocando cada um a direita de um bit começando por 11111111
e a cada impressão imprimir no stdout uma string vazia.
4. O programa alterado, arquivo fonte (*.s) não está mostrado abaixo.
*/

;Aluno: Thales Coutinho Layber

.equ PRINT_STRING_STDOUT,   0x02
.equ PRINT_INT,             0x6B
.equ PRINT_CHAR_STDOUT,     0x00
.equ STDOUT,                1
.equ EXIT,                  0x11

.text
_start:
    LDR     R2, =i
    LDR     R2, [R2]            ; R2 = contador

    LDR     R1, =a
    LDR     R1, [R1]            ; entrada = 150
    MOV     R3, #1              ; Configura a impressão para int (1)
    BL shift_loop

    LDR     R1, =b
    LDR     R1, [R1]            ; entrada = 'B'
    MOV     R3, #0              ; Configura a impressão para char (0)
    BL shift_loop



/*
Subrotina: print
    Imprime uma variável que pode ser um inteiro ou char
    Entrada:    R3 = 0 (char) ou 1 (int), R1 = variável a ser impressa
    Saída:      (nenhuma)
    Preserva:   R1, R3
    Modifica:   R0
*/
print:
    CMP     R3, #1              ; Compara R3 com 1
    BEQ     print_int           ; Se R3 == 1, vai para print_int
    B       print_char          ; Senão, vai para print_char

print_char:
    MOV     R0, R1              ; Move o caractere de R1 para R0
    SWI     PRINT_CHAR_STDOUT   ; Imprime o caractere
    B       print_end           ; Pula para o fim

print_int:
    MOV     R0, #STDOUT         ; Define modo stdout
    SWI     PRINT_INT           ; Imprime o inteiro em R1

print_end:
    MOV     R0, #'\n'
    SWI     PRINT_CHAR_STDOUT   ; Imprime quebra de linha

    MOV     PC, LR              ; retorno da subrotina

/*
Subrotina: shift_loop
    loop que vai fazendo shift de 1 bit a esquerda sucessivas vezes
    Entrada:    R0 = char(0) ou int (1) a ser passado para a subrotina print
                R1 = valor a ser shiftado
                R2 = contador descrescente
    Saída:      R1 = valor que foi shiftado
    Modifica:   R0, R1, R2
*/
shift_loop:
    BL      print               ; Imprime a variável em R1

    MOV     R1, R1, LSL #1      ; Faz o shift para esquerda em 1 bit

    SUBS    R2, R2, #1          ; Decrementa o contador
    BNE     shift_loop          ; Loop se o contador > 0

    MOV     PC, LR              ; Retorna da subrotina


.data
a:  .word 150
b:  .byte 'C'
i:  .word 10

.end