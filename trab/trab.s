/* Trabalho de Arquitetura de Computadores
Thales Coutinho Layber e Pedro Belizário */

.equ PRINT_CHAR_STDOUT,     0x00            ; Chamada de sistema para imprimir caractere
.equ PRINT_STRING_STDOUT,   0x02            ; Chamada de sistema para imprimir string
.equ STDOUT,                0x01            ; Identificador do dispositivo de saída padrão
.equ EXIT,                  0x11            ; Chamada de sistema para encerrar o programa
.equ LCD_DISPLAY_STRING,    0x204           ; Chamada de sistema para exibir string no LCD
.equ LCD_DISPLAY_CHAR,      0x207           ; Chamada de sistema para exibir caractere no LCD
.equ LCD_CLEAR_SCREEN,      0x206           ; Chamada de sistema para limpar a tela do LCD
.equ LCD_CLEAR_LINE,        0x208           ; Chamada de sistema para limpar a linha do LCD
.equ READ_KEYPAD,           0x203           ; Chamada de sistema para ler o teclado de botões azuis
.equ LCD_WIDTH,     40
.equ LCD_HEIGHT,    15

.text
/* Variaveis globais:
    r0 = coluna
    r1 = linha
    r2 = caractere
*/
_start:

    SWI     LCD_CLEAR_SCREEN                ; Limpa a tela do LCD
    BL      draw_field                      ; Desenha o campo de jogo vazio

game_loop:
    BL      wait_keypad                     ; Caprura o botão pressionado (r0=coluna, r1=linha)
    BL      draw_x                          ; Desenha o X na posição do botão pressionado
    MOV     r2, #'X'                        ; Carrega o caractere 'X' em r2
    BL      store_move
    B       game_loop                       ; Repete o loop do jogo

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
Subrotina: draw_at_position - Calcula a posição (x, y) no LCD para determinada célula (col, row) no campo e 
    desenha na posição o caractere r2
Entradas:
    r0 = coluna
    r1 = linha
    r2 = caractere
Saídas:
    Desenha o caractere r2 na posição (x, y) correspondente no LCD
*/
draw_at_position:
    STMFD   SP!, {r0, LR}                   ; Salva LR na pilha

    ADD     r0, r0, r0, LSL #1              ; Calcula x = 3*col + 1   (col está em r0)
    ADD     r0, r0, #1                      ; r0 = 3*col + 1 → x

    SWI     LCD_DISPLAY_CHAR                ; Desenha o caractere r2 no LCD na posição (x, y) = (r0, r1)

    LDMFD   SP!, {r0, PC}                   ; Restaura LR da pilha e retorna

/*
Subrotina: draw_x - Desenha um X no campo designado
Entradas:
    r0 = coluna
    r1 = linha
Saídas: 
    Desenha o X na posição r0, r1
*/
draw_x:
    STMFD   SP!, {r2, LR}                   ; Salva r2 e lr na pilha

    MOV     r2, #'X'                        ; Carrega o caractere 'X' em r2
    BL      draw_at_position                ; Desenha o X na posição r0, r1

    LDMFD   SP!, {r2, PC}                   ; Restaura r2 e lr da pilha

/*
Subrotina: draw_o - Desenha um O no campo designado
Entradas:
    r0 = coluna
    r1 = linha
Saídas: Desenha o O na posição r0, r1
*/
draw_o:
    STMFD   SP!, {r2, LR}                   ; Salva r2 e lr na pilha
    MOV     r2, #'O'                        ; Carrega o caractere 'O' em r2
    BL      draw_at_position                ; Desenha o O na posição r0, r1
    LDMFD   SP!, {r2, PC}                   ; Restaura r2 e lr da pilha e retorna

/*
Subrotina: wait_keypad - Aguarda até que um dos 9 botões do teclado seja pressionado e
 retorna o índice (col, row) do botão pressionado em (r0, r1)
Entradas:
    Botão do teclado azul pressionado
Saídas:
    r0 = coluna
    r1 = linha
*/
wait_keypad:
    STMFD   SP!, {r2, r3, LR}               ; preserva temporários

poll_loop:
    SWI     READ_KEYPAD                     ; r0 = resultado da leitura do teclado
    LDR     r3, =0x777                      ; r3 = Máscara para botões válidos (0,1,2 / 4,5,6 / 8,9,10)
    AND     r0, r0, r3                      ; Mantém bits 0,1,2 / 4,5,6 / 8,9,10 (r0= r0 & r3)
    CMP     r0, #0                          ; Verifica se algum botão válido foi pressionado
    BEQ     poll_loop                       ; Nenhum botão -> continua esperando
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

.data
empty_line: .asciz "[_][_][_]"
field:      .byte ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '

.end