#!/bin/bash

main() {

  home_dir="/home/$(whoami)"
  backup_dir="/home/backup"
  log_dir="${backup_dir}/logs"

  time_stamp=$(date +"%d-%m-%Y-%H-%M-%S")
  file_name="$(whoami)-${time_stamp}.tar.gz"
  log_file="backup-$(whoami)-${file_name%%.*}.log"
  temp_log_dir="/home/backup"

  init "$home_dir" "$backup_dir" "$log_dir"

  log
  log "Inicio"

  compactacao "$home_dir" "$file_name" "$backup_dir"

  log "Fim"
  log

  mv "${temp_log_dir}/temp.log" "${log_dir}/$log_file"

}

init() {

  home_dir="/home/$(whoami)"
  backup_dir="/home/backup"
  log_dir="${backup_dir}/logs"

  if [ ! -d "$home_dir" ]
  then
    log "Não há diretório home"
    exit 1
  fi

  if [ ! -d "$backup_dir" ]
  then
    log "Criando diretório de backup"
    mkdir "$backup_dir"
    if [ "$?" == "0" ]
    then
      log "Diretório $backup_dir criado com sucesso"
    else
      log "Diretório $backup_dir não criado com sucesso"
      exit 1
    fi
  fi

  if [ ! -d "$log_dir" ]
  then
    log "Criando diretório de log"
    mkdir "$log_dir"
    if [ "$?" == "0" ]
    then
      log "Diretório $log_dir criado com sucesso"
    else
      log "Diretório $log_dir não criado com sucesso"
      exit 1
    fi
  fi

  touch "${log_dir}/${log_file}"
  if [ "$?" != "0" ]
  then
    echo log "Não conseguiu criar arquivo de log em ${log_dir}/${log_file}"
  fi

}

compactacao() {

  home_dir="$1"
  file_name="$2"
  backup_dir="$3"

  cd "$backup_dir"
  if [ "$?" != "0" ]
  then
    log "Não conseguiu acessar o diretório de backup"
    exit 1
  fi

  log "Início do processo de compactação"
  tar -pcvzf "$file_name" "$home_dir" &> /dev/null
  if [ "$?" == "0" ]
  then
     log "Arquivo ${backup_dir}/${file_name} criado com sucesso!"
  else
    log "Erro compactar ${home_dir}"
    exit 1
  fi

}

log() {

  temp_log="/home/backup/temp.log"

  if [ -z "$1" ]
  then
    msg="===================="
    echo "$msg"
    echo "$msg" >> "$temp_log"
  else
    msg="[LOG] $1"
    echo "$msg"
    echo "$msg" >> "$temp_log"
  fi

}

main
exit 0
