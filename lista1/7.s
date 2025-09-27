/*
7) Faça um programa em Assembly/ARM de forma legível (com comentários) que 
imprime no stdout números aleatórios num intervalo de 200 ms. Os registradores 
deverão ler todas as variáveis (intervalo e strings) da área data. Usar a 
diretiva SWI_GetTicks. Não precisa usar arquivo externo.
*/

.equ PRINT_CHAR_STDOUT,     0x00
.equ PRINT_INT,             0x6B
.equ STDOUT,                1
.equ GET_TICKS,             0x6D
.equ EXIT,                  0x11


.text
_start:
    LDR     R3, =intervalo
    LDR     R3, [R3]            ; R3 = delay = intervalo no .data

loop:
    BL      wait                ; espera R3 ms
    BL      random              ; R1 = numero aleatorio entre 0 e 1
    BL      print_int_stdout    ; subrotina que imprime R1
    B       loop

/*
Subrotina: wait
    Aguarda pelo intervalo em ms passado em R1.
    Entrada:    R3 = intervalo (ms)
    Saída:      (nenhuma)
    Preserva:   R3 (intervalo)
    Modifica:   R0 (tempo_ms_atual), R1 (base), R2 (tempo_decorrido)
*/
wait:
    SWI     GET_TICKS           ; atualiza tempo_ms_atual
    MOV     R1, R0              ; base = tempo_ms_atual

wait_loop:
    SWI     GET_TICKS           ; atualiza tempo_ms_atual
    SUB     R2, R0, R1          ; tempo_decorrido = tempo_ms_atual - base
    CMP     R2, R3              ; compara tempo_decorrido com intervalo
    BLT     wait_loop           ; espera ate que (tempo_decorrido > intervalo)

    MOV     PC, LR              ; retorna da subrotina

/*
Subrotina: print_int_stdout
    Imprime um numero inteiro (R5) e uma quebra de linha no stdout
    Entrada:    R1 = num_inteiro
    Saída:      (nenhuma)
    Preserva:   R1 (num_inteiro)
    Modifica:   R0
*/
print_int_stdout:
    MOV     R0, #STDOUT
    SWI     PRINT_INT           ; imprime o numero ineiro

    MOV     R0, #'\n'
    SWI     PRINT_CHAR_STDOUT   ; imprime a quebra de linha

    MOV     PC, LR              ; retorna da subrotina

/*
Subrotina: random
    Gera um numero pseudo-aleatorio entre 0 e 255
    Entrada:    (nenhuma)
    Saída:      R1 = inteiro 0..255
    Modifica:   R0, R1
*/
random:
    ; Pega os 8 bits mais baixos do contador, que variam muito
    SWI     GET_TICKS           ; pega o tempo do relogio
    AND     R1, R0, #0xFF       ; so os 8 bits mais baixos
    MOV     PC, LR              ; retorna da subrotina

.data
intervalo: .word 200
.end