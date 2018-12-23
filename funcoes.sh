#!/bin/bash

variaveis() {

  echo "Valor do parâmetro 1: $1"
  echo "Printa todos os parâmetros $*"
  #printf "%s\n" "$@"
  echo "$@"
  echo "$#"

}

main() {

  var1="v1"
  var2="v2"
  var3="v3"
  array=("v4" "v5" "v6")

  variaveis "${var1}" "${var2}" "${var3}"

}

main
