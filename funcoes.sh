#!/bin/bash

variaveis() {

# Algumas considerações:
#   - A variável FUNCNAME guarda o nome da função

# Special Parameters
#   - A variável # guarda o número de argumentos da função
#   - A variável @ guarda todos os argumentos da função em forma de Array1
#   - A variável * guarda todos os argumentos da função em forma de string separadas por " "
#   - A variável - guarda os flags de opção utilizados para chamada da função/script
#   - A variável $ guarda o ID de processo do shell. Em um subshell, guarda o ID do shell que o invocou
#   - A variável ! guarda o ID do último comando executado
#   - A variável 0 guarda o nome do script, caso executado pelo Bash. O caminho, caso executado via filesystem (./script.sh)
#   - A variável _ guarda o filepath absoluto para o script
#   - A variável ? guarda o resultado do último comando executado. 0 para sucesso, 1-255 para falha.

  echo "Valor do parâmetro 1: $1"
  echo "Valor do parâmetro 2: $2"
  echo "Valor do parâmetro 3: $3"
  echo "Printa todos os parâmetros como String: $*"
  printf "Printa todos os parâmetros como um array: %s\n" "$@"
  echo "Printa o número de parâmetros recebidos pelo script/função: $#"
  echo "Printa o nome da função: $FUNCNAME"

}

arrays() {
# Algumas considerações:
#   - Os arrays são passados para funções na sua forma expandida, isto é, como uma string separada por espações " ".
#     - Cada elemento do array é considerado como um parâmetro da função

  for elem in ${arrayP[@]}
  do
    echo "Elemento do array passado como parâmetro: $elem"
  done

# ou dessa forma:

  arrayP=("$@")
  printf "Elemento do array: %s\n" "${arrayP[@]}"

}

funcao_com_retorno() {

  if [ -z $1 ]
  then
    return 1
  else
    return 0
  fi

}

main() {

  var1="v1"
  var2="v2"
  var3="v3"
  array=("v4" "v5" "v6")

  variaveis "${var1}" "${var2}" "${var3}"
  arrays "${array[@]}"

  if funcao_com_retorno
  then
    echo "Funcionou!"
  else
    echo "Não funcionou"
  fi

  funcao_com_retorno && echo "Funcionou" || echo "Não funcionou"

}

main
