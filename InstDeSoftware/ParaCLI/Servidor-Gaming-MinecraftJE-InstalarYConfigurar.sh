#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar el servidor gaming de MinecraftJE (mcserver) en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Servidor-Gaming-MinecraftJE-InstalarYConfigurar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Servidor-Gaming-MinecraftJE-InstalarYConfigurar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Servidor-Gaming-MinecraftJE-InstalarYConfigurar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de MinecraftJE para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo "  Instalando dependencias..." 
    echo ""
    sudo dpkg --add-architecture i386
    sudo apt-get -y update
    sudo apt-get -y install mailutils
    sudo apt-get -y install postfix
    sudo apt-get -y install curl
    sudo apt-get -y install wget
    sudo apt-get -y install file
    sudo apt-get -y install tar
    sudo apt-get -y install bzip2
    sudo apt-get -y install gzip
    sudo apt-get -y install unzip
    sudo apt-get -y install bsdmainutils
    sudo apt-get -y install python3
    sudo apt-get -y install util-linux
    sudo apt-get -y install ca-certificates
    sudo apt-get -y install binutils
    sudo apt-get -y install bc
    sudo apt-get -y install jq
    sudo apt-get -y install tmux
    sudo apt-get -y install netcat-openbsd
    sudo apt-get -y install distro-info
    sudo apt-get -y install lib32gcc-s1
    sudo apt-get -y install pigz
    sudo apt-get -y install uuid-runtime
    sudo apt-get -y install 'lib32stdc++6'

    # Instalar la última versión de java
      # Determinar la última versión
        vUltVersJava=$(apt-cache search openjdk | grep jre | grep runtime | grep -v nvidia | grep -v headless | tail -n1 | cut -d' ' -f1)
      sudo apt-get -y install $vUltVersJava

    echo ""
    echo "  Dependencias instaladas."
    echo "  Revisa el script porque hay comandos que tendrás que ejecutar manualmente para terminar de instalar el servidor de MinecraftJE."
    echo ""

   # Crear usuario mcserver
      sudo useradd -m -d /opt/mcserver mcserver

    # Crear la carpeta
      sudo mkdir /opt/mcserver/
      sudo chown mcserver:mcserver /opt/mcserver/

    # Bajar script de instalación
      su - mcserver -c "wget -O  /opt/mcserver/linuxgsm.sh https://linuxgsm.sh"

    # Ejecutar selector de script
      su - mcserver -c "chmod +x /opt/mcserver/linuxgsm.sh"
      su - mcserver -c "bash     /opt/mcserver/linuxgsm.sh mcserver"

    # Instalar servidor
      su - mcserver -c "bash     /opt/mcserver/mcserver install"

    # Creando el script para lanzar
      echo '#!/bash'                      | sudo tee    /opt/mcserver/ServidorMC-Iniciar.sh
      echo ""                             | sudo tee -a /opt/mcserver/ServidorMC-Iniciar.sh
      echo "/opt/mcserver/mcserver start" | sudo tee -a /opt/mcserver/ServidorMC-Iniciar.sh
      sudo chmod +x /opt/mcserver/ServidorMC-Iniciar.sh

    # Reparar permisos
      chown mcserver:mcserver /opt/mcserver/ -Rv

    # Agregar el lanzador a los comandospost arranque
      echo 'su - mcserver -c /opt/mcserver/ServidorMC-Iniciar.sh' | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

    # Notificar fin del script
     echo ""
     echo "  Ejecución del script, finalizada."
     echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de MinecraftJE para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de MinecraftJE para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de MinecraftJE para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de MinecraftJE para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de MinecraftJE para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de MinecraftJE para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi

