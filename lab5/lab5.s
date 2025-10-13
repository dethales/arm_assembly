; Aluno: Thales Coutinho Layber
/*
Parte 1
1. Faça um programa em Assembly/ARM que soma dois números e imprime o resultado, sendo
um número representado na forma hexadecimal e outro em decimal e em seguida, imprime
uma string retorno de carro.
2. Em seguida, carrega um número (x) para um registrador e move este número para outro
registrador e a seguir carrega um número (y) para o registrador. Logo após, soma estes dois
números (x) e (y) e imprime o resultado. Em seguida, imprime uma string retorno de carro.
3. Em seguida, multiplica o número (x) que foi salvo num registrador pelo número (y)
armazenando o resultado no registrador r1 e imprime o resultado. Em seguida, imprime uma
string retorno de carro.
4. Após, subtraia o número (x) que foi salvo num registrador do valor 200 e armazenando o
resultado no registrador r1 e imprime o resultado. Em seguida, imprime uma string retorno de
carro.
5. Não se esquecer de encerrar o programa com a interrupção (swi 0x11) e ainda criar um label
(por exemplo, fimdoprograma), antes desta interrupção.
6. O programa solicitado com o arquivo fonte (*.s) está mostrado logo a seguir.
7. Pergunta: Existe um mnemônico em Assembly para dividir ou outra forma de fazer a
divisão?
8. Identifiquem no seu projeto os valores nos registradores, Figura 1.
9. Uma boa forma de aprendizado e memorização é praticar e tentar fazer o programa e
somente depois ver os resultados no arquivo fonte.

Parte 2
Depois do programa anterior realizado, iremos incorporar mais funcionalidades a este
programa. Para isto faça:
1. Antes da finalização do programa multiplica um valor qualquer (number_value) por 2
(dois) e imprime o resultado no stdout.
2. Em seguida, imprime uma string de retorno de carro.
3. Após isto, imprime number_value modificando seu valor pelo deslocamento à direita de
um bit.
4. Em seguida, imprime uma string de retorno de carro.
5. O que você observou? Qual conclusão encontrou?
6. Agora imprime valores, começando pelo number_value, num loop repetido cinco vezes e a
cada loop deslocar o valor a direita de um bit e imprimir. O que você observou? Qual conclusão
encontrou? Em que situação pode utilizar esta propriedade de deslocar bits à direita?
7. O programa alterado, arquivo fonte (*.s) não está mostrado abaixo.
*/

.equ PRINT_CHAR_STDOUT,     0x00
.equ PRINT_STRING_STDOUT,   0x02
.equ PRINT_INT,             0x6B
.equ STDOUT,                0x01
.equ EXIT,                  0x11

.text
_start:
    MOV     R2, #0x2A           ; R2 = 42 em hexadecimal
    MOV     R3, #22             ; R3 = 22 em decimal
    ADD     R1, R2, R3          ; R1 = R2 + R3
    BL      print_int           ; Imprime a soma

    LDR     R5, =176            ; carrega x=176 em R5
    MOV     R4, R5              ; move x para R4
    LDR     R6, =247            ; carrega y=247 em R6
    ADD     R1, R5, R6          ; r1 = x + y
    BL      print_int           ; Imprime a soma

    MUL     R1, R5, R6          ; R1 = x * y
    BL      print_int           ; Imprime a multiplicação

    RSB     R1, R4, #200        ; R1 = 200 - x (RSB = Subtração Reversa)
    BL      print_int

    MOV     R8, #2              ; Valor 2 para o MUL multiplicar
    LDR     R2, =54             ; R2 = number_value
    MUL     R1, R2, R8          ; R1 = number_value * 2
    BL      print_int

    MOV     R1, R2, LSL #1      ; R1 = R2 << 1
    BL      print_int

    MOV     R7, #5              ; contador = 5 e vai descrescendo (5 loops)
loop:
    MOV     R2, R2, LSL #1      ; R2 deslocado 1 bit à esquerda
    BL      print_int           ; Imprime o valor deslocado
    
    SUBS    R7, R7, #1          ; Decrementa contador (atualiza flags)
    BNE     loop


    SWI     EXIT

/*
Subrotina: print_int
    Imprime o numero inteiro em R1 e um '\n'
    Entrada:    R1 = número
    Saída:      (nenhuma)
    Preserva:   R1
    Modifica:   R0
*/
print_int:
    MOV     R0, #STDOUT
    SWI     PRINT_INT           ; Imprime o inteiro

    MOV     R0, #'\n'
    SWI     PRINT_CHAR_STDOUT   ; Imprime '\n'

    MOV     PC, LR              ; Retorna da subrotina

.data

.end