main() {
# Algumas considerações:
#   - Piline é o nome que se dá para uma série de comandos concatenados por pipes
#   - Pipes pode ser: "|" ou "&|"
#   - Pipes redirecionam a saída de um comando para o próximo comando
#   - "|" redireciona o Standard Input (stdin) para o próximo comando
#   - stdin é saída para caso o comando execute com sucesso
#   - "&|" redireciona o stdin e Standard Error (stderr) para o próximo comando
#   -  stderr é a saída para caso o comando execute com falha

  echo "Redirecionando o stdin de um comando para o próximo"
  ls -l | grep "pipeline.sh"

  echo "Nada será redirecionado, pois o arquivo não existe e comando ls -l termina em erro"
  ls -l | grep "naoexiste.sh"

  echo "Redirecionando a saída mesmo com erro, pois &| foi usado"
  ls -l "naoexiste.sh" | cat

}

main
