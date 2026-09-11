#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar uhub en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Servidor-Archivos-uhub-InstalarYConfigurar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Servidor-Archivos-uhub-InstalarYConfigurar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Servidor-Archivos-uhub-InstalarYConfigurar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
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

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de uhub para Debian 13 (x)...${cFinColor}"
    echo ""

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  El paquete dialog no está instalado. Iniciando su instalación..."
          echo ""
          sudo apt-get -y update > /dev/null
          sudo apt-get -y install dialog
          echo ""
        fi
      menu=(dialog --radiolist "Elige como instalar:" 22 76 16)
        opciones=(
          1 "Instalar desde los repos de Debian (normalmente la 0.4.1)" off
          2 "Bajar, compilar e instalar la última versión de GitHub"    on
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      for choice in $choices
        do
          case $choice in

          1)

            echo ""
            echo -e "${cColorVerde}  Instalando la versión disponible en los repos de Debian...${cFinColor}"
            echo ""
            sudo apt-get -y update 2> /dev/null
            sudo apt-get -y install uhub
            echo "# uHub access control lists."                                                                                  | sudo tee    /etc/uhub/users.conf
            echo "#"                                                                                                             | sudo tee -a /etc/uhub/users.conf
            echo "# Syntax: <command> [data]"                                                                                    | sudo tee -a /etc/uhub/users.conf
            echo "#"                                                                                                             | sudo tee -a /etc/uhub/users.conf
            echo "# commands:"                                                                                                   | sudo tee -a /etc/uhub/users.conf
            echo "# 'user_reg'   - registered user with no particular privileges (data=nick:password)"                           | sudo tee -a /etc/uhub/users.conf
            echo "# 'user_op'    - operator, can kick or ban people (data=nick:password)"                                        | sudo tee -a /etc/uhub/users.conf
            echo "# 'user_admin' - administrator, can do everything operators can, and reconfigure the hub (data=nick:password)" | sudo tee -a /etc/uhub/users.conf
            echo "# 'deny_nick'  - nick name that is not accepted (example; Administrator)"                                      | sudo tee -a /etc/uhub/users.conf
            echo "# 'deny_ip'    - Unacceptable IP (masks can be specified as CIDR: 0.0.0.0/32 will block all IPv4)"             | sudo tee -a /etc/uhub/users.conf
            echo "# 'ban_nick'   - banned user by nick"                                                                          | sudo tee -a /etc/uhub/users.conf
            echo "# 'ban_cid'    - banned user by cid"                                                                           | sudo tee -a /etc/uhub/users.conf
            echo ""                                                                                                              | sudo tee -a /etc/uhub/users.conf
            echo "# Administrator"                                                                                               | sudo tee -a /etc/uhub/users.conf
            echo "# user_admin    userA:password1"                                                                               | sudo tee -a /etc/uhub/users.conf
            echo "# user_op       userB:password2"                                                                               | sudo tee -a /etc/uhub/users.conf
            echo ""                                                                                                              | sudo tee -a /etc/uhub/users.conf
            echo "# We don't want users with these names"                                                                        | sudo tee -a /etc/uhub/users.conf
            echo "deny_nick Hub-Security"                                                                                        | sudo tee -a /etc/uhub/users.conf
            echo "deny_nick Administrator"                                                                                       | sudo tee -a /etc/uhub/users.conf
            echo "deny_nick root"                                                                                                | sudo tee -a /etc/uhub/users.conf
            echo "deny_nick admin"                                                                                               | sudo tee -a /etc/uhub/users.conf
            echo "deny_nick username"                                                                                            | sudo tee -a /etc/uhub/users.conf
            echo "deny_nick user"                                                                                                | sudo tee -a /etc/uhub/users.conf
            echo "deny_nick guest"                                                                                               | sudo tee -a /etc/uhub/users.conf
            echo "deny_nick operator"                                                                                            | sudo tee -a /etc/uhub/users.conf
            echo ""                                                                                                              | sudo tee -a /etc/uhub/users.conf
            echo "# Banned users"                                                                                                | sudo tee -a /etc/uhub/users.conf
            echo "# ban_nick H4X0R"                                                                                              | sudo tee -a /etc/uhub/users.conf
            echo "# ban_cid FOIL5EK2UDZYAXT7UIUFEKL4SEBEAJE3INJDKAY"                                                             | sudo tee -a /etc/uhub/users.conf
            echo ""                                                                                                              | sudo tee -a /etc/uhub/users.conf
            echo "# ban by ip"                                                                                                   | sudo tee -a /etc/uhub/users.conf
            echo "#"                                                                                                             | sudo tee -a /etc/uhub/users.conf
            echo "# to ban by CIDR"                                                                                              | sudo tee -a /etc/uhub/users.conf
            echo "# deny_ip 10.21.44.0/24"                                                                                       | sudo tee -a /etc/uhub/users.conf
            echo "#"                                                                                                             | sudo tee -a /etc/uhub/users.conf
            echo "# to ban by IP-range."                                                                                         | sudo tee -a /etc/uhub/users.conf
            echo "# deny_ip 10.21.44.7-10.21.44.9"                                                                               | sudo tee -a /etc/uhub/users.conf
            echo "#"                                                                                                             | sudo tee -a /etc/uhub/users.conf
            echo "# to ban a single IP address"                                                                                  | sudo tee -a /etc/uhub/users.conf
            echo "# deny_ip 10.21.44.7"                                                                                          | sudo tee -a /etc/uhub/users.conf
            echo "# (which is equivalent to using):"                                                                             | sudo tee -a /etc/uhub/users.conf
            echo "# deny_ip 10.21.44.7/32"                                                                                       | sudo tee -a /etc/uhub/users.conf
            echo ""                                                                                                              | sudo tee -a /etc/uhub/users.conf
            echo "# Will not work, yet"                                                                                          | sudo tee -a /etc/uhub/users.conf
            echo "# nat_ip 10.0.0.0/8"                                                                                           | sudo tee -a /etc/uhub/users.conf
            echo "# nat_ip 127.0.0.0/8"                                                                                          | sudo tee -a /etc/uhub/users.conf
            echo ""                                                                                                              | sudo tee -a /etc/uhub/users.conf
            echo "# If you have made changes to this file, you must send a HANGUP signal"                                        | sudo tee -a /etc/uhub/users.conf
            echo "# to uHub so that it will re-read the configuration files."                                                    | sudo tee -a /etc/uhub/users.conf
            echo "# For example by invoking: 'killall -HUP uhub'"                                                                | sudo tee -a /etc/uhub/users.conf
            echo "Bienvenido a este Hub" | sudo tee /etc/uhub/motd.txt
            sudo openssl genrsa -out /etc/uhub/sslpriv.key 8192
            sudo openssl req -new -x509 -nodes -sha512 -days 365 -key /etc/uhub/sslpriv.key > /etc/uhub/sslown.crt
            echo 'tls_private_key="/etc/uhub/sslpriv.key"' | sudo tee -a /etc/uhub/uhub.conf
            echo 'tls_certificate="/etc/uhub/sslown.crt"'  | sudo tee -a /etc/uhub/uhub.conf
            echo 'tls_enable=yes'                          | sudo tee -a /etc/uhub/uhub.conf
            #echo 'tls_require=yes' >> /etc/uhub/uhub.conf
            sudo uhub-passwd /etc/uhub/users.db create
            sudo systemctl enable uhub.service
            sudo systemctl start uhub.service
            sleep5
            sudo systemctl status uhub --no-pager

          ;;

          2)

            echo ""
            echo -e "${cColorVerde}  Iniciando el script para bajar, compilar e instalar la versión de GitHub de uhub...${cFinColor}"
            echo ""

            echo ""
            echo "  Instalando dependencias y paquetes necesarios..."
            echo ""
            sudo apt-get -y update
            sudo apt-get -y install cmake
            sudo apt-get -y install make
            sudo apt-get -y install gcc
            sudo apt-get -y install git
            sudo apt-get -y install libsqlite3-dev
            sudo apt-get -y install libssl-dev

            echo ""
            echo "  Bajando el código fuente..."
            echo ""
            sudo mkdir -p /root/SoftInst/ 2> /dev/null
            sudo cd /root/SoftInst/
            sudo rm -rf /root/SoftInst/uhub/ -R 2> /dev/null
            # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
               if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                 echo ""
                 echo "  El paquete git no está instalado. Iniciando su instalación..."
                 echo ""
                 sudo apt-get -y update > /dev/null
                 sudo apt-get -y install git
                 echo ""
               fi
            sudo git clone https://github.com/janvidar/uhub.git

            echo ""
            echo "  Compilando ..."
            echo ""
            cd /root/SoftInst/uhub/
            sudo cmake .
            sudo make

            echo ""
            echo "  Instalando..."
            echo ""
            sudo make install

            echo ""
            echo "  Personalizando..."
            echo ""
            echo "Bienvenido a este servidor ADC!" | sudo tee /usr/local/etc/uhub/motd.txt
            sed -i -e 's|show_banner=1|show_banner=0|g'                                              /usr/local/etc/uhub/uhub.conf
            sed -i -e 's|show_banner_sys_info=1|show_banner_sys_info=0|g'                            /usr/local/etc/uhub/uhub.conf
            sed -i -e 's|hub_name=my hub|hub_name=Servidor ADC de X|g'                               /usr/local/etc/uhub/uhub.conf
            sed -i -e 's|hub_description=Powered by uhub|hub_description=Para compartir archivos!|g' /usr/local/etc/uhub/uhub.conf

            echo ''                                                                                                                                                  | sudo tee    /usr/local/etc/uhub/motd.txt
            echo '--------------------------------------------'                                                                                                      | sudo tee -a /usr/local/etc/uhub/motd.txt
            echo ' Bienvenido al servidor ADC de hacks4geeks'                                                                                                        | sudo tee -a /usr/local/etc/uhub/motd.txt
            echo '--------------------------------------------'                                                                                                      | sudo tee -a /usr/local/etc/uhub/motd.txt
            echo ''                                                                                                                                                  | sudo tee -a /usr/local/etc/uhub/motd.txt
            echo 'Para configurar el programa sigue las siguientes instrucciones:'                                                                                   | sudo tee -a /usr/local/etc/uhub/motd.txt
            echo ''                                                                                                                                                  | sudo tee -a /usr/local/etc/uhub/motd.txt
            echo 'Ve a "Menú >> Preferencias >> Personales", agrega tu Nick y tu correo electrónico e indica que velocidad de subida tienes en el internet de casa.' | sudo tee -a /usr/local/etc/uhub/motd.txt
            echo ''                                                                                                                                                  | sudo tee -a /usr/local/etc/uhub/motd.txt
            echo 'Ve a "Menú >> Preferencias >> Conexión" y marca la casilla "Detectar la conexión automáticamente".'                                                | sudo tee -a /usr/local/etc/uhub/motd.txt
            echo ''                                                                                                                                                  | sudo tee -a /usr/local/etc/uhub/motd.txt
            echo 'Ve a "Menú >> Preferencias >> Descargas" y configura el directorio para descargas y el directorio para archivos incompletos.'                      | sudo tee -a /usr/local/etc/uhub/motd.txt
            echo ''                                                                                                                                                  | sudo tee -a /usr/local/etc/uhub/motd.txt

            echo ""
            echo "  Creando el certificado SSL..."
            echo ""
            sudo mkdir /etc/uhub/
            sudo openssl genrsa -out /etc/uhub/sslpriv.key 8192
            sudo openssl req -new -x509 -nodes -sha512 -days 365 -key /etc/uhub/sslpriv.key > /etc/uhub/sslown.crt
            sudo sed -i -e 's|# tls_enable=1|tls_enable=1|g'                                                    /usr/local/etc/uhub/uhub.conf
            sudo sed -i -e 's|# tls_require=0|tls_require=0|g'                                                  /usr/local/etc/uhub/uhub.conf
            sudo sed -i -e 's|# tls_certificate=/etc/uhub/server.crt|tls_certificate="/etc/uhub/sslown.crt"|g'  /usr/local/etc/uhub/uhub.conf
            sudo sed -i -e 's|# tls_private_key=/etc/uhub/server.key|tls_private_key="/etc/uhub/sslpriv.key"|g' /usr/local/etc/uhub/uhub.conf

            echo ""
            echo "  Creando el servicio..."
            echo ""
            echo "[Unit]"                        | sudo tee    /etc/systemd/system/uhub.service
            echo "Description=Servidor ADC uhub" | sudo tee -a /etc/systemd/system/uhub.service
            echo "After=network.target"          | sudo tee -a /etc/systemd/system/uhub.service
            echo ""                              | sudo tee -a /etc/systemd/system/uhub.service
            echo "[Service]"                     | sudo tee -a /etc/systemd/system/uhub.service
            echo "Type=simple"                   | sudo tee -a /etc/systemd/system/uhub.service
            echo "Restart=always"                | sudo tee -a /etc/systemd/system/uhub.service
            echo "ExecStart=/usr/local/bin/uhub" | sudo tee -a /etc/systemd/system/uhub.service
            echo ""                              | sudo tee -a /etc/systemd/system/uhub.service
            echo "[Install]"                     | sudo tee -a /etc/systemd/system/uhub.service
            echo "WantedBy=multi-user.target"    | sudo tee -a /etc/systemd/system/uhub.service

            echo ""
            echo "  Creando la base de datos de usuarios..."
            echo ""
            sudo uhub-passwd /etc/uhub/users.db create

            echo ""
            echo "  Activando e iniciando el servicio..."
            echo ""
            sudo systemctl enable uhub.service
            sudo systemctl start uhub.service
            sleep 5
            sudo systemctl status uhub.service --no-pager

          ;;

        esac

    done

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de uhub para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de uhub para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de uhub para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de uhub para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de uhub para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de uhub para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
