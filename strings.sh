#!/bin/bash

main() {
#	Substring
#		-	seja uma string um uma variavel str="string"
#		-	${str:inicio}
#		-	${str:inicio:fim}
#		-	Os índices podem ser negativos. Nesse caso, conta apartir da direita para esquerda
#		-	Pode ser utilizado com arrays, mas retorna os elementos dos índices como uma única string
#		-	${str%padrao} deleta da string apartir do primeiro match, da direita para esquerda, em diante
#		-	${str%%padrao} deleta da string apartir do último match, da direita para esquerda, em diante
#		-	${str#padrao} deleta da string apartir do primeiro match, da esquerda para a direita, em diante
#		-	${str##padrao} deleta da string apartir do primeiro match, da esquerda para a direita, em diante

#	strlen
#		-	seja str="string"
#		-	${#str} retorna o tamanho da string

#	Bracer expansion
#		-	{} pode ser usado para delimitar uma variável para uma String
#		-	ou para executar um comando várias vezes com vários argumentos comando {arg1,arg2,..,argn}
#		-	ou para gerar strings em um intervalo $(echo {a..z})

	str="string"
	strlen "$str"

	file="arquivo.tar.gz"
	filename "$file"

}

strlen() {

	echo "Str length ${#1}"

}

filename() {

	echo "Nome do arquivo ${1%%.*}"

}

main
