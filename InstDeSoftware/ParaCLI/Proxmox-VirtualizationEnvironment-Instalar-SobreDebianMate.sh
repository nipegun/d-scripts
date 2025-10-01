#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ---------
# Script de NiPeGun para instalar y configurar ProxmoxVE sobre Debian instalado con Mate Desktop
#
# Ejecución remota (puede requerir permisos sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Proxmox-VirtualizationEnvironment-Instalar-SobreDebianMate.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Proxmox-VirtualizationEnvironment-Instalar-SobreDebianMate.sh | sed 's-sudo--g' | bash
# ---------

# IP Local
  #cIPLocal="$(hostname -I)"
  cIPLocal="192.168.1.200"
  cCIDR="24"
  cIPGateway="192.168.1.1"

# Definir fecha de ejecución del script
  cFechaDeEjec=$(date +a%Ym%md%d@%T)

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
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

if [ $cVerSO == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ProxmoxVE para Debian 13 (x)...${cFinColor}"  
  echo ""

  if [[ ! -f "/root/Fase1Completa.txt" ]]; then

    # Agregar el repositorio de proxmox
      echo ""
      echo "    Agregando el repositorio de Proxmox..."
      echo ""
      echo 'Types: deb'                                                 | sudo tee    /etc/apt/sources.list.d/pve-no-subscription.sources
      echo 'URIs: http://download.proxmox.com/debian/pve'               | sudo tee -a /etc/apt/sources.list.d/pve-no-subscription.sources
      echo 'Suites: trixie'                                             | sudo tee -a /etc/apt/sources.list.d/pve-no-subscription.sources
      echo 'Components: pve-no-subscription'                            | sudo tee -a /etc/apt/sources.list.d/pve-no-subscription.sources
      echo 'Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg' | sudo tee -a /etc/apt/sources.list.d/pve-no-subscription.sources

    # Agregar a llave para firmar las descargas desde el repositorio de Proxmox
      echo ""
      echo "    Agregando a llave para firmar las descargas desde el repositorio de Proxmox..."
      echo ""
      # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          apt-get -y update
          apt-get -y install wget
          echo ""
        fi
      wget https://enterprise.proxmox.com/debian/proxmox-archive-keyring-trixie.gpg -O /usr/share/keyrings/proxmox-archive-keyring.gpg

    # Actualizar la lista de paquetes disponibles en los repositorios activados
      echo ""
      echo "    Actualizar la lista de paquetes disponibles en los repositorios activados..."
      echo ""
      apt -y modernize-sources
      apt-get -y update
      apt -y full-upgrade

    # Configurar el archivo /etc/hosts
      echo ""
      echo "      Editando el archivo /etc/hosts..."
      echo ""
      cp /etc/hosts /etc/hosts.bak.$cFechaDeEjec
      echo "127.0.0.1 localhost localhost.localdomain" > /etc/hosts
      echo "$cIPLocal $HOSTNAME $HOSTNAME.home.arpa"  >> /etc/hosts
      echo ""
      echo "        El archivo /etc/hosts ha quedado así:"
      echo ""
      cat /etc/hosts
      echo ""

    # Instalar el kernel por defecto
      echo ""
      echo "    Instalando el kernel por defecto..."
      echo ""
      apt-get -y install proxmox-default-kernel

    # Personalizar mate-desktop
       curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/GUI/Escritorio-Mate-Personalizar.sh | sed 's-sudo--g' | bash

    # Activar PCI-PassThrough
      # Para procesadores Intel:
        #sed -i 's|GRUB_CMDLINE_LINUX_DEFAULT="quiet|GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt"|g' /etc/default/grub
      # Para procesadores AMD:
        #sed -i 's|GRUB_CMDLINE_LINUX_DEFAULT="quiet|GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on iommu=pt"|g' /etc/default/grub
      # Agregar módulos
        echo '# PCIPassThrough' | sudo tee -a /etc/modules
        echo 'vfio'             | sudo tee -a /etc/modules
        echo 'vfio_iommu_type1' | sudo tee -a /etc/modules
        echo 'vfio_pci'         | sudo tee -a /etc/modules
        echo 'vfio_virqfd'      | sudo tee -a /etc/modules
      sudo apt-get -y install driverctl
      

    # Crear el archivo de Fase1 Completa
      echo ""
      echo "    Creando el archivo de fase 1 completa..."
      echo ""
      touch /root/Fase1Completa.txt

    # Reiniciar Debian
      echo ""
      echo "    Reiniciando Debian..."
      echo ""
      shutdown -r now

  fi

  if [[ -f "/root/Fase1Completa.txt" ]]; then

    # Instalar paquetes
      echo ""
      echo "    Instalando paquetes..."
      echo ""
      apt-get -y update
      apt-get -y install proxmox-ve
      apt-get -y install postfix
      apt-get -y install open-iscsi
      apt-get -y install chrony

    # Desinstalar el kernel de Debian
      echo ""
      echo "    Desinstalando el kernel de Debian..."
      echo ""
      apt-get -y remove linux-image-amd64
      apt-get -y remove linux-image-[5-6]*
      apt-get -y remove os-prober

    # Actualizar grub
      echo ""
      echo "    Actualizando grub..."
      echo ""
      update-grub

    # Desactivar el repositorio enterprise
      echo ""
      echo "    Desactivando el repositorio enterprise..."
      echo ""
      mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak 2> /dev/null
      echo '#Types: deb'                                                  | sudo tee    /etc/apt/sources.list.d/pve-enterprise.sources
      echo '#URIs: https://enterprise.proxmox.com/debian/pve'             | sudo tee -a /etc/apt/sources.list.d/pve-enterprise.sources
      echo '#Suites: trixie'                                              | sudo tee -a /etc/apt/sources.list.d/pve-enterprise.sources
      echo '#Components: pve-enterprise'                                  | sudo tee -a /etc/apt/sources.list.d/pve-enterprise.sources
      echo '#Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg'  | sudo tee -a /etc/apt/sources.list.d/pve-enterprise.sources

    # Volver a actualizar la lista de paquetes disponibles en los repositorios activados
      echo ""
      echo "    Volviendo a actualizar la lista de paquetes disponibles en los repositorios activados..."
      echo ""
      apt-get -y update

    # Instalar las cabeceras del kernel
      echo ""
      echo "    Instalando las cabeceras del kernel..."
      echo ""
      apt-get -y install pve-headers

    # Configurar la red
      echo ""
      echo "      Editando el archivo /etc/network/interfaces..."
      echo ""
      cp /etc/network/interfaces /etc/network/interfaces.bak.$cFechaDeEjec
      echo "auto lo"                         > /etc/network/interfaces
      echo "iface lo inet loopback"         >> /etc/network/interfaces
      echo ""                               >> /etc/network/interfaces
      echo "iface eth0 inet manual"         >> /etc/network/interfaces
      echo ""                               >> /etc/network/interfaces
      echo "auto vmbr0"                     >> /etc/network/interfaces
      echo "iface vmbr0 inet static"        >> /etc/network/interfaces
      echo "  address $cIPLocal/$cCIDR"     >> /etc/network/interfaces
      echo "  gateway $cIPGateway"          >> /etc/network/interfaces
      echo "  bridge-ports eth0"            >> /etc/network/interfaces
      echo "  bridge-stp off"               >> /etc/network/interfaces
      echo "  bridge-fd 0"                  >> /etc/network/interfaces
      echo "  #hwaddress 00:00:00:00:02:10" >> /etc/network/interfaces
      echo ""                               >> /etc/network/interfaces
      echo "auto vmbr1"                     >> /etc/network/interfaces
      echo "iface vmbr1 inet manual"        >> /etc/network/interfaces
      echo "bridge-ports none"              >> /etc/network/interfaces
      echo "  bridge-stp off"               >> /etc/network/interfaces
      echo "  bridge-fd 0"                  >> /etc/network/interfaces
      echo "  #Switch 1"                    >> /etc/network/interfaces
      echo ""
      echo "        El archivo /etc/network/interfaces ha quedado así:"
      echo ""
      cat /etc/network/interfaces
      # /etc/resolv.conf
        echo ""
        echo "      Editando el archivo /etc/resolv.conf..."
        echo ""
        echo "nameserver $cIPGateway"      > /etc/resolv.conf
        echo "nameserver 9.9.9.9"         >> /etc/resolv.conf
        echo "nameserver 149.112.112.112" >> /etc/resolv.conf

    # Notificar fin de la instalación
      echo ""
      echo -e "${cColorVerde}    Ejecución del script, finalizada.${cFinColor}"
      echo ""
      echo -e "${cColorVerde}      Para desinstalar Proxmox ejecuta:${cFinColor}"
      echo -e "${cColorVerde}        touch /please-remove-proxmox-ve${cFinColor}"
      echo -e "${cColorVerde}        apt-get -y purge proxmox-ve${cFinColor}"
      echo ""

    # Reiniciar el servicio de red
      echo ""
      echo "    Reiniciando el servicio de red.."
      echo ""
      service networking restart

    # Evitar que proxmox se suspenda al cerrar la tapa del portátil
      echo '[Login]'                      | sudo tee -a /etc/systemd/logind.conf
      echo 'HandleLidSwitch=ignore'       | sudo tee -a /etc/systemd/logind.conf
      echo 'HandleLidSwitchDocked=ignore' | sudo tee -a /etc/systemd/logind.conf
      sudo systemctl restart systemd-logind.service

    # Deshabilitar el suspenso y al hibernación
      systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
      # Para volver a habilitarlo:
      #   systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target

    # Configurar la fecha y hora correctas
      timedatectl set-timezone Europe/Madrid
      apt-get -y install chrony

    # Instalar el servicio de escritorio remoto
      echo ""
      echo "  Instalando XRDP con sus correspondientes servicios de monitorización..."
      echo ""
      curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Servidor-Escritorio-xrdp-Instalar.sh | sed 's-sudo--g' | bash
      # Instalar también la monitorización
        curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/GUI/Servicio-xrdpMonitorCon-Instalar.sh | sed 's-sudo--g' | bash
        curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/GUI/Servicio-xrdpMonitorSes-Instalar.sh | sed 's-sudo--g' | bash

    # Instalar ssh y fail2ban
      sudo tasksel install ssh-server
      curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Fail2Ban-InstalarYConfigurar.sh | sed 's-sudo--g' | bash

    # Ignorar msrs para evitar el loop de arranque de las máquinas virtuales de macOS.
      echo "options kvm ignore_msrs=Y" | sudo tee -a /etc/modprobe.d/macos.conf
      sudo update-initramfs -u -k all

    # Dismonuir el uso de Swap
      echo "vm.swappiness=0" | sudo tee -a /etc/sysctl.conf

    # Indicar partición de intercambio en /etc/fstab
      #echo "/dev/disk/by-partlabel/PartSwap none swap defaults 0 0" | sudo tee -a /etc/fstab

    # Desinstalar sudo
      #

    # Volver a reinciar, pero esta vez ya en modo texto
      curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Interfaz-ModoCLI.sh | sed 's-sudo--g' | bash

  fi

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ProxmoxVE para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  if [[ ! -f "/root/Fase1Completa.txt" ]]; then

    # Agregar el repositorio de proxmox
      echo ""
      echo "    Agregando el repositorio de Proxmox..."
      echo ""
      echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list

    # Agregar a llave para firmar las descargas desde el repositorio de Proxmox
      echo ""
      echo "    Agregando a llave para firmar las descargas desde el repositorio de Proxmox..."
      echo ""
      # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          apt-get -y update
          apt-get -y install wget
          echo ""
        fi
      wget http://download.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmomx-release-bookworm.gpg

    # Actualizar la lista de paquetes disponibles en los repositorios activados
      echo ""
      echo "    Actualizar la lista de paquetes disponibles en los repositorios activados..."
      echo ""
      apt-get -y update

    # Configurar el archivo /etc/hosts
      echo ""
      echo "      Editando el archivo /etc/hosts..."
      echo ""
      cp /etc/hosts /etc/hosts.bak.$cFechaDeEjec
      echo "127.0.0.1 localhost localhost.localdomain" > /etc/hosts
      echo "$cIPLocal $HOSTNAME $HOSTNAME.home.arpa"  >> /etc/hosts
      echo ""
      echo "        El archivo /etc/hosts ha quedado así:"
      echo ""
      cat /etc/hosts
      echo ""

    # Instalar el kernel por defecto
      echo ""
      echo "    Instalando el kernel por defecto..."
      echo ""
      apt-get -y install proxmox-default-kernel

    # Crear el archivo de Fase1 Completa
      echo ""
      echo "    Creando el archivo de fase 1 completa..."
      echo ""
      touch /root/Fase1Completa.txt

    # Reiniciar Debian
      echo ""
      echo "    Reiniciando Debian..."
      echo ""
      shutdown -r now

  fi

  if [[ -f "/root/Fase1Completa.txt" ]]; then

    # Instalar paquetes
      echo ""
      echo "    Instalando paquetes..."
      echo ""
      apt-get -y update
      apt-get -y install proxmox-ve
      apt-get -y install postfix
      apt-get -y install open-iscsi
      apt-get -y install chrony

    # Desinstalar el kernel de Debian
      echo ""
      echo "    Desinstalando el kernel de Debian..."
      echo ""
      apt-get -y remove linux-image-amd64
      apt-get -y remove linux-image-[5-6]*

    # Actualizar grub
      echo ""
      echo "    Actualizando grub..."
      echo ""
      update-grub

    # Borrar el repositorio enterprise
      echo ""
      echo "    Desactivando el repositorio enterprise..."
      echo ""
      mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak

    # Volver a actualizar la lista de paquetes disponibles en los repositorios activados
      echo ""
      echo "    Volviendo a actualizar la lista de paquetes disponibles en los repositorios activados..."
      echo ""
      apt-get -y update

    # Instalar las cabeceras del kernel
      echo ""
      echo "    Instalando las cabeceras del kernel..."
      echo ""
      apt-get -y install pve-headers

    # Desinstalar OSProber
      #echo ""
      #echo "    Desinstalando OSProber..."
      #echo ""
      #apt-get -y remove os-prober

    # Configurar la red
      echo ""
      echo "      Editando el archivo /etc/network/interfaces..."
      echo ""
      cp /etc/network/interfaces /etc/network/interfaces.bak.$cFechaDeEjec
      echo "auto lo"                         > /etc/network/interfaces
      echo "iface lo inet loopback"         >> /etc/network/interfaces
      echo ""                               >> /etc/network/interfaces
      echo "iface eth0 inet manual"         >> /etc/network/interfaces
      echo ""                               >> /etc/network/interfaces
      echo "auto vmbr0"                     >> /etc/network/interfaces
      echo "iface vmbr0 inet static"        >> /etc/network/interfaces
      echo "  address $cIPLocal/$cCIDR"     >> /etc/network/interfaces
      echo "  gateway $cIPGateway"          >> /etc/network/interfaces
      echo "  bridge-ports eth0"            >> /etc/network/interfaces
      echo "  bridge-stp off"               >> /etc/network/interfaces
      echo "  bridge-fd 0"                  >> /etc/network/interfaces
      echo "  #hwaddress 00:00:00:00:02:10" >> /etc/network/interfaces
      echo ""                               >> /etc/network/interfaces
      echo "auto vmbr1"                     >> /etc/network/interfaces
      echo "iface vmbr1 inet manual"        >> /etc/network/interfaces
      echo "bridge-ports none"              >> /etc/network/interfaces
      echo "  bridge-stp off"               >> /etc/network/interfaces
      echo "  bridge-fd 0"                  >> /etc/network/interfaces
      echo "  #Switch 1"                    >> /etc/network/interfaces
      echo ""
      echo "        El archivo /etc/network/interfaces ha quedado así:"
      echo ""
      cat /etc/network/interfaces
      # /etc/resolv.conf
        echo ""
        echo "      Editando el archivo /etc/resolv.conf..."
        echo ""
        echo "nameserver $cIPGateway"      > /etc/resolv.conf
        echo "nameserver 9.9.9.9"         >> /etc/resolv.conf
        echo "nameserver 149.112.112.112" >> /etc/resolv.conf

    # Notificar fin de la instalación
      echo ""
      echo -e "${cColorVerde}    Ejecución del script, finalizada.${cFinColor}"
      echo ""
      echo -e "${cColorVerde}      Para desinstalar Proxmox ejecuta:${cFinColor}"
      echo -e "${cColorVerde}        touch /please-remove-proxmox-ve${cFinColor}"
      echo -e "${cColorVerde}        apt-get -y purge proxmox-ve${cFinColor}"
      echo ""

    # Reiniciar el servicio de red
      echo ""
      echo "    Reiniciando el servicio de red.."
      echo ""
      service networking restart

  fi

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ProxmoxVE para Debian 11 (Bullseye)...${cFinColor}"  
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ProxmoxVE para Debian 10 (Buster)...${cFinColor}"  
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ProxmoxVE para Debian 9 (Stretch)...${cFinColor}"  
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ProxmoxVE para Debian 8 (Jessie)...${cFinColor}"  
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ProxmoxVE para Debian 7 (Wheezy)...${cFinColor}"  
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

fi

