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
    ; R2 = i == 0
    LDR     R2, =i
    LDR     R2, [R2]

    ; R3 = a == 150
    LDR     R3, =a
    LDR     R3, [R3]


; subrotina para imprimir um inteiro
; R1: inteiro a ser impresso
; Registradores alterados: R0
print_int:
    ; imprime o valor da variavel em R1
    MOV     R0, #STDOUT
    SWI     PRINT_INT

    ; imprime uma nova linha
    LDR     R0, =0xA
    SWI     PRINT_CHAR_STDOUT

    ; retorno da subrotina
    MOV      PC, LR

; subrotina para fazer 9 shifts
; Imprime o valor inicial e os 9 valores shiftados
; R0: valor inicial
; R1: quantidade de bits para o shift (por passo)
; R2: modo de impressão (0=char, 1=int)
shift_9_times:
    
    CMP     R2, #10
    
    ; imprime o valor da variavel em R2
    

    ; imprime um espaço
    LDR     R0, #' '
    SWI     PRINT_CHAR_STDOUT

    ; shift a um bit para a esquerda (a = a << 1)
    MOV     R3, R3, LSL #1

    ; incrementa i (i = i + 1)
    ADD     R2, R2, #1

    ; repete enquanto i < 10
    CMP     R2, #10
    BLT     loop



loop_shift:
    ; se i >= 10, termina o loop
    CMP     R2, #10
    BGE     end_loop_shift

    ; imprime o valor de a
    MOV     R0, #STDOUT
    MOV     R1, R3
    SWI     PRINT_INT

    ; imprime um espaço
    MOV     R0, #' '
    SWI     PRINT_CHAR_STDOUT

    ; shift a um bit para a esquerda (a = a << 1) (multiplica por 2)
    ; LSL = Logical Shift Left 
    MOV     R3, R3, LSL #1

    ; incrementa i (i = i + 1)
    ADD     R2, R2, #1

    ; retoma ao início do loop
    B       loop_shift

end_loop_shift:
    ; R2 = i == 0
    LDR     R2, =i
    LDR     R2, [R2]
    
    ; R3 = b == 'C'
    LDR     R3, =b
    LDRB    R3, [R3] ; LDRB é a instrução de carregar byte da memória

loop_chars:
    ; se i >= 10, termina o loop
    CMP     R2, #10
    BGE     end_loop_chars

    ; imprime o valor de b
    MOV     R0, R3
    SWI     PRINT_CHAR_STDOUT

    ; imprime um espaço
    MOV     R0, #' '
    SWI     PRINT_CHAR_STDOUT

    ; shift b um bit para a esquerda (b = b << 2) (multiplica por 2)
    ; LSL = Logical Shift Left 
    MOV     R3, R3, LSL #2

    ; incrementa i (i = i + 1)
    ADD     R2, R2, #1

    ; retoma ao início do loop
    B       loop_chars
    

end_loop_chars:


.data
a: .word 150
b: .byte 'C'
i: .word 0


.end