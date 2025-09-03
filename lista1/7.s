/*
7) Faça um programa em Assembly/ARM de forma legível (com comentários) que 
imprime no stdout números aleatórios num intervalo de 200 ms. Os registradores 
deverão ler todas as variáveis (intervalo e strings) da área data. Usar a 
diretiva SWI_GetTicks. Não precisa usar arquivo externo. Parte do programa 
está descrito abaixo com uso da diretiva:

@ esse programa gera números aleatórios num intervalo de 200 milissegundos
.equ SWI_GetTicks, 0x06d
...
...
...
@ atraso definido em r2 que espera por 200 milissegundos
atraso:
    stmfd sp!, {r0-r1, lr} @Salva registradores no ponto de execução do programa
    swi SWI_GetTicks
    mov r7, r0 @r7 - tempo de partida
Loop:
    swi SWI_GetTicks
    subs r0, r0, r7 @ r0: tempo de partida depois de iniciado
    rsblt r0, r0, #0 @ fixar subtração sem sinal
...
...
...
*/