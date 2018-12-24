main() {
# Algumas considerações:
#   - Piline é o nome que se dá para uma série de comandos concatenados por pipes
#   - Pipes pode ser: "|" ou "|&"
#   - Pipes redirecionam a saída de um comando para o próximo comando
#   - "|" redireciona o Standard Input (stdin) para o próximo comando
#   - stdin é saída para caso o comando execute com sucesso
#   - "|&" redireciona o stdin e Standard Error (stderr) para o próximo comando
#   -  stderr é a saída para caso o comando execute com falha
#   -  > redireciona o stdout do comando para um arquivo e substitui seu conteúdo
#   -  >> redireciona o stdout do comando e concatena com o final do arquivo
#   -  2> redireciona o stderr do comando para um arquivo e substitui seu conteúdo
#   -  2>> redireciona o stderr do comando e concatena com o final do arquivo
#   -  < lê um arquivo e o direciona como parâmetro para outro comandos
#   -  &> redireciona tanto stdout quanto sterr para um arquivo
#   -  File descriptors são índices que o shell mantém para os arquivos que estão abertos
#   -  stdin, stdout e stderr possuem file descriptors 1, 2 e 3 respectivamente
#   -  M>N, onde M é um file descriptor, com valor padrão de 1, e N é um filename
#   -  M>&N, onde M é um file descriptor e &N é outro file descriptor

}

main
