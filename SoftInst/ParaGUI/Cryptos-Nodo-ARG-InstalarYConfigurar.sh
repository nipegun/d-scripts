
#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar la cadena de bloques de argentum (ARG)
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Nodo-ARG-InstalarYConfigurar.sh | bash
# ----------

vUsuarioNoRoot="nipegun"

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

echo ""
echo -e "${cColorAzulClaro}  Iniciando el script de instalación de la cadena de bloques de ARG...${cFinColor}"
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
    1 "Instalar el nodo ARG en modo CLI desde la web oficial." on
    2 "Instalar el nodo ARG en modo CLI desde la web de GitHub." off
    3 "Agregar la configuración para modo GUI." off
  )
choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Instalando el nodo ARG para modo CLI desde la web oficial..."          echo ""

          echo ""
          echo "    Determinando la última versión de argentum disponible en la web oficial..."          echo ""
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
          $vUltVersArgentum=$(curl -sL https://raven.org/wallet/ | sed 's->->\n-g' | sed 's-"-\n-g' | grep tar.gz | sed 's|.*raven-||' | cut -d'-' -f1)
          echo ""
          echo "      La última versión de argentum disponible en la web oficial es la $vUltVersArgentum"
          echo ""

          echo ""
          echo "    Determinando la URL del archivo a descargar..."          echo ""
          vURLArchivo=$(curl -sL https://raven.org/wallet/ | sed 's->->\n-g' | sed 's-"-\n-g' | grep tar.gz)
          echo ""
          echo "      La URL del archivo es: $vURLArchivo"
          echo ""

          echo ""
          echo "    Intentando descargar el archivo..."          echo ""
          mkdir -p /root/SoftInst/Cryptos/ARG/ 2> /dev/null
          rm -rf /root/SoftInst/Cryptos/ARG/*
          cd /root/SoftInst/Cryptos/ARG/
          # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${cColorAzulClaro}      El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
              echo ""
              apt-get -y update
              apt-get -y install wget
              echo ""
            fi
          wget $vURLArchivo -O /root/SoftInst/Cryptos/ARG/raven$vUltVersArgentum.tar.gz

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
          tar -xf /root/SoftInst/Cryptos/ARG/raven$vUltVersArgentum.tar.gz
          rm -f /root/SoftInst/Cryptos/ARG/raven$vUltVersArgentum.tar.gz
          find /root/SoftInst/Cryptos/ARG/ -type d -name "raven*" -exec mv {} /root/SoftInst/Cryptos/ARG/"raven-$vUltVersArgentum"/ \; 2> /dev/null

          echo ""
          echo "    Creando carpetas y archivos necesarios para ese usuario..."          echo ""
          mkdir -p /home/$vUsuarioNoRoot/.argentum/
          touch    /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "rpcuser=ARGrpc"           > /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "rpcpassword=ARGrpcpass"  >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "rpcallowip=127.0.0.1"    >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "#Default RPC port 8766"  >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "rpcport=20401"           >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "server=1"                >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "listen=1"                >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "prune=550"               >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "daemon=1"                >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "gen=0"                   >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          rm -rf   /home/$vUsuarioNoRoot/Cryptos/ARG/
          mkdir -p /home/$vUsuarioNoRoot/Cryptos/ARG/ 2> /dev/null
          mv /root/SoftInst/Cryptos/ARG/raven-$vUltVersArgentum/* /home/$vUsuarioNoRoot/Cryptos/ARG/
          chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/
          chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/ARG/ -R
          find /home/$vUsuarioNoRoot/Cryptos/ARG/ -type d -exec chmod 775 {} \;
          find /home/$vUsuarioNoRoot/Cryptos/ARG/ -type f -exec chmod 664 {} \;
          find /home/$vUsuarioNoRoot/Cryptos/ARG/bin -type f -exec chmod +x {} \;

          # Instalar los c-scripts
            su $vUsuarioNoRoot -c "curl -sL https://raw.githubusercontent.com/nipegun/c-scripts/main/CScripts-Instalar.sh | bash"
            find /home/$vUsuarioNoRoot/scripts/c-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;

          # Reparación de permisos
            chmod +x /home/$vUsuarioNoRoot/Cryptos/ARG/bin/*
            chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/ARG/ -R
            chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.argentum/ -R

          # Iniciar el demonio
            echo ""
            echo "  Arrancando argentumd..."
            echo ""
            su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/scripts/c-scripts/ARG-daemon-iniciar.sh"
            sleep 5

            #su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/Cryptos/ARG/bin/argentum-cli getnewaddress" > /home/$vUsuarioNoRoot/pooladdress-ARG.txt
            #chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/pooladdress-ARG.txt
            #echo ""
            #echo "  La dirección para recibir argentums es:"
            #echo ""
            #cat /home/$vUsuarioNoRoot/pooladdress-ARG.txt
            #vDirCartARG=$(cat /home/$vUsuarioNoRoot/pooladdress-ARG.txt)
            #echo ""

          # Autoejecución del nodo al iniciar el sistema
            echo ""
            echo "    Agregando argentumd a los ComandosPostArranque..."
            echo ""
            chmod +x /home/$vUsuarioNoRoot/scripts/c-scripts/ARG-daemon-iniciar.sh
            echo "su $vUsuarioNoRoot -c '/home/"$vUsuarioNoRoot"/scripts/c-scripts/ARG-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh
            echo ""

        ;;

        2)

          echo ""
          echo "  Instalando el nodo ARG para modo CLI desde la web de GitHub..."          echo ""

          echo ""
          echo "    Determinando la última versión de argentum disponible en GitHub..."          echo ""
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
          $vUltVersArgentum=$(curl -sL https://github.com/argentumproject/argentum/releases/ | grep linux | grep gnu | grep tar | grep href | cut -d '"' -f 2 | sed -n 1p | cut -d'-' -f 2)
          echo ""
          echo "      La última versión de argentum disponible en GitHub es la $vUltVersArgentum"
          echo ""

          echo ""
          echo "    Determinando la URL del archivo a descargar..."          echo ""
          vNombreArchivo=$(curl -sL https://github.com/RavenProject/Raven/releases/tag/v$vUltVersArgentum | grep href | grep inux | grep -v isable | grep x86 | cut -d'"' -f2 | cut -d '/' -f7)
          echo ""
          echo "      El nombre del archivo es $vNombreArchivo"
          echo ""
          vURLArchivo="https://github.com/RavenProject/Raven/releases/download/v$vUltVersArgentum/$vNombreArchivo"
          vURLArchivo=$(curl -sL https://raven.org/wallet/ | sed 's->->\n-g' | sed 's-"-\n-g' | grep tar.gz)
          echo ""
          echo "      La URL del archivo es: $vURLArchivo"
          echo ""

          echo ""
          echo "    Intentando descargar el archivo..."          echo ""
          mkdir -p /root/SoftInst/Cryptos/ARG/ 2> /dev/null
          rm -rf /root/SoftInst/Cryptos/ARG/*
          cd /root/SoftInst/Cryptos/ARG/
          # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${cColorAzulClaro}      El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
              echo ""
              apt-get -y update
              apt-get -y install wget
              echo ""
            fi
          wget $vURLArchivo -O /root/SoftInst/Cryptos/ARG/raven$vUltVersArgentum.tar.gz

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
          tar -xf /root/SoftInst/Cryptos/ARG/raven$vUltVersArgentum.tar.gz
          rm -f /root/SoftInst/Cryptos/ARG/raven$vUltVersArgentum.tar.gz
          find /root/SoftInst/Cryptos/ARG/ -type d -name "raven*" -exec mv {} /root/SoftInst/Cryptos/ARG/"raven-$vUltVersArgentum"/ \; 2> /dev/null

          echo ""
          echo "    Creando carpetas y archivos necesarios para ese usuario..."          echo ""
          mkdir -p /home/$vUsuarioNoRoot/.argentum/
          touch    /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "rpcuser=ARGrpc"           > /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "rpcpassword=ARGrpcpass"  >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "rpcallowip=127.0.0.1"    >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "#Default RPC port 8766"  >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "rpcport=20401"           >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "server=1"                >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "listen=1"                >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "prune=550"               >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "daemon=1"                >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          echo "gen=0"                   >> /home/$vUsuarioNoRoot/.argentum/argentum.conf
          rm -rf   /home/$vUsuarioNoRoot/Cryptos/ARG/
          mkdir -p /home/$vUsuarioNoRoot/Cryptos/ARG/ 2> /dev/null
          mv /root/SoftInst/Cryptos/ARG/raven-$vUltVersArgentum/* /home/$vUsuarioNoRoot/Cryptos/ARG/
          chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/
          chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/ARG/ -R
          find /home/$vUsuarioNoRoot/Cryptos/ARG/ -type d -exec chmod 775 {} \;
          find /home/$vUsuarioNoRoot/Cryptos/ARG/ -type f -exec chmod 664 {} \;
          find /home/$vUsuarioNoRoot/Cryptos/ARG/bin -type f -exec chmod +x {} \;

          # Instalar los c-scripts
            su $vUsuarioNoRoot -c "curl -sL https://raw.githubusercontent.com/nipegun/c-scripts/main/CScripts-Instalar.sh | bash"
            find /home/$vUsuarioNoRoot/scripts/c-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;

          # Reparación de permisos
            chmod +x /home/$vUsuarioNoRoot/Cryptos/ARG/bin/*
            chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/ARG/ -R
            chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.argentum/ -R

          # Iniciar el demonio
            echo ""
            echo "  Arrancando argentumd..."
            echo ""
            su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/scripts/c-scripts/ARG-daemon-iniciar.sh"
            sleep 5

            #su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/Cryptos/ARG/bin/argentum-cli getnewaddress" > /home/$vUsuarioNoRoot/pooladdress-ARG.txt
            #chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/pooladdress-ARG.txt
            #echo ""
            #echo "  La dirección para recibir argentums es:"
            #echo ""
            #cat /home/$vUsuarioNoRoot/pooladdress-ARG.txt
            #vDirCartARG=$(cat /home/$vUsuarioNoRoot/pooladdress-ARG.txt)
            #echo ""

          # Autoejecución del nodo al iniciar el sistema
            echo ""
            echo "    Agregando argentumd a los ComandosPostArranque..."
            echo ""
            chmod +x /home/$vUsuarioNoRoot/scripts/c-scripts/ARG-daemon-iniciar.sh
            echo "su $vUsuarioNoRoot -c '/home/"$vUsuarioNoRoot"/scripts/c-scripts/ARG-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh
            echo ""

        ;;

        3)

          echo ""
          echo "  Agregando configuración para el modo GUI..."          echo ""

          # Icono de lanzamiento en el menú gráfico
            echo ""
            echo "    Agregando la aplicación gráfica al menú..."
            echo ""
            mkdir -p /home/$vUsuarioNoRoot/.local/share/applications/ 2> /dev/null
            chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.local/share/applications/
            echo "[Desktop Entry]"                                                   > /home/$vUsuarioNoRoot/.local/share/applications/ARG.desktop
            echo "Name=ARG GUI"                                                     >> /home/$vUsuarioNoRoot/.local/share/applications/ARG.desktop
            echo "Type=Application"                                                 >> /home/$vUsuarioNoRoot/.local/share/applications/ARG.desktop
            echo "Exec=/home/$vUsuarioNoRoot/scripts/c-scripts/ARG-gui-iniciar.sh"  >> /home/$vUsuarioNoRoot/.local/share/applications/ARG.desktop
            echo "Terminal=false"                                                   >> /home/$vUsuarioNoRoot/.local/share/applications/ARG.desktop
            echo "Hidden=false"                                                     >> /home/$vUsuarioNoRoot/.local/share/applications/ARG.desktop
            echo "Categories=Cryptos"                                               >> /home/$vUsuarioNoRoot/.local/share/applications/ARG.desktop
            #echo "Icon="                                                           >> /home/$vUsuarioNoRoot/.local/share/applications/ARG.desktop
            chown $vUsuarioNoRoot:$vUsuarioNoRoot                                      /home/$vUsuarioNoRoot/.local/share/applications/ARG.desktop
            gio set /home/$vUsuarioNoRoot/.local/share/applications/ARG.desktop "metadata::trusted" yes
            

          # Autoejecución gráfica de argentum
            echo ""
            echo "  Creando el archivo de autoejecución de argentum-qt para escritorio..."
            echo ""
            mkdir -p /home/$vUsuarioNoRoot/.config/autostart/ 2> /dev/null
            chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.config/autostart/
            echo "[Desktop Entry]"                                                   > /home/$vUsuarioNoRoot/.config/autostart/ARG.desktop
            echo "Name=ARG GUI"                                                     >> /home/$vUsuarioNoRoot/.config/autostart/ARG.desktop
            echo "Type=Application"                                                 >> /home/$vUsuarioNoRoot/.config/autostart/ARG.desktop
            echo "Exec=/home/$vUsuarioNoRoot/scripts/c-scripts/ARG-gui-iniciar.sh"  >> /home/$vUsuarioNoRoot/.config/autostart/ARG.desktop
            echo "Terminal=false"                                                   >> /home/$vUsuarioNoRoot/.config/autostart/ARG.desktop
            echo "Hidden=false"                                                     >> /home/$vUsuarioNoRoot/.config/autostart/ARG.desktop
            chown $vUsuarioNoRoot:$vUsuarioNoRoot                                      /home/$vUsuarioNoRoot/.config/autostart/ARG.desktop
            gio set /home/$vUsuarioNoRoot/.config/autostart/ARG.desktop "metadata::trusted" yes

        ;;

    esac

done




























echo ""
echo "  Intentando descargar el archivo comprimido de la última versión..."echo ""
mkdir -p /root/SoftInst/Argentumcoin/ 2> /dev/null
rm -rf /root/SoftInst/Argentumcoin/*
cd /root/SoftInst/Argentumcoin/
ArchUltVersAgentum=$(curl -sL https://github.com/argentumproject/argentum/releases/ | grep linux | grep gnu | grep tar | grep href | cut -d '"' -f 2 | sed -n 1p)

wget --no-check-certificate https://github.com$ArchUltVersAgentum -O /root/SoftInst/Argentumcoin/Argentum.tar.gz

echo ""
echo "  Descomprimiendo el archivo..."echo ""
# Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  tar no está instalado. Iniciando su instalación..."    echo ""
    apt-get -y update
    apt-get -y install tar
    echo ""
  fi
tar -xf /root/SoftInst/Argentumcoin/Argentum.tar.gz
rm -rf /root/SoftInst/Argentumcoin/Argentum.tar.gz

echo ""
echo "  Creando carpetas y archivos necesarios para ese usuario..."echo ""
mkdir -p /home/$UsuarioNoRoot/Cryptos/ARG/ 2> /dev/null
# Archivo argentum.conf
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
  # Denegar el acceso a la carpeta a los otros usuarios del sistema
    #find /home/$UsuarioNoRoot -type d -exec chmod 750 {} \;
    #find /home/$UsuarioNoRoot -type f -exec chmod 664 {} \;

#echo ""
#echo "  Arrancando argentumd..."#echo ""
#su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/Cryptos/ARG/bin/argentumd"
#sleep 5
#su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/Cryptos/ARG/bin/argentum-cli getnewaddress" > /home/$UsuarioNoRoot/pooladdress-arg.txt
#chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/pooladdress-arg.txt
#echo ""
#echo "  La dirección para recibir argentum es:"
#echo ""
#cat /home/$UsuarioNoRoot/pooladdress-arg.txt
#DirCartARG=$(cat /home/$UsuarioNoRoot/pooladdress-arg.txt)
#echo ""

# Autoejecución de Argentum al iniciar el sistema
#  echo ""
#  echo "  Agregando argentumd a los ComandosPostArranque..."#  echo ""
#  echo "chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/arg-daemon-iniciar.sh"
#  echo "su "$UsuarioNoRoot" -c '/home/"$UsuarioNoRoot"/scripts/c-scripts/arg-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh

# Icono de lanzamiento en el menú gráfico
  echo ""
  echo "  Agregando la aplicación gráfica al menú..." 
echo ""
  mkdir -p /home/$UsuarioNoRoot/.local/share/applications/ 2> /dev/null
  echo "[Desktop Entry]"                                                     > /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
  echo "Name=arg GUI"                                                       >> /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
  echo "Type=Application"                                                   >> /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
  echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/arg-qt-iniciar.sh"      >> /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
  echo "Terminal=false"                                                     >> /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
  echo "Hidden=false"                                                       >> /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
  echo "Categories=Cryptos"                                                 >> /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
  #echo "Icon="                                                             >> /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
  chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
  gio set /home/$UsuarioNoRoot/.local/share/applications/arg.desktop "metadata::trusted" yes

# Autoejecución gráfica de Argentum
  echo ""
  echo "  Creando el archivo de autoejecución de argentum-qt para escritorio..." 
echo ""
  mkdir -p /home/$UsuarioNoRoot/.config/autostart/ 2> /dev/null
  echo "[Desktop Entry]"                                                     > /home/$UsuarioNoRoot/.config/autostart/arg.desktop
  echo "Name=arg GUI"                                                       >> /home/$UsuarioNoRoot/.config/autostart/arg.desktop
  echo "Type=Application"                                                   >> /home/$UsuarioNoRoot/.config/autostart/arg.desktop
  echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/arg-qt-iniciar.sh"      >> /home/$UsuarioNoRoot/.config/autostart/arg.desktop
  echo "Terminal=false"                                                     >> /home/$UsuarioNoRoot/.config/autostart/arg.desktop
  echo "Hidden=false"                                                       >> /home/$UsuarioNoRoot/.config/autostart/arg.desktop
  chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/.config/autostart/arg.desktop
  gio set /home/$UsuarioNoRoot/.config/autostart/arg.desktop "metadata::trusted" yes

# Reparación de permisos
  chmod +x /home/$UsuarioNoRoot/Cryptos/ARG/bin/*
  chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/Cryptos/ARG/ -R
  
# Instalar los c-scripts
  echo ""
  echo "  Instalando los c-scripts..." 
echo ""
  su $UsuarioNoRoot -c "curl --silent https://raw.githubusercontent.com/nipegun/c-scripts/main/CScripts-Instalar.sh | bash"
  find /home/$UsuarioNoRoot/scripts/c-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;

# Parar el daemon
  #chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/arg-daemon-parar.sh
  #su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/scripts/c-scripts/arg-daemon-parar.sh"
