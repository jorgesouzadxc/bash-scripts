#!/bin/bash

main() {
# Consideraçoes
#   - O while usa os mesmo operadores condicionais do if

# Bash conditional expressions
#   - -a arquivo existe
#   - -d diretório existe
#   - -f arquivo existe e é regular
#   - -r arquivo existe e é legível
#   - -x arquivo existe e é executável
#   - file1 -nt -file2 arquivo 1 é mais novo que arquivo 2, ou se arquivo 1 existe e arquivo 2 não
#   - file1 -ot -file2 arquivo 1 é mais velho que arquivo 2, ou se arquivo 2 existe e arquivo 1 função
#   - -v variável variável tem um valor assiginado a declaradas
#   - -z string verdadeiro se o tamanho da string for 0
#   - -n string verdadeiro se o tamanho da string for diferente de 0
#   - ! inverte o valor booleano

# Operadores de comparação aritméticos
#   - arg1 -gt arg2 arg1 maior que arg2
#   - arg1 -eq arg2 arg1 é igual a arg2
#   - arg1 -lt arg2 arg1 é menor arg2
#   - arg1 -ne arg2 arg1 não é igual a arg2
#   - arg1 -ge arg2 arg1 é maior ou igual a arg2
#   - arg1 -le arg2 arg1 é menor ou igual a arg2
i=1
while [ $i -le 10 ]
do
  echo $i
  ((i++))
done

}

main
