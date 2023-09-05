#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar la cadena de bloques de bitcoin cash (BCH)
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Nodo-BCH-InstalarYConfigurar.sh | bash
# ----------

vUsuarioNoRoot="nipegun"

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

echo ""
echo -e "${cColorAzulClaro}  Iniciando el script de instalación de la cadena de bloques de BCH...${cFinColor}"
echo ""

# Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install dialog
    echo ""
  fi

menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
  opciones=(
    1 "Instalar BitcoinCashNode en modo CLI desde la web oficial." on
    2 "Instalar BitcoinCashNode en modo CLI desde la web de GitHub." off
    3 "Agregar la configuración para modo GUI." off
  )
choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Instalando BitcoinCashNode para modo CLI desde la web oficial..."
          echo ""

          echo ""
          echo "    Determinando la última versión del nodo BitcoinCashNode disponible en la web oficial..."
          echo ""
          # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${cColorAzulClaro}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
              echo "  "
              echo ""
              apt-get -y update
              apt-get -y install curl
              echo ""
            fi
          $vUltVersBitcoinCashNode=$(curl -sL https://bitcoin.org/wallet/ | sed 's->->\n-g' | sed 's-"-\n-g' | grep tar.gz | sed 's|.*raven-||' | cut -d'-' -f1)
          echo ""
          echo "      La última versión de bitcoin cash disponible en la web oficial es la $vUltVersBitcoinCashNode"
          echo ""

          echo ""
          echo "    Determinando la URL del archivo a descargar..."          echo ""
          vURLArchivo=$(curl -sL https://bitcoin.org/wallet/ | sed 's->->\n-g' | sed 's-"-\n-g' | grep tar.gz)
          echo ""
          echo "      La URL del archivo es: $vURLArchivo"
          echo ""

          echo ""
          echo "    Intentando descargar el archivo..."          echo ""
          mkdir -p /root/SoftInst/Cryptos/BCH/ 2> /dev/null
          rm -rf /root/SoftInst/Cryptos/BCH/*
          cd /root/SoftInst/Cryptos/BCH/
          # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${cColorAzulClaro}      El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
              echo ""
              apt-get -y update
              apt-get -y install wget
              echo ""
            fi
          wget $vURLArchivo -O /root/SoftInst/Cryptos/BCH/raven$vUltVersBitcoinCashNode.tar.gz

          echo ""
          echo "    Descomprimiendo el archivo..."          echo ""
          # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${cColorAzulClaro}      El paquete tar no está instalado. Iniciando su instalación...${cFinColor}"
              echo ""
              apt-get -y update
              apt-get -y install tar
              echo ""
            fi
          tar -xf /root/SoftInst/Cryptos/BCH/raven$vUltVersBitcoinCashNode.tar.gz
          rm -f /root/SoftInst/Cryptos/BCH/raven$vUltVersBitcoinCashNode.tar.gz
          find /root/SoftInst/Cryptos/BCH/ -type d -name "raven*" -exec mv {} /root/SoftInst/Cryptos/BCH/"raven-$vUltVersBitcoinCashNode"/ \; 2> /dev/null

          echo ""
          echo "    Creando carpetas y archivos necesarios para ese usuario..."          echo ""
          mkdir -p /home/$vUsuarioNoRoot/.raven/
          touch    /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "rpcuser=bchrpc"           > /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "rpcpassword=bchrpcpass"  >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "rpcallowip=127.0.0.1"    >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "#Default RPC port 8766"  >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "rpcport=20401"           >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "server=1"                >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "listen=1"                >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "prune=550"               >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "daemon=1"                >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "gen=0"                   >> /home/$vUsuarioNoRoot/.raven/raven.conf
          rm -rf   /home/$vUsuarioNoRoot/Cryptos/BCH/
          mkdir -p /home/$vUsuarioNoRoot/Cryptos/BCH/ 2> /dev/null
          mv /root/SoftInst/Cryptos/BCH/raven-$vUltVersBitcoinCashNode/* /home/$vUsuarioNoRoot/Cryptos/BCH/
          chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/
          chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/BCH/ -R
          find /home/$vUsuarioNoRoot/Cryptos/BCH/ -type d -exec chmod 775 {} \;
          find /home/$vUsuarioNoRoot/Cryptos/BCH/ -type f -exec chmod 664 {} \;
          find /home/$vUsuarioNoRoot/Cryptos/BCH/bin -type f -exec chmod +x {} \;

          # Instalar los c-scripts
            su $vUsuarioNoRoot -c "curl -sL https://raw.githubusercontent.com/nipegun/c-scripts/main/CScripts-Instalar.sh | bash"
            find /home/$vUsuarioNoRoot/scripts/c-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;

          # Reparación de permisos
            chmod +x /home/$vUsuarioNoRoot/Cryptos/BCH/bin/*
            chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/BCH/ -R
            chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.raven/ -R

          # Iniciar el demonio
            echo ""
            echo "  Arrancando bitcoind..."
            echo ""
            su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/scripts/c-scripts/bch-daemon-iniciar.sh"
            sleep 5

            #su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/Cryptos/BCH/bin/raven-cli getnewaddress" > /home/$vUsuarioNoRoot/pooladdress-bch.txt
            #chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/pooladdress-bch.txt
            #echo ""
            #echo "  La dirección para recibir bitcoins es:"
            #echo ""
            #cat /home/$vUsuarioNoRoot/pooladdress-bch.txt
            #vDirCartBCH=$(cat /home/$vUsuarioNoRoot/pooladdress-bch.txt)
            #echo ""

          # Autoejecución del nodo al iniciar el sistema
            echo ""
            echo "    Agregando ravend a los ComandosPostArranque..."
            echo ""
            chmod +x /home/$vUsuarioNoRoot/scripts/c-scripts/bch-daemon-iniciar.sh
            echo "su $vUsuarioNoRoot -c '/home/"$vUsuarioNoRoot"/scripts/c-scripts/bch-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh
            echo ""

        ;;

        2)

          echo ""
          echo "  Instalando el nodo BitcoinCashNode desde la web de GitHub..."
          echo ""

          echo ""
          echo "    Determinando la última versión de BitcoinCashNode disponible en GitHub..."
          echo ""
          # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
              echo "  "
              echo ""
              apt-get -y update
              apt-get -y install curl
              echo ""
            fi
          $vUltVersBitcoinCashNode=$(curl -sL https://github.com/bitcoin-cash-node/bitcoin-cash-node/releases | sed 's->->\n-g' | grep href | grep tar | grep inux | grep 686 | grep -v debug | cut -d'"' -f2 | cut -d'/' -f6 |
cut -d'v' -f2)
          echo ""
          echo "      La última versión de BitcoinCashNode disponible en GitHub es la $vUltVersBitcoinCashNode"
          echo ""

          echo ""
          echo "    Determinando la URL del archivo a descargar..."
          echo ""
          vNombreArchivo=$(curl -sL https://github.com/bitcoin-cash-node/bitcoin-cash-node/releases | sed 's->->\n-g' | grep href | grep tar | grep inux | grep 686 | grep -v debug | cut -d'"' -f2)
          vURLArchivo="https://github.com/$vNombreArchivo"
          echo ""
          echo "      La URL del archivo es: $vURLArchivo"
          echo ""

          echo ""
          echo "    Intentando descargar el archivo..."          echo ""
          mkdir -p /root/SoftInst/Cryptos/BCH/ 2> /dev/null
          rm -rf /root/SoftInst/Cryptos/BCH/*
          cd /root/SoftInst/Cryptos/BCH/
          # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${cColorRojo}      El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
              echo ""
              apt-get -y update
              apt-get -y install wget
              echo ""
            fi
          wget $vURLArchivo -O /root/SoftInst/Cryptos/BCH/bitcoincashnode$vUltVersBitcoinCashNode.tar.gz

          echo ""
          echo "    Descomprimiendo el archivo..."          echo ""
          # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${cColorRojo}      El paquete tar no está instalado. Iniciando su instalación...${cFinColor}"
              echo ""
              apt-get -y update
              apt-get -y install tar
              echo ""
            fi
          tar -xf /root/SoftInst/Cryptos/BCH/bitcoincashnode$vUltVersBitcoinCashNode.tar.gz
          rm -f /root/SoftInst/Cryptos/BCH/bitcoincashnode$vUltVersBitcoinCashNode.tar.gz
          find /root/SoftInst/Cryptos/BCH/ -type d -name "raven*" -exec mv {} /root/SoftInst/Cryptos/BCH/"raven-$vUltVersBitcoinCashNode"/ \; 2> /dev/null

          echo ""
          echo "    Creando carpetas y archivos necesarios para ese usuario..."          echo ""
          mkdir -p /home/$vUsuarioNoRoot/.raven/
          touch    /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "rpcuser=bchrpc"           > /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "rpcpassword=bchrpcpass"  >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "rpcallowip=127.0.0.1"    >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "#Default RPC port 8766"  >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "rpcport=20401"           >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "server=1"                >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "listen=1"                >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "prune=550"               >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "daemon=1"                >> /home/$vUsuarioNoRoot/.raven/raven.conf
          echo "gen=0"                   >> /home/$vUsuarioNoRoot/.raven/raven.conf
          rm -rf   /home/$vUsuarioNoRoot/Cryptos/BCH/
          mkdir -p /home/$vUsuarioNoRoot/Cryptos/BCH/ 2> /dev/null
          mv /root/SoftInst/Cryptos/BCH/raven-$vUltVersBitcoinCashNode/* /home/$vUsuarioNoRoot/Cryptos/BCH/
          chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/
          chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/BCH/ -R
          find /home/$vUsuarioNoRoot/Cryptos/BCH/ -type d -exec chmod 775 {} \;
          find /home/$vUsuarioNoRoot/Cryptos/BCH/ -type f -exec chmod 664 {} \;
          find /home/$vUsuarioNoRoot/Cryptos/BCH/bin -type f -exec chmod +x {} \;

          # Instalar los c-scripts
            su $vUsuarioNoRoot -c "curl -sL https://raw.githubusercontent.com/nipegun/c-scripts/main/CScripts-Instalar.sh | bash"
            find /home/$vUsuarioNoRoot/scripts/c-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;

          # Reparación de permisos
            chmod +x /home/$vUsuarioNoRoot/Cryptos/BCH/bin/*
            chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/BCH/ -R
            chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.raven/ -R

          # Iniciar el demonio
            echo ""
            echo "  Arrancando bitcoind..."
            echo ""
            su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/scripts/c-scripts/bch-daemon-iniciar.sh"
            sleep 5

            #su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/Cryptos/BCH/bin/raven-cli getnewaddress" > /home/$vUsuarioNoRoot/pooladdress-bch.txt
            #chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/pooladdress-bch.txt
            #echo ""
            #echo "  La dirección para recibir bitcoins es:"
            #echo ""
            #cat /home/$vUsuarioNoRoot/pooladdress-bch.txt
            #vDirCartBCH=$(cat /home/$vUsuarioNoRoot/pooladdress-bch.txt)
            #echo ""

          # Autoejecución del nodo al iniciar el sistema
            echo ""
            echo "    Agregando ravend a los ComandosPostArranque..."
            echo ""
            chmod +x /home/$vUsuarioNoRoot/scripts/c-scripts/bch-daemon-iniciar.sh
            echo "su $vUsuarioNoRoot -c '/home/"$vUsuarioNoRoot"/scripts/c-scripts/bch-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh
            echo ""

        ;;

        3)

          echo ""
          echo "  Agregando configuración para el modo GUI..."
          echo ""

          # Icono de lanzamiento en el menú gráfico
            echo ""
            echo "    Agregando la aplicación gráfica al menú..."
            echo ""
            mkdir -p /home/$vUsuarioNoRoot/.local/share/applications/ 2> /dev/null
            chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.local/share/applications/
            echo "[Desktop Entry]"                                                   > /home/$vUsuarioNoRoot/.local/share/applications/bch.desktop
            echo "Name=bch GUI"                                                     >> /home/$vUsuarioNoRoot/.local/share/applications/bch.desktop
            echo "Type=Application"                                                 >> /home/$vUsuarioNoRoot/.local/share/applications/bch.desktop
            echo "Exec=/home/$vUsuarioNoRoot/scripts/c-scripts/bch-gui-iniciar.sh"  >> /home/$vUsuarioNoRoot/.local/share/applications/bch.desktop
            echo "Terminal=false"                                                   >> /home/$vUsuarioNoRoot/.local/share/applications/bch.desktop
            echo "Hidden=false"                                                     >> /home/$vUsuarioNoRoot/.local/share/applications/bch.desktop
            echo "Categories=Cryptos"                                               >> /home/$vUsuarioNoRoot/.local/share/applications/bch.desktop
            #echo "Icon="                                                           >> /home/$vUsuarioNoRoot/.local/share/applications/bch.desktop
            chown $vUsuarioNoRoot:$vUsuarioNoRoot                                      /home/$vUsuarioNoRoot/.local/share/applications/bch.desktop
            gio set /home/$vUsuarioNoRoot/.local/share/applications/bch.desktop "metadata::trusted" yes
            

          # Autoejecución gráfica de bitcoin
            echo ""
            echo "  Creando el archivo de autoejecución de raven-qt para escritorio..."
            echo ""
            mkdir -p /home/$vUsuarioNoRoot/.config/autostart/ 2> /dev/null
            chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.config/autostart/
            echo "[Desktop Entry]"                                                   > /home/$vUsuarioNoRoot/.config/autostart/bch.desktop
            echo "Name=bch GUI"                                                     >> /home/$vUsuarioNoRoot/.config/autostart/bch.desktop
            echo "Type=Application"                                                 >> /home/$vUsuarioNoRoot/.config/autostart/bch.desktop
            echo "Exec=/home/$vUsuarioNoRoot/scripts/c-scripts/bch-gui-iniciar.sh"  >> /home/$vUsuarioNoRoot/.config/autostart/bch.desktop
            echo "Terminal=false"                                                   >> /home/$vUsuarioNoRoot/.config/autostart/bch.desktop
            echo "Hidden=false"                                                     >> /home/$vUsuarioNoRoot/.config/autostart/bch.desktop
            chown $vUsuarioNoRoot:$vUsuarioNoRoot                                      /home/$vUsuarioNoRoot/.config/autostart/bch.desktop
            gio set /home/$vUsuarioNoRoot/.config/autostart/bch.desktop "metadata::trusted" yes

        ;;

    esac

done
