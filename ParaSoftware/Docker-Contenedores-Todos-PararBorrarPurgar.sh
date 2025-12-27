#!/bin/bash

# Ejecución remota (puede requerir permisos sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/Docker-Contenedores-Todos-PararBorrarPurgar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/Docker-Contenedores-Todos-PararBorrarPurgar.sh | sed 's-sudo--g' | bash

set -e

fPararContenedores() {
  echo ""
  echo "  Intentando parar todos los contenedores Docker..."
  echo ""
  sudo docker ps -q | while read vContenedor; do
    sudo docker stop "$vContenedor"
  done
}

fBorrarContenedores() {
  echo ""
  echo "  Intentando borrar todos los contenedores Docker..."
  echo ""
  sudo docker ps -aq | while read vContenedor; do
    sudo docker rm "$vContenedor"
  done
}

fBorrarImagenes() {
  echo ""
  echo "  Intentando borrar todas las imagenes de contenedores Docker..."
  echo ""
  sudo docker images -q | sort -u | while read vImagen; do
    sudo docker rmi -f "$vImagen"
  done
}

fBorrarVolumenes() {
  echo ""
  echo "  Intentando borrar todos los volúmenes de contenedores Docker..."
  echo ""
  sudo docker volume ls -q | while read vVolumen; do
    sudo docker volume rm -f "$vVolumen"
  done
}

fBorrarRedes() {
  echo ""
  echo "  Intentando borrar todas las redes de Docker..."
  echo ""
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
