/* Trabalho de Arquitetura de Computadores
Thales Coutinho Layber e Pedro Belizário */

.equ PRINT_CHAR_STDOUT,     0x00            ; Chamada de sistema para imprimir caractere
.equ PRINT_STRING_STDOUT,   0x02            ; Chamada de sistema para imprimir string
.equ STDOUT,                0x01            ; Identificador do dispositivo de saída padrão
.equ EXIT,                  0x11            ; Chamada de sistema para encerrar o programa
.equ LCD_DISPLAY_STRING,    0x204           ; Chamada de sistema para exibir string no LCD
.equ LCD_DISPLAY_CHAR,      0x207           ; Chamada de sistema para exibir caractere no LCD
.equ LCD_CLEAR_SCREEN,      0x206           ; Chamada de sistema para limpar a tela do LCD
.equ READ_KEYPAD,           0x203           ; Chamada de sistema para ler o teclado de botões azuis
.equ LCD_WIDTH,     40
.equ LCD_HEIGHT,    15

.text
/* Variaveis globais:
    r0 = coluna do campo (0,1,2)
    r1 = linha do campo (0,1,2)
    r2 = caractere marcador atual ('X' ou 'O')
    r3 = casa vazia (1 se vazia, 0 se ocupada)
    r4 = jogador atual (0 para X, 1 para O)
    r5 = jogador vencedor (0: jogo em andamento, 1: jogador X venceu, 2: jogador O venceu, 3: empate)
*/
_start:
    SWI     LCD_CLEAR_SCREEN                ; Limpa a tela do LCD
    MOV     r4, #0                          ; Jogador atual = 0 (X)
    MOV     r2, #'X'                        ; Caractere do jogador atual = 'X'
    BL      draw_field                      ; Desenha o campo de jogo vazio
    BL      display_turn_msg                ; Exibe a mensagem "Vez do Jogador"

game_loop:
    BL      display_turn                    ; Exibe o turno do jogador atual
    BL      wait_keypad                     ; Captura o botão pressionado (r0=coluna, r1=linha)

    ; Checa se a posição está vazia
    BL      is_empty                        ; Retorna se a posição selecionada está vazia (r3=1 se vazia, 0 se ocupada)
    CMP     r3, #0                          ; Verifica se a casa está ocupada
    BEQ     game_loop                       ; Se ocupada, espera por outro botão
    
    ; Se vazia, prossegue:
    BL      place_marker                    ; Desenha o marcador do jogador atual na posição selecionada
    BL      store_move                      ; Armazena o movimento no vetor field

    ; Checa se há vencedor
    BL      check_winner                    ; Verifica se há um vencedor (r5=0: nenhum, 1: X venceu, 2: O venceu)
    CMP     r5, #0                          ; Verifica se há um vencedor
    BNE     game_end                        ; Se houver vencedor, vai para o fim do jogo

    ; Checa se há empate
    BL      check_draw                      ; Verifica se o jogo terminou em empate (r5=0: não, 3: empate)
    CMP     r5, #0                          ; Verifica se há empate
    BNE     game_end                        ; Se houver empate, vai para o fim do jogo

    ; Se não houve vencedor nem empate, alterna o jogador
    BL      toggle_player                   ; Alterna o jogador atual

    B       game_loop                       ; Repete o loop do jogo

game_end:
    BL      display_winner                  ; Exibe a mensagem do vencedor ou empate
    SWI     EXIT                            ; Encerra o programa

/* Subrotina: draw_field - Desenha o campo do jogo da velha vazio no LCD
Entradas:
    string empty_line no .data
Saídas:
    Desenha o campo vazio no LCD
*/
draw_field:
    STMFD   SP!, {r0-r2, LR}

    MOV     r1, #0                          ; Linha inicial = 0
    LDR     r2, =empty_line                 ; Carrega a string da linha vazia

loop_df:
    MOV     r0, #0                          ; Coluna inicial = 0
    SWI     LCD_DISPLAY_STRING              ; Desenha a linha vazia no LCD na linha r1
    ADD     r1, r1, #1                      ; Incrementa a linha
    CMP     r1, #3                          ; Verifica se desenhou 3 linhas
    BLT     loop_df                         ; Se não desenhou 3 linhas, repete

    LDMFD   SP!, {r0-r2, PC}

/*
Subrotina: place_marker - Calcula a posição (x, y) no LCD para determinada célula (col, row) no campo e 
    desenha na posição o caractere r2
Entradas:
    r0 = coluna
    r1 = linha
    r2 = marcador atual ('X' ou 'O')
Saídas:
    Desenha o caractere r2 na posição (x, y) correspondente no LCD
*/
place_marker:
    STMFD   SP!, {r0, LR}                   ; Salva LR na pilha

    ADD     r0, r0, r0, LSL #1              ; Calcula x = 3*col + 1   (col está em r0)
    ADD     r0, r0, #1                      ; r0 = 3*col + 1 -> x

    SWI     LCD_DISPLAY_CHAR                ; Desenha o caractere r2 no LCD na posição (x, y) = (r0, r1)

    LDMFD   SP!, {r0, PC}                   ; Restaura LR da pilha e retorna

wait_keypad:
    STMFD   SP!, {r2, r3, LR}               ; preserva temporários

poll_loop:
    SWI     READ_KEYPAD                     ; r0 = resultado da leitura do teclado
    LDR     r3, =0x777                      ; r3 = Máscara para botões válidos (bits 0,1,2 / 4,5,6 / 8,9,10)
    AND     r0, r0, r3                      ; Mantém bits 0,1,2 / 4,5,6 / 8,9,10 (r0= r0 & r3)
    CMP     r0, #0                          ; Verifica se algum botão válido foi pressionado
    BEQ     poll_loop                       ; Nenhum botão pressionado -> continua esperando
    MOV     r2, #0                          ; Contador de bit

; Encontra o bit mais baixo setado.
find_bit:
    MOV     r3, #1                          ; Máscara para testar o bit
    MOV     r3, r3, LSL r2                  ; r3 = (1 << r2)
    TST     r0, r3                          ; Testa se o bit está setado
    BNE     found_bit                       ; Se está setado, achou o bit do botão pressionado
    ADD     r2, r2, #1                      ; Incrementa o contador de bit
    B       find_bit                        ; Continua procurando a partir do próximo bit

found_bit:
    ; r2 tem o número do bit (0,1,2,4,5,6,8,9,10)
    ; acha o indice (row, col)
    AND     r0, r2, #3                      ; r0 = col = bit % 4
    MOV     r1, r2, LSR #2                  ; r1 = row = bit / 4
    LDMFD   SP!, {r2, r3, PC}               ; Restaura temporários e retorna

/*
Subrotina: store_move - Armazena o movimento no vetor field
Entradas:
    r0 = coluna
    r1 = linha
    r2 = caractere ('X' ou 'O')
Saídas: (nenhuma)
*/
store_move:
    STMFD   SP!, {r3, r4, LR}               ; Salva r3, r4 e lr na pilha

    ; Calcula o índice (index) no array 1D correspondente à posição (col, row)
    ADD     r3, r1, r1, LSL #1              ; r3 = row + (row<<1) = 3*row
    ADD     r3, r3, r0                      ; index = r3 = row*3 + col

    ; Calcula o endereço do elemento field[index]
    LDR     r4, =field                      ; Carrega o endereço base do array field
    ADD     r4, r4, r3                      ; Endereço final = base + index

    STRB    r2, [r4]                        ; Grava o caractere em field[index]

    LDMFD   SP!, {r3, r4, PC}               ; Restaura r3, r4 e lr da pilha e retorna

/*
Subrotina: is_empty - Verifica se uma posição está vazia
Entradas:
    r0 = coluna
    r1 = linha
; Saídas:
    r3 = 1 se a casa estiver vazia, 0 caso contrário
*/
is_empty:
    STMFD   SP!, {r4, r5, LR}               ; Salva temporários na pilha

    ; Calcula índice = row*3 + col
    ADD     r4, r1, r1, LSL #1              ; r4 = row*3
    ADD     r4, r4, r0                      ; index = r4 = row*3 + col

    LDR     r5, =field                      ; endereço base
    LDRB    r5, [r5, r4]                    ; r5 = field[index]

    CMP     r5, #' '                        ; verifica se é espaço vazio (caractere espaço: ' ')
    MOVEQ   r3, #1                          ; se vazio -> r3 = 1
    MOVNE   r3, #0                          ; se ocupado -> r3 = 0

    LDMFD   SP!, {r4, r5, PC}               ; Restaura temporários e retorna

/*
Subrotina: toggle_player - Alterna o jogador atual entre 0 (X) e 1 (O)
Entradas: (nenhuma)
Saídas:
    r4 = jogador atual (0 para X, 1 para O)
    r2 = marcador atual ('X' ou 'O')
*/
toggle_player:
    STMFD   SP!, {LR}                       ; Salva LR na pilha

    EOR     r4, r4, #1                      ; Alterna jogador: 0 -> 1, 1 -> 0
    CMP     r4, #0                          ; Verifica o jogador atual
    MOVEQ   r2, #'X'                        ; Se jogador 0, caractere = 'X'
    MOVNE   r2, #'O'                        ; Se jogador 1, caractere = 'O'

    LDMFD   SP!, {PC}                       ; Restaura LR da pilha e retorna

/*
Subrotina: check_sequence - Verifica se existe uma sequência de três 'X' ou 'O'
Entradas:
    r0 = ponteiro para o campo do jogo da velha (field)
    r1 = ponteiro para a sequência de 3 índices a ser verificada (win_seq)
Saída: r5 = 0 -> nenhum vencedor
            1 -> jogador X venceu
            2 -> jogador O venceu
*/
check_sequence:
    STMFD SP!, {r2, r3, LR}

    ; Carrega i
    LDRB    r2, [r1]                        ; Carrega a primeira posição da sequência (índice i) - i = win_seq[0]
    LDRB    r2, [r0, r2]                    ; Carrega o valor da célula i ('X' ou 'O' ou ' ') - i = field[i]
    CMP     r2, #' '                        ; Verifica se é espaço vazio - i == ' ' ?
    BEQ     no_win                          ; Se for vazio, não há vitória

    ; Carrega j
    LDRB    r3, [r1, #1]                    ; Carrega a segunda posição da sequência (índice j) - j = win_seq[1]
    LDRB    r3, [r0, r3]                    ; Carrega o valor da célula j ('X' ou 'O' ou ' ') - j = field[j]
    CMP     r2, r3                          ; Compara i e j - i == j ?
    BNE     no_win                          ; Se i != j (X e O ou O e X), não há vitória

    ; Carrega k
    LDRB    r3, [r1, #2]                    ; Carrega a terceira posição da sequência (índice k) - k = win_seq[2]
    LDRB    r3, [r0, r3]                    ; Carrega o valor da célula k ('X' ou 'O' ou ' ') - k = field[k]
    CMP     r2, r3                          ; Compara i e k - i == k ?
    BNE     no_win                          ; Se i != k (X e O ou O e X), não há vitória

    ; Vitória encontrada
    CMP     r2, #'X'                        ; Verifica se o vencedor é 'X'
    MOVEQ   r5, #1                          ; Se for 'X', retorna 1
    MOVNE   r5, #2                          ; Se for 'O', retorna 2
    B       done

no_win:
    MOV     r5, #0

done:
    LDMFD   SP!, {r2, r3, PC}

/*
Subrotina: check_winner - Verifica se há um vencedor no jogo da velha percorrendo todas as sequências
    possíveis de vitória (linhas, colunas e diagonais).
Entrada: field - vetor do campo do jogo da velha
         win_seq - vetor com as sequências de índices a serem verificadas
Saída: r5 = 0 -> nenhum vencedor
            1 -> jogador X venceu
            2 -> jogador O venceu
*/
check_winner:
    STMFD   SP!, {r0-r2, LR}                ; Salva registradores na pilha

    LDR     r0, =field                      ; r0 = ponteiro para field
    LDR     r1, =win_seq                    ; r1 = ponteiro para win_seq
    MOV     r2, #0                          ; r2 = contador de sequências (0 a 7)

next_seq:
    BL      check_sequence                  ; r5 = resultado da verificação da sequência
    CMP     r5, #0                          ; verifica se houve vencedor
    BNE     done_sequences                  ; se r5 != 0, tem vencedor -> sai retornando r5

    ADD     r1, r1, #3                      ; Atualiza r1 para próxima sequência (3 bytes)
    ADD     r2, r2, #1                      ; Incrementa contador
    CMP     r2, #8                          ; condição de parada: 8 sequências percorridas
    BLT     next_seq                        ; se r2 < 8, continua verificando

    MOV     r5, #0                          ; nenhum vencedor

done_sequences:
    LDMFD SP!, {r0-r2, PC}                  ; Restaura registradores da pilha e retorna

/*
Subrotina: check_draw - Verifica se o jogo terminou em empate (todas as casas preenchidas)
Entrada: field - vetor do campo do jogo da velha
Saída: r5 = 0 -> não cheio
            3 -> empate
*/
check_draw:
    STMFD   SP!, {r1-r2, LR}                ; Salva registradores na pilha
    LDR     r0, =field                      ; r0 = ponteiro para field
    MOV     r1, #0                          ; índice inicial

check_loop:
    LDRB    r2, [r0, r1]                    ; Carrega valor da célula atual
    CMP     r2, #' '                        ; Verifica se está vazia
    BEQ     not_full                        ; Se houver espaço vazio, não é empate
    ADD     r1, r1, #1                      ; Incrementa o índice
    CMP     r1, #9                          ; Verificou todas as 9 casas?
    BLT     check_loop                      ; Se não, continua o loop

    MOV     r5, #3                          ; Se chegou aqui, o campo está cheio -> empate
    B       done_draw

not_full:
    MOV     r5, #0                          ; Ainda há casas livres

done_draw:
    LDMFD   SP!, {r1-r2, PC}                ; Restaura registradores da pilha e retorna

/*
Subrotina: display_turn - Imprime no LCD a vez do jogador atual
Entrada: r4 = jogador atual (0 para X, 1 para O)
Saída: imprime o caractere X ou O na posição apropriada no LCD
*/
display_turn:
    STMFD SP!, {r0-r2, LR}                  ; Salva temporários e LR

    CMP r4, #0
    MOVEQ r2, #'X'                          ; Se r4 == 0, vez do jogador X
    MOVNE r2, #'O'                          ; Se r4 != 0, vez do jogador O

    MOV r1, #4                              ; Imprime na linha 4
    MOV r0, #15                             ; Imprime na coluna 15
    SWI LCD_DISPLAY_CHAR

    LDMFD SP!, {r0-r2, PC}                  ; Restaura registradores e retorna

/*
Subrotina: display_turn_msg - Imprime a mensagem "Vez do Jogador" no LCD
Entrada: (nenhuma)
Saída: imprime a string no LCD na posição fixa
*/
display_turn_msg:
    STMFD SP!, {r0-r2, LR}                  ; salva registradores

    LDR r2, =msg_turn                       ; r2 = endereço da string
    MOV r1, #4                              ; Imprime na linha 4
    MOV r0, #0                              ; a partir da coluna 0
    SWI LCD_DISPLAY_STRING                  ; imprime a string no LCD

    LDMFD SP!, {r0-r2, PC}                  ; restaura registradores

/*Subrotina: display_winner - Imprime no LCD a mensagem do jogador vencedor
Entrada: r5 = jogador vencedor (1 para X, 2 para O, 3 para empate)
Saída: imprime no LCD mensagem do vencedor
*/
display_winner:
    STMFD   SP!, {r0-r2, LR}

    CMP     r5, #1
    BEQ     winner_x                        ; Se r5 == 1, jogador X venceu

    CMP     r5, #2
    BEQ     winner_o                        ; Se r5 == 2, jogador O venceu

    CMP     r5, #3
    BEQ     draw

    B       done_winner

winner_x:
    LDR     r2, =msg_win_x                  ; Carrega "Jogador X venceu!"
    B       print_msg

winner_o:
    LDR     r2, =msg_win_o                  ; Carrega "Jogador O venceu!"
    B       print_msg

draw:
    LDR     r2, =msg_draw                   ; Carrega "Empate!"

print_msg:
    MOV     r1, #4                          ; Imprime na linha 4
    MOV     r0, #0                          ; A partir da coluna 0
    SWI     LCD_DISPLAY_STRING

done_winner:
    LDMFD   SP!, {r0-r2, PC}

.data
field:      .byte ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
win_seq:    .byte 0,1,2, 3,4,5, 6,7,8, 0,3,6, 1,4,7, 2,5,8, 0,4,8, 2,4,6
empty_line: .asciz "[_][_][_]"
msg_turn:   .asciz "Vez do jogador"
msg_win_x:  .asciz "Jogador X venceu!"
msg_win_o:  .asciz "Jogador O venceu!"
msg_draw:   .asciz "Empate!"

.end