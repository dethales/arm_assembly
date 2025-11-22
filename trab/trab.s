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
_start:

    SWI     LCD_CLEAR_SCREEN                ; Limpa a tela do LCD
    BL      draw_field                      ; Desenha o campo de jogo vazio

game_loop:
    BL      wait_keypad                     ; Caprura o botão pressionado (r0=linha, r1=coluna)
    BL      draw_x                          ; Desenha o X na posição do botão pressionado
    B       game_loop                       ; Repete o loop do jogo

    SWI     EXIT                            ; Encerra o programa

; Subrotina: Desenha o campo do jogo da velha vazio no LCD
draw_field:
    STMFD   SP!, {LR}                       ; Salva o LR na pilha

    ; Desenha a 1ª linha vazia
    MOV     r0, #0                          ; Posição X inicial
    MOV     r1, #0                          ; Posição Y inicial
    LDR     r2, =empty_line                 ; Carrega o endereço da linha vazia
    SWI     LCD_DISPLAY_STRING

    ; Repete para a 2ª linha
    MOV     r1, #1
    SWI     LCD_DISPLAY_STRING

    ; Repete para a 3ª linha
    MOV     r1, #2
    SWI     LCD_DISPLAY_STRING

    LDMFD   SP!, {PC}                       ; Restaura o lr da pilha e retorna

; Subrotina: Calcula a posição (x, y) no LCD para determinada célula (row, col) no campo e
; desenha na posição o caractere r2
; Entrada:
;   r0 = row   (y)
;   r1 = col   (x-base)
;   r2 = caractere
draw_at_position:
    STMFD   SP!, {r0, r1, r3, LR}           ; Salva r0, r1, r2 e lr na pilha

    ADD     r1, r1, r1, LSL #1              ; Calcula x = 3*col + 1   (col está em r1)
    ADD     r1, r1, #1                      ; r1 = 3*col + 1 → x

    ; troca r0 ↔ r1 (para SWI receber (x,y))
    MOV     r3, r0                          ; r3 <- row
    MOV     r0, r1                          ; r0 <- x
    MOV     r1, r3                          ; r1 <- row = y

    SWI     LCD_DISPLAY_CHAR                ; Desenha o caractere r2 no LCD na posição (x, y) = (r0, r1)

    LDMFD   SP!, {r0, r1, r3, PC}           ; Restaura r0, r1, r2 e LR da pilha e retorna

; Subrotina: Desenha um X no campo designado row=r0, col=r1
draw_x:
    STMFD   SP!, {r2, LR}                   ; Salva r2 e lr na pilha

    MOV     r2, #'X'                        ; Carrega o caractere 'X' em r2
    BL      draw_at_position                ; Desenha o X na posição r0, r1

    LDMFD   SP!, {r2, PC}                   ; Restaura r2 e lr da pilha

; Subrotina: Desenha um O no campo designado x=r0, y=r1
draw_o:
    STMFD   SP!, {r2, LR}                   ; Salva r2 e lr na pilha
    MOV     r2, #'O'                        ; Carrega o caractere 'O' em r2
    BL      draw_at_position                ; Desenha o O na posição r0, r1
    LDMFD   SP!, {r2, PC}                   ; Restaura r2 e lr da pilha e retorna

; Subrotina: Aguarda até que um dos 9 botões do teclado seja pressionado e
;            retorna o índice (row, col) do botão pressionado em (r0, r1)
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
    MOV     r0, r2, LSR #2                  ; row = bit / 4
    AND     r1, r2, #3                      ; col = bit % 4
    LDMFD   SP!, {r2, r3, PC}               ; Restaura temporários e retorna

.data
empty_line: .asciz "[_][_][_]"


.end