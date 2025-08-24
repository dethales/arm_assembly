.global _start                      ; Declara _start como símbolo global (ponto de entrada)
.equ PRINT_STRING_STDOUT, 0x02      ; Define constante para imprimir string na saída padrão
.equ EXIT, 0x11                     ; Define constante para sair do programa

.text                               ; Seção de código executável
_start:                             ; Ponto de entrada do programa
    LDR R0, =hello_msg              ; Carrega endereço da string em R0
    SWI PRINT_STRING_STDOUT         ; Interrupção para imprimir string apontada por R0

    SWI EXIT                        ; Interrupção para encerrar programa

.data                               ; Seção de dados inicializados
hello_msg: .asciz "Hello, World!\n" ; String terminada em null com quebra de linha