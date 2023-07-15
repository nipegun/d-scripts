#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar diferentes carteras de criptomonedas en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Cryptos-Carteras-InstalarYConfigurar.sh | bash
# ----------

UsuarioNoRoot="nipegun"

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}" >&2
    exit 1
  fi

echo ""
echo -e "${cColorAzulClaro}  Iniciando el script de instalación de las diferentes carteras de criptomonedas...${cFinColor}"
echo ""

# Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "    El paquete dialog no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install dialog
    echo ""
  fi

menu=(dialog --timeout 5 --checklist "Marca lo que quieras instalar:" 22 76 16)
  opciones=(
    1 "Crear usuario sin privilegios para ejecutar la pool (Obligatorio)" on
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
    16 "Reniciar el sistema" off
  )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  clear

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo -e "${cColorVerde}  Creando el usuario para ejecutar y administrar la pool...${cFinColor}"
          echo ""

          # Agregar el usuario
             useradd -d /home/$UsuarioNoRoot/ -s /bin/bash $UsuarioNoRoot

          # Crear la contraseña
             passwd $UsuarioNoRoot

          # Crear la carpeta
             mkdir -p /home/$UsuarioNoRoot/ 2> /dev/null

          # Reparación de permisos
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R
        ;;

        2)

          echo ""
          echo -e "${cColorVerde}  Instalando los c-scripts...${cFinColor}"
          echo ""

          # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
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
          echo -e "${cColorVerde}  Borrando carteras y configuraciones anteriores...${cFinColor}"
          echo ""

          # Litecoin
             rm -rf /home/$UsuarioNoRoot/.litecoin/
          # Raven
             rm -rf /home/$UsuarioNoRoot/.raven/
          # Argentum
             rm -rf /home/$UsuarioNoRoot/.argentum/
          # Chia
             rm -rf /home/$UsuarioNoRoot/.chia/
             rm -rf /home/$UsuarioNoRoot/.config/Chia Blockchain/
          # Pool MPOS
             rm -rf /var/www/MPOS/

          # Reparación de permisos
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R
        ;;

        4)

          echo ""
          echo -e "${cColorVerde}  Instalando la cartera litecoin...${cFinColor}"
          echo ""

          echo "  Determinando la última versión de litecoin core..."
          echo ""
          # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
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
          # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
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
          # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
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

          # Autoejecución de Litecoin al iniciar el sistema

             echo ""
             echo "  Agregando litecoind a los ComandosPostArranque..."
             echo ""
             echo "chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/ltc-daemon-iniciar.sh"
             echo "su "$UsuarioNoRoot" -c '/home/"$UsuarioNoRoot"/scripts/c-scripts/ltc-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh

          # Icono de lanzamiento en el menú gráfico

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

          # Autoejecución gráfica de Litecoin

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

          # Reparación de permisos

             chmod +x /home/$UsuarioNoRoot/Cryptos/LTC/bin/*
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R

          # Parar el daemon
             chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/ltc-daemon-parar.sh
             su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/scripts/c-scripts/ltc-daemon-parar.sh"

        ;;

        5)

          echo ""
          echo -e "${cColorVerde}  Instalando la cartera de raven...${cFinColor}"
          echo ""

        ;;

        6)




        ;;

        7)

          echo ""
          echo -e "${cColorVerde}  Instalando la cartera de monero...${cFinColor}"
          echo ""
          
        ;;

        8)

          echo ""
          echo -e "${cColorVerde}  Instalando la cadena de bloques de chia y sus utilidades...${cFinColor}"
          echo ""
       
        ;;

        9)

          echo ""
          echo -e "${cColorVerde}  Instalando core de BCH (Todavía no disponible)...${cFinColor}"
          echo ""

        ;;

        10)

          echo ""
          echo -e "${cColorVerde}  Instalando core de BTC (Todavía no disponible)...${cFinColor}"
          echo ""

        ;;

        11)

          echo ""
          echo -e "${cColorVerde}  Instalando o actualizando messenger de Utopia...${cFinColor}"
          echo ""

        ;;

        12)

          echo ""
          echo -e "${cColorVerde}  (Todavía no disponible)...${cFinColor}"
          echo ""

        ;;

        13)

          echo ""
          echo -e "${cColorVerde}  (Todavía no disponible)...${cFinColor}"
          echo ""

        ;;

        14)

          echo ""
          echo -e "${cColorVerde}  Instalando escritorio...${cFinColor}"
          echo ""

          # Comprobar si el paquete tasksel está instalado. Si no lo está, instalarlo.
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
          echo -e "${cColorVerde}  Reparando permisos...${cFinColor}"
          echo ""

          chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/

          # Denegar a los otros usuarios del sistema el acceso a la carpeta del usuario 
             find /home/$UsuarioNoRoot -type d -exec chmod 750 {} \;
             find /home/$UsuarioNoRoot -type f -exec chmod 664 {} \;

          find /home/$UsuarioNoRoot/Cryptos/LTC/bin/             -type f -exec chmod +x {} \;
          find /home/$UsuarioNoRoot/Cryptos/RVN/bin/             -type f -exec chmod +x {} \;
          find /home/$UsuarioNoRoot/Cryptos/ARG/bin/             -type f -exec chmod +x {} \;
          find /home/$UsuarioNoRoot/Cryptos/XMR/bin/             -type f -exec chmod +x {} \;
          find /home/$UsuarioNoRoot/Cryptos/XCH/chia-blockchain/ -type f -exec chmod +x {} \;
          find /home/$UsuarioNoRoot/                             -type f -iname "*.sh" -exec chmod +x {} \;

          # Reparar permisos para permitir la ejecución de la cartera de Chia
             chown root:root /home/$UsuarioNoRoot/Cryptos/XCH/chia-blockchain/chrome-sandbox
             chmod 4755 /home/$UsuarioNoRoot/Cryptos/XCH/chia-blockchain/chrome-sandbox

        ;;

        16)

          echo ""
          echo -e "${cColorVerde}  Reiniciando el sistema...${cFinColor}"
          echo ""

          shutdown -r now

        ;;

      esac

done

echo ""
echo -e "${cColorVerde}  Script de instalación de las diferentes carteras de criptomonedas, finalizado.${cFinColor}"
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

