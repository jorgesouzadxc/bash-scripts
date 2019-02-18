#!/bin/bash
#   Script para compactação de N pastas quaisquer
#   Para execução
#   -   Precisa ser executado como root
#   -   É necessário passar como parâmetro a(s) pasta(s) que serão compactadas

#   Grava um arquivo de log, dado um nome de arquivo e pasta para salvamento
#   Parâmetros:
#       $1 - diretório para salvamento do arquivo de log
#       $2 - nome do arquivo de log
write_log() {

    local dir_logs="$1"
    local fn_log="$2"
    local temp_log_to_write="$temp_log"

    temp_log=""

    log "Gravando arquivo de log $fn_log"
    echo -e "$temp_log_to_write" > "${dir_logs}/${fn_log}"
    
    return "$?"
    
}

#   Ao receber uma string, concatena com o prefixo [INFO] e printa no console
#   guarda a string numa variável global "temp_log" para que posteriormente
#   possa ser gerado o arquivo de log a partir dessa variável
#   Parâmetros:
#       $1 - String a ser adicionada ao log
log() {

    local msg="[INFO] $1"
    echo "$msg"
    temp_log+="$msg\n"

}

#   Ao receber uma string, concatena com o prefixo [ERR] e printa no console
#   guarda a string numa variável global "temp_log" para que posteriormente
#   possa ser gerado o arquivo de log a partir dessa variável
#   Parâmetros:
#       $1 - String a ser adicionada ao log
logerr() {

    local msg="[ERR] $1"
    echo "$msg"
    temp_log+="$msg\n"

}

#   Cria as pastas para salvamento de backup e log, caso ainda não existam
#   Parâmetros:
#       $1 - diretório para salvamento de backups
#       $2 - diretório para salvamento de logs
create_folders() {

    local dir_backup="$1"
    local dir_logs="$2"

    if [ ! -d "$dir_backup" ]
    then
        log "Diretório de backup não existe."
        log "Criando diretório de backup."
        mkdir "$dir_backup"
        if [ $? == 0 ]
        then
            log "Diretório de backup criado: $dir_backup"
        else
            logerr "Falha ao criar diretório de backup em: $dir_backup"
            return 1
        fi
    fi

    if [ ! -d "$dir_logs" ]
    then
        log "Diretório de logs não existe."
        log "Criando diretório de logs."
        mkdir "$dir_logs"
        if [ $? == 0 ]
        then
            log "Diretório de logs criado: $dir_logs"
        else
            logerr "Falha ao criar diretório de logs em: $dir_logs"
            return 1
        fi
    fi

    return 0

}

#   Criar um arquivo compactado com a extensão .tar.gz e o move para o diretório de backup
#   Parâmetros:
#       $1 - diretório para backup
#       $2 - nome do arquivo de backup
#       $3 - diretório para o qual será movido o arquivo gerado
compact() {

    local dir="$1"
    local fn_backup="$2"
    local dir_backup="$3"
    local dir_current="$(pwd)"

    if [ ! -d "$dir" ]
    then
        logerr "Diretório para backup não existe: $dir"
        return 1
    fi

    tar -pcvzf "$fn_backup" "$dir"
    if [ "$?" == "0" ]
    then
        log "Arquivo ${fn_backup} gerado com sucesso"
    elif [ $? != 0 ] && [ -f "${dir_current}/${fn_backup}" ]
    then
        log "Arquivo ${fn_backup} gerado com sucesso, mas com falhas."
    else
        logerr "Erro ao gerar ${fn_backup}"
        return 1
    fi

    mv "${dir_current}/${fn_backup}" "$dir_backup"
    if [ $? == 0 ]
    then
        log "Arquivo ${fn_backup} movido para ${dir_backup}"
    else
        logerr "Falha ao mover arquivo ${fn_backup} para ${dir_backup}"
        return 1
    fi

    return 0

}

#   Controla o fluxo do script, faz a verificação e seta parâmetros que serão
#   utilizados nas demais funções
#   Parâmetros:
#       $@ - Array contendo as N pastas as quais serão feitas o backup
main() {

    if [ -z "${#@}" ]
    then
        echo "Parâmetro de diretório para backup não suprido"
        echo "Usagem deste script"
        echo "$0 [diretório1, diretório2, ... , diretórioN]"
        return 1
    fi

    if [ "$EUID" -ne 0 ]
    then
        echo "Este escript precisa ser executado com privilégios de root"
        return 1
    fi

    dir_backup="/home/backup"
    dir_logs="${dir_backup}/logs"

    for dir in "$@"
    do

        time_stamp=$(date +"%d-%m-%Y-%H-%M-%S")
        if [ -z "${dir##*/}" ]
        then
            fn_backup="backup_${dir%%/}_${time_stamp}.tar.gz"
        else
            fn_backup="backup_${dir##*/}_${time_stamp}.tar.gz"
        fi

        fn_log="${fn_backup%%.*}.log"

        log "Início da execução para o diretório $dir"

        create_folders "$dir_backup" "$dir_logs"
        if (( $? != 0 ))
        then
            logerr "Erro durante a criação de pastas"
            write_log "$dir_logs" "$fn_log"
            continue
        fi

        compact "$dir" "$fn_backup" "$dir_backup"
        if [ $? != 0 ]
        then
            logerr "Erro durante a criação do arquivo de backup"
            write_log "$dir_logs" "$fn_log"
            continue
        fi

        write_log "$dir_logs" "$fn_log"
        if [ $? != 0 ]
        then
            echo "Erro ao gravar log ${fn_log} em ${dir_logs} (Log não salvo)"
        fi

    done

    return 0

}

main "$@"