<<<<<<< HEAD
funcao() {

	output+=$(cat nexiste) || return

}

funcao
echo $?
#if output+=$(funcao); then echo sim; else echo nao; fi
#output+=$(funcao) || return
#echo $output
=======
#!/bin/bash

main() {

    logsDir="/home/backup/logs/"
    declare -a allFiles=($(ls ${logsDir}))
    declare -a arr

    for file in "${allFiles[@]}"
    do
        echo "${logsDir}${file}"
        arr=($(tail -20 ${logsDir}${file} | grep [ERRO] | - ${file}))
    done

    echo ${arr[@]}
    
}

main
>>>>>>> be6b5c10d53f817f3d50cbdc860cf5c44b16e84e
