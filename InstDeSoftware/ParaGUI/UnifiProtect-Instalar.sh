#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Unifi Protect en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaGUI/UnifiProtect-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaGUI/UnifiProtect-Instalar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaGUI/UnifiProtect-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaGUI/UnifiProtect-Instalar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaGUI/UnifiProtect-Instalar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Unifi Protect para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Unifi Protect corre mejor en Debian 11.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Unifi Protect para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Unifi Protect corre mejor en Debian 11.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Unifi Protect para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    # Actualizar la lista de paquetes disponibles en los repositorios
      sudo apt-get -y update

    # Instalar paquetes necesarios
      sudo apt-get -y install ca-certificates
      sudo apt-get -y install curl
      sudo apt-get -y install gnupg
      sudo apt-get -y install lsb-release
      sudo apt-get -y install ffmpeg

    # Instalar MongoDB 4.4
      # Descargar binario de mongodb
        cd /opt
        curl -LO https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-debian10-4.4.29.tgz
      # Desempaquetar
        sudo tar -xzf /opt/mongodb-linux-x86_64-debian10-4.4.29.tgz -C /opt
      # Crear rutas y enlazar binarios de MongoDB
        sudo ln -s /opt/mongodb-linux-x86_64-debian10-4.4.29/bin/* /usr/local/bin/
      # Crear usuario, directorios y permisos para MongoDB
        sudo useradd -r -s /usr/sbin/nologin mongodb
        sudo mkdir -p /var/lib/mongodb /var/log/mongodb
        sudo chown -R mongodb:mongodb /var/lib/mongodb /var/log/mongodb
      # Crear el servidio de systemd
        echo '[Unit]'                                                                                                              | sudo tee    /etc/systemd/system/mongod.service
        echo 'Description=MongoDB Database Server'                                                                                 | sudo tee -a /etc/systemd/system/mongod.service
        echo 'After=network.target'                                                                                                | sudo tee -a /etc/systemd/system/mongod.service
        echo ''                                                                                                                    | sudo tee -a /etc/systemd/system/mongod.service
        echo '[Service]'                                                                                                           | sudo tee -a /etc/systemd/system/mongod.service
        echo 'User=mongodb'                                                                                                        | sudo tee -a /etc/systemd/system/mongod.service
        echo 'Group=mongodb'                                                                                                       | sudo tee -a /etc/systemd/system/mongod.service
        echo 'ExecStart=/usr/local/bin/mongod --dbpath /var/lib/mongodb --logpath /var/log/mongodb/mongod.log --bind_ip 127.0.0.1' | sudo tee -a /etc/systemd/system/mongod.service
        echo 'Restart=always'                                                                                                      | sudo tee -a /etc/systemd/system/mongod.service
        echo 'LimitNOFILE=64000'                                                                                                   | sudo tee -a /etc/systemd/system/mongod.service
        echo ''                                                                                                                    | sudo tee -a /etc/systemd/system/mongod.service
        echo '[Install]'                                                                                                           | sudo tee -a /etc/systemd/system/mongod.service
        echo 'WantedBy=multi-user.target'                                                                                          | sudo tee -a /etc/systemd/system/mongod.service
      # Arrancar MongoDB y verificar versión
        sudo systemctl daemon-reexec
        sudo systemctl daemon-reload
        sudo systemctl enable --now mongod
        sudo mongod --version



    # Instalar NodeJS 16
      curl -fsSL https://deb.nodesource.com/setup_16.x | sudo bash -
      sudo apt-get -y install nodejs

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Unifi Protect para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Unifi Protect para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Unifi Protect para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Unifi Protect para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
