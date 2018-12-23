#!/bin/bash
var2="Valor de var2"
local var3="Valor de var 3"

function main {

# Algumas considerações:
#  - As variáveis declaradas como locais funcionam apenas dentro de sua função
#  - As variáveis têm escopo padrão global, e podem ser acessadas mesmo fora de funções

  local var1="Variável local"
  echo "Valor de var 1, visivel dentro do escopo: ${var1}"

  echo "Valor para var 2, visível pois o escopo é global: ${var2}"
  echo "Valor para var 3, invisível pois seu escopo é local: ${var3}"

}

main

echo "Nenhum valor para var1, pois está fora do escopo: ${var1}"
