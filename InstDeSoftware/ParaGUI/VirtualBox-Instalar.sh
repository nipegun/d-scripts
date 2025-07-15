#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar VirtualBox en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaGUI/VirtualBox-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaGUI/VirtualBox-Instalar.sh | sed 's-sudo--g' | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
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

if [ $cVerSO == "13" ]; then

  echo ""
  echo "  Iniciando el script de instalación de VirtualBox para Debian 13 (x)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación de VirtualBox para Debian 12 (Bookworm)..." 
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install dialog
      echo ""
    fi

  # Crear el menú
    menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
      opciones=(
        1 "Instalar la versión disponible en el repositorio de Debian" off
        2 "Instalar la última versión desde la web" off
      )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando la última versión de VirtualBox disponible en los repositorios de Debian..."
            echo ""

            # Instalar paquetes necesarios
               echo ""
               echo "    Instalando paquetes necesarios..."
               echo ""
               sudo apt-get -y update
               sudo apt-get -y install linux-headers-$(uname -r)
               sudo apt-get -y install dkms

             # Agregar repositorio
               echo ""
               echo "    Agregando repositorio de VirtualBox..."
               echo ""
               sudo apt-get -y install gnupg2
               # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                 if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                   echo ""
                   echo "      El paquete wget no está instalado. Iniciando su instalación..."
                   echo ""
                   sudo apt-get -y update
                   sudo apt-get -y install wget
                   echo ""
                 fi
               wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
               wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
               sudo echo "deb [arch=$(dpkg --print-architecture)] http://download.virtualbox.org/virtualbox/debian bookworm contrib" > /etc/apt/sources.list.d/virtualbox.list
               sudo apt-get -y update

             # Instalar virtualbox
               echo ""
               echo "    Instalando el paquete virtualbox..."
               echo ""
               PaqueteAInstalar=$(apt-cache search virtualbox | grep "virtualbox-" | tail -n1 | cut -d' ' -f1)
               sudo apt-get -y install $PaqueteAInstalar

             # Instalar el pack de extensiones
               echo ""
               echo "    Instalando el pack de extensiones..."
               echo ""
               sudo mkdir -p /root/SoftInst/VirtualBox/
               VersDeVBoxInstalada=$(virtualbox -h | grep "VirtualBox Manager" | cut -d'v' -f2)
               sudo wget http://download.virtualbox.org/virtualbox/$VersDeVBoxInstalada/Oracle_VirtualBox_Extension_Pack-$VersDeVBoxInstalada.vbox-extpack -O /root/SoftInst/VirtualBox/Oracle_VirtualBox_Extension_Pack-$VersDeVBoxInstalada.vbox-extpack
               echo y | sudo vboxmanage extpack install --replace /root/SoftInst/VirtualBox/Oracle_VirtualBox_Extension_Pack-$VersDeVBoxInstalada.vbox-extpack

             # Agregar el usuario 1000 al grupo virtualbox
               echo ""
               echo "    Agregando el usuario 1000 en el grupo virtualbox..."
               echo ""
               Usuario1000=$(id 1000 | cut -d'(' -f2 | cut -d')' -f1)
               sudo usermod -a -G vboxusers $Usuario1000

          ;;

          2)

            echo ""
            echo "  Instalando la última versión disponible en la web..."
            echo ""

            # Determinar la última versión
              echo ""
              echo "  Determinando la última versión..."
              echo ""
              # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo "    El paquete curl no está instalado. Iniciando su instalación..."
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install curl
                  echo ""
                fi
              vUltVersEnWeb=$(curl -sL http://download.virtualbox.org/virtualbox/LATEST.TXT)
              echo "    La última versión disponible en la web es la $vUltVersEnWeb"
              echo ""

            # Determinar el enlace de descarga del archivo .deb
              echo ""
              echo "  Determinando el enlace de descarga del archivo .deb..."
              echo ""
              vEnlaceArchivoDeb=$(curl -sL https://download.virtualbox.org/virtualbox/$vUltVersEnWeb/ | grep ookworm | cut -d'"' -f2)
              echo "    En enlace de descarga es: https://download.virtualbox.org/virtualbox/$vUltVersEnWeb/$vEnlaceArchivoDeb"
              echo ""

            # Descargar archivo .deb
              echo ""
              echo "  Descargando archivo .deb..."
              echo ""
              cd /tmp/
              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo "    El paquete wget no está instalado. Iniciando su instalación..."
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install wget
                  echo ""
                fi
              wget https://download.virtualbox.org/virtualbox/$vUltVersEnWeb/$vEnlaceArchivoDeb

            # Instalar el paquete
              echo ""
              echo "  Instalando el paquete .deb..."
              echo ""
              sudo apt -y install /tmp/$vEnlaceArchivoDeb

            # Instalar el pack de extensiones
              echo ""
              echo "  Instalando el pack de extensiones..."
              echo ""
              cd /tmp/
              wget http://download.virtualbox.org/virtualbox/$vUltVersEnWeb/Oracle_VirtualBox_Extension_Pack-$vUltVersEnWeb.vbox-extpack
              echo y | sudo vboxmanage extpack install --replace /tmp/Oracle_VirtualBox_Extension_Pack-$vUltVersEnWeb.vbox-extpack

          ;;

      esac

  done

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de VirtualBox para Debian 11 (Bullseye)..."  
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi

  # Crear el menú
    menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
      opciones=(
        1 "Instalar la versión disponible en el repositorio de Debian" off
        2 "Instalar la última versión desde la web" off
      )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando la última versión de VirtualBox disponible en los repositorios de Debian..."
            echo ""

            # Instalar paquetes necesarios
               echo ""
               echo "    Instalando paquetes necesarios..."
               echo ""
               apt-get -y update
               apt-get -y install linux-headers-$(uname -r)
               apt-get -y install dkms

             # Agregar repositorio
               echo ""
               echo "    Agregando repositorio de VirtualBox..."
               echo ""
               apt-get -y install gnupg2
               # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                 if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                   echo ""
                   echo "      El paquete wget no está instalado. Iniciando su instalación..."
                   echo ""
                   apt-get -y update && apt-get -y install wget
                   echo ""
                 fi
               wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
               wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
               echo "deb [arch=$(dpkg --print-architecture)] http://download.virtualbox.org/virtualbox/debian bookworm contrib" > /etc/apt/sources.list.d/virtualbox.list
               apt-get -y update

             # Instalar virtualbox
               echo ""
               echo "    Instalando el paquete virtualbox..."
               echo ""
               PaqueteAInstalar=$(apt-cache search virtualbox | grep "virtualbox-" | tail -n1 | cut -d' ' -f1)
               apt-get -y install $PaqueteAInstalar

             # Instalar el pack de extensiones
               echo ""
               echo "    Instalando el pack de extensiones..."
               echo ""
               mkdir -p /root/SoftInst/VirtualBox/
               cd /root/SoftInst/VirtualBox/
               VersDeVBoxInstalada=$(virtualbox -h | grep "VirtualBox Manager" | cut -d'v' -f2)
               wget http://download.virtualbox.org/virtualbox/$VersDeVBoxInstalada/Oracle_VirtualBox_Extension_Pack-$VersDeVBoxInstalada.vbox-extpack
               echo y | vboxmanage extpack install --replace /root/SoftInst/VirtualBox/Oracle_VirtualBox_Extension_Pack-$VersDeVBoxInstalada.vbox-extpack

             # Agregar el usuario 1000 al grupo virtualbox
               echo ""
               echo "    Agregando el usuario 1000 en el grupo virtualbox..."
               echo ""
               Usuario1000=$(id 1000 | cut -d'(' -f2 | cut -d')' -f1)
               usermod -a -G vboxusers $Usuario1000

          ;;

          2)

            echo ""
            echo "  Instalando la última versión disponible en la web..."
            echo ""

            # Determinar la última versión
              echo ""
              echo "  Determinando la última versión..."
              echo ""
              # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo "    El paquete curl no está instalado. Iniciando su instalación..."
                  echo ""
                  apt-get -y update && apt-get -y install curl
                  echo ""
                fi
              vUltVersEnWeb=$(curl -sL http://download.virtualbox.org/virtualbox/LATEST.TXT)
              echo "    La última versión disponible en la web es la $vUltVersEnWeb"
              echo ""

            # Determinar el enlace de descarga del archivo .deb
              echo ""
              echo "  Determinando el enlace de descarga del archivo .deb..."
              echo ""
              vEnlaceArchivoDeb=$(curl -sL https://download.virtualbox.org/virtualbox/$vUltVersEnWeb/ | grep ullseye | cut -d'"' -f2)
              echo "    En enlace de descarga es: https://download.virtualbox.org/virtualbox/$vUltVersEnWeb/$vEnlaceArchivoDeb"
              echo ""

            # Descargar archivo .deb
              echo ""
              echo "  Descargando archivo .deb..."
              echo ""
              mkdir -p /root/SoftInst/VirtualBox/
              cd /root/SoftInst/VirtualBox/
              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo "    El paquete wget no está instalado. Iniciando su instalación..."
                  echo ""
                  apt-get -y update && apt-get -y install wget
                  echo ""
                fi
              wget https://download.virtualbox.org/virtualbox/$vUltVersEnWeb/$vEnlaceArchivoDeb

            # Instalar el paquete
              echo ""
              echo "  Instalando el paquete .deb..."
              echo ""
              apt -y install /root/SoftInst/VirtualBox/$vEnlaceArchivoDeb

            # Instalar el pack de extensiones
              echo ""
              echo "  Instalando el pack de extensiones..."
              echo ""
              cd /root/SoftInst/VirtualBox/
              wget http://download.virtualbox.org/virtualbox/$vUltVersEnWeb/Oracle_VirtualBox_Extension_Pack-$vUltVersEnWeb.vbox-extpack
              echo y | vboxmanage extpack install --replace /root/SoftInst/VirtualBox/Oracle_VirtualBox_Extension_Pack-$vUltVersEnWeb.vbox-extpack

          ;;

      esac

  done

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de VirtualBox para Debian 10 (Buster)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de VirtualBox para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  AGREGANDO EL REPOSITORIO"
  echo ""
  echo "deb http://download.virtualbox.org/virtualbox/debian stretch contrib" > /etc/apt/sources.list.d/virtualbox.list

  echo ""
  echo "  AGREGANDO LA LLAVE"
  echo ""
  wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -

  echo ""
  echo "  ACTUALIZANDO EL SISTEMA"
  echo ""
  apt-get update

  echo ""
  echo "  INSTALANDO EL PAQUETE"
  echo ""
  apt-get -y install virtualbox-5.1

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de VirtualBox para Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de VirtualBox para Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi

