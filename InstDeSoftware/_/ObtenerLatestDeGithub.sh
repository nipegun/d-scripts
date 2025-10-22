#!/bin/bash

    # Obtener el tag de la última release del repo de Github
      echo ""
      echo "    Obteniendo el tag de la última release del repo de Github..."
      echo ""
      # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install curl
          echo ""
        fi
      # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install jq
          echo ""
        fi
      curl -s https://api.github.com/repos/Nombre/Repo/releases/latest | jq -r '.tag_name'
