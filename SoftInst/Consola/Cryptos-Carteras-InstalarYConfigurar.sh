#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar diferentes carteras de criptomonedas en Debian10
#-------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

UsuarioNoRoot="NiPeGun"

echo ""
echo -e "${ColorVerde}-------------------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Iniciando el script de instalación de las diferentes carteras de criptomonedas...${FinColor}"
echo -e "${ColorVerde}-------------------------------------------------------------------------------------${FinColor}"
echo ""

## Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  dialog no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install dialog
     echo ""
   fi

menu=(dialog --timeout 5 --checklist "Marca lo que quieras instalar:" 22 76 16)
  opciones=(1 "Crear usuario sin privilegios para ejecutar la pool (Obligatorio)" on
            2 "Instalar los c-scripts (Obligatorio)" on
            3 "Borrar todas las carteras y configuraciones ya existentes" off
            4 "Instalar core de Litecoin" off
            5 "Instalar core de Ravencoin" off
            6 "Instalar core de Argentum" off
            7 "Instalar core de Monero" off
            8 "Instalar core de Chia" off
            9 "Instalar core de Bitcoin BCH (Todavía no disponible)" off
           10 "Instalar core de Bitcoin BTC (Todavía no disponible)" off
           11 "Instalar messenger de Utopia" off
           12 "(Todavía no disponible)" off
           13 "Mover todo hacia la carpeta del usuario no root" off
           14 "Instalar escritorio y algunas utilidades de terminal" off
           15 "Reparar permisos (Obligatorio)" on
           16 "Reniciar el sistema" off)
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  clear

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo -e "${ColorVerde}-------------------------------------------------------------${FinColor}"
          echo -e "${ColorVerde}  Creando el usuario para ejecutar y administrar la pool...${FinColor}"
          echo -e "${ColorVerde}-------------------------------------------------------------${FinColor}"
          echo ""

          ## Agregar el usuario
             useradd -d /home/$UsuarioNoRoot/ -s /bin/bash $UsuarioNoRoot

          ## Crear la contraseña
             passwd $UsuarioNoRoot

          ## Crear la carpeta
             mkdir -p /home/$UsuarioNoRoot/ 2> /dev/null

          ## Reparación de permisos
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R
        ;;

        2)

          echo ""
          echo -e "${ColorVerde}-------------------------------${FinColor}"
          echo -e "${ColorVerde}  Instalando los c-scripts...${FinColor}"
          echo -e "${ColorVerde}-------------------------------${FinColor}"
          echo ""

          ## Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "  curl no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install curl
               echo ""
             fi

          su $UsuarioNoRoot -c "curl --silent https://raw.githubusercontent.com/nipegun/c-scripts/main/CScripts-Instalar.sh | bash"
          find /home/$UsuarioNoRoot/scripts/c-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;

        ;;

        3)

          echo ""
          echo -e "${ColorVerde}-----------------------------------------------------${FinColor}"
          echo -e "${ColorVerde}  Borrando carteras y configuraciones anteriores...${FinColor}"
          echo -e "${ColorVerde}-----------------------------------------------------${FinColor}"
          echo ""

          ## Litecoin
             rm -rf /home/$UsuarioNoRoot/.litecoin/
          ## Raven
             rm -rf /home/$UsuarioNoRoot/.raven/
          ## Argentum
             rm -rf /home/$UsuarioNoRoot/.argentum/
          ## Chia
             rm -rf /home/$UsuarioNoRoot/.chia/
             rm -rf /home/$UsuarioNoRoot/.config/Chia Blockchain/
          ## Pool MPOS
             rm -rf /var/www/MPOS/

          ## Reparación de permisos
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R
        ;;

        4)

          echo ""
          echo -e "${ColorVerde}-------------------------------------${FinColor}"
          echo -e "${ColorVerde}  Instalando la cartera litecoin...${FinColor}"
          echo -e "${ColorVerde}-------------------------------------${FinColor}"
          echo ""

          echo "  Determinando la última versión de litecoin core..."
          echo ""
          ## Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo "  curl no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update
              apt-get -y install curl
              echo ""
            fi
          UltVersLite=$(curl --silent https://litecoin.org | grep linux-gnu | grep x86_64 | grep -v in64 | cut -d '"' -f 2 | sed 2d | cut -d '-' -f 3)
          echo ""
          echo "  La última versión de raven es la $UltVersLite"

          echo ""
          echo "  Intentando descargar el archivo comprimido de la última versión..."
          echo ""
          mkdir -p /root/SoftInst/Litecoin/ 2> /dev/null
          rm -rf /root/SoftInst/Litecoin/*
          cd /root/SoftInst/Litecoin/
          ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo "  wget no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update
              apt-get -y install wget
              echo ""
            fi
          echo "  Pidiendo el archivo en formato tar.gz..."
          echo ""
          wget https://download.litecoin.org/litecoin-$UltVersLite/linux/litecoin-$UltVersLite-x86_64-linux-gnu.tar.gz

          echo ""
          echo "  Descomprimiendo el archivo..."
          echo ""
          ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo "  tar no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update
              apt-get -y install tar
              echo ""
            fi
          tar -xf /root/SoftInst/Litecoin/litecoin-$UltVersLite-x86_64-linux-gnu.tar.gz
          rm -rf /root/SoftInst/Litecoin/litecoin-$UltVersLite-x86_64-linux-gnu.tar.gz

          echo ""
          echo "  Creando carpetas y archivos necesarios para ese usuario..."
          echo ""
          mkdir -p /home/$UsuarioNoRoot/Cryptos/LTC/ 2> /dev/null
          mkdir -p /home/$UsuarioNoRoot/.litecoin/
          touch /home/$UsuarioNoRoot/.litecoin/litecoin.conf
          echo "rpcuser=user1"      > /home/$UsuarioNoRoot/.litecoin/litecoin.conf
          echo "rpcpassword=pass1" >> /home/$UsuarioNoRoot/.litecoin/litecoin.conf
          echo "prune=550"         >> /home/$UsuarioNoRoot/.litecoin/litecoin.conf
          echo "daemon=1"          >> /home/$UsuarioNoRoot/.litecoin/litecoin.conf
          rm -rf /home/$UsuarioNoRoot/Cryptos/LTC/
          mv /root/SoftInst/Litecoin/litecoin-$UltVersLite/ /home/$UsuarioNoRoot/Cryptos/LTC/
          chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R
          find /home/$UsuarioNoRoot -type d -exec chmod 775 {} \;
          find /home/$UsuarioNoRoot -type f -exec chmod 664 {} \;
          find /home/$UsuarioNoRoot/Cryptos/LTC/bin -type f -exec chmod +x {} \;

          echo ""
          echo "  Arrancando litecoind..."
          echo ""
          su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/Cryptos/LTC/bin/litecoind -daemon"
          sleep 5
          su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/Cryptos/LTC/bin/litecoin-cli getnewaddress" > /home/$UsuarioNoRoot/pooladdress-ltc.txt
          chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/pooladdress-ltc.txt
          echo ""
          echo "  La dirección para recibir litecoins es:"
          echo ""
          cat /home/$UsuarioNoRoot/pooladdress-ltc.txt
          DirCartLTC=$(cat /home/$UsuarioNoRoot/pooladdress-ltc.txt)
          echo ""

          ## Autoejecución de Litecoin al iniciar el sistema

             echo ""
             echo "  Agregando litecoind a los ComandosPostArranque..."
             echo ""
             echo "chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/ltc-daemon-iniciar.sh"
             echo "su "$UsuarioNoRoot" -c '/home/"$UsuarioNoRoot"/scripts/c-scripts/ltc-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh

          ## Icono de lanzamiento en el menú gráfico

             echo ""
             echo "  Agregando la aplicación gráfica al menú..."
             echo ""
             mkdir -p /home/$UsuarioNoRoot/.local/share/applications/ 2> /dev/null
             echo "[Desktop Entry]"                                                     > /home/$UsuarioNoRoot/.local/share/applications/litecoin.desktop
             echo "Name=Litecoin GUI"                                                  >> /home/$UsuarioNoRoot/.local/share/applications/litecoin.desktop
             echo "Type=Application"                                                   >> /home/$UsuarioNoRoot/.local/share/applications/litecoin.desktop
             echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/ltc-qt-iniciar.sh" >> /home/$UsuarioNoRoot/.local/share/applications/litecoin.desktop
             echo "Terminal=false"                                                     >> /home/$UsuarioNoRoot/.local/share/applications/litecoin.desktop
             echo "Hidden=false"                                                       >> /home/$UsuarioNoRoot/.local/share/applications/litecoin.desktop
             echo "Categories=Cryptos"                                                 >> /home/$UsuarioNoRoot/.local/share/applications/litecoin.desktop
             #echo "Icon="                                                             >> /home/$UsuarioNoRoot/.local/share/applications/litecoin.desktop

          ## Autoejecución gráfica de Litecoin

             echo ""
             echo "  Creando el archivo de autoejecución de litecoin-qt para escritorio..."
             echo ""
             mkdir -p /home/$UsuarioNoRoot/.config/autostart/ 2> /dev/null
             echo "[Desktop Entry]"                                                     > /home/$UsuarioNoRoot/.config/autostart/litecoin.desktop
             echo "Name=Litecoin GUI"                                                  >> /home/$UsuarioNoRoot/.config/autostart/litecoin.desktop
             echo "Type=Application"                                                   >> /home/$UsuarioNoRoot/.config/autostart/litecoin.desktop
             echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/ltc-qt-iniciar.sh" >> /home/$UsuarioNoRoot/.config/autostart/litecoin.desktop
             echo "Terminal=false"                                                     >> /home/$UsuarioNoRoot/.config/autostart/litecoin.desktop
             echo "Hidden=false"                                                       >> /home/$UsuarioNoRoot/.config/autostart/litecoin.desktop

          ## Reparación de permisos

             chmod +x /home/$UsuarioNoRoot/Cryptos/LTC/bin/*
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R

          ## Parar el daemon
             chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/ltc-daemon-parar.sh
             su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/scripts/c-scripts/ltc-daemon-parar.sh"

        ;;

        5)

          echo ""
          echo -e "${ColorVerde}-------------------------------------${FinColor}"
          echo -e "${ColorVerde}  Instalando la cartera de raven...${FinColor}"
          echo -e "${ColorVerde}-------------------------------------${FinColor}"
          echo ""

          echo "  Determinando la última versión de raven core..."
          echo ""
          ## Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "  curl no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install curl
               echo ""
             fi
          UltVersRaven=$(curl --silent https://github.com/RavenProject/Ravencoin/releases/latest | cut -d '/' -f 8 | cut -d '"' -f 1 | cut -c2-)
          echo ""
          echo "  La última versión de raven es la $UltVersRaven"
          echo ""

          echo ""
          echo "  Intentando descargar el archivo comprimido de la última versión..."
          echo ""
          mkdir -p /root/SoftInst/Ravencoin/ 2> /dev/null
          rm -rf /root/SoftInst/Ravencoin/*
          cd /root/SoftInst/Ravencoin/
          ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "  wget no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install wget
               echo ""
             fi
          echo ""
          echo "  Pidiendo el archivo en formato zip..."
          echo ""
          wget https://github.com/RavenProject/Ravencoin/releases/download/v$UltVersRaven/raven-$UltVersRaven-x86_64-linux-gnu.zip
          echo ""
          echo "  Pidiendo el archivo en formato tar.gz..."
          echo ""
          wget https://github.com/RavenProject/Ravencoin/releases/download/v$UltVersRaven/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz

          echo ""
          echo "  Descomprimiendo el archivo..."
          echo ""
          ## Comprobar si el paquete zip está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s zip 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "  zip no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install zip
               echo ""
             fi
          unzip /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.zip
          mv /root/SoftInst/Ravencoin/linux/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz /root/SoftInst/Ravencoin/
          rm -rf /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.zip
          rm -rf /root/SoftInst/Ravencoin/linux/
          rm -rf /root/SoftInst/Ravencoin/__MACOSX/
          ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "  tar no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install tar
               echo ""
             fi
          tar -xf /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz
          rm -rf /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz

          echo ""
          echo "  Creando carpetas y archivos necesarios para ese usuario..."
          echo ""
          mkdir -p /home/$UsuarioNoRoot/Cryptos/RVN/ 2> /dev/null
          mkdir -p /home/$UsuarioNoRoot/.raven/
          touch /home/$UsuarioNoRoot/.raven/raven.conf
          echo "rpcuser=rvnrpc"           > /home/$UsuarioNoRoot/.raven/raven.conf
          echo "rpcpassword=rvnrpcpass"  >> /home/$UsuarioNoRoot/.raven/raven.conf
          echo "rpcallowip=127.0.0.1"    >> /home/$UsuarioNoRoot/.raven/raven.conf
          echo "#Default RPC port 8766"  >> /home/$UsuarioNoRoot/.raven/raven.conf
          echo "rpcport=20401"           >> /home/$UsuarioNoRoot/.raven/raven.conf
          echo "server=1"                >> /home/$UsuarioNoRoot/.raven/raven.conf
          echo "listen=1"                >> /home/$UsuarioNoRoot/.raven/raven.conf
          echo "prune=550"               >> /home/$UsuarioNoRoot/.raven/raven.conf
          echo "daemon=1"                >> /home/$UsuarioNoRoot/.raven/raven.conf
          echo "gen=0"                   >> /home/$UsuarioNoRoot/.raven/raven.conf
          rm -rf /home/$UsuarioNoRoot/Cryptos/RVN/
          mv /root/SoftInst/Ravencoin/raven-$UltVersRaven/ /home/$UsuarioNoRoot/Cryptos/RVN/
          chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R
          find /home/$UsuarioNoRoot -type d -exec chmod 775 {} \;
          find /home/$UsuarioNoRoot -type f -exec chmod 664 {} \;
          find /home/$UsuarioNoRoot/Cryptos/RVN/bin -type f -exec chmod +x {} \;

          echo ""
          echo "  Arrancando ravencoind..."
          echo ""
          su $UsuarioNoRoot -c /home/$UsuarioNoRoot/Cryptos/RVN/bin/ravend
          sleep 5
          su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/Cryptos/RVN/bin/raven-cli getnewaddress" > /home/$UsuarioNoRoot/pooladdress-rvn.txt
          chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/pooladdress-rvn.txt
          echo ""
          echo "  La dirección para recibir ravencoins es:"
          echo ""
          cat /home/$UsuarioNoRoot/pooladdress-rvn.txt
          DirCartRVN=$(cat /home/$UsuarioNoRoot/pooladdress-rvn.txt)
          echo ""

          ## Autoejecución de Ravencoin al iniciar el sistema

             echo ""
             echo "  Agregando ravend a los ComandosPostArranque..."
             echo ""
             chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/rvn-daemon-iniciar.sh
             echo "su "$UsuarioNoRoot" -c '/home/"$UsuarioNoRoot"/scripts/c-scripts/rvn-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh

          ## Icono de lanzamiento en el menú gráfico

             echo ""
             echo "  Agregando la aplicación gráfica al menú..."
             echo ""
             mkdir -p /home/$UsuarioNoRoot/.local/share/applications/ 2> /dev/null
             echo "[Desktop Entry]"                                                  > /home/$UsuarioNoRoot/.local/share/applications/raven.desktop
             echo "Name=Raven GUI"                                                  >> /home/$UsuarioNoRoot/.local/share/applications/raven.desktop
             echo "Type=Application"                                                >> /home/$UsuarioNoRoot/.local/share/applications/raven.desktop
             echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/rvn-qt-iniciar.sh"   >> /home/$UsuarioNoRoot/.local/share/applications/raven.desktop
             echo "Terminal=false"                                                  >> /home/$UsuarioNoRoot/.local/share/applications/raven.desktop
             echo "Hidden=false"                                                    >> /home/$UsuarioNoRoot/.local/share/applications/raven.desktop
             echo "Categories=Cryptos"                                              >> /home/$UsuarioNoRoot/.local/share/applications/raven.desktop
             #echo "Icon="                                                          >> /home/$UsuarioNoRoot/.local/share/applications/raven.desktop

          ## Autoejecución gráfica de Ravencoin

             echo ""
             echo "  Creando el archivo de autoejecución de raven-qt para escritorio..."
             echo ""
             mkdir -p /home/$UsuarioNoRoot/.config/autostart/ 2> /dev/null
             echo "[Desktop Entry]"                                                  > /home/$UsuarioNoRoot/.config/autostart/raven.desktop
             echo "Name=Raven GUI"                                                  >> /home/$UsuarioNoRoot/.config/autostart/raven.desktop
             echo "Type=Application"                                                >> /home/$UsuarioNoRoot/.config/autostart/raven.desktop
             echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/rvn-qt-iniciar.sh"   >> /home/$UsuarioNoRoot/.config/autostart/raven.desktop
             echo "Terminal=false"                                                  >> /home/$UsuarioNoRoot/.config/autostart/raven.desktop
             echo "Hidden=false"                                                    >> /home/$UsuarioNoRoot/.config/autostart/raven.desktop

          ## Reparación de permisos

             chmod +x /home/$UsuarioNoRoot/Cryptos/RVN/bin/*
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R

          ## Parar el daemon
             chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/rvn-daemon-parar.sh
             su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/scripts/c-scripts/rvn-daemon-parar.sh"

        ;;

        6)

          echo ""
          echo -e "${ColorVerde}----------------------------------------${FinColor}"
          echo -e "${ColorVerde}  Instalando la cartera de argentum...${FinColor}"
          echo -e "${ColorVerde}----------------------------------------${FinColor}"
          echo ""

          echo "  Determinando la última versión de argentum core..."
          echo ""
          ## Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "  curl no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install curl
               echo ""
             fi

          UltVersArgentum=$(curl -s https://github.com/argentumproject/argentum/releases/ | grep linux | grep gnu | grep tar | grep href | cut -d '"' -f 2 | sed -n 1p | cut -d'-' -f 2)
          echo ""
          echo "  La última versión de argentum core es la $UltVersArgentum"
          echo ""

          echo ""
          echo "  Intentando descargar el archivo comprimido de la última versión..."
          echo ""
          mkdir -p /root/SoftInst/Argentumcoin/ 2> /dev/null
          rm -rf /root/SoftInst/Argentumcoin/*
          cd /root/SoftInst/Argentumcoin/
          ArchUltVersAgentum=$(curl -s https://github.com/argentumproject/argentum/releases/ | grep linux | grep gnu | grep tar | grep href | cut -d '"' -f 2 | sed -n 1p)
          ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "  wget no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install wget
               echo ""
             fi
          wget --no-check-certificate https://github.com$ArchUltVersAgentum -O /root/SoftInst/Argentumcoin/Argentum.tar.gz

          echo ""
          echo "  Descomprimiendo el archivo..."
          echo ""
          ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "  tar no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install tar
               echo ""
             fi
          tar -xf /root/SoftInst/Argentumcoin/Argentum.tar.gz
          rm -rf /root/SoftInst/Argentumcoin/Argentum.tar.gz

          echo ""
          echo "  Creando carpetas y archivos necesarios para ese usuario..."
          echo ""
          mkdir -p /home/$UsuarioNoRoot/Cryptos/ARG/ 2> /dev/null
          ## Archivo argentum.conf
             mkdir -p /home/$UsuarioNoRoot/.argentum/
             touch /home/$UsuarioNoRoot/.argentum/argentum.conf
             echo "daemon=1"                       > /home/$UsuarioNoRoot/.argentum/argentum.conf
             echo "addnode=31.25.241.224:13580"   >> /home/$UsuarioNoRoot/.argentum/argentum.conf
             echo "addnode=52.27.168.5:13580"     >> /home/$UsuarioNoRoot/.argentum/argentum.conf
             echo "addnode=46.105.63.132:13580"   >> /home/$UsuarioNoRoot/.argentum/argentum.conf
             echo "addnode=85.15.179.171:13580"   >> /home/$UsuarioNoRoot/.argentum/argentum.conf
             echo "addnode=95.79.35.133:13580"    >> /home/$UsuarioNoRoot/.argentum/argentum.conf
             echo "addnode=172.104.110.155:13580" >> /home/$UsuarioNoRoot/.argentum/argentum.conf
          rm -rf /home/$UsuarioNoRoot/Cryptos/ARG/
          mv /root/SoftInst/Argentumcoin/argentum-$UltVersArgentum/ /home/$UsuarioNoRoot/Cryptos/ARG/
          chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R
          find /home/$UsuarioNoRoot -type d -exec chmod 775 {} \;
          find /home/$UsuarioNoRoot -type f -exec chmod 664 {} \;
          find /home/$UsuarioNoRoot/Cryptos/ARG/bin -type f -exec chmod +x {} \;
          ## Denegar el acceso a la carpeta a los otros usuarios del sistema
             #find /home/$UsuarioNoRoot -type d -exec chmod 750 {} \;
             #find /home/$UsuarioNoRoot -type f -exec chmod 664 {} \;

          echo ""
          echo "  Arrancando argentumd..."
          echo ""
          su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/Cryptos/ARG/bin/argentumd"
          sleep 5
          su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/Cryptos/ARG/bin/argentum-cli getnewaddress" > /home/$UsuarioNoRoot/pooladdress-arg.txt
          chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/pooladdress-arg.txt
          echo ""
          echo "  La dirección para recibir argentum es:"
          echo ""
          cat /home/$UsuarioNoRoot/pooladdress-arg.txt
          DirCartARG=$(cat /home/$UsuarioNoRoot/pooladdress-arg.txt)
          echo ""

          ## Autoejecución de Argentum al iniciar el sistema

             echo ""
             echo "  Agregando argentumd a los ComandosPostArranque..."
             echo ""
             echo "chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/arg-daemon-iniciar.sh"
             echo "su "$UsuarioNoRoot" -c '/home/"$UsuarioNoRoot"/scripts/c-scripts/arg-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh

          ## Icono de lanzamiento en el menú gráfico

             echo ""
             echo "  Agregando la aplicación gráfica al menú..."
             echo ""
             mkdir -p /home/$UsuarioNoRoot/.local/share/applications/ 2> /dev/null
             echo "[Desktop Entry]"                                                     > /home/$UsuarioNoRoot/.local/share/applications/argentum.desktop
             echo "Name=Argentum GUI"                                                  >> /home/$UsuarioNoRoot/.local/share/applications/argentum.desktop
             echo "Type=Application"                                                   >> /home/$UsuarioNoRoot/.local/share/applications/argentum.desktop
             echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/arg-qt-iniciar.sh"      >> /home/$UsuarioNoRoot/.local/share/applications/argentum.desktop
             echo "Terminal=false"                                                     >> /home/$UsuarioNoRoot/.local/share/applications/argentum.desktop
             echo "Hidden=false"                                                       >> /home/$UsuarioNoRoot/.local/share/applications/argentum.desktop
             echo "Categories=Cryptos"                                                 >> /home/$UsuarioNoRoot/.local/share/applications/argentum.desktop
             #echo "Icon="                                                             >> /home/$UsuarioNoRoot/.local/share/applications/argentum.desktop

          ## Autoejecución gráfica de Argentum

             echo ""
             echo "  Creando el archivo de autoejecución de argentum-qt para escritorio..."
             echo ""
             mkdir -p /home/$UsuarioNoRoot/.config/autostart/ 2> /dev/null
             echo "[Desktop Entry]"                                                     > /home/$UsuarioNoRoot/.config/autostart/argentum.desktop
             echo "Name=Argentum GUI"                                                  >> /home/$UsuarioNoRoot/.config/autostart/argentum.desktop
             echo "Type=Application"                                                   >> /home/$UsuarioNoRoot/.config/autostart/argentum.desktop
             echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/arg-qt-iniciar.sh"      >> /home/$UsuarioNoRoot/.config/autostart/argentum.desktop
             echo "Terminal=false"                                                     >> /home/$UsuarioNoRoot/.config/autostart/argentum.desktop
             echo "Hidden=false"                                                       >> /home/$UsuarioNoRoot/.config/autostart/argentum.desktop

          ## Reparación de permisos

             chmod +x /home/$UsuarioNoRoot/Cryptos/ARG/bin/*
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R

          ## Parar el daemon
             chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/arg-daemon-parar.sh
             su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/scripts/c-scripts/arg-daemon-parar.sh"
        ;;

        7)

          echo ""
          echo -e "${ColorVerde}--------------------------------------${FinColor}"
          echo -e "${ColorVerde}  Instalando la cartera de monero...${FinColor}"
          echo -e "${ColorVerde}--------------------------------------${FinColor}"
          echo ""

          echo ""
          echo "  Descargando el archivo comprimido de la última release..."
          echo ""
          ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "  wget no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install wget
               echo ""
             fi
          mkdir -p /root/SoftInst/Monerocoin/ 2> /dev/null
          rm -rf /root/SoftInst/Monerocoin/*
          wget https://downloads.getmonero.org/gui/linux64 -O /root/SoftInst/Monerocoin/monero.tar.bz2
          #wget https://downloads.getmonero.org/cli/linux64 -O /root/SoftInst/Monerocoin/monero.tar.bz2

          echo ""
          echo "  Descomprimiendo el archivo..."
          echo ""
          ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "  tar no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install tar
               echo ""
             fi
          tar xjfv /root/SoftInst/Monerocoin/monero.tar.bz2 -C /root/SoftInst/Monerocoin/
          rm -rf /root/SoftInst/Monerocoin/monero.tar.bz2

          echo ""
          echo "  Preparando la carpeta final..."
          echo ""
          mkdir -p /home/$UsuarioNoRoot/Cryptos/XMR/bin/ 2> /dev/null
          find /root/SoftInst/Monerocoin/ -type d -name monero* -exec cp -r {}/. /home/$UsuarioNoRoot/Cryptos/XMR/bin/ \;
          rm -rf /root/SoftInst/Monerocoin/*
          mkdir -p /home/$UsuarioNoRoot/.config/monero-project/ 2> /dev/null
          echo "[General]"                                       > /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "account_name=$UsuarioNoRoot"                    >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "askPasswordBeforeSending=true"                  >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "autosave=true"                                  >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "autosaveMinutes=10"                             >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "blackTheme=true"                                >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "blockchainDataDir=/home/$UsuarioNoRoot/.monero" >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "checkForUpdates=true"                           >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "customDecorations=true"                         >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "fiatPriceEnabled=true"                          >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "fiatPriceProvider=kraken"                       >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "language=Espa\xf1ol"                            >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "language_wallet=Espa\xf1ol"                     >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "locale=es_ES"                                   >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "lockOnUserInActivity=true"                      >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "lockOnUserInActivityInterval=1"                 >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "transferShowAdvanced=true"                      >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "useRemoteNode=false"                            >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
          echo "walletMode=2"                                   >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf

          echo ""
          echo "  Instalando paquetes necesarios para ejecutar la cartera..."
          echo ""
          apt-get -y install libxcb-icccm4
          apt-get -y install libxcb-image0
          apt-get -y install libxcb-keysyms1
          apt-get -y install libxcb-randr0
          apt-get -y install libxcb-render-util0
          apt-get -y install libxcb-xkb1
          apt-get -y install libxkbcommon-x11-0

          ## Autoejecución de Monero al iniciar el sistema

             echo ""
             echo "  Agregando monerod a los ComandosPostArranque..."
             echo ""
             echo "chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/xmr-daemon-iniciar"
             echo "su $UsuarioNoRoot -c '/home/"$UsuarioNoRoot"/scripts/c-scripts/xmr-daemon-iniciar'" >> /root/scripts/ComandosPostArranque.sh

          ## Icono de lanzamiento en el menú gráfico

             echo ""
             echo "  Agregando la aplicación gráfica al menú..."
             echo ""
             mkdir -p /home/$UsuarioNoRoot/.local/share/applications/ 2> /dev/null
             echo "[Desktop Entry]"                                                    > /home/$UsuarioNoRoot/.local/share/applications/monero.desktop
             echo "Name=Monero GUI"                                                   >> /home/$UsuarioNoRoot/.local/share/applications/monero.desktop
             echo "Type=Application"                                                  >> /home/$UsuarioNoRoot/.local/share/applications/monero.desktop
             echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/xmr-gui-iniciar.sh"    >> /home/$UsuarioNoRoot/.local/share/applications/monero.desktop
             echo "Terminal=false"                                                    >> /home/$UsuarioNoRoot/.local/share/applications/monero.desktop
             echo "Hidden=false"                                                      >> /home/$UsuarioNoRoot/.local/share/applications/monero.desktop
             echo "Categories=Cryptos"                                                >> /home/$UsuarioNoRoot/.local/share/applications/monero.desktop
             #echo "Icon="                                                            >> /home/$UsuarioNoRoot/.local/share/applications/monero.desktop

          ## Autoejecución gráfica de monero

             echo ""
             echo "  Creando el archivo de autoejecución de monero-wallet-gui para el escritorio..."
             echo ""
             mkdir -p /home/$UsuarioNoRoot/.config/autostart/ 2> /dev/null
             echo "[Desktop Entry]"                                                    > /home/$UsuarioNoRoot/.config/autostart/monero.desktop
             echo "Name=Monero GUI"                                                   >> /home/$UsuarioNoRoot/.config/autostart/monero.desktop
             echo "Type=Application"                                                  >> /home/$UsuarioNoRoot/.config/autostart/monero.desktop
             echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/xmr-gui-iniciar.sh" >> /home/$UsuarioNoRoot/.config/autostart/monero.desktop
             echo "Terminal=false"                                                    >> /home/$UsuarioNoRoot/.config/autostart/monero.desktop
             echo "Hidden=false"                                                      >> /home/$UsuarioNoRoot/.config/autostart/monero.desktop

          ## Reparación de permisos

             chmod +x /home/$UsuarioNoRoot/Cryptos/XMR/bin/*
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R

          ## Parar el daemon
             chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/xmr-daemon-parar.sh
             su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/scripts/c-scripts/xmr-daemon-parar.sh"

        ;;

        8)

          echo ""
          echo -e "${ColorVerde}---------------------------------------------------------------${FinColor}"
          echo -e "${ColorVerde}  Instalando la cadena de bloques de chia y sus utilidades...${FinColor}"
          echo -e "${ColorVerde}---------------------------------------------------------------${FinColor}"
          echo ""

          ## Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "  git no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install git
               echo ""
             fi

          mkdir -p /root/SoftInst/Cryptos/XCH/ 2> /dev/null
          rm -rf /root/SoftInst/Cryptos/XCH/*
          cd /root/SoftInst/Cryptos/XCH/
          echo ""
          echo "  Descargando el paquete .deb de la instalación de core de Chia..."
          echo ""
          wget https://download.chia.net/latest/x86_64-Ubuntu-gui -O /root/SoftInst/Cryptos/XCH/chia-blockchain.deb
          echo ""
          echo "  Extrayendo los archivos de dentro del paquete .deb..."
          echo ""
          ## Comprobar si el paquete binutils está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s binutils 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "  binutils no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install binutils
               echo ""
             fi
          ar xv /root/SoftInst/Cryptos/XCH/chia-blockchain.deb
          rm -rf /root/SoftInst/Cryptos/XCH/debian-binary
          rm -rf /root/SoftInst/Cryptos/XCH/control.tar.xz
          echo ""
          echo "  Descomprimiendo el archivo data.tar.xz..."
          echo ""
          ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "  tar no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install tar
               echo ""
             fi
          tar -xvf /root/SoftInst/Cryptos/XCH/data.tar.xz
          rm -rf /root/SoftInst/Cryptos/XCH/data.tar.xz
          echo ""
          echo "  Instalando dependencias necesarias para ejecutar el core de Chia..."
          echo ""
          apt-get -y install libgtk-3-0
          apt-get -y install libnotify4
          apt-get -y install libnss3
          apt-get -y install libxtst6
          apt-get -y install xdg-utils
          apt-get -y install libatspi2.0-0
          apt-get -y install libdrm2
          apt-get -y install libgbm1
          apt-get -y install libxcb-dri3-0
          apt-get -y install kde-cli-tools
          apt-get -y install kde-runtime
          apt-get -y install trash-cli
          apt-get -y install libglib2.0-bin
          apt-get -y install gvfs-bin
          #dpkg -i /root/SoftInst/Cryptos/XCH/chia-blockchain.deb
          #echo ""
          #echo "Para ver que archivos instaló el paquete, ejecuta:"
          #echo ""
          #echo "dpkg-deb -c /root/SoftInst/Cryptos/XCH/chia-blockchain.deb"
          mkdir -p /home/$UsuarioNoRoot/Cryptos/XCH/ 2> /dev/null
          rm -rf /home/$UsuarioNoRoot/Cryptos/XCH/chia-blockchain/ 2> /dev/null
          mv /root/SoftInst/Cryptos/XCH/usr/lib/chia-blockchain/ /home/$UsuarioNoRoot/Cryptos/XCH/
          rm -rf /root/SoftInst/Cryptos/XCH/usr/
          #mkdir -p /home/$UsuarioNoRoot/.config/Chia Blockchain/ 2> /dev/null
          #echo '{"spellcheck":{"dictionaries":["es-ES"],"dictionary":""}}' > /home/$UsuarioNoRoot/.config/Chia Blockchain/Preferences

          ## Icono de lanzamiento en el menú gráfico

             echo ""
             echo "  Agregando la aplicación gráfica al menú..."
             echo ""
             mkdir -p /home/$UsuarioNoRoot/.local/share/applications/ 2> /dev/null
             echo "[Desktop Entry]"                                                 > /home/$UsuarioNoRoot/.local/share/applications/chia.desktop
             echo "Name=Chia GUI"                                                  >> /home/$UsuarioNoRoot/.local/share/applications/chia.desktop
             echo "Type=Application"                                               >> /home/$UsuarioNoRoot/.local/share/applications/chia.desktop
             echo "Exec=/home/$UsuarioNoRoot/scipts/c-scripts/xch-gui-iniciar.sh" >> /home/$UsuarioNoRoot/.local/share/applications/chia.desktop
             echo "Terminal=false"                                                 >> /home/$UsuarioNoRoot/.local/share/applications/chia.desktop
             echo "Hidden=false"                                                   >> /home/$UsuarioNoRoot/.local/share/applications/chia.desktop
             echo "Categories=Cryptos"                                             >> /home/$UsuarioNoRoot/.local/share/applications/chia.desktop
             #echo "Icon="                                                         >> /home/$UsuarioNoRoot/.local/share/applications/chia.desktop

          ## Autoejecución de chia

             echo ""
             echo "  Creando el archivo de autoejecución de chia-blockchain para el escritorio..."
             echo ""
             mkdir -p /home/$UsuarioNoRoot/.config/autostart/ 2> /dev/null
             echo "[Desktop Entry]"                                                  > /home/$UsuarioNoRoot/.config/autostart/chia.desktop
             echo "Name=Chia GUI"                                                   >> /home/$UsuarioNoRoot/.config/autostart/chia.desktop
             echo "Type=Application"                                                >> /home/$UsuarioNoRoot/.config/autostart/chia.desktop
             echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/xch-gui-iniciar.sh"  >> /home/$UsuarioNoRoot/.config/autostart/chia.desktop
             echo "Terminal=false"                                                  >> /home/$UsuarioNoRoot/.config/autostart/chia.desktop
             echo "Hidden=false"                                                    >> /home/$UsuarioNoRoot/.config/autostart/chia.desktop

          ## Reparación de permisos

             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R
             chown root:root /home/$UsuarioNoRoot/Cryptos/XCH/chia-blockchain/chrome-sandbox
             chmod 4755 /home/$UsuarioNoRoot/Cryptos/XCH/chia-blockchain/chrome-sandbox

          ## Parar el daemon
             chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/xch-daemon-parar.sh
             su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/scripts/c-scripts/xch-daemon-parar.sh"

        ;;

        9)

          echo ""
          echo -e "${ColorVerde}------------------------------${FinColor}"
          echo -e "${ColorVerde}  Instalando core de BCH (Todavía no disponible)...${FinColor}"
          echo -e "${ColorVerde}------------------------------${FinColor}"
          echo ""

        ;;

        10)

          echo ""
          echo -e "${ColorVerde}------------------------------${FinColor}"
          echo -e "${ColorVerde}  Instalando core de BTC (Todavía no disponible)...${FinColor}"
          echo -e "${ColorVerde}------------------------------${FinColor}"
          echo ""

        ;;

        11)

          echo ""
          echo -e "${ColorVerde}----------------------------------------------------${FinColor}"
          echo -e "${ColorVerde}  Instalando o actualizando messenger de Utopia...${FinColor}"
          echo -e "${ColorVerde}----------------------------------------------------${FinColor}"
          echo ""

          ## Crear la carpeta
             rm -rf /root/Cryptos/CRP/messenger/ 2> /dev/null
             mkdir -p /root/Cryptos/CRP/ 2> /dev/null

          ## Descargar la última versión del messenger
             ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo "  wget no está instalado. Iniciando su instalación..."
                  echo ""
                  apt-get -y update
                  apt-get -y install wget
                  echo ""
                fi
             echo ""
             echo "  Descargando el archivo .deb..."
             echo ""
             cd /root/Cryptos/CRP/
             wget https://update.u.is/downloads/linux/utopia-latest.amd64.deb

          ## Extraer los archivos de dentro del archivo .deb
             ## Comprobar si el paquete binutils está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s binutils 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo "  binutils no está instalado. Iniciando su instalación..."
                  echo ""
                  apt-get -y update
                  apt-get -y install binutils
                  echo ""
                fi
             echo ""
             echo "  Descomprimiendo el archivo .deb..."
             echo ""
             ar xv /root/Cryptos/CRP/utopia-latest.amd64.deb

          ## Extraer los archivos de dentro del archivo data.tar.xz
             ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo "  tar no está instalado. Iniciando su instalación..."
                  echo ""
                  apt-get -y update
                  apt-get -y install tar
                  echo ""
                fi
             echo ""
             echo "  Descomprimiendo el archivo data.tar.xz..."
             echo ""
             tar xfv /root/Cryptos/CRP/data.tar.xz
             echo ""

          ## Mover la carpeta de messenger a la raíz de CRP
             mv /root/Cryptos/CRP/opt/utopia/* /root/Cryptos/CRP/
             mkdir -p /root/Cryptos/CRP/container/

          ## Crear icono para el menu gráfico
             rm -rf /usr/share/applications/utopia.desktop 2> /dev/null
             rm -rf /root/.local/share/applications/utopia.desktop 2> /dev/null
             mkdir -p /root/.local/share/applications/ 2> /dev/null
             mv /root/Cryptos/CRP/usr/share/applications/utopia.desktop    /root/.local/share/applications/
             mv /root/Cryptos/CRP/usr/share/pixmaps/utopia.png             /root/Cryptos/CRP/messenger/
             sed -i -e 's|/usr/share/pixmaps/utopia.png|/root/Cryptos/CRP/messenger/utopia.png|g' /root/.local/share/applications/utopia.desktop
             sed -i -e 's|/opt/utopia/messenger|/root/Cryptos/CRP/messenger|g'                    /root/.local/share/applications/utopia.desktop

          ## Crear icono para auto-ejecución gráfica
             mkdir -p /root/.config/autostart/ 2> /dev/null
             cp /root/.local/share/applications/utopia.desktop /root/.config/autostart/utopia.desktop

          ## Borrar archivos sobrantes
             echo ""
             echo "  Borrando archivos sobrantes..."
             echo ""
             rm -rf /root/Cryptos/CRP/opt/
             rm -rf /root/Cryptos/CRP/usr/
             rm -rf /root/Cryptos/CRP/control.tar.gz
             rm -rf /root/Cryptos/CRP/data.tar.xz
             rm -rf /root/Cryptos/CRP/debian-binary
             rm -rf /root/Cryptos/CRP/utopia-latest.amd64.deb

          ## Crear el archivo de auto-ejecución gráfica
             #echo ""
             #echo "  Creando el archivo de auto-ejecución gráfica..."
             #echo ""
             #mkdir -p /root/.config/autostart/ 2> /dev/null
             #echo "[Desktop Entry]"                                           > /root/.config/autostart/utopia.desktop
             #echo "Name=utopia"                                              >> /root/.config/autostart/utopia.desktop
             #echo "Type=Application"                                         >> /root/.config/autostart/utopia.desktop
             #echo 'Exec=sh -c "/root/Cryptos/CRP/messenger/utopia --url %u"' >> /root/.config/autostart/utopia.desktop
             #echo "Terminal=false"                                           >> /root/.config/autostart/utopia.desktop
             #echo "Hidden=false"                                             >> /root/.config/autostart/utopia.desktop

        ;;

        12)

          echo ""
          echo -e "${ColorVerde}------------------------------${FinColor}"
          echo -e "${ColorVerde}  (Todavía no disponible)...${FinColor}"
          echo -e "${ColorVerde}------------------------------${FinColor}"
          echo ""

        ;;

        13)

          echo ""
          echo -e "${ColorVerde}------------------------------${FinColor}"
          echo -e "${ColorVerde}  (Todavía no disponible)...${FinColor}"
          echo -e "${ColorVerde}------------------------------${FinColor}"
          echo ""

        ;;

        14)

          echo ""
          echo -e "${ColorVerde}----------------------------${FinColor}"
          echo -e "${ColorVerde}  Instalando escritorio...${FinColor}"
          echo -e "${ColorVerde}----------------------------${FinColor}"
          echo ""

          ## Comprobar si el paquete tasksel está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s tasksel 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "  tasksel no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install tasksel
               echo ""
             fi
          tasksel install mate-desktop
          apt-get -y install xrdp jq
          systemctl set-default -f multi-user.target

        ;;

        15)

          echo ""
          echo -e "${ColorVerde}-------------------------${FinColor}"
          echo -e "${ColorVerde}  Reparando permisos...${FinColor}"
          echo -e "${ColorVerde}-------------------------${FinColor}"
          echo ""

          chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/

          ## Denegar a los otros usuarios del sistema el acceso a la carpeta del usuario 
             find /home/$UsuarioNoRoot -type d -exec chmod 750 {} \;
             find /home/$UsuarioNoRoot -type f -exec chmod 664 {} \;

          find /home/$UsuarioNoRoot/Cryptos/LTC/bin/             -type f -exec chmod +x {} \;
          find /home/$UsuarioNoRoot/Cryptos/RVN/bin/             -type f -exec chmod +x {} \;
          find /home/$UsuarioNoRoot/Cryptos/ARG/bin/             -type f -exec chmod +x {} \;
          find /home/$UsuarioNoRoot/Cryptos/XMR/bin/             -type f -exec chmod +x {} \;
          find /home/$UsuarioNoRoot/Cryptos/XCH/chia-blockchain/ -type f -exec chmod +x {} \;
          find /home/$UsuarioNoRoot/                             -type f -iname "*.sh" -exec chmod +x {} \;

          ## Reparar permisos para permitir la ejecución de la cartera de Chia
             chown root:root /home/$UsuarioNoRoot/Cryptos/XCH/chia-blockchain/chrome-sandbox
             chmod 4755 /home/$UsuarioNoRoot/Cryptos/XCH/chia-blockchain/chrome-sandbox

        ;;

        16)

          echo ""
          echo -e "${ColorVerde}-----------------------------${FinColor}"
          echo -e "${ColorVerde}  Reiniciando el sistema...${FinColor}"
          echo -e "${ColorVerde}-----------------------------${FinColor}"
          echo ""

          shutdown -r now

        ;;

      esac

done

echo ""
echo -e "${ColorVerde}----------------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Script de instalación de las diferentes carteras de criptomonedas, finalizado.${FinColor}"
echo -e "${ColorVerde}----------------------------------------------------------------------------------${FinColor}"
echo ""

echo "ARGENTUM:"
echo "Recuerda editar el cortafuegos del ordenador para que acepte conexiones TCP en el puerto xxx."
echo "Si has instalado ArgentumCore en una MV de Proxmox agrega una regla a su cortauegos indicando:"
echo ""
echo "Dirección: out"
echo "Acción: ACCEPT"
echo "Protocolo: tcp"
echo "Puerto destino: xxxx"
echo ""

echo "RAVEN:"
echo "Recuerda editar el cortafuegos del ordenador para que acepte conexiones TCP en el puerto 8767."
echo "Si has instalado RavenCore en una MV de Proxmox agrega una regla a su cortauegos indicando:"
echo ""
echo "Dirección: out"
echo "Acción: ACCEPT"
echo "Protocolo: tcp"
echo "Puerto destino: 8767"
echo ""

echo "MONERO:"
echo "Recuerda editar el cortafuegos del ordenador para que acepte conexiones TCP en el puerto 18080."
echo "Si has instalado Monero en una MV de Proxmox agrega una regla a su cortauegos indicando:"
echo ""
echo "Dirección: out"
echo "Acción: ACCEPT"
echo "Protocolo: tcp"
echo "Puerto destino: 18080"
echo ""

