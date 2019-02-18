#!/bin/bash

function variaveis {
# Expansão de parâmetros
#   - ${!prefixo*} printa todas as variáveis que começam com o prefixo
#   - ${var:-valorpadrao} usa o valor da variavel para o valor padrao, caso ele seja vazio
#   - ${var:=valorpadrao} seta o valor da variavel para o valor padrao, caso ele não tenha sido setado
#   - ${var:?msg_err} se existir valor na variavel, usa-a, caso contrário, printa uma mensagem de erro


  declare varn
  echo ${varn:-"teste de teste"}
  varn="varlo de var n"
  echo "Valor: ${varn:-valor}"

  echo "Declaração de variáveis"
  var1="Hello World"
  echo ou
  var2="Hello World2"

  echo "Acesso ao valor das variáveis"
  echo $var1
  echo ${var1}
  echo "Onde $var1 é um atalho para ${var1}"

  echo "Concatenação de variávies"
  newVar1="${var1} é o novo valor para var1"
  echo $newVar1

}

function arrays {

  # Algumas considerações sobre Arrays:
  # - Arrays são 0 indexados em Shell Script
  # - Para acessar um array completamente, utiliza-se ${array[@]}
  # - Para acessar os elementos de um array indexado ${array[i]}
  # - Para acessar os elementos de um array associativo ${array[chave]}
  # - Para acessar o número de elementos de um array (length), ${#array[@]}
  # - Declaração explícita de arrays:
  #   - declare -a array Para array associativos
  #   - declare -A array Para array indexado
  # - Para inicializar um array: array=(elem1 elem2 ... elemN)
  # - Para recuperar os indícies ou chaves de um array indexado/associativo, utiliza-se: ${!array[@]} ou ${!array[*]}

  echo "Array são declarados das seguintes formas:"
  echo "Para arrays indexados:"
  declare -a array1
  echo "Para arrays associativos:"
  declare -A array2

  echo "Atribuição de valores:"
  echo "Array indexado:"
  array1=("Hello" "World")

  echo "Array Associativo"
  array2=([num1]=1 [num2]=10)

  echo "Acessando o valor de um elemento em particular:"
  echo "Indexado:"
  echo "${array1[1]}"

  echo "Associativo:"
  echo "${array2[num2]}"

  echo "Iterar por um array indexado:"
  for i in "${array1[@]}"
  do
    echo "$i"
  done

  #Nota: Itera pelos valores, e ignora as chaves
  echo "Iterar por um array associativo"
  for i in "${array2[@]}"
  do
    echo "$i"
  done

  #Nota: Itera pelas chaves
  echo "Iterar pelas chaves de um array associativo:"
  for i in "${!array2[@]}"
  do
    echo $i
  done

  echo "Printar um array completamente"
  printf "Elemento %s\n" "${array1[@]}"
  echo "ou"
  echo "${array1[@]}"

  echo "Iterando por um array fazendo uso de índice"
  array1len=${#array1[@]}
  echo "Tamanho do array: ${#array1[@]}"

  for ((i=1; i < ${array1len}+1; i++))
  do
    echo ${i} " / " $array1len " : " ${array1[$i-1]}
  done

  echo "Adicionando elementos a um array:"
  elem="Elemento a ser adicionado"

  echo "Array indexado:"
  echo "Array1 antes: ${array1[@]}"
  array1+=($elem)
  echo "Array1 depois: ${array1[@]}"

  echo "Array associativo:"
  echo "Array2 antes: ${array2[@]}"
  array2[num1]+=$elem
  echo "Array1 depois: ${array2[@]}"

}

function main {

  variaveis
  arrays

}

main
exit 0
