#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Node.js en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Node.js-InstalarYConfigurar.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Node.js-InstalarYConfigurar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Node.js-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Node.js-InstalarYConfigurar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update && apt-get -y install curl
    echo ""
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Node.js para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Node.js para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

  # Crear el menú
    menu=(dialog --checklist "Instalando Node.js - Marca la versión deseada:" 22 96 16)
      opciones=(
        1 "Versión disponible en los repositorios oficiales de Debian" off
        2 "Última versión LTS, directamente"                           on
        3 "Última versión LTS, mediante nvm"                           off
        4 "Versión Current"                                            off
        5 "x"                                                          off
      )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando la versión de Node.js disponible en los repositorios oficiales de Debian..."
            echo ""
            sudo apt-get -y update
            sudo apt-get -y install nodejs
            sudo apt-get -y install npm

            # Notificar fin de instalación
              vNodeJS=$(node -v | cut  -d'v' -f2)
              echo ""
              echo "    Se ha instalado la versión $vNodeJS de Node.js."
              echo ""

           # Probar la instalación
             # Crear el archivo de configuración del servidor
               echo ""                                                      > /tmp/ServidorPrueba.js 
               echo "var http = require('http');"                          >> /tmp/ServidorPrueba.js
               echo "var server = http.createServer(function(req, res) {"  >> /tmp/ServidorPrueba.js
               echo 'res.write("Servidor http Node.js de prueba!\n");'     >> /tmp/ServidorPrueba.js
               echo "res.end();"                                           >> /tmp/ServidorPrueba.js
               echo "}).listen(8081);"                                     >> /tmp/ServidorPrueba.js
             # Lanzar el servidor
               node /tmp/ServidorPrueba.js &
             # Notificar el servidor de pruebas corriendo
               echo ""
               echo "      Se ha creado y ejecutado el servidor http de prueba en /tmp/ServidorPrueba.js."
               echo "        Para acceder: http://localhost:8081"
               vNumProcSP=$(jobs | grep "/tmp/ServidorPrueba.js" | cut -d'[' -f2 | cut -d']' -f1)
               echo "        Para detenerlo: kill %$vNumProcSP"
               echo ""
               echo "      Si la web del servidor se ve, es que Node.js se ha instalado correctamente."
               echo ""

          ;;

          2)

            echo ""
            echo "  Instalando la versión LTS de Node.js directamente..."
            echo ""

            # Instalar paquetes necesarios para la correcta ejecución del script
              sudo apt-get -y update
              sudo apt-get -y install curl 2> /dev/null
              sudo apt-get -y install jq   2> /dev/null

            # Determinar la última versión LTS de Node.js
              vUltVersLTSdeNodeJS=$(curl -s https://nodejs.org/dist/index.json | jq -r 'map(select(.lts != null)) | .[] | select(.lts == "Jod") | .version' | head -n1)

            # Descargar el archivo comprimido
              cd /tmp
              curl -L https://nodejs.org/dist/"$vUltVersLTSdeNodeJS"/node-"$vUltVersLTSdeNodeJS"-linux-x64.tar.xz -O

            # Descomprimir el archivo
              tar -vxJf node-"$vUltVersLTSdeNodeJS"-linux-x64.tar.xz

            # Mover carpeta descomprimida
              sudo mv node-"$vUltVersLTSdeNodeJS"-linux-x64 /usr/local/nodejs

            # Crear los enlaces simbólicos
              sudo ln -s /usr/local/nodejs/bin/node /usr/bin/node
              sudo ln -s /usr/local/nodejs/bin/npm  /usr/bin/npm

            # Comprobando instalación
              node -v
              npm -v

          ;;

          3)

            echo ""
            echo "  Instalando la versión LTS de Node.js mediante nvm..."
            echo ""

            # Instalar nvm
              echo ""
              echo "    Instalando nvm..."
              echo ""
              curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/NodeVersionManager-Instalar.sh | sudo bash

            # Cargar las opciones de shell de nvm
              \. "$HOME/.nvm/nvm.sh"

            # Instalar Node.js LTS
              nvm install 22

          ;;

          4)

            echo ""
            echo "  Instalando la versión Current de Node.js..."
            echo ""

          ;;

          5)

            echo ""
            echo "  Opción 5..."
            echo ""

          ;;

      esac

  done

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Node.js para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Node.js para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Node.js para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Node.js para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Node.js para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
