#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar Visual Studio Code en Debian
#
#  Ejecución remota:
#  curl -s  https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/Escritorio/OracleSQLDeveloper-Instalar.sh | bash
#-------------------------------------------------------------------------------------------------------------------------------

## Determinar la versión de Debian

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
  echo "--------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Visual Studio Code para Debian 7 (Wheezy)..."
  echo "--------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Visual Studio Code para Debian 8 (Jessie)..."
  echo "--------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Visual Studio Code para Debian 9 (Stretch)..."
  echo "---------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Visual Studio Code para Debian 10 (Buster)..."
  echo "---------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Visual Studio Code para Debian 11 (Bullseye)..."
  echo "-------------------------------------------------------------------------------------------"
  echo ""

  ## Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  dialog no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update > /dev/null
       apt-get -y install dialog
       echo ""
     fi
  menu=(dialog --timeout 5 --checklist "Instalación de Visual Studio Code:" 22 76 16)
    opciones=(1 "Instalar versión estable para i386" off
              2 "Instalar versión estable para amd64" off
              3 "Instalar versión estable para armhf" off
              4 "Instalar versión estable para arm64" off
              5 "Instalar version -insider- para i386 " off
              6 "Instalar versión -insider- para amd64" off
              7 "Instalar versión -insider- para armhf" off
              8 "Instalar versión -insider- para arm64" off)
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando versión estable para i386..."
              echo ""

              ## Determinar URL del paquete
                 URLDelPaquete=$(curl -s https://code.visualstudio.com/sha/ | sed 's/.deb/.deb\n/g' | sed 's-//-\n-g' | grep ".deb" | grep i386 | grep -v side)
                 echo ""
                 echo "  El archivo .deb que se va a descargar es:"
                 echo "  $URLDelPaquete"
                 echo ""

              ## Descargar el paquete
                 echo ""
                 echo "  Descargando el paquete..."
                 echo ""
                 mkdir -p /root/SoftInst/Microsoft/VisualStudioCode/ 2> /dev/null
                 cd /root/SoftInst/Microsoft/VisualStudioCode/
                 ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo "  wget no está instalado. Iniciando su instalación..."
                      echo ""
                      apt-get -y update > /dev/null
                      apt-get -y install wget
                      echo ""
                    fi
                 wget $URLDelPaquete -O /root/SoftInst/Microsoft/VisualStudioCode/VisualStudioCode.deb

            ;;

            2)

              echo ""
              echo "  Instalando versión estable para amd64..."
              echo ""

              ## Determinar URL del paquete
                 URLDelPaquete=$(curl -s https://code.visualstudio.com/sha/ | sed 's/.deb/.deb\n/g' | sed 's-//-\n-g' | grep ".deb" | grep amd64 | grep -v side)
                 echo ""
                 echo "  El archivo .deb que se va a descargar es:"
                 echo "  $URLDelPaquete"
                 echo ""

              ## Descargar el paquete
                 echo ""
                 echo "  Descargando el paquete..."
                 echo ""
                 mkdir -p /root/SoftInst/Microsoft/VisualStudioCode/ 2> /dev/null
                 cd /root/SoftInst/Microsoft/VisualStudioCode/
                 ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo "  wget no está instalado. Iniciando su instalación..."
                      echo ""
                      apt-get -y update > /dev/null
                      apt-get -y install wget
                      echo ""
                    fi
                 wget $URLDelPaquete -O /root/SoftInst/Microsoft/VisualStudioCode/VisualStudioCode.deb

            ;;

            3)

              echo ""
              echo "  Instalando versión estable para armhf..."
              echo ""

              ## Determinar URL del paquete
                 URLDelPaquete=$(curl -s https://code.visualstudio.com/sha/ | sed 's/.deb/.deb\n/g' | sed 's-//-\n-g' | grep ".deb" | grep armhf | grep -v side)
                 echo ""
                 echo "  El archivo .deb que se va a descargar es:"
                 echo "  $URLDelPaquete"
                 echo ""

              ## Descargar el paquete
                 echo ""
                 echo "  Descargando el paquete..."
                 echo ""
                 mkdir -p /root/SoftInst/Microsoft/VisualStudioCode/ 2> /dev/null
                 cd /root/SoftInst/Microsoft/VisualStudioCode/
                 ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo "  wget no está instalado. Iniciando su instalación..."
                      echo ""
                      apt-get -y update > /dev/null
                      apt-get -y install wget
                      echo ""
                    fi
                 wget $URLDelPaquete -O /root/SoftInst/Microsoft/VisualStudioCode/VisualStudioCode.deb

            ;;

            4)

              echo ""
              echo "  Instalando para versión estable para arm64..."
              echo ""

              ## Determinar URL del paquete
                 URLDelPaquete=$(curl -s https://code.visualstudio.com/sha/ | sed 's/.deb/.deb\n/g' | sed 's-//-\n-g' | grep ".deb" | grep arm64 | grep -v side)
                 echo ""
                 echo "  El archivo .deb que se va a descargar es:"
                 echo "  $URLDelPaquete"
                 echo ""

              ## Descargar el paquete
                 echo ""
                 echo "  Descargando el paquete..."
                 echo ""
                 mkdir -p /root/SoftInst/Microsoft/VisualStudioCode/ 2> /dev/null
                 cd /root/SoftInst/Microsoft/VisualStudioCode/
                 ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo "  wget no está instalado. Iniciando su instalación..."
                      echo ""
                      apt-get -y update > /dev/null
                      apt-get -y install wget
                      echo ""
                    fi
                 wget $URLDelPaquete -O /root/SoftInst/Microsoft/VisualStudioCode/VisualStudioCode.deb

            ;;

            5)

              echo ""
              echo "  Instalando versión insider para i386..."
              echo ""

              ## Determinar URL del paquete
                 URLDelPaquete=$(curl -s https://code.visualstudio.com/sha/ | sed 's/.deb/.deb\n/g' | sed 's-//-\n-g' | grep ".deb" | grep i386 | grep side)
                 echo ""
                 echo "  El archivo .deb que se va a descargar es:"
                 echo "  $URLDelPaquete"
                 echo ""

              ## Descargar el paquete
                 echo ""
                 echo "  Descargando el paquete..."
                 echo ""
                 mkdir -p /root/SoftInst/Microsoft/VisualStudioCode/ 2> /dev/null
                 cd /root/SoftInst/Microsoft/VisualStudioCode/
                 ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo "  wget no está instalado. Iniciando su instalación..."
                      echo ""
                      apt-get -y update > /dev/null
                      apt-get -y install wget
                      echo ""
                    fi
                 wget $URLDelPaquete -O /root/SoftInst/Microsoft/VisualStudioCode/VisualStudioCode.deb

            ;;

            6)

              echo ""
              echo "  Instalando versión insider para amd64..."
              echo ""

              ## Determinar URL del paquete
                 URLDelPaquete=$(curl -s https://code.visualstudio.com/sha/ | sed 's/.deb/.deb\n/g' | sed 's-//-\n-g' | grep ".deb" | grep amd64 | grep side)
                 echo ""
                 echo "  El archivo .deb que se va a descargar es:"
                 echo "  $URLDelPaquete"
                 echo ""

              ## Descargar el paquete
                 echo ""
                 echo "  Descargando el paquete..."
                 echo ""
                 mkdir -p /root/SoftInst/Microsoft/VisualStudioCode/ 2> /dev/null
                 cd /root/SoftInst/Microsoft/VisualStudioCode/
                 ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo "  wget no está instalado. Iniciando su instalación..."
                      echo ""
                      apt-get -y update > /dev/null
                      apt-get -y install wget
                      echo ""
                    fi
                 wget $URLDelPaquete -O /root/SoftInst/Microsoft/VisualStudioCode/VisualStudioCode.deb

            ;;

            7)

              echo ""
              echo "  Instalando versión insider para armhf..."
              echo ""

              ## Determinar URL del paquete
                 URLDelPaquete=$(curl -s https://code.visualstudio.com/sha/ | sed 's/.deb/.deb\n/g' | sed 's-//-\n-g' | grep ".deb" | grep armhf | grep side)
                 echo ""
                 echo "  El archivo .deb que se va a descargar es:"
                 echo "  $URLDelPaquete"
                 echo ""

              ## Descargar el paquete
                 echo ""
                 echo "  Descargando el paquete..."
                 echo ""
                 mkdir -p /root/SoftInst/Microsoft/VisualStudioCode/ 2> /dev/null
                 cd /root/SoftInst/Microsoft/VisualStudioCode/
                 ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo "  wget no está instalado. Iniciando su instalación..."
                      echo ""
                      apt-get -y update > /dev/null
                      apt-get -y install wget
                      echo ""
                    fi
                 wget $URLDelPaquete -O /root/SoftInst/Microsoft/VisualStudioCode/VisualStudioCode.deb

            ;;

            8)

              echo ""
              echo "  Instalando versión insider para arm64..."
              echo ""

              ## Determinar URL del paquete
                 URLDelPaquete=$(curl -s https://code.visualstudio.com/sha/ | sed 's/.deb/.deb\n/g' | sed 's-//-\n-g' | grep ".deb" | grep arm64 | grep side)
                 echo ""
                 echo "  El archivo .deb que se va a descargar es:"
                 echo "  $URLDelPaquete"
                 echo ""

              ## Descargar el paquete
                 echo ""
                 echo "  Descargando el paquete..."
                 echo ""
                 mkdir -p /root/SoftInst/Microsoft/VisualStudioCode/ 2> /dev/null
                 cd /root/SoftInst/Microsoft/VisualStudioCode/
                 ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo "  wget no está instalado. Iniciando su instalación..."
                      echo ""
                      apt-get -y update > /dev/null
                      apt-get -y install wget
                      echo ""
                    fi
                 wget $URLDelPaquete -O /root/SoftInst/Microsoft/VisualStudioCode/VisualStudioCode.deb

            ;;

          esac

        done

fi

