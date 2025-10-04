#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Wazuh en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/SIEM-Wazuh-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/SIEM-Wazuh-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/SIEM-Wazuh-Instalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Wazuh para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Wazuh para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Determinar la última versión disponible
      echo ""
      echo "    Determinando la última versión disponible..."
      echo ""
      vUltVersWazuh=$(curl -sL https://documentation.wazuh.com/current/release-notes/index.html | sed 's->->\n-g' | grep href | grep release | grep internal | head -n1 | sed 's|release-||g' | cut -d'.' -f1 | cut -d'"' -f4 | sed 's|-|.|g')
      echo "      La última versión disponible es la $vUltVersWazuh"
      echo ""

    # Instalar
      vUltVersSanitizada=$(echo "$vUltVersWazuh" | cut -d. -f1-2)
      echo ""
      echo "    Instalando la versión $vUltVersSanitizada..."
      echo ""
      cd /tmp
      sudo rm -f wazuh-install*.sh* 2> /dev/null
      curl -sLO https://packages.wazuh.com/"$vUltVersSanitizada"/wazuh-install.sh
      chmod +x /tmp/wazuh-install.sh
      # Instalar
        # Comprobar si el paquete sudo está instalado. Si no lo está, instalarlo.
          if [[ $(dpkg-query -s sudo 2>/dev/null | grep installed) == "" ]]; then
            echo ""
            echo -e "${cColorRojo}      El paquete sudo no está instalado. Iniciando su instalación...${cFinColor}"
            echo ""
            sudo apt-get -y update
            sudo apt-get -y install sudo
            echo ""
          fi
        sudo /tmp/wazuh-install.sh -a

    # Deshabilitar actualizaciones
      echo ""
      echo "    Deshabilitando actualizaciones..."
      echo ""
      sudo sed -i "s/^deb /#deb /" /etc/apt/sources.list.d/wazuh.list
      sudo apt-get -y update 2> /dev/null

    # Notificar fin de ejecución del script
      echo ""
      echo "    Ejecución del script, finalizada. Accede al panel de Wazuh en:"
      echo ""
      vIPLocal=$(hostname -I | sed 's- --g')
      echo "      https://$vIPLocal"
      echo ""
      echo "    Si quieres ver las contraseñas de todos los usuarios de Wazuh indexer y Wazuh API puedes hacerlo de la siguiente manera:"
      echo ""
      echo "      sudo tar -O -xvf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt"
      echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Wazuh para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Wazuh para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Wazuh para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Wazuh para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Wazuh para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
