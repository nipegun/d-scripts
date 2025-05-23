#!/bin/bash

# https://github.com/hashtopolis/server/wiki/Installation

# Crear la carpeta
  mkdir hashtopolis
  cd hashtopolis

# Descargar archivos
  curl -L https://raw.githubusercontent.com/hashtopolis/server/master/docker-compose.yml -O
  curl -L https://raw.githubusercontent.com/hashtopolis/server/master/env.example -O

# Modificar el environment
  mv env.example .env
  vIPLocal=$(hostname -I | sed 's- --g')
  sed -i -e "s-localhost-$vIPLocal-g" .env

# Levantar el contenedor
  # Comprobar si el paquete docker-compose está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s docker-compose 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete docker-compose no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install docker-compose
      echo ""
    fi
  docker-compose up -d

# Notificar fin de ejecución del script
  echo ""
  echo "  Ejecución del script, finalizada. Para configurar el servicio accede a:"
  echo ""
  echo "    http://$vIPLocal:8080" 
  echo ""
  echo "    Usuario: admin"
  echo "    Contraseña: hashtopolis"
  echo ""
