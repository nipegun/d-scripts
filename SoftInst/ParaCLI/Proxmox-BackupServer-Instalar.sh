#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Proxmox Backup Server en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Proxmox-BackupServer-Instalar.sh | bash
# ----------

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    OS_NAME=$NAME
    OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    OS_NAME=$(lsb_release -si)
    OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    OS_NAME=$DISTRIB_ID
    OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    OS_NAME=Debian
    OS_VERS=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    OS_NAME=$(uname -s)
    OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Proxmox Backup Server para Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Proxmox Backup Server para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Proxmox Backup Server para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Proxmox Backup Server para Debian 10 (Buster)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Proxmox Backup Server para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update > /dev/null
      apt-get -y install dialog
      echo ""
    fi
  menu=(dialog --checklist "Instalación de Proxmox Backup Server" 22 76 16)
    opciones=(
      1 "Instalar en un Debian nativo o en una MV de Debian." off
      2 "Instalar en un contenedor LXC de Debian." off
    )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            # Bajar e instalar la llave
              echo ""
              echo "    Bajando e instalando la llave para firmar el repositorio de Proxmox..."
              echo ""
              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${vColorRojo}      El paquete wget no está instalado. Iniciando su instalación...${vFinColor}"
                  echo ""
                  apt-get -y update
                  apt-get -y install wget
                  echo ""
                fi
              wget https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg

            # Agregar los repositorios
              echo ""
              echo "    Agregando los repositorios..."
              echo ""
              # Agregar el repositorio enterprise y comentarlo
                echo "#deb https://enterprise.proxmox.com/debian/pbs bullseye pbs-enterprise" > /etc/apt/sources.list.d/pbs-enterprise.list
              # Agregar el repositorio para no suscriptores
                echo "deb http://download.proxmox.com/debian/pbs bullseye pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list
              # Agregar el repositorio test y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs bullseye pbstest" > /etc/apt/sources.list.d/pbstest.list
              # Agregar el repositorio client y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs-client bullseye main" > /etc/apt/sources.list.d/pbs-client.list

            # Actualizar la lista de paquetes disponibles en los repositorios
              echo ""
              echo "    Actualizando la lista de paquetes disponibles en los repositorios..."
              echo ""
              apt-get -y update

            # Instalar el paquete proxmox-backup (cambia el kernel y agrega sporte para ZFS) (Igual que la instalación del ISO)
              echo ""
              echo "    Instalando el paquete proxmox-backup (cambia el kernel y agrega sporte para ZFS)..."
              echo ""
              apt-get -y install proxmox-backup

            # Volver agregar los repositorios
              echo ""
              echo "    Volviendo a agregar los repositorios..."
              echo ""
              # Agregar el repositorio enterprise y comentarlo
                echo "#deb https://enterprise.proxmox.com/debian/pbs bullseye pbs-enterprise" > /etc/apt/sources.list.d/pbs-enterprise.list
              # Agregar el repositorio para no suscriptores
                echo "deb http://download.proxmox.com/debian/pbs bullseye pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list
              # Agregar el repositorio test y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs bullseye pbstest" > /etc/apt/sources.list.d/pbstest.list
              # Agregar el repositorio client y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs-client bullseye main" > /etc/apt/sources.list.d/pbs-client.list

            # Actualizar todo el sistema
              echo ""
              echo "    Actualizando todo el sistema..."
              echo ""
              apt-get -y update
              apt-get -y upgrade
              apt-get -y dist-upgrade
              apt-get -y autoremove

            echo ""
            echo -e "${vColorVerde}  Instalación finalizada.${vFinColor}"
            echo ""
            echo -e "${vColorVerde}  Conéctate a la administración Web en mediante la siguiente URL en LAN:${vFinColor}"
            echo ""
            echo "  https://$(hostname -I | sed 's- --g'):8007"
            echo ""

          ;;

          2)

            # Bajar e instalar la llave
              echo ""
              echo "    Bajando e instalando la llave para firmar el repositorio de Proxmox..."
              echo ""
              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${vColorRojo}    El paquete wget no está instalado. Iniciando su instalación...${vFinColor}"
                  echo ""
                  apt-get -y update
                  apt-get -y install wget
                  echo ""
                fi
              wget https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg

            # Agregar los repositorios
              echo ""
              echo "    Agregando los repositorios..."
              echo ""
              # Agregar el repositorio enterprise y comentarlo
                echo "#deb https://enterprise.proxmox.com/debian/pbs bullseye pbs-enterprise" > /etc/apt/sources.list.d/pbs-enterprise.list
              # Agregar el repositorio para no suscriptores
                echo "deb http://download.proxmox.com/debian/pbs bullseye pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list
              # Agregar el repositorio test y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs bullseye pbstest" > /etc/apt/sources.list.d/pbstest.list
              # Agregar el repositorio client y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs-client bullseye main" > /etc/apt/sources.list.d/pbs-client.list

            # Actualizar la lista de paquetes disponibles en los repositorios
              echo ""
              echo "    Actualizando la lista de paquetes disponibles en los repositorios..."
              echo ""
              apt-get -y update

            # Instalar el paquete proxmox-backup-server (no cambia el kernel y no tiene soporte para ZFS) (Apto para contenedores)
              echo ""
              echo "    Instalando el paquete proxmox-backup-server (no cambia el kernel y no tiene soporte para ZFS)..."
              echo ""
              apt-get -y install proxmox-backup-server

            # Volver a establecer repositorios
              echo ""
              echo "    Volviendo a estableceer los repositorios..."
              echo ""
              # Agregar el repositorio enterprise y comentarlo
                echo "#deb https://enterprise.proxmox.com/debian/pbs bullseye pbs-enterprise" > /etc/apt/sources.list.d/pbs-enterprise.list
              # Agregar el repositorio para no suscriptores
                echo "deb http://download.proxmox.com/debian/pbs bullseye pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list
              # Agregar el repositorio test y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs bullseye pbstest" > /etc/apt/sources.list.d/pbstest.list
              # Agregar el repositorio client y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs-client bullseye main" > /etc/apt/sources.list.d/pbs-client.list

            # Actualizar todo el sistema
              echo ""
              echo "    Actualizando todo el sistema..."
              echo ""
              apt-get -y update
              apt-get -y upgrade
              apt-get -y dist-upgrade
              apt-get -y autoremove

            echo ""
            echo -e "${vColorVerde}  Instalación finalizada.${vFinColor}"
            echo ""
            echo -e "${vColorVerde}  Conéctate a la administración Web en mediante la siguiente URL en LAN:${vFinColor}"
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
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Proxmox Backup Server para Debian 12 (Bookworm)...${vFinColor}"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update > /dev/null
      apt-get -y install dialog
      echo ""
    fi
  menu=(dialog --checklist "Instalación de Proxmox Backup Server" 22 76 16)
    opciones=(
      1 "Instalar en un Debian nativo o en una MV de Debian." off
      2 "Instalar en un contenedor LXC de Debian." off
    )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            # Bajar e instalar la llave
              echo ""
              echo "    Bajando e instalando la llave para firmar el repositorio de Proxmox..."
              echo ""
              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${vColorRojo}    El paquete wget no está instalado. Iniciando su instalación...${vFinColor}"
                  echo ""
                  apt-get -y update
                  apt-get -y install wget
                  echo ""
                fi
              wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg

            # Agregar los repositorios
              echo ""
              echo "    Agregando los repositorios..."
              echo ""
              # Agregar el repositorio enterprise y comentarlo
                echo "#deb https://enterprise.proxmox.com/debian/pbs bookworm pbs-enterprise" > /etc/apt/sources.list.d/pbs-enterprise.list
              # Agregar el repositorio para no suscriptores
                echo "deb http://download.proxmox.com/debian/pbs bookworm pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list
              # Agregar el repositorio test y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs bookworm pbstest" > /etc/apt/sources.list.d/pbstest.list
              # Agregar el repositorio client y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs-client bookworm main" > /etc/apt/sources.list.d/pbs-client.list

            # Actualizar la lista de paquetes disponibles en los repositorios
              echo ""
              echo "    Actualizando la lista de paquetes disponibles en los repositorios..."
              echo ""
              apt-get -y update

            # Instalar el paquete proxmox-backup (cambia el kernel y agrega sporte para ZFS) (Igual que la instalación del ISO)
              echo ""
              echo "    Instalando el paquete proxmox-backup (cambia el kernel y agrega sporte para ZFS)..."
              echo ""
              apt-get -y install proxmox-backup

            # Volver a agregar los repositorios
              echo ""
              echo "    Volviendo a agregar los repositorios..."
              echo ""
              # Agregar el repositorio enterprise y comentarlo
                echo "#deb https://enterprise.proxmox.com/debian/pbs bookworm pbs-enterprise" > /etc/apt/sources.list.d/pbs-enterprise.list
              # Agregar el repositorio para no suscriptores
                echo "deb http://download.proxmox.com/debian/pbs bookworm pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list
              # Agregar el repositorio test y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs bookworm pbstest" > /etc/apt/sources.list.d/pbstest.list
              # Agregar el repositorio client y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs-client bookworm main" > /etc/apt/sources.list.d/pbs-client.list

            # Actualizar todo el sistema
              echo ""
              echo "    Actualizando todo el sistema..."
              echo ""
              apt-get -y update
              apt-get -y upgrade
              apt-get -y dist-upgrade
              apt-get -y autoremove

            echo ""
            echo -e "${vColorVerde}  Instalación finalizada.${vFinColor}"
            echo ""
            echo -e "${vColorVerde}  Conéctate a la administración Web en mediante la siguiente URL en LAN:${vFinColor}"
            echo ""
            echo "  https://$(hostname -I | sed 's- --g'):8007"
            echo ""

          ;;

          2)
            # Bajar e instalar la llave
              echo ""
              echo "    Bajando e instalando la llave para firmar el repositorio de Proxmox..."
              echo ""
              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${vColorRojo}      El paquete wget no está instalado. Iniciando su instalación...${vFinColor}"
                  echo ""
                  apt-get -y update
                  apt-get -y install wget
                  echo ""
                fi
              wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg

            # Agregar los repositorios
              echo ""
              echo "    Agregando los repositorios..."
              echo ""
              # Agregar el repositorio enterprise y comentarlo
                echo "#deb https://enterprise.proxmox.com/debian/pbs bookworm pbs-enterprise" > /etc/apt/sources.list.d/pbs-enterprise.list
              # Agregar el repositorio para no suscriptores
                echo "deb http://download.proxmox.com/debian/pbs bookworm pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list
              # Agregar el repositorio test y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs bookworm pbstest" > /etc/apt/sources.list.d/pbstest.list
              # Agregar el repositorio client y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs-client bookworm main" > /etc/apt/sources.list.d/pbs-client.list

            # Actualizar la lista de paquetes disponibles en los repositorios
              echo ""
              echo "    Actualizando la lista de paquetes disponibles en los repositorios..."
              echo ""
              apt-get -y update

            # Instalar el paquete proxmox-backup-server (no cambia el kernel y no tiene soporte para ZFS) (Apto para contenedores)
              echo ""
              echo "    Instalando el paquete proxmox-backup-server (no cambia el kernel y no tiene soporte para ZFS)..."
              echo ""
              apt-get -y install proxmox-backup-server

            # Agregar a agregar los repositorios
              echo ""
              echo "    Volviendo a agregar los repositorios..."
              echo ""
              # Agregar el repositorio enterprise y comentarlo
                echo "#deb https://enterprise.proxmox.com/debian/pbs bookworm pbs-enterprise" > /etc/apt/sources.list.d/pbs-enterprise.list
              # Agregar el repositorio para no suscriptores
                echo "deb http://download.proxmox.com/debian/pbs bookworm pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list
              # Agregar el repositorio test y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs bookworm pbstest" > /etc/apt/sources.list.d/pbstest.list
              # Agregar el repositorio client y comentarlo
                echo "#deb http://download.proxmox.com/debian/pbs-client bookworm main" > /etc/apt/sources.list.d/pbs-client.list

            # Actualizar todo el sistema
              echo ""
              echo "    Actualizando el sistema..."
              echo ""
              apt-get -y update
              apt-get -y upgrade
              apt-get -y dist-upgrade
              apt-get -y autoremove

            echo ""
            echo -e "${vColorVerde}  Instalación finalizada.${vFinColor}"
            echo ""
            echo -e "${vColorVerde}  Conéctate a la administración Web en mediante la siguiente URL en LAN:${vFinColor}"
            echo ""
            echo "  https://$(hostname -I | sed 's- --g'):8007"
            echo ""

          ;;

          3)

          ;;
        
        esac

      done

fi

