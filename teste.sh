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