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

UsuarioDaemon="pooladmin"

echo ""
echo -e "${ColorVerde}---------------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Iniciando el script de instalación de las diferentes carteras de criptomonedas...${FinColor}"
echo -e "${ColorVerde}---------------------------------------------------------------------------------${FinColor}"
echo ""

## Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "dialog no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install dialog
   fi

menu=(dialog --timeout 5 --checklist "Marca lo que quieras instalar:" 22 76 16)
  opciones=(1 "Crear usuario sin privilegios para ejecutar la pool (Obligatorio)" on
            2 "Instalar los c-scripts (Obligatorio)" on
            3 "Borrar todas las carteras y configuraciones ya existentes" off
            4 "Instalar cartera de Litecoin" off
            5 "Instalar cartera de Ravencoin" off
            6 "Instalar cartera de Argentum" off
            7 "Instalar cartera de Monero" off
            8 "Instalar cartera de Chia" off
            9 "Instalar cartera de Bitcoin BCH (Todavía no disponible)" off
           10 "Instalar cartera de Bitcoin BTC (Todavía no disponible)" off
           11 "(Todavía no disponible)" off
           12 "(Todavía no disponible)" off
           13 "(Todavía no disponible)" off
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
             useradd -d /home/$UsuarioDaemon/ -s /bin/bash $UsuarioDaemon

          ## Crear la contraseña
             passwd $UsuarioDaemon

          ## Reparación de permisos
             chown :$UsuarioDaemon /home/$UsuarioDaemon/ -R
        ;;

        2)

          echo ""
          echo -e "${ColorVerde}-------------------------------${FinColor}"
          echo -e "${ColorVerde}  Instalando los c-scripts...${FinColor}"
          echo -e "${ColorVerde}-------------------------------${FinColor}"
          echo ""

          su $UsuarioDaemon -c "curl --silent https://raw.githubusercontent.com/nipegun/c-scripts/main/CScripts-Instalar.sh | bash"

        ;;

        3)

          echo ""
          echo -e "${ColorVerde}-----------------------------------------------------${FinColor}"
          echo -e "${ColorVerde}  Borrando carteras y configuraciones anteriores...${FinColor}"
          echo -e "${ColorVerde}-----------------------------------------------------${FinColor}"
          echo ""

          ## Litecoin
             rm -rf /home/$UsuarioDaemon/.litecoin/
          ## Raven
             rm -rf /home/$UsuarioDaemon/.raven/
          ## Argentum
             rm -rf /home/$UsuarioDaemon/.argentum/
          ## Chia
             rm -rf /home/$UsuarioDaemon/.chia/
             rm -rf /home/$UsuarioDaemon/.config/Chia Blockchain/
          ## Pool MPOS
             rm -rf /var/www/MPOS/

          ## Reparación de permisos
             chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ -R
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
              echo "curl no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update
              apt-get -y install curl
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
              echo "wget no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update
              apt-get -y install wget
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
              echo "tar no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update
              apt-get -y install tar
            fi
          tar -xf /root/SoftInst/Litecoin/litecoin-$UltVersLite-x86_64-linux-gnu.tar.gz
          rm -rf /root/SoftInst/Litecoin/litecoin-$UltVersLite-x86_64-linux-gnu.tar.gz

          echo ""
          echo "  Creando carpetas y archivos necesarios para ese usuario..."
          echo ""
          mkdir -p /home/$UsuarioDaemon/ 2> /dev/null
          mkdir -p /home/$UsuarioDaemon/.litecoin/
          touch /home/$UsuarioDaemon/.litecoin/litecoin.conf
          echo "rpcuser=user1"      > /home/$UsuarioDaemon/.litecoin/litecoin.conf
          echo "rpcpassword=pass1" >> /home/$UsuarioDaemon/.litecoin/litecoin.conf
          echo "prune=550"         >> /home/$UsuarioDaemon/.litecoin/litecoin.conf
          echo "daemon=1"          >> /home/$UsuarioDaemon/.litecoin/litecoin.conf
          rm -rf /home/$UsuarioDaemon/CoresCripto/LTC/
          mv /root/SoftInst/Litecoin/litecoin-$UltVersLite/ /home/$UsuarioDaemon/CoresCripto/LTC/
          chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ -R
          find /home/$UsuarioDaemon -type d -exec chmod 775 {} \;
          find /home/$UsuarioDaemon -type f -exec chmod 664 {} \;
          find /home/$UsuarioDaemon/CoresCripto/LTC/bin -type f -exec chmod +x {} \;

          echo ""
          echo "  Arrancando litecoind..."
          echo ""
          su $UsuarioDaemon -c "/home/$UsuarioDaemon/CoresCripto/LTC/bin/litecoind -daemon"
          sleep 5
          su $UsuarioDaemon -c "/home/$UsuarioDaemon/CoresCripto/LTC/bin/litecoin-cli getnewaddress" > /home/$UsuarioDaemon/pooladdress-ltc.txt
          chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/pooladdress-ltc.txt
          echo ""
          echo "  La dirección para recibir litecoins es:"
          echo ""
          cat /home/$UsuarioDaemon/pooladdress-ltc.txt
          DirCartLTC=$(cat /home/$UsuarioDaemon/pooladdress-ltc.txt)
          echo ""

          ## Autoejecución de Litecoin al iniciar el sistema

             echo ""
             echo "  Agregando litecoind a los ComandosPostArranque..."
             echo ""
             echo "chmod +x /home/$UsuarioDaemon/scripts/c-scripts/litecoin-daemon-iniciar.sh"
             echo "su "$UsuarioDaemon" -c '/home/"$UsuarioDaemon"/scripts/c-scripts/litecoin-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh

          ## Icono de lanzamiento en el menú gráfico

             echo ""
             echo "  Agregando la aplicación gráfica al menú..."
             echo ""
             mkdir -p /home/$UsuarioDaemon/.local/share/applications/ 2> /dev/null
             echo "[Desktop Entry]"                                                     > /home/$UsuarioDaemon/.local/share/applications/litecoin.desktop
             echo "Name=Litecoin GUI"                                                  >> /home/$UsuarioDaemon/.local/share/applications/litecoin.desktop
             echo "Type=Application"                                                   >> /home/$UsuarioDaemon/.local/share/applications/litecoin.desktop
             echo "Exec=/home/$UsuarioDaemon/scripts/c-scripts/litecoin-qt-iniciar.sh" >> /home/$UsuarioDaemon/.local/share/applications/litecoin.desktop
             echo "Terminal=false"                                                     >> /home/$UsuarioDaemon/.local/share/applications/litecoin.desktop
             echo "Hidden=false"                                                       >> /home/$UsuarioDaemon/.local/share/applications/litecoin.desktop
             echo "Categories=Cryptos"                                                 >> /home/$UsuarioDaemon/.local/share/applications/litecoin.desktop
             #echo "Icon="                                                             >> /home/$UsuarioDaemon/.local/share/applications/litecoin.desktop

          ## Autoejecución gráfica de Litecoin

             echo ""
             echo "  Creando el archivo de autoejecución de litecoin-qt para escritorio..."
             echo ""
             mkdir -p /home/$UsuarioDaemon/.config/autostart/ 2> /dev/null
             echo "[Desktop Entry]"                                                     > /home/$UsuarioDaemon/.config/autostart/litecoin.desktop
             echo "Name=Litecoin GUI"                                                  >> /home/$UsuarioDaemon/.config/autostart/litecoin.desktop
             echo "Type=Application"                                                   >> /home/$UsuarioDaemon/.config/autostart/litecoin.desktop
             echo "Exec=/home/$UsuarioDaemon/scripts/c-scripts/litecoin-qt-iniciar.sh" >> /home/$UsuarioDaemon/.config/autostart/litecoin.desktop
             echo "Terminal=false"                                                     >> /home/$UsuarioDaemon/.config/autostart/litecoin.desktop
             echo "Hidden=false"                                                       >> /home/$UsuarioDaemon/.config/autostart/litecoin.desktop

          ## Reparación de permisos

             chmod +x /home/$UsuarioDaemon/CoresCripto/LTC/bin/*
             chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ -R

          ## Parar el daemon

             su $UsuarioDaemon -c "/home/$UsuarioDaemon/scripts/c-scripts/litecoin-daemon-parar.sh"

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
               echo "curl no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install curl
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
               echo "wget no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install wget
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
          echo "Descomprimiendo el archivo..."
          echo ""
          ## Comprobar si el paquete zip está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s zip 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "zip no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install zip
             fi
          unzip /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.zip
          mv /root/SoftInst/Ravencoin/linux/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz /root/SoftInst/Ravencoin/
          rm -rf /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.zip
          rm -rf /root/SoftInst/Ravencoin/linux/
          rm -rf /root/SoftInst/Ravencoin/__MACOSX/
          ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "tar no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install tar
             fi
          tar -xf /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz
          rm -rf /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz

          echo ""
          echo "  Creando carpetas y archivos necesarios para ese usuario..."
          echo ""
          mkdir -p /home/$UsuarioDaemon/ 2> /dev/null
          mkdir -p /home/$UsuarioDaemon/.raven/
          touch /home/$UsuarioDaemon/.raven/raven.conf
          echo "rpcuser=rvnrpc"           > /home/$UsuarioDaemon/.raven/raven.conf
          echo "rpcpassword=rvnrpcpass"  >> /home/$UsuarioDaemon/.raven/raven.conf
          echo "rpcallowip=127.0.0.1"    >> /home/$UsuarioDaemon/.raven/raven.conf
          echo "#Default RPC port 8766"  >> /home/$UsuarioDaemon/.raven/raven.conf
          echo "rpcport=20401"           >> /home/$UsuarioDaemon/.raven/raven.conf
          echo "server=1"                >> /home/$UsuarioDaemon/.raven/raven.conf
          echo "listen=1"                >> /home/$UsuarioDaemon/.raven/raven.conf
          echo "prune=550"               >> /home/$UsuarioDaemon/.raven/raven.conf
          echo "daemon=1"                >> /home/$UsuarioDaemon/.raven/raven.conf
          echo "gen=0"                   >> /home/$UsuarioDaemon/.raven/raven.conf
          rm -rf /home/$UsuarioDaemon/CoresCripto/RVN/
          mv /root/SoftInst/Ravencoin/raven-$UltVersRaven/ /home/$UsuarioDaemon/CoresCripto/RVN/
          chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ -R
          find /home/$UsuarioDaemon -type d -exec chmod 775 {} \;
          find /home/$UsuarioDaemon -type f -exec chmod 664 {} \;
          find /home/$UsuarioDaemon/CoresCripto/RVN/bin -type f -exec chmod +x {} \;

          echo ""
          echo "  Arrancando ravencoind..."
          echo ""
          su $UsuarioDaemon -c /home/$UsuarioDaemon/CoresCripto/RVN/bin/ravend
          sleep 5
          su $UsuarioDaemon -c "/home/$UsuarioDaemon/CoresCripto/RVN/bin/raven-cli getnewaddress" > /home/$UsuarioDaemon/pooladdress-rvn.txt
          chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/pooladdress-rvn.txt
          echo ""
          echo "  La dirección para recibir ravencoins es:"
          echo ""
          cat /home/$UsuarioDaemon/pooladdress-rvn.txt
          DirCartRVN=$(cat /home/$UsuarioDaemon/pooladdress-rvn.txt)
          echo ""

          ## Autoejecución de Ravencoin al iniciar el sistema

             echo ""
             echo "  Agregando ravend a los ComandosPostArranque..."
             echo ""
             chmod +x /home/$UsuarioDaemon/scripts/c-scripts/raven-daemon-iniciar.sh
             echo "su "$UsuarioDaemon" -c '/home/"$UsuarioDaemon"/scripts/c-scripts/raven-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh

          ## Icono de lanzamiento en el menú gráfico

             echo ""
             echo "  Agregando la aplicación gráfica al menú..."
             echo ""
             mkdir -p /home/$UsuarioDaemon/.local/share/applications/ 2> /dev/null
             echo "[Desktop Entry]"                                                  > /home/$UsuarioDaemon/.local/share/applications/raven.desktop
             echo "Name=Raven GUI"                                                  >> /home/$UsuarioDaemon/.local/share/applications/raven.desktop
             echo "Type=Application"                                                >> /home/$UsuarioDaemon/.local/share/applications/raven.desktop
             echo "Exec=/home/$UsuarioDaemon/scripts/c-scripts/raven-qt-iniciar.sh" >> /home/$UsuarioDaemon/.local/share/applications/raven.desktop
             echo "Terminal=false"                                                  >> /home/$UsuarioDaemon/.local/share/applications/raven.desktop
             echo "Hidden=false"                                                    >> /home/$UsuarioDaemon/.local/share/applications/raven.desktop
             echo "Categories=Cryptos"                                              >> /home/$UsuarioDaemon/.local/share/applications/raven.desktop
             #echo "Icon="                                                          >> /home/$UsuarioDaemon/.local/share/applications/raven.desktop

          ## Autoejecución gráfica de Ravencoin

             echo ""
             echo "  Creando el archivo de autoejecución de raven-qt para escritorio..."
             echo ""
             mkdir -p /home/$UsuarioDaemon/.config/autostart/ 2> /dev/null
             echo "[Desktop Entry]"                                                  > /home/$UsuarioDaemon/.config/autostart/raven.desktop
             echo "Name=Raven GUI"                                                  >> /home/$UsuarioDaemon/.config/autostart/raven.desktop
             echo "Type=Application"                                                >> /home/$UsuarioDaemon/.config/autostart/raven.desktop
             echo "Exec=/home/$UsuarioDaemon/scripts/c-scripts/raven-qt-iniciar.sh" >> /home/$UsuarioDaemon/.config/autostart/raven.desktop
             echo "Terminal=false"                                                  >> /home/$UsuarioDaemon/.config/autostart/raven.desktop
             echo "Hidden=false"                                                    >> /home/$UsuarioDaemon/.config/autostart/raven.desktop

          ## Reparación de permisos

             chmod +x /home/$UsuarioDaemon/CoresCripto/RVN/bin/*
             chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ -R

          ## Parar el daemon

             su $UsuarioDaemon -c "/home/$UsuarioDaemon/scripts/c-scripts/raven-daemon-parar.sh"

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
               echo "curl no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install curl
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
               echo "wget no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install wget
             fi
          wget --no-check-certificate https://github.com$ArchUltVersAgentum -O /root/SoftInst/Argentumcoin/Argentum.tar.gz

          echo ""
          echo "  Descomprimiendo el archivo..."
          echo ""
          ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "tar no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install tar
             fi
          tar -xf /root/SoftInst/Argentumcoin/Argentum.tar.gz
          rm -rf /root/SoftInst/Argentumcoin/Argentum.tar.gz

          echo ""
          echo "  Creando carpetas y archivos necesarios para ese usuario..."
          echo ""
          mkdir -p /home/$UsuarioDaemon/ 2> /dev/null
          ## Archivo argentum.conf
             mkdir -p /home/$UsuarioDaemon/.argentum/
             touch /home/$UsuarioDaemon/.argentum/argentum.conf
             echo "daemon=1"                       > /home/$UsuarioDaemon/.argentum/argentum.conf
             echo "addnode=31.25.241.224:13580"   >> /home/$UsuarioDaemon/.argentum/argentum.conf
             echo "addnode=52.27.168.5:13580"     >> /home/$UsuarioDaemon/.argentum/argentum.conf
             echo "addnode=46.105.63.132:13580"   >> /home/$UsuarioDaemon/.argentum/argentum.conf
             echo "addnode=85.15.179.171:13580"   >> /home/$UsuarioDaemon/.argentum/argentum.conf
             echo "addnode=95.79.35.133:13580"    >> /home/$UsuarioDaemon/.argentum/argentum.conf
             echo "addnode=172.104.110.155:13580" >> /home/$UsuarioDaemon/.argentum/argentum.conf
          rm -rf /home/$UsuarioDaemon/CoresCripto/ARG/
          mv /root/SoftInst/Argentumcoin/argentum-$UltVersArgentum/ /home/$UsuarioDaemon/CoresCripto/ARG/
          chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ -R
          find /home/$UsuarioDaemon -type d -exec chmod 775 {} \;
          find /home/$UsuarioDaemon -type f -exec chmod 664 {} \;
          find /home/$UsuarioDaemon/CoresCripto/ARG/bin -type f -exec chmod +x {} \;
          ## Denegar el acceso a la carpeta a los otros usuarios del sistema
             #find /home/$UsuarioDaemon -type d -exec chmod 750 {} \;
             #find /home/$UsuarioDaemon -type f -exec chmod 664 {} \;

          echo ""
          echo "  Arrancando argentumd..."
          echo ""
          su $UsuarioDaemon -c "/home/$UsuarioDaemon/CoresCripto/ARG/bin/argentumd"
          sleep 5
          su $UsuarioDaemon -c "/home/$UsuarioDaemon/CoresCripto/ARG/bin/argentum-cli getnewaddress" > /home/$UsuarioDaemon/pooladdress-arg.txt
          chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/pooladdress-arg.txt
          echo ""
          echo "  La dirección para recibir argentum es:"
          echo ""
          cat /home/$UsuarioDaemon/pooladdress-arg.txt
          DirCartARG=$(cat /home/$UsuarioDaemon/pooladdress-arg.txt)
          echo ""

          ## Autoejecución de Argentum al iniciar el sistema

             echo ""
             echo "  Agregando argentumd a los ComandosPostArranque..."
             echo ""
             echo "chmod +x /home/$UsuarioDaemon/scripts/c-scripts/argentum-daemon-iniciar.sh"
             echo "su "$UsuarioDaemon" -c '/home/"$UsuarioDaemon"/scripts/c-scripts/argentum-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh

          ## Icono de lanzamiento en el menú gráfico

             echo ""
             echo "  Agregando la aplicación gráfica al menú..."
             echo ""
             mkdir -p /home/$UsuarioDaemon/.local/share/applications/ 2> /dev/null
             echo "[Desktop Entry]"                                                     > /home/$UsuarioDaemon/.local/share/applications/argentum.desktop
             echo "Name=Argentum GUI"                                                  >> /home/$UsuarioDaemon/.local/share/applications/argentum.desktop
             echo "Type=Application"                                                   >> /home/$UsuarioDaemon/.local/share/applications/argentum.desktop
             echo "Exec=/home/$UsuarioDaemon/scripts/c-scripts/argentum-qt-iniciar.sh" >> /home/$UsuarioDaemon/.local/share/applications/argentum.desktop
             echo "Terminal=false"                                                     >> /home/$UsuarioDaemon/.local/share/applications/argentum.desktop
             echo "Hidden=false"                                                       >> /home/$UsuarioDaemon/.local/share/applications/argentum.desktop
             echo "Categories=Cryptos"                                                 >> /home/$UsuarioDaemon/.local/share/applications/argentum.desktop
             #echo "Icon="                                                             >> /home/$UsuarioDaemon/.local/share/applications/argentum.desktop

          ## Autoejecución gráfica de Argentum

             echo ""
             echo "  Creando el archivo de autoejecución de argentum-qt para escritorio..."
             echo ""
             mkdir -p /home/$UsuarioDaemon/.config/autostart/ 2> /dev/null
             echo "[Desktop Entry]"                                                     > /home/$UsuarioDaemon/.config/autostart/argentum.desktop
             echo "Name=Argentum GUI"                                                  >> /home/$UsuarioDaemon/.config/autostart/argentum.desktop
             echo "Type=Application"                                                   >> /home/$UsuarioDaemon/.config/autostart/argentum.desktop
             echo "Exec=/home/$UsuarioDaemon/scripts/c-scripts/argentum-qt-iniciar.sh" >> /home/$UsuarioDaemon/.config/autostart/argentum.desktop
             echo "Terminal=false"                                                     >> /home/$UsuarioDaemon/.config/autostart/argentum.desktop
             echo "Hidden=false"                                                       >> /home/$UsuarioDaemon/.config/autostart/argentum.desktop

          ## Reparación de permisos

             chmod +x /home/$UsuarioDaemon/CoresCripto/ARG/bin/*
             chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ -R

          ## Parar el daemon

             su $UsuarioDaemon -c "/home/$UsuarioDaemon/scripts/c-scripts/argentum-daemon-parar.sh"
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
               echo "wget no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install wget
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
               echo "tar no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install tar
             fi
          tar xjfv /root/SoftInst/Monerocoin/monero.tar.bz2 -C /root/SoftInst/Monerocoin/
          rm -rf /root/SoftInst/Monerocoin/monero.tar.bz2

          echo ""
          echo "  Preparando la carpeta final..."
          echo ""
          mkdir -p /home/$UsuarioDaemon/CoresCripto/XMR/bin/ 2> /dev/null
          find /root/SoftInst/Monerocoin/ -type d -name monero* -exec cp -r {}/. /home/$UsuarioDaemon/CoresCripto/XMR/bin/ \;
          rm -rf /root/SoftInst/Monerocoin/*
          mkdir -p /home/$UsuarioDaemon/.config/monero-project/ 2> /dev/null
          echo "[General]"                                       > /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "account_name=$UsuarioDaemon"                    >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "askPasswordBeforeSending=true"                  >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "autosave=true"                                  >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "autosaveMinutes=10"                             >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "blackTheme=true"                                >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "blockchainDataDir=/home/$UsuarioDaemon/.monero" >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "checkForUpdates=true"                           >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "customDecorations=true"                         >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "fiatPriceEnabled=true"                          >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "fiatPriceProvider=kraken"                       >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "language=Espa\xf1ol"                            >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "language_wallet=Espa\xf1ol"                     >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "locale=es_ES"                                   >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "lockOnUserInActivity=true"                      >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "lockOnUserInActivityInterval=1"                 >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "transferShowAdvanced=true"                      >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "useRemoteNode=false"                            >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "walletMode=2"                                   >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf

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
             echo "chmod +x /home/$UsuarioDaemon/scripts/c-scripts/monero-daemon-iniciar"
             echo "su $UsuarioDaemon -c '/home/"$UsuarioDaemon"/scripts/c-scripts/monero-daemon-iniciar'" >> /root/scripts/ComandosPostArranque.sh

          ## Icono de lanzamiento en el menú gráfico

             echo ""
             echo "  Agregando la aplicación gráfica al menú..."
             echo ""
             mkdir -p /home/$UsuarioDaemon/.local/share/applications/ 2> /dev/null
             echo "[Desktop Entry]"                                                    > /home/$UsuarioDaemon/.local/share/applications/monero.desktop
             echo "Name=Monero GUI"                                                   >> /home/$UsuarioDaemon/.local/share/applications/monero.desktop
             echo "Type=Application"                                                  >> /home/$UsuarioDaemon/.local/share/applications/monero.desktop
             echo "Exec=/home/$UsuarioDaemon/scripts/c-scripts/monero-gui-iniciar.sh" >> /home/$UsuarioDaemon/.local/share/applications/monero.desktop
             echo "Terminal=false"                                                    >> /home/$UsuarioDaemon/.local/share/applications/monero.desktop
             echo "Hidden=false"                                                      >> /home/$UsuarioDaemon/.local/share/applications/monero.desktop
             echo "Categories=Cryptos"                                                >> /home/$UsuarioDaemon/.local/share/applications/monero.desktop
             #echo "Icon="                                                            >> /home/$UsuarioDaemon/.local/share/applications/monero.desktop

          ## Autoejecución gráfica de monero

             echo ""
             echo "  Creando el archivo de autoejecución de monero-wallet-gui para el escritorio..."
             echo ""
             mkdir -p /home/$UsuarioDaemon/.config/autostart/ 2> /dev/null
             echo "[Desktop Entry]"                                                    > /home/$UsuarioDaemon/.config/autostart/monero.desktop
             echo "Name=Monero GUI"                                                   >> /home/$UsuarioDaemon/.config/autostart/monero.desktop
             echo "Type=Application"                                                  >> /home/$UsuarioDaemon/.config/autostart/monero.desktop
             echo "Exec=/home/$UsuarioDaemon/scripts/c-scripts/monero-gui-iniciar.sh" >> /home/$UsuarioDaemon/.config/autostart/monero.desktop
             echo "Terminal=false"                                                    >> /home/$UsuarioDaemon/.config/autostart/monero.desktop
             echo "Hidden=false"                                                      >> /home/$UsuarioDaemon/.config/autostart/monero.desktop

          ## Reparación de permisos

             chmod +x /home/$UsuarioDaemon/CoresCripto/XMR/bin/*
             chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ -R

          ## Parar el daemon

             su $UsuarioDaemon -c "/home/$UsuarioDaemon/scripts/c-scripts/monero-daemon-parar.sh"

        ;;

        8)

          echo ""
          echo -e "${ColorVerde}------------------------------------${FinColor}"
          echo -e "${ColorVerde}  Instalando la cartera de chia...${FinColor}"
          echo -e "${ColorVerde}------------------------------------${FinColor}"
          echo ""

          ## Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "git no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install git
             fi

          mkdir -p /root/SoftInst/Chiacoin/ 2> /dev/null
          rm -rf /root/SoftInst/Chiacoin/*
          cd /root/SoftInst/Chiacoin/
          echo ""
          echo "  Descargando el paquete .deb de la instalación de core de Chia..."
          echo ""
          wget https://download.chia.net/latest/x86_64-Ubuntu-gui -O /root/SoftInst/Chiacoin/chia-blockchain.deb
          echo ""
          echo "  Extrayendo los archivos de dentro del paquete .deb..."
          echo ""
          ## Comprobar si el paquete binutils está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s binutils 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "binutils no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install binutils
             fi
          ar x /root/SoftInst/Chiacoin/chia-blockchain.deb
          rm -rf /root/SoftInst/Chiacoin/debian-binary
          rm -rf /root/SoftInst/Chiacoin/control.tar.xz
          ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "tar no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install tar
             fi
          tar -xf /root/SoftInst/Chiacoin/data.tar.xz
          rm -rf /root/SoftInst/Chiacoin/data.tar.xz
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
          #dpkg -i /root/SoftInst/Chiacoin/chia-blockchain.deb
          #echo ""
          #echo "Para ver que archivos instaló el paquete, ejecuta:"
          #echo ""
          #echo "dpkg-deb -c /root/SoftInst/Chiacoin/chia-blockchain.deb"
          mkdir -p /home/$UsuarioDaemon/CoresCripto/XCH/ 2> /dev/null
          rm -rf /home/$UsuarioDaemon/CoresCripto/XCH/*
          mv /root/SoftInst/Chiacoin/usr/lib/chia-blockchain/ /home/$UsuarioDaemon/CoresCripto/XCH/bin/
          rm -rf /root/SoftInst/Chiacoin/usr/
          #mkdir -p /home/$UsuarioDaemon/.config/Chia Blockchain/ 2> /dev/null
          #echo '{"spellcheck":{"dictionaries":["es-ES"],"dictionary":""}}' > /home/$UsuarioDaemon/.config/Chia Blockchain/Preferences

          ## Icono de lanzamiento en el menú gráfico

             echo ""
             echo "  Agregando la aplicación gráfica al menú..."
             echo ""
             mkdir -p /home/$UsuarioDaemon/.local/share/applications/ 2> /dev/null
             echo "[Desktop Entry]"                                                 > /home/$UsuarioDaemon/.local/share/applications/chia.desktop
             echo "Name=Chia GUI"                                                  >> /home/$UsuarioDaemon/.local/share/applications/chia.desktop
             echo "Type=Application"                                               >> /home/$UsuarioDaemon/.local/share/applications/chia.desktop
             echo "Exec=/home/$UsuarioDaemon/scipts/c-scripts/chia-gui-iniciar.sh" >> /home/$UsuarioDaemon/.local/share/applications/chia.desktop
             echo "Terminal=false"                                                 >> /home/$UsuarioDaemon/.local/share/applications/chia.desktop
             echo "Hidden=false"                                                   >> /home/$UsuarioDaemon/.local/share/applications/chia.desktop
             echo "Categories=Cryptos"                                             >> /home/$UsuarioDaemon/.local/share/applications/chia.desktop
             #echo "Icon="                                                         >> /home/$UsuarioDaemon/.local/share/applications/chia.desktop

          ## Autoejecución de chia

             echo ""
             echo "  Creando el archivo de autoejecución de chia-blockchain para el escritorio..."
             echo ""
             mkdir -p /home/$UsuarioDaemon/.config/autostart/ 2> /dev/null
             echo "[Desktop Entry]"                                                  > /home/$UsuarioDaemon/.config/autostart/chia.desktop
             echo "Name=Chia GUI"                                                   >> /home/$UsuarioDaemon/.config/autostart/chia.desktop
             echo "Type=Application"                                                >> /home/$UsuarioDaemon/.config/autostart/chia.desktop
             echo "Exec=/home/$UsuarioDaemon/scripts/c-scripts/chia-gui-iniciar.sh" >> /home/$UsuarioDaemon/.config/autostart/chia.desktop
             echo "Terminal=false"                                                  >> /home/$UsuarioDaemon/.config/autostart/chia.desktop
             echo "Hidden=false"                                                    >> /home/$UsuarioDaemon/.config/autostart/chia.desktop

          ## Reparación de permisos

             chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ -R
             chown root:root /home/$UsuarioDaemon/CoresCripto/XCH/bin/chrome-sandbox
             chmod 4755 /home/$UsuarioDaemon/CoresCripto/XCH/bin/chrome-sandbox

          ## Parar el daemon

             su $UsuarioDaemon -c "/home/$UsuarioDaemon/scripts/c-scripts/chia-daemon-parar.sh"

        ;;

        9)

          echo ""
          echo -e "${ColorVerde}------------------------------${FinColor}"
          echo -e "${ColorVerde}  (Todavía no disponible)...${FinColor}"
          echo -e "${ColorVerde}------------------------------${FinColor}"
          echo ""

        ;;

        10)

          echo ""
          echo -e "${ColorVerde}------------------------------${FinColor}"
          echo -e "${ColorVerde}  (Todavía no disponible)...${FinColor}"
          echo -e "${ColorVerde}------------------------------${FinColor}"
          echo ""

        ;;

        11)

          echo ""
          echo -e "${ColorVerde}------------------------------${FinColor}"
          echo -e "${ColorVerde}  (Todavía no disponible)...${FinColor}"
          echo -e "${ColorVerde}------------------------------${FinColor}"
          echo ""

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
               echo "tasksel no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install tasksel
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

          chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/

          ## Denegar a los otros usuarios del sistema el acceso a la carpeta del usuario 
             find /home/$UsuarioDaemon -type d -exec chmod 750 {} \;
             find /home/$UsuarioDaemon -type f -exec chmod 664 {} \;

          find /home/$UsuarioDaemon/CoresCripto/LTC/bin/ -type f -exec chmod +x {} \;
          find /home/$UsuarioDaemon/CoresCripto/RVN/bin/ -type f -exec chmod +x {} \;
          find /home/$UsuarioDaemon/CoresCripto/ARG/bin/ -type f -exec chmod +x {} \;
          find /home/$UsuarioDaemon/CoresCripto/XMR/bin/ -type f -exec chmod +x {} \;
          find /home/$UsuarioDaemon/ -type f -iname "*.sh" -exec chmod +x {} \;

          ## Reparar permisos para pemitir la ejecución de la cartera de Chia
             chown root:root /home/$UsuarioDaemon/CoresCripto/XCH/bin/chrome-sandbox
             chmod 4755 /home/$UsuarioDaemon/CoresCripto/XCH/bin/chrome-sandbox

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
echo -e "${ColorVerde}--------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Script de instalación de una pool de minería de criptomonedas, finalzaado.${FinColor}"
echo -e "${ColorVerde}--------------------------------------------------------------------------${FinColor}"
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

