#!/bin/bash

main() {
# Escopo aritmético
#   - O escopo aritmético é usado para fazer expressões aritméticas em shell script
#   - Ao abrir um escopo aritmético o valor das variáveis é tratado como números inteiros
#   - Para abrir um escopo aritmético usa-se ((expressão))
#   - Nele, podem ser usados os operadores lógicos e artiméitcos no estilo linguagem C
#   - Lógicos: == != || &&
#   - Aritméticos: = + - * / % ** += -= var++ ++var var-- --var
#   - Os operadores lógicos também podem ser utilizados para avaliar strings
#   - Variáveis podem ser declaradas dentro do contexto aritmético
#   - Loops for e whi

num1=20
num2=40


((result = num1 + num2))
echo $result

for ((i=1; i<=5; i++))
do
    echo $i
done

echo "I: $i"
i=0
while ((i<5))
do
    echo $i
    ((i++))
done

}

main