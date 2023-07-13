#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar Proxmox Backup Server en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Proxmox-BackupServer-Instalar.sh | bash
# ----------

ColorAzul="\033[0;34m"
ColorVerde='\033[1;32m'
ColorRojo='\033[1;31m'
FinColor='\033[0m'

# Determinar la versión de Debian

  if [ -f /etc/os-release ]; then
    # Para systemd y freedesktop.org
      . /etc/os-release
      OS_NAME=$NAME
      OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
      OS_NAME=$(lsb_release -si)
      OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then
    # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
      OS_NAME=$DISTRIB_ID
      OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then
    # Para versiones viejas de Debian.
      OS_NAME=Debian
      OS_VERS=$(cat /etc/debian_version)
  else
    # Para el viejo uname (También funciona para BSD)
      OS_NAME=$(uname -s)
      OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Proxmox Backup Server para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Proxmox Backup Server para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Proxmox Backup Server para Debian 9 (Stretch)..."
  echo "------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Proxmox Backup Server para Debian 10 (Buster)..."
  echo "------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Proxmox Backup Server para Debian 11 (Bullseye)..."
  echo "--------------------------------------------------------------------------------------------"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${ColorRojo}  dialog no está instalado. Iniciando su instalación...${FinColor}"
      echo ""
      apt-get -y update > /dev/null
      apt-get -y install dialog
      echo ""
    fi
  menu=(dialog --timeout 10 --checklist "Instalación de Proxmox Backup Server" 22 76 16)
    opciones=(
      1 "Instalar en un Debian nativo o en una MV de Debian." off
      2 "Instalar en un contenedor LXC de Debian." off
      3 "" off
    )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
    clear

    for choice in $choices
      do
        case $choice in

          1)

            # Bajar e instalar la llave
              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${ColorRojo}    wget no está instalado. Iniciando su instalación...${FinColor}"
                  echo ""
                  apt-get -y update
                  apt-get -y install wget
                  echo ""
                fi
              wget https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg

            # Establecer repositorios
              # Agregar el repositorio enterprise y comentarlo
                echo "#deb https://enterprise.proxmox.com/debian/pbs bullseye pbs-enterprise" > /etc/apt/sources.list.d/pbs-enterprise.list
              # Agregar el repositorio para no suscriptores
                echo "deb http://download.proxmox.com/debian/pbs bullseye pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list
              # Agregar el repositorio test y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs bullseye pbstest" > /etc/apt/sources.list.d/pbstest.list
              # Agregar el repositorio client y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs-client bullseye main" > /etc/apt/sources.list.d/pbs-client.list

            # Actualizar el caché de paquetes
              apt-get -y update

            # Instalar cambiando el kernel (Agrega soporte ZFS) (Igual que la instalación del ISO)
              apt-get -y install proxmox-backup

            # Volver a establecer repositorios
              # Agregar el repositorio enterprise y comentarlo
                echo "#deb https://enterprise.proxmox.com/debian/pbs bullseye pbs-enterprise" > /etc/apt/sources.list.d/pbs-enterprise.list
              # Agregar el repositorio para no suscriptores
                echo "deb http://download.proxmox.com/debian/pbs bullseye pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list
              # Agregar el repositorio test y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs bullseye pbstest" > /etc/apt/sources.list.d/pbstest.list
              # Agregar el repositorio client y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs-client bullseye main" > /etc/apt/sources.list.d/pbs-client.list

            # Actualizar todo el sistema
              apt-get -y update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get -y autoremove

            echo ""
            echo -e "${ColorVerde}  Instalación finalizada.${FinColor}"
            echo ""
            echo -e "${ColorVerde}  Conéctate a la administración Web en mediante la siguiente URL en LAN:${FinColor}"
            echo ""
            echo "  https://$(hostname -I | sed 's- --g'):8007"
            echo ""

          ;;

          2)

            # Bajar e instalar la llave
              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${ColorRojo}    wget no está instalado. Iniciando su instalación...${FinColor}"
                  echo ""
                  apt-get -y update
                  apt-get -y install wget
                  echo ""
                fi
              wget https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg

            # Establecer repositorios
              # Agregar el repositorio enterprise y comentarlo
                echo "#deb https://enterprise.proxmox.com/debian/pbs bullseye pbs-enterprise" > /etc/apt/sources.list.d/pbs-enterprise.list
              # Agregar el repositorio para no suscriptores
                echo "deb http://download.proxmox.com/debian/pbs bullseye pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list
              # Agregar el repositorio test y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs bullseye pbstest" > /etc/apt/sources.list.d/pbstest.list
              # Agregar el repositorio client y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs-client bullseye main" > /etc/apt/sources.list.d/pbs-client.list

            # Actualizar el caché de paquetes
              apt-get -y update

            # Instalar Proxmox Backup Server manteniendo el kernel instalado (Apto para contenedores)
              apt-get -y install proxmox-backup-server

            # Volver a establecer repositorios
              # Agregar el repositorio enterprise y comentarlo
                echo "#deb https://enterprise.proxmox.com/debian/pbs bullseye pbs-enterprise" > /etc/apt/sources.list.d/pbs-enterprise.list
              # Agregar el repositorio para no suscriptores
                echo "deb http://download.proxmox.com/debian/pbs bullseye pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list
              # Agregar el repositorio test y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs bullseye pbstest" > /etc/apt/sources.list.d/pbstest.list
              # Agregar el repositorio client y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs-client bullseye main" > /etc/apt/sources.list.d/pbs-client.list

            # Actualizar todo el sistema
              apt-get -y update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get -y autoremove

            echo ""
            echo -e "${ColorVerde}  Instalación finalizada.${FinColor}"
            echo ""
            echo -e "${ColorVerde}  Conéctate a la administración Web en mediante la siguiente URL en LAN:${FinColor}"
            echo ""
            echo "  https://$(hostname -I | sed 's- --g'):8007"
            echo ""

          ;;

          3)

          ;;
        
        esac

      done

elif [ $OS_VERS == "12" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Proxmox Backup Server para Debian 12 (Bookworm)..."
  echo "--------------------------------------------------------------------------------------------"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${ColorRojo}  dialog no está instalado. Iniciando su instalación...${FinColor}"
      echo ""
      apt-get -y update > /dev/null
      apt-get -y install dialog
      echo ""
    fi
  menu=(dialog --timeout 10 --checklist "Instalación de Proxmox Backup Server" 22 76 16)
    opciones=(
      1 "Instalar en un Debian nativo o en una MV de Debian." off
      2 "Instalar en un contenedor LXC de Debian." off
      3 "" off
    )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
    clear

    for choice in $choices
      do
        case $choice in

          1)

            # Bajar e instalar la llave
              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${ColorRojo}    El paquete wget no está instalado. Iniciando su instalación...${FinColor}"
                  echo ""
                  apt-get -y update
                  apt-get -y install wget
                  echo ""
                fi
              wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg

            # Establecer repositorios
              # Agregar el repositorio enterprise y comentarlo
                echo "#deb https://enterprise.proxmox.com/debian/pbs bookworm pbs-enterprise" > /etc/apt/sources.list.d/pbs-enterprise.list
              # Agregar el repositorio para no suscriptores
                echo "deb http://download.proxmox.com/debian/pbs bookworm pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list
              # Agregar el repositorio test y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs bookworm pbstest" > /etc/apt/sources.list.d/pbstest.list
              # Agregar el repositorio client y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs-client bookworm main" > /etc/apt/sources.list.d/pbs-client.list

            # Actualizar el caché de paquetes
              apt-get -y update

            # Instalar cambiando el kernel (Agrega soporte ZFS) (Igual que la instalación del ISO)
              apt-get -y install proxmox-backup

            # Volver a establecer repositorios
              # Agregar el repositorio enterprise y comentarlo
                echo "#deb https://enterprise.proxmox.com/debian/pbs bookworm pbs-enterprise" > /etc/apt/sources.list.d/pbs-enterprise.list
              # Agregar el repositorio para no suscriptores
                echo "deb http://download.proxmox.com/debian/pbs bookworm pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list
              # Agregar el repositorio test y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs bookworm pbstest" > /etc/apt/sources.list.d/pbstest.list
              # Agregar el repositorio client y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs-client bookworm main" > /etc/apt/sources.list.d/pbs-client.list

            # Actualizar todo el sistema
              apt-get -y update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get -y autoremove

            echo ""
            echo -e "${ColorVerde}  Instalación finalizada.${FinColor}"
            echo ""
            echo -e "${ColorVerde}  Conéctate a la administración Web en mediante la siguiente URL en LAN:${FinColor}"
            echo ""
            echo "  https://$(hostname -I | sed 's- --g'):8007"
            echo ""

          ;;

          2)

            # Bajar e instalar la llave
              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${ColorRojo}    El paquete wget no está instalado. Iniciando su instalación...${FinColor}"
                  echo ""
                  apt-get -y update
                  apt-get -y install wget
                  echo ""
                fi
              wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg

            # Establecer repositorios
              # Agregar el repositorio enterprise y comentarlo
                echo "#deb https://enterprise.proxmox.com/debian/pbs bookworm pbs-enterprise" > /etc/apt/sources.list.d/pbs-enterprise.list
              # Agregar el repositorio para no suscriptores
                echo "deb http://download.proxmox.com/debian/pbs bookworm pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list
              # Agregar el repositorio test y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs bookworm pbstest" > /etc/apt/sources.list.d/pbstest.list
              # Agregar el repositorio client y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs-client bookworm main" > /etc/apt/sources.list.d/pbs-client.list

            # Actualizar el caché de paquetes
              apt-get -y update

            # Instalar Proxmox Backup Server manteniendo el kernel instalado (Apto para contenedores)
              apt-get -y install proxmox-backup-server

            # Volver a establecer repositorios
              # Agregar el repositorio enterprise y comentarlo
                echo "#deb https://enterprise.proxmox.com/debian/pbs bookworm pbs-enterprise" > /etc/apt/sources.list.d/pbs-enterprise.list
              # Agregar el repositorio para no suscriptores
                echo "deb http://download.proxmox.com/debian/pbs bookworm pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list
              # Agregar el repositorio test y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs bookworm pbstest" > /etc/apt/sources.list.d/pbstest.list
              # Agregar el repositorio client y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs-client bookworm main" > /etc/apt/sources.list.d/pbs-client.list

            # Actualizar todo el sistema
              apt-get -y update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get -y autoremove

            echo ""
            echo -e "${ColorVerde}  Instalación finalizada.${FinColor}"
            echo ""
            echo -e "${ColorVerde}  Conéctate a la administración Web en mediante la siguiente URL en LAN:${FinColor}"
            echo ""
            echo "  https://$(hostname -I | sed 's- --g'):8007"
            echo ""

          ;;

          3)

          ;;
        
        esac

      done

fi

