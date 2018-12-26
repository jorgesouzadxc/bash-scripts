#!/bin/bash

main() {

  log
  log "Inicio"

  compactacao

  log "Fim"
  log

}

compactacao() {

  home_dir="/home/$(whoami)"
  file_name="$(whoami).tar.gz"
  backup_dir="/home/backup"

  echo "Home dir $home_dir"
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

  if cd "$backup_dir"
  then
    log "Caminho atual mudado para $backup_dir"
  else
    log "Não conseguiu acessar o diretório"
    exit 1
  fi


  tar -pcvzf "$file_name" "$home_dir"
  if [ "$?" == 0 ]
  then
     log "Arquivo ${backup_dir}/${file_name} criado com sucesso!"
  else
    log "Erro compactar ${home_dir}"
    exit 1
  fi

}

log() {

  if [ -z "$1" ]
  then
    echo "---------------------"
  else
    echo "[LOG] $1"
  fi

}

main
exit 0
