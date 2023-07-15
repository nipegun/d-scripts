#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar la cartera de RVN Electrum en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Cartera-RVN-Electrum.sh | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Cartera-RVN-Electrum.sh | bash
#
#  Ejecución remota con parámetros:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Cartera-RVN-Electrum.sh | bash -s Parámetro1 Parámetro2
# ----------

vUsuarioNoRoot=nipegun

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}" >&2
    exit 1
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

if [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de la cartera RVN Electrum para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de la cartera RVN Electrum para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de la cartera RVN Electrum para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de la cartera RVN Electrum para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de la cartera RVN Electrum para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi

  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Instalar para el usuario root" on
      2 "Mover a la carpeta del usuario no-root" off
      3 "..." off
      4 "..." off
      5 "..." off
    )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
    clear

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando para el usuario root..."
            echo ""

            # Borrar archivos de ejecuciones anteriores
            rm -rf /root/SoftInst/ElectrumRavencoin/ 2> /dev/null
            rm -rf /root/ElectrumRavencoin/ 2> /dev/null
            rm -rf /home/$vUsuarioNoRoot/ElectrumRavencoin/ 2> /dev/null

            echo ""
            echo "  Determinando última versión del código fuente..."
            echo ""
            # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update && apt-get -y install curl
                echo ""
              fi
            #vAppImage=$(curl -s https://github.com/Electrum-RVN-SIG/electrum-ravencoin/releases | sed 's->-\n-g' | grep ownload | grep href | grep mage | head -n1 | cut -d'"' -f2)
            vUltVersCodFuente=$(curl -s https://github.com/Electrum-RVN-SIG/electrum-ravencoin/releases | sed 's->-\n-g' | grep href | grep ".tar.gz" | head -n1 | cut -d'"' -f2 | cut -d'/' -f7 | sed 's-.tar.gz--g')
            echo ""
            echo "    La última versión es la $vUltVersCodFuente"
            echo ""

            echo ""
            echo "  Determinando la URL del archivo a descargar..."
            echo ""
            vURLArchivo=$(curl -s https://github.com/Electrum-RVN-SIG/electrum-ravencoin/releases/tag/$vUltVersCodFuente | grep href | grep ".tar.gz" | cut -d'"' -f2)
            echo ""
            echo "    La URL del archivo a descargar es https://github.com$vURLArchivo"
            echo ""

            echo ""
            echo "  Descargando el archivo del código fuente... "
            echo ""
            mkdir -p /root/SoftInst/ElectrumRavencoin/ 2> /dev/null
            cd /root/SoftInst/ElectrumRavencoin/
            curl -sL https://github.com"$vURLArchivo" -o /root/SoftInst/ElectrumRavencoin/CodFuente.tar.gz

            echo ""
            echo "  Descomprimiendo el archivo descargado... "
            echo ""
            # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
                 echo ""
                 echo -e "${cColorRojo}    tar no está instalado. Iniciando su instalación...${cFinColor}"
                 echo ""
                 apt-get -y update && apt-get -y install tar
                 echo ""
              fi
            cd /root/SoftInst/ElectrumRavencoin/
            tar -xvzf /root/SoftInst/ElectrumRavencoin/CodFuente.tar.gz
            find /root/SoftInst/ElectrumRavencoin/* -type d -exec mv {} /root/SoftInst/ElectrumRavencoin/CodFuente \; 2> /dev/null
            rm -rf /root/SoftInst/ElectrumRavencoin/CodFuente/.github/
            rm -rf /root/SoftInst/ElectrumRavencoin/CodFuente/.tx/
            rm -f  /root/SoftInst/ElectrumRavencoin/CodFuente/.gitignore
            rm -f  /root/SoftInst/ElectrumRavencoin/CodFuente/.gitmodules
            rm -f  /root/SoftInst/ElectrumRavencoin/CodFuente/.dockerignore

            echo ""
            echo "  Instalando paquetes necesarios..."
            echo ""
            apt-get -y update
            #apt-get -y install python3
            apt-get -y install python3-venv
            apt-get -y install cmake
            apt-get -y install python3-pip
            apt-get -y install python3-cryptography
            apt-get -y install libsecp256k1-0
            apt-get -y install python3-pyqt5
  
            #pip3 install virtualenv
            #apt-get -y install automake
            #apt-get -y install libtool
            #./contrib/make_libsecp256k1.sh

            echo ""
            echo "  Moviendo el software a la carpeta de usuario..."
            echo ""
            mv /root/SoftInst/ElectrumRavencoin/CodFuente/ /root/ElectrumRavencoin/

            echo ""
            echo -e "${cColorVerde}  Electrum instalado para el usuario root.${cFinColor}"
            echo ""
            echo -e "${cColorVerde}  Para lanzar la app como root, ejecuta:${cFinColor}"
            echo ""
            echo -e "${cColorVerde}  /root/ElectrumRavencoin/electrum-env${cFinColor}"
            echo ""
            echo -e "${cColorVerde}  La primera vez tardará más tiempo en ejecutarse.${cFinColor}"
            echo -e "${cColorVerde}  A partir de la segunda vez será casi instantánea.${cFinColor}"
            echo ""

          ;;

          2)

            echo ""
            echo "  Moviendo la app a la carpeta del usuario no-root..."
            echo ""
            mv /root/ElectrumRavencoin/ /home/$vUsuarioNoRoot/ElectrumRavencoin/
            chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/ -R
            cp /home/$vUsuarioNoRoot/ElectrumRavencoin/electrum/gui/icons/electrum-ravencoin.png /home/$vUsuarioNoRoot/ElectrumRavencoin/electrum/gui/icons/Logo.png

            # Icono de lanzamiento en el menú gráfico
              echo ""
              echo "  Agregando la aplicación gráfica al menú..."
              echo ""
              mkdir -p /home/$vUsuarioNoRoot/.local/share/applications/ 2> /dev/null
              echo "[Desktop Entry]"                                                           > /home/$vUsuarioNoRoot/.local/share/applications/electrum-ravencoin.desktop
              echo "Name=electrum GUI"                                                        >> /home/$vUsuarioNoRoot/.local/share/applications/electrum-ravencoin.desktop
              echo "Type=Application"                                                         >> /home/$vUsuarioNoRoot/.local/share/applications/electrum-ravencoin.desktop
              echo "Exec=/home/$vUsuarioNoRoot/ElectrumRavencoin/electrum-env"                >> /home/$vUsuarioNoRoot/.local/share/applications/electrum-ravencoin.desktop
              echo "Terminal=false"                                                           >> /home/$vUsuarioNoRoot/.local/share/applications/electrum-ravencoin.desktop
              echo "Hidden=false"                                                             >> /home/$vUsuarioNoRoot/.local/share/applications/electrum-ravencoin.desktop
              echo "Categories=Cryptos"                                                       >> /home/$vUsuarioNoRoot/.local/share/applications/electrum-ravencoin.desktop
              echo "Icon=/home/$vUsuarioNoRoot/ElectrumRavencoin/electrum/gui/icons/Logo.png" >> /home/$vUsuarioNoRoot/.local/share/applications/electrum-ravencoin.desktop
              chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.local/share/applications/ -R
              gio set                               /home/$vUsuarioNoRoot/.local/share/applications/electrum-ravencoin.desktop "metadata::trusted" yes

            # Autoejecución gráfica de electrum-ravencoin
              echo ""
              echo "  Creando el archivo de autoejecución de electrum-ravencoin para escritorio..."
              echo ""
              mkdir -p /home/$vUsuarioNoRoot/.config/autostart/ 2> /dev/null
              echo "[Desktop Entry]"                                            > /home/$vUsuarioNoRoot/.config/autostart/electrum-ravencoin.desktop
              echo "Name=electrum GUI"                                         >> /home/$vUsuarioNoRoot/.config/autostart/electrum-ravencoin.desktop
              echo "Type=Application"                                          >> /home/$vUsuarioNoRoot/.config/autostart/electrum-ravencoin.desktop
              echo "Exec=/home/$vUsuarioNoRoot/ElectrumRavencoin/electrum-env" >> /home/$vUsuarioNoRoot/.config/autostart/electrum-ravencoin.desktop
              echo "Terminal=false"                                            >> /home/$vUsuarioNoRoot/.config/autostart/electrum-ravencoin.desktop
              echo "Hidden=false"                                              >> /home/$vUsuarioNoRoot/.config/autostart/electrum-ravencoin.desktop
              chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.config/autostart/ -R
              gio set                               /home/$vUsuarioNoRoot/.config/autostart/electrum-ravencoin.desktop "metadata::trusted" yes

            echo ""
            echo -e "${cColorVerde}  Script finalizado.${cFinColor}"
            echo ""
            echo -e "${cColorVerde}  La primera vez que ejecutes la app, tardará un poco en abrirse.${cFinColor}"
            echo -e "${cColorVerde}  A partir de la segunda será casi instantánea.${cFinColor}"
            echo ""


          ;;

          3)

            echo ""
            echo "  ..."
            echo ""

          ;;

          4)

            echo ""
            echo "  ..."
            echo ""

          ;;

          5)

            echo ""
            echo "  ..."
            echo ""

          ;;

      esac

  done

fi

