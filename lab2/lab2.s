;Aluno: Thales Coutinho Layber

.global _start

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