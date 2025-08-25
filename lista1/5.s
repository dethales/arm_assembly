.global _start
.equ PRINT_STRING_STDOUT, 0x02
.equ EXIT, 0x11                 ; Código iterrupt para sair do programa

.text
_start:
    LDR R0, =start_msg
    SWI PRINT_STRING_STDOUT

    LDR R1, =start_value
    LDR R2, #20
    BL mult

mult:

.data
start_msg: .asciz "Início de Programa\n"
start_value: .word 100