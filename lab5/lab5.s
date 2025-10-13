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

