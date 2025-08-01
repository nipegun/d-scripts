#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar HedgeDoc en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/HedgeDoc-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/HedgeDoc-Instalar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/HedgeDoc-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/HedgeDoc-Instalar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/HedgeDoc-Instalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install curl
    echo ""
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

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de HedgeDoc para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de HedgeDoc para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Dependencias
      sudo apt -y update
      sudo apt -y install git
      sudo apt -y install curl
      sudo apt -y install build-essential
      sudo apt -y install libpq-dev

    # Instalar Node.js
      # Detertminar la última versión
        vVersNodeJSrecomendado='18'
      curl -fsSL https://deb.nodesource.com/setup_"$vVersNodeJSrecomendado".x | sudo bash -
      sudo apt-get install -y nodejs

    # Instalar yarn
      sudo npm install -g yarn

    # Instalar PostgreSQL
      sudo apt install -y postgresql
      sudo apt install -y postgresql-contrib

    # Crear base de datos y usuario:
      sudo -u postgres psql
CREATE DATABASE hedgedoc;
CREATE USER hedgedoc WITH PASSWORD 'hedgedocpass';
GRANT ALL PRIVILEGES ON DATABASE hedgedoc TO hedgedoc;
\q

    # Clonar HedgeDoc y preparar entorno
      cd /opt
      sudo git clone https://github.com/hedgedoc/hedgedoc.git
      sudo chown -R $USER:$USER hedgedoc
      cd hedgedoc
      yarn install
      yarn build
      yarn start

    # Crear el usuario hedgedoc
      sudo adduser --system --no-create-home --group --shell /usr/sbin/nologin hedgedoc

    # Crear el servicio de systemd
      echo '[Unit]'                                               | sudo tee    /etc/systemd/system/HedgeDoc.service
      echo 'Description=HedgeDoc - Collaborative Markdown Editor' | sudo tee -a /etc/systemd/system/HedgeDoc.service
      echo 'After=network.target'                                 | sudo tee -a /etc/systemd/system/HedgeDoc.service
      echo ''                                                     | sudo tee -a /etc/systemd/system/HedgeDoc.service
      echo '[Service]'                                            | sudo tee -a /etc/systemd/system/HedgeDoc.service
      echo 'Type=simple'                                          | sudo tee -a /etc/systemd/system/HedgeDoc.service
      echo 'User=hedgedoc'                                        | sudo tee -a /etc/systemd/system/HedgeDoc.service
      echo 'WorkingDirectory=/opt/hedgedoc'                       | sudo tee -a /etc/systemd/system/HedgeDoc.service
      echo 'ExecStart=/usr/bin/yarn start'                        | sudo tee -a /etc/systemd/system/HedgeDoc.service
      echo 'Environment=NODE_ENV=production'                      | sudo tee -a /etc/systemd/system/HedgeDoc.service
      echo 'Restart=always'                                       | sudo tee -a /etc/systemd/system/HedgeDoc.service
      echo 'RestartSec=10'                                        | sudo tee -a /etc/systemd/system/HedgeDoc.service
      echo ''                                                     | sudo tee -a /etc/systemd/system/HedgeDoc.service
      echo '[Install]'                                            | sudo tee -a /etc/systemd/system/HedgeDoc.service
      echo 'WantedBy=multi-user.target'                           | sudo tee -a /etc/systemd/system/HedgeDoc.service

    # .
      sudo systemctl daemon-reexec
      sudo systemctl daemon-reload
      sudo systemctl enable --now hedgedoc

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de HedgeDoc para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de HedgeDoc para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de HedgeDoc para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de HedgeDoc para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de HedgeDoc para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
