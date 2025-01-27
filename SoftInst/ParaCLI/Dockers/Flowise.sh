#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar Flowise en el DockerCE de Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Dockers/Flowise.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Dockers/Flowise.sh | sed 's-sudo--g' | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD)
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "13" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Flowise en el DockerCE de Debian 13 (x)..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 13 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Flowise en el DockerCE de Debian 12 (Bookworm)..." 
  echo ""

  # Crear el menú
    # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "    El paquete dialog no está instalado. Iniciando su instalación..."
        echo ""
        sudo apt-get -y update
        sudo apt-get -y install dialog
        echo ""
      fi
    menu=(dialog --checklist "¿Donde quieres instalar MediaWiki?:" 22 76 16)
      opciones=(
        1 "En un ordenador o máquina virtual" off
        2 "En un contenedor LXC de Proxmox"   off
      )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

        1)

          echo ""
          echo -e "${cColorVerde}  Instalando Flowise en un ordenador o máquina virtual...${cFinColor}"
          echo ""
          sudo mkdir -p /Contenedores/Flowise/data 2> /dev/null

          echo ""
          echo "  Creando el comando para iniciar el contenedor docker..."
          echo ""
          echo '#!/bin/bash'                                       | sudo tee    /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh
          echo ""                                                  | sudo tee -a /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh
          echo "docker run -d --restart=always                 \\" | sudo tee -a /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh
          echo "  --name Flowise                               \\" | sudo tee -a /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh
          echo "  -p 3000:3000                                 \\" | sudo tee -a /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh
          echo "  -v /var/run/docker.sock:/var/run/docker.sock \\" | sudo tee -a /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh
          echo "  -v /Contenedores/Flowise/data:/data          \\" | sudo tee -a /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh
          echo "  flowiseai/flowise:latest"                        | sudo tee -a /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh
          sudo chmod +x                                                          /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh
              
          echo ""
          echo "  Creando el comando post arranque..."
          echo ""
          echo "/root/scripts/DockerCE-Cont-Iniciar-Flowise.sh" | sudo tee -a /root/scripts/ComandosPostArranque.sh
          echo ""
          echo "  Iniciando el container por primera vez..."
          echo ""
          sudo /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh

        ;;

        2)

          echo ""
          echo -e "${cColorVerde}  Instalando Flowise en un contenedor LXC...${cFinColor}"
          echo ""
          sudo mkdir -p /Host/Flowise/data 2> /dev/null

          echo ""
          echo "  Creando el comando para iniciar el contenedor docker..."
          echo ""
          echo '#!/bin/bash'                                       | sudo tee    /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh
          echo ""                                                  | sudo tee -a /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh
          echo "docker run -d --restart=always                 \\" | sudo tee -a /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh
          echo "  --name Flowise                               \\" | sudo tee -a /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh
          echo "  -p 3000:3000                                 \\" | sudo tee -a /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh
          echo "  -v /var/run/docker.sock:/var/run/docker.sock \\" | sudo tee -a /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh
          echo "  -v /Host/Flowise/data:/data                  \\" | sudo tee -a /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh
          echo "  flowiseai/flowise:latest"                        | sudo tee -a /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh
          sudo chmod +x                                                          /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh

          echo ""
          echo "  Creando el comando post arranque..."
          echo ""
          echo "/root/scripts/DockerCE-Cont-Iniciar-Flowise.sh" | sudo tee -a /root/scripts/ComandosPostArranque.sh

          echo ""
          echo "  Iniciando el container por primera vez..."
          echo ""
          sudo /root/scripts/DockerCE-Cont-Iniciar-Flowise.sh

        ;;
        
      esac

    done

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Flowise en el DockerCE de Debian 11 (Bullseye)..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Flowise en el DockerCE de Debian 10 (Buster)..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Flowise en el DockerCE de Debian 9 (Stretch)..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Flowise en el DockerCE de Debian 8 (Jessie)..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Flowise en el DockerCE de Debian 7 (Wheezy)..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

fi
