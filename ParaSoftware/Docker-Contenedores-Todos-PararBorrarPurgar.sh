#!/bin/bash

set -e

fPararContenedores() {
  docker ps -q | while read vContenedor; do
    docker stop "$vContenedor"
  done
}

fBorrarContenedores() {
  docker ps -aq | while read vContenedor; do
    docker rm "$vContenedor"
  done
}

fBorrarImagenes() {
  docker images -q | sort -u | while read vImagen; do
    docker rmi -f "$vImagen"
  done
}

fBorrarVolumenes() {
  docker volume ls -q | while read vVolumen; do
    docker volume rm -f "$vVolumen"
  done
}

fBorrarRedes() {
  docker network ls -q | while read vRed; do
    case "$vRed" in
      bridge|host|none) ;;
      *) docker network rm "$vRed" ;;
    esac
  done
}

fPararContenedores
fBorrarContenedores
fBorrarImagenes
fBorrarVolumenes
fBorrarRedes
