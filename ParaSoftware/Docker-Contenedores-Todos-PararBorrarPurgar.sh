#!/bin/bash

# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/Docker-Contenedores-Todos-PararBorrarPurgar.sh | bash

set -e

fPararContenedores() {
  sudo docker ps -q | while read vContenedor; do
    sudo docker stop "$vContenedor"
  done
}

fBorrarContenedores() {
  sudo docker ps -aq | while read vContenedor; do
    sudo docker rm "$vContenedor"
  done
}

fBorrarImagenes() {
  sudo docker images -q | sort -u | while read vImagen; do
    sudo docker rmi -f "$vImagen"
  done
}

fBorrarVolumenes() {
  sudo docker volume ls -q | while read vVolumen; do
    sudo docker volume rm -f "$vVolumen"
  done
}

fBorrarRedes() {
  sudo docker network ls -q | while read vRed; do
    case "$vRed" in
      bridge|host|none) ;;
      *) sudo docker network rm "$vRed" ;;
    esac
  done
}

fPararContenedores
fBorrarContenedores
fBorrarImagenes
fBorrarVolumenes
fBorrarRedes

