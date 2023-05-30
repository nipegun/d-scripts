#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar la cadena de bloques de Chia (XCH)
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Nodo-RVN-InstalarYConfigurar.sh | bash
# ----------

vUsuarioNoRoot="nipegun"

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

echo ""
echo -e "${vColorAzulClaro}  Iniciando el script de instalación de la cadena de bloques de RVN...${vFinColor}"
echo ""

# Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install dialog
    echo ""
  fi

menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
  opciones=(
    1 "Instalar el nodo RVN en modo CLI" on
    2 "Agregar la configuración para modo GUI" off
    3 "Opción 3" off
    4 "Opción 4" off
    5 "Opción 5" off
  )
choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Instalando el nodo RVN para modo CLI..."
          echo ""

          echo ""
          echo "    Determinando la última versión de raven core..."
          echo ""
          # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${vColorAzulClaro}      El paquete curl no está instalado. Iniciando su instalación...${vFinColor}"
              echo "  "
              echo ""
              apt-get -y update
              apt-get -y install curl
              echo ""
            fi
          vUltVersRaven=$(curl -sL https://github.com/RavenProject/Ravencoin/releases/latest | grep inux | grep href | grep -v isable | cut -d'"' -f2 | cut -d '/' -f 6 | cut -c2- | head -n1)
          echo ""
          echo "      La última versión de raven es la $vUltVersRaven"
          echo ""

          echo ""
          echo "    Determinando el nombre del archivo tar de la versión $vUltVersRaven..."
          echo ""
          vNombreArchivo=$(curl -sL https://github.com/RavenProject/Ravencoin/releases/latest/ | grep href | grep inux | grep -v isable | grep x86 | cut -d'"' -f2 | cut -d '/' -f7)
          echo ""
          echo "      El nombre del archivo es $vNombreArchivo"
          echo ""

          echo ""
          echo "    Intentando descargar el archivo..."
          echo ""
          mkdir -p /root/SoftInst/Cryptos/RVN/ 2> /dev/null
          rm -rf /root/SoftInst/Cryptos/RVN/*
          cd /root/SoftInst/Cryptos/RVN/
          # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${vColorAzulClaro}      El paquete wget no está instalado. Iniciando su instalación...${vFinColor}"
              echo ""
              apt-get -y update
              apt-get -y install wget
              echo ""
            fi
          wget https://github.com/RavenProject/Ravencoin/releases/download/v$vUltVersRaven/$vNombreArchivo

          echo ""
          echo "    Descomprimiendo el archivo..."
          echo ""
          # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${vColorAzulClaro}      El paquete tar no está instalado. Iniciando su instalación...${vFinColor}"
              echo ""
              apt-get -y update
              apt-get -y install tar
              echo ""
            fi
          tar -xf /root/SoftInst/Cryptos/RVN/$vNombreArchivo
          rm -rf /root/SoftInst/Cryptos/RVN/$vNombreArchivo
          find /root/SoftInst/Cryptos/RVN/ -type d -name "raven*" -exec mv {} /root/SoftInst/Cryptos/RVN/"raven-$vUltVersRaven"/ \; 2> /dev/null

          echo ""
          echo "    Creando carpetas y archivos necesarios para ese usuario..."
          echo ""
          mkdir -p /home/$vUsuarioNoRoot/.raven/
          touch    /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "rpcuser=rvnrpc"           > /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "rpcpassword=rvnrpcpass"  >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "rpcallowip=127.0.0.1"    >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "#Default RPC port 8766"  >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "rpcport=20401"           >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "server=1"                >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "listen=1"                >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "prune=550"               >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "daemon=1"                >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "gen=0"                   >> /home/$vUsuarioNoRoot/.raven/raven.conf
          rm -rf   /home/$vUsuarioNoRoot/Cryptos/RVN/
          mkdir -p /home/$vUsuarioNoRoot/Cryptos/RVN/ 2> /dev/null
          mv /root/SoftInst/Cryptos/RVN/raven-$vUltVersRaven/* /home/$vUsuarioNoRoot/Cryptos/RVN/
          chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/RVN/ -R
          find /home/$vUsuarioNoRoot/Cryptos/RVN/ -type d -exec chmod 775 {} \;
          find /home/$vUsuarioNoRoot/Cryptos/RVN/ -type f -exec chmod 664 {} \;
          find /home/$vUsuarioNoRoot/Cryptos/RVN/bin -type f -exec chmod +x {} \;

          # Instalar los c-scripts
            echo ""
            echo "    Instalando los c-scripts..."
            echo ""
            su $vUsuarioNoRoot -c "curl --silent https://raw.githubusercontent.com/nipegun/c-scripts/main/CScripts-Instalar.sh | bash"
            find /home/$vUsuarioNoRoot/scripts/c-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;

          # Reparación de permisos
            chmod +x /home/$vUsuarioNoRoot/Cryptos/RVN/bin/*
            chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/RVN/ -R
            chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.raven/ -R
            chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.local/share/applications/ -R

          #echo ""
          #echo "  Arrancando ravencoind..."
          #echo ""
          #su $vUsuarioNoRoot -c /home/$vUsuarioNoRoot/Cryptos/RVN/bin/ravend
          #sleep 5
          #su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/Cryptos/RVN/bin/raven-cli getnewaddress" > /home/$vUsuarioNoRoot/pooladdress-rvn.txt
          #chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/pooladdress-rvn.txt
          #echo ""
          #echo "  La dirección para recibir ravencoins es:"
          #echo ""
          #cat /home/$vUsuarioNoRoot/pooladdress-rvn.txt
          #DirCartRVN=$(cat /home/$vUsuarioNoRoot/pooladdress-rvn.txt)
          #echo ""

          # Autoejecución de Ravencoin al iniciar el sistema
            #echo ""
            #echo "  Agregando ravend a los ComandosPostArranque..."
            #echo ""
            #chmod +x /home/$vUsuarioNoRoot/scripts/c-scripts/rvn-daemon-iniciar.sh
            #echo "su "$vUsuarioNoRoot" -c '/home/"$vUsuarioNoRoot"/scripts/c-scripts/rvn-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh

        ;;

        2)

          echo ""
          echo "  Agregando configuración para el modo GUI..."
          echo ""

          # Parar el daemon
            chmod +x /home/$vUsuarioNoRoot/scripts/c-scripts/rvn-daemon-parar.sh
            su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/scripts/c-scripts/rvn-daemon-parar.sh"

          # Icono de lanzamiento en el menú gráfico
            echo ""
            echo "    Agregando la aplicación gráfica al menú..."
            echo ""
            mkdir -p /home/$vUsuarioNoRoot/.local/share/applications/ 2> /dev/null
            echo "[Desktop Entry]"                                                   > /home/$vUsuarioNoRoot/.local/share/applications/rvn.desktop
            echo "Name=rvn GUI"                                                     >> /home/$vUsuarioNoRoot/.local/share/applications/rvn.desktop
            echo "Type=Application"                                                 >> /home/$vUsuarioNoRoot/.local/share/applications/rvn.desktop
            echo "Exec=/home/$vUsuarioNoRoot/scripts/c-scripts/rvn-gui-iniciar.sh"  >> /home/$vUsuarioNoRoot/.local/share/applications/rvn.desktop
            echo "Terminal=false"                                                   >> /home/$vUsuarioNoRoot/.local/share/applications/rvn.desktop
            echo "Hidden=false"                                                     >> /home/$vUsuarioNoRoot/.local/share/applications/rvn.desktop
            echo "Categories=Cryptos"                                               >> /home/$vUsuarioNoRoot/.local/share/applications/rvn.desktop
            #echo "Icon="                                                           >> /home/$vUsuarioNoRoot/.local/share/applications/rvn.desktop
            gio set /home/$vUsuarioNoRoot/.local/share/applications/rvn.desktop "metadata::trusted" yes

            # Autoejecución gráfica de Ravencoin
            echo ""
            echo "  Creando el archivo de autoejecución de raven-qt para escritorio..."
            echo ""
            mkdir -p /home/$vUsuarioNoRoot/.config/autostart/ 2> /dev/null
            echo "[Desktop Entry]"                                                   > /home/$vUsuarioNoRoot/.config/autostart/rvn.desktop
            echo "Name=rvn GUI"                                                     >> /home/$vUsuarioNoRoot/.config/autostart/rvn.desktop
            echo "Type=Application"                                                 >> /home/$vUsuarioNoRoot/.config/autostart/rvn.desktop
            echo "Exec=/home/$vUsuarioNoRoot/scripts/c-scripts/rvn-gui-iniciar.sh"  >> /home/$vUsuarioNoRoot/.config/autostart/rvn.desktop
            echo "Terminal=false"                                                   >> /home/$vUsuarioNoRoot/.config/autostart/rvn.desktop
            echo "Hidden=false"                                                     >> /home/$vUsuarioNoRoot/.config/autostart/rvn.desktop
            gio set /home/$vUsuarioNoRoot/.config/autostart/rvn.desktop "metadata::trusted" yes

        ;;

    esac

done

