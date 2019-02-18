funcao() {

	output+=$(cat nexiste) || return

}

funcao
echo $?
#if output+=$(funcao); then echo sim; else echo nao; fi
#output+=$(funcao) || return
#echo $output
