/* Trabalho de Arquitetura de Computadores
Thales Coutinho Layber e Pedro Belizário */

; Definições de constantes para chamadas de sistema
.equ PRINT_CHAR_STDOUT,     0x00
.equ PRINT_STRING_STDOUT,   0x02
.equ STDOUT,                0x01
.equ EXIT,                  0x11

; Definições de constantes para chamadas de sistema do LCD Embest
.equ LCD_DISPLAY_STRING,    0x204
.equ LCD_DISPLAY_CHAR,      0x207
.equ LCD_CLEAR_SCREEN,      0x206
.equ LCD_CLEAR_LINE,        0x208

.equ LCD_WIDTH,     40
.equ LCD_HEIGHT,    15

.text
_start:

    SWI     LCD_CLEAR_SCREEN                ; Limpa a tela do LCD
    BL      draw_field                      ; Desenha o campo de jogo vazio

    MOV     r0, #0                          ; Posição X do campo (coluna 0)
    MOV     r1, #0                          ; Posição Y do campo (linha 0)
    BL      compute_lcd_position            ; Converte para coordenadas LCD
    BL      draw_x                          ; Desenha um X na posição calculada

    MOV     r0, #0                          ; Posição X do campo (coluna 0)
    MOV     r1, #1                          ; Posição Y do campo (linha 1)
    BL      compute_lcd_position            ; Converte para coordenadas LCD
    BL      draw_o                          ; Desenha um O na posição calculada

    SWI     EXIT                            ; Encerra o programa

; Subrotina: Desenha o campo do jogo da velha vazio no LCD
draw_field:
    STMFD   sp!, {lr}                       ; Salva o link register na pilha
    MOV     r0, #0                          ; Posição X inicial
    MOV     r1, #0                          ; Posição Y inicial
    LDR     r2, =empty_line                 ; Carrega o endereço da linha vazia
    SWI     LCD_DISPLAY_STRING              ; Desenha a linha vazia
    MOV     r1, #1                          ; Repete para a 2ª linha
    SWI     LCD_DISPLAY_STRING              ; Desenha a linha vazia
    MOV     r1, #2                          ; Repete para a 3ª linha
    SWI     LCD_DISPLAY_STRING              ; Desenha a linha vazia
    LDMFD   sp!, {pc}                       ; Restaura o lr da pilha e retorna

; Subrotina: Desenha um X no campo designado x=r0, y=r1
draw_x:
    STMFD   sp!, {r2, lr}                   ; Salva r2 e lr na pilha
    MOV     r2, #'X'                        ; Carrega o caractere 'X' em r2
    BL      draw_at_position                ; Desenha o X na posição r0, r1
    LDMFD   sp!, {r2, lr}                   ; Restaura r2 e lr da pilha
    MOV     pc, lr                          ; Retorna ao chamador

; Subrotina: Desenha um O no campo designado x=r0, y=r1
draw_o:
    STMFD   sp!, {r2, lr}                   ; Salva r2 e lr na pilha
    MOV     r2, #'O'                        ; Carrega o caractere 'O' em r2
    BL      draw_at_position                ; Desenha o O na posição r0, r1
    LDMFD   sp!, {r2, pc}                   ; Restaura r2 e lr da pilha e retorna

; Subrotina: Calcula a posição no LCD para o campo designado x=r0, y=r1 e desenha na posição o caractere r2
draw_at_position:
    STMFD   sp!, {r0, r1, lr}               ; Salva r0, r1 e lr na pilha
    ADD     r0, r0, r0, lsl #1              ; r0 = X + (X << 1) = 3*X
    ADD     r0, r0, #1                      ; r0 = 3*X + 1 (agora X está na coordenada LCD)
    SWI     LCD_DISPLAY_CHAR                ; Desenha o caractere r2 no LCD na posição r0, r1
    LDMFD   sp!, {r0, r1, pc}               ; Restaura r0, r1 e lr da pilha e retorna

.data
empty_line: .asciz "[_][_][_]"

.end