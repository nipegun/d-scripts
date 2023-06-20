#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar la cadena de bloques de Chia (XCH)
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Nodo-XCH-InstalarYConfigurar.sh | bash
# ----------

vUsuarioNoRoot="nipegun"

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

echo ""
echo -e "${vColorAzulClaro}  Iniciando el script de instalación de la cadena de bloques de XCH...${vFinColor}"
echo ""

vFechaDeEjec=$(date +a%Ym%md%d@%T)

# Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install dialog
    echo ""
  fi

menu=(dialog --checklist "Indica el tipo de instalación o actualización que quieres realizar:" 22 96 16)
  opciones=(
    1 "Instalar o actualizar en la carpeta por defecto /opt." off
    2 "Instalar o actualizar en la carpeta de root." off
    3 "Instalar o actualizar en la carpeta del usuario no root." off 
  )
choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Instalando o actualizando en la carpeta por defecto (/opt)..."
          echo ""

          # Crear carpeta de descarga
            echo ""
            echo "    Creando carpeta de descarga..."
            echo ""
            mkdir -p /root/SoftInst/Cryptos/XCH/ 2> /dev/null
            rm -rf /root/SoftInst/Cryptos/XCH/*

          # Determinar la última versión para Debian
            vUltVersDeb=$(curl -sL https://www.chia.net/downloads/ | sed 's|>|>\n|g' | grep href | grep releases | cut -d'"' -f2 | cut -d'/' -f8 | head -n1)

          # Descargar y descomprimir todos los archivos
            echo ""
            echo "    Descargando el paquete .deb de la instalación..."
            echo ""
          # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo "      El paquete wget no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update
              apt-get -y install wget
              echo ""
            fi
          cd /root/SoftInst/Cryptos/XCH/
          #wget https://download.chia.net/install/chia-blockchain_"$vUltVersDeb"_amd64.deb -O /root/SoftInst/Cryptos/XCH/chia-blockchain.deb
          wget https://download.chia.net/latest/x86_64-Ubuntu-gui -O /root/SoftInst/Cryptos/XCH/chia-blockchain.deb

          # Instalar el paquete
            echo ""
            echo "    Instalando el paquete .deb..."
            echo ""
            # Comprobar si el paquete gdebi está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s gdebi 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo "      El paquete gdebi no está instalado. Iniciando su instalación..."
                echo ""
                apt-get -y update
                apt-get -y install gdebi
                echo ""
              fi

        ;;

        2)

          echo ""
          echo "  Instalando o actualizando en la carpeta de root...."
          echo ""

          # Crear carpeta de descarga
            echo ""
            echo "    Creando carpeta de descarga..."
            echo ""
            mkdir -p /root/SoftInst/Cryptos/XCH/ 2> /dev/null
            rm -rf /root/SoftInst/Cryptos/XCH/*

          # Determinar la última versión para Debian
            vUltVersDeb=$(curl -sL https://www.chia.net/downloads/ | sed 's|>|>\n|g' | grep href | grep releases | cut -d'"' -f2 | cut -d'/' -f8 | head -n1)

          # Descargar y descomprimir todos los archivos
            echo ""
            echo "    Descargando el paquete .deb de la instalación..."
            echo ""
          # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo "      El paquete wget no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update
              apt-get -y install wget
              echo ""
            fi
          cd /root/SoftInst/Cryptos/XCH/
          #wget https://download.chia.net/install/chia-blockchain_"$vUltVersDeb"_amd64.deb -O /root/SoftInst/Cryptos/XCH/chia-blockchain.deb
          wget https://download.chia.net/latest/x86_64-Ubuntu-gui -O /root/SoftInst/Cryptos/XCH/chia-blockchain.deb

          echo ""
          echo "    Extrayendo los archivos de dentro del paquete .deb..."
          echo ""
          # Comprobar si el paquete binutils está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s binutils 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo "      El paquete binutils no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update > /dev/null
              apt-get -y install binutils
              echo ""
            fi
          ar xv /root/SoftInst/Cryptos/XCH/chia-blockchain.deb

          echo ""
          echo "    Descomprimiendo el archivo data.tar.xz..."
          echo ""
          # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo "      El paquete tar no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update > /dev/null
              apt-get -y install tar
              echo ""
            fi
          tar -xvf /root/SoftInst/Cryptos/XCH/data.tar.xz
          echo ""

        ;;

        3)

          echo ""
          echo "  Instalando o actualizando en la carpeta del usuario no root...."
          echo ""

          # Crear carpeta de descarga
            echo ""
            echo "    Creando carpeta de descarga..."
            echo ""
            mkdir -p /root/SoftInst/Cryptos/XCH/ 2> /dev/null
            rm -rf /root/SoftInst/Cryptos/XCH/*

          # Determinar la última versión para Debian
            vUltVersDeb=$(curl -sL https://www.chia.net/downloads/ | sed 's|>|>\n|g' | grep href | grep releases | cut -d'"' -f2 | cut -d'/' -f8 | head -n1)

          # Descargar y descomprimir todos los archivos
            echo ""
            echo "    Descargando el paquete .deb de la instalación..."
            echo ""
          # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo "      El paquete wget no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update
              apt-get -y install wget
              echo ""
            fi
          cd /root/SoftInst/Cryptos/XCH/
          #wget https://download.chia.net/install/chia-blockchain_"$vUltVersDeb"_amd64.deb -O /root/SoftInst/Cryptos/XCH/chia-blockchain.deb
          wget https://download.chia.net/latest/x86_64-Ubuntu-gui -O /root/SoftInst/Cryptos/XCH/chia-blockchain.deb


          echo ""
          echo "    Extrayendo los archivos de dentro del paquete .deb..."
          echo ""
          # Comprobar si el paquete binutils está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s binutils 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo "      El paquete binutils no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update > /dev/null
              apt-get -y install binutils
              echo ""
            fi
          ar xv /root/SoftInst/Cryptos/XCH/chia-blockchain.deb

          echo ""
          echo "    Descomprimiendo el archivo data.tar.xz..."
          echo ""
          # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo "      El paquete tar no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update > /dev/null
              apt-get -y install tar
              echo ""
            fi
          tar -xvf /root/SoftInst/Cryptos/XCH/data.tar.xz
          echo ""

        ;;

    esac

done






# Instalar dependencias necesarias
  #echo ""
  #echo "    Instalando dependencias necesarias..."
  #echo ""
  #apt-get -y install libgtk-3-0
  #apt-get -y install libnotify4
  #apt-get -y install libnss3
  #apt-get -y install libxtst6
  #apt-get -y install xdg-utils
  #apt-get -y install libatspi2.0-0
  #apt-get -y install libdrm2
  #apt-get -y install libgbm1
  #apt-get -y install libxcb-dri3-0
  #apt-get -y install kde-cli-tools
  #apt-get -y install kde-runtime
  #apt-get -y install trash-cli
  #apt-get -y install libglib2.0-bin
  #apt-get -y install gvfs-bin
  #dpkg -i /root/SoftInst/Cryptos/XCH/chia-blockchain.deb
  #echo ""
  #echo "Para ver que archivos instaló el paquete, ejecuta:"
  #echo ""
  #echo "dpkg-deb -c /root/SoftInst/Cryptos/XCH/chia-blockchain.deb"

# Crear la carpeta para el usuario no root
  #echo ""
  #echo "    Creando la carpeta para el usuario no root..."
  #echo ""
  #mkdir -p /home/$vUsuarioNoRoot/Cryptos/XCH/ 2> /dev/null
  #rm -rf /home/$vUsuarioNoRoot/Cryptos/XCH/chia-blockchain/ 2> /dev/null
  #mv /root/SoftInst/Cryptos/XCH/usr/lib/chia-blockchain/ /home/$vUsuarioNoRoot/Cryptos/XCH/
  #rm -rf /root/SoftInst/Cryptos/XCH/usr/
  #mkdir -p /home/$vUsuarioNoRoot/.config/Chia Blockchain/ 2> /dev/null
  #echo '{"spellcheck":{"dictionaries":["es-ES"],"dictionary":""}}' > /home/$vUsuarioNoRoot/.config/Chia Blockchain/Preferences

# Borrar archivos sobrantes
  echo ""
  echo "    Borrando archivos sobrantes..."
  echo ""
  #rm -rf /root/SoftInst/Cryptos/XCH/debian-binary
  #rm -rf /root/SoftInst/Cryptos/XCH/control.tar.xz
  #rm -rf /root/SoftInst/Cryptos/XCH/data.tar.xz

# Agregar aplicación al menú
  echo ""
  echo "    Agregando la aplicación gráfica al menú..."
  echo ""
  mkdir -p /home/$vUsuarioNoRoot/.local/share/applications/ 2> /dev/null
  echo "[Desktop Entry]"                                                             > /home/$vUsuarioNoRoot/.local/share/applications/xch.desktop
  echo "Name=xch GUI"                                                               >> /home/$vUsuarioNoRoot/.local/share/applications/xch.desktop
  echo "Type=Application"                                                           >> /home/$vUsuarioNoRoot/.local/share/applications/xch.desktop
  echo "Exec=/home/$vUsuarioNoRoot/scripts/c-scripts/xch-gui-iniciar.sh"            >> /home/$vUsuarioNoRoot/.local/share/applications/xch.desktop
  echo "Terminal=false"                                                             >> /home/$vUsuarioNoRoot/.local/share/applications/xch.desktop
  echo "Hidden=false"                                                               >> /home/$vUsuarioNoRoot/.local/share/applications/xch.desktop
  echo "Categories=Cryptos"                                                         >> /home/$vUsuarioNoRoot/.local/share/applications/xch.desktop
  echo "Icon=/home/$vUsuarioNoRoot/Cryptos/XCH/chia-blockchain/chia-blockchain.png" >> /home/$vUsuarioNoRoot/.local/share/applications/xch.desktop
  chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.local/share/applications/xch.desktop -R
  gio set /home/$vUsuarioNoRoot/.local/share/applications/xch.desktop "metadata::trusted" yes

# Crear el archivo de auto-ehecución
  echo ""
  echo "    Creando el archivo de autoejecución de chia-blockchain para el escritorio..."
  echo ""
  mkdir -p /home/$vUsuarioNoRoot/.config/autostart/ 2> /dev/null
  echo "[Desktop Entry]"                                                             > /home/$vUsuarioNoRoot/.config/autostart/xch.desktop
  echo "Name=xch GUI"                                                               >> /home/$vUsuarioNoRoot/.config/autostart/xch.desktop
  echo "Type=Application"                                                           >> /home/$vUsuarioNoRoot/.config/autostart/xch.desktop
  echo "Exec=/home/$vUsuarioNoRoot/scripts/c-scripts/xch-gui-iniciar.sh"            >> /home/$vUsuarioNoRoot/.config/autostart/xch.desktop
  echo "Terminal=false"                                                             >> /home/$vUsuarioNoRoot/.config/autostart/xch.desktop
  echo "Hidden=false"                                                               >> /home/$vUsuarioNoRoot/.config/autostart/xch.desktop
  echo "Categories=Cryptos"                                                         >> /home/$vUsuarioNoRoot/.config/autostart/xch.desktop
  echo "Icon=/home/$vUsuarioNoRoot/Cryptos/XCH/chia-blockchain/chia-blockchain.png" >> /home/$vUsuarioNoRoot/.config/autostart/xch.desktop
  chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.config/autostart/xch.desktop -R
  gio set /home/$vUsuarioNoRoot/.config/autostart/xch.desktop "metadata::trusted" yes

# Instalar los c-scripts
  echo ""
  echo "    Instalando los c-scripts..."
  echo ""
  su $vUsuarioNoRoot -c "curl -sL https://raw.githubusercontent.com/nipegun/c-scripts/main/CScripts-Instalar.sh | bash"
  find /home/$vUsuarioNoRoot/scripts/c-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;
  
# Parar el daemon
  echo ""
  echo "    Parando el daemon (si es que está activo)..."
  echo ""
  chmod +x /home/$vUsuarioNoRoot/scripts/c-scripts/xch-daemon-parar.sh
  su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/scripts/c-scripts/xch-daemon-parar.sh"

# Reparar permisos
  echo ""
  echo "    Reparando permisos..."
  echo ""
  # Carpeta Cryptos
    chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/XCH/ -R
    find /home/$vUsuarioNoRoot/Cryptos/XCH/ -type d -exec chmod 750 {} \;
    find /home/$vUsuarioNoRoot/Cryptos/XCH/chia-blockchain/ -type f -exec chmod +x {} \;
    find /home/$vUsuarioNoRoot/                             -type f -iname "*.sh" -exec chmod +x {} \;
    chown root:root /home/$vUsuarioNoRoot/Cryptos/XCH/chia-blockchain/chrome-sandbox
    chmod 4755      /home/$vUsuarioNoRoot/Cryptos/XCH/chia-blockchain/chrome-sandbox
    chmod 0644 /home/$vUsuarioNoRoot/Cryptos/XCH/chia-blockchain/resources/app.asar.unpacked/daemon/mozilla-ca/cacert.pem
    chmod +x   /home/$vUsuarioNoRoot/Cryptos/XCH/chia-blockchain/chia-blockchain
    chmod +x   /home/$vUsuarioNoRoot/Cryptos/XCH/chia-blockchain/resources/app.asar.unpacked/daemon/chia
  # Carpeta .chia
    chmod 0644 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/ca/chia_ca.crt
    chmod 0644 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/daemon/private_daemon.crt
    chmod 0644 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/farmer/private_farmer.crt
    chmod 0644 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/farmer/public_farmer.crt
    chmod 0644 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/full_node/private_full_node.crt
    chmod 0644 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/full_node/public_full_node.crt
    chmod 0644 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/ca/chia_ca.crt
    chmod 0644 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/ca/private_ca.crt
    chmod 0644 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/harvester/private_harvester.crt
    chmod 0644 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/full_node/public_full_node.crt
    chmod 0644 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/ca/private_ca.crt
    chmod 0644 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/timelord/private_timelord.crt
    chmod 0644 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/timelord/public_timelord.crt
    chmod 0644 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/daemon/private_daemon.crt
    chmod 0644 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/wallet/private_wallet.crt
    chmod 0644 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/wallet/public_wallet.crt
    chmod 0600 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/ca/chia_ca.key
    chmod 0600 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/daemon/private_daemon.key
    chmod 0600 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/farmer/private_farmer.key
    chmod 0600 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/farmer/public_farmer.key
    chmod 0600 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/full_node/private_full_node.key
    chmod 0600 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/full_node/public_full_node.key
    chmod 0600 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/ca/chia_ca.key
    chmod 0600 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/ca/private_ca.key
    chmod 0600 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/harvester/private_harvester.key
    chmod 0600 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/full_node/public_full_node.key
    chmod 0600 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/ca/private_ca.key
    chmod 0600 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/timelord/private_timelord.key
    chmod 0600 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/timelord/public_timelord.key
    chmod 0600 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/daemon/private_daemon.key
    chmod 0600 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/wallet/private_wallet.key
    chmod 0600 /home/$vUsuarioNoRoot/.chia/mainnet/config/ssl/wallet/public_wallet.key
  # Carpeta .local
    chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.local/ -R
  # Carpea .config
    chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.config/ -R


