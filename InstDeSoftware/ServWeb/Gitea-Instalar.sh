#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Gitea en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Gitea-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Gitea-Instalar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Gitea-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Gitea-Instalar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Gitea-Instalar.sh | nano -
# ----------

vPassRootMariaDB='P@ssw0rd'

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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Gitea para Debian 13 (x)...${cFinColor}"
    echo ""

    # Instalar dependencias
      sudo apt-get -y update
      sudo apt-get -y install mariadb-server 

    # Crear la base de datos
      # Cambiar la contraseña del usuario root de MariaDB
        sudo mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${vPassRootMariaDB}'; FLUSH PRIVILEGES;"
      # Borrar la base de datos existente
        sudo mysql -uroot -p"${vPassRootMariaDB}" -e "DROP DATABASE IF EXISTS Gitea;"
      # Borrar el usuario existente
        sudo mysql -uroot -p"${vPassRootMariaDB}" -e "DROP USER IF EXISTS 'gitea'@'localhost';"
      # Crear el usuario y la base de datos
        sudo mysql -uroot -p"$vPassRootMariaDB" -e "CREATE DATABASE Gitea;"
        sudo mysql -uroot -p"$vPassRootMariaDB" -e "CREATE USER 'gitea'@'localhost' IDENTIFIED BY 'gitea';"
        sudo mysql -uroot -p"$vPassRootMariaDB" -e "GRANT ALL PRIVILEGES ON Gitea.* TO 'gitea'@'localhost';"
        sudo mysql -uroot -p"$vPassRootMariaDB" -e "FLUSH PRIVILEGES;"

    # Descargar el binario de Gitea
      # Determinar el número de la última versión
        echo ""
        echo "    Determinando el número de la última versión..."
        echo ""
        vNroUltVers=$(curl -sL http://dl.gitea.com/gitea/ | sed 's->->\n-g'| grep href | grep gitea | cut -d'"' -f2 | head -n1 | cut -d'/' -f3)
        echo "      La última versión es la $vNroUltVers"
        echo ""
      # Descargar el archivo de instalación de la última versión
        echo ""
        echo "    Descargando el archivo de instalación de la última versión..."
        echo ""
        curl -L https://dl.gitea.com/gitea/"$vNroUltVers"/gitea-"$vNroUltVers"-linux-amd64 -o /tmp/gitea

    # Crear el usuario
      sudo adduser --disabled-password --gecos "" gitea
      echo "gitea:gitea" | sudo chpasswd

    # Preparar la carpeta /opt
      echo ""
      echo "    Creando la carpeta /opt"
      echo ""
      sudo mkdir -p /opt/gitea/
      sudo mv /tmp/gitea /opt/gitea/
      chmod +x /opt/gitea/gitea
      chown gitea:gitea /opt/gitea/ -R

    # Crear el servicio de systemd
      echo ""
      echo "    Creando el servicio de systemd..."
      echo ""
      echo '[Unit]'                                | sudo tee    /etc/systemd/system/gitea.service
      echo 'Description=Gitea'                     | sudo tee -a /etc/systemd/system/gitea.service
      echo 'After=network.target mariadb.service'  | sudo tee -a /etc/systemd/system/gitea.service
      echo 'Requires=mariadb.service'              | sudo tee -a /etc/systemd/system/gitea.service
      echo ''                                      | sudo tee -a /etc/systemd/system/gitea.service
      echo '[Service]'                             | sudo tee -a /etc/systemd/system/gitea.service
      echo 'Type=simple'                           | sudo tee -a /etc/systemd/system/gitea.service
      echo 'User=gitea'                            | sudo tee -a /etc/systemd/system/gitea.service
      echo 'Group=gitea'                           | sudo tee -a /etc/systemd/system/gitea.service
      echo 'WorkingDirectory=/opt/gitea'           | sudo tee -a /etc/systemd/system/gitea.service
      echo ''                                      | sudo tee -a /etc/systemd/system/gitea.service
      echo 'ExecStart=/opt/gitea/gitea web'        | sudo tee -a /etc/systemd/system/gitea.service
      echo ''                                      | sudo tee -a /etc/systemd/system/gitea.service
      echo 'Restart=always'                        | sudo tee -a /etc/systemd/system/gitea.service
      echo 'RestartSec=2s'                         | sudo tee -a /etc/systemd/system/gitea.service
      echo 'LimitNOFILE=1048576'                   | sudo tee -a /etc/systemd/system/gitea.service
      echo ''                                      | sudo tee -a /etc/systemd/system/gitea.service
      echo 'Environment=USER=gitea'                | sudo tee -a /etc/systemd/system/gitea.service
      echo 'Environment=HOME=/opt/gitea'           | sudo tee -a /etc/systemd/system/gitea.service
      echo 'Environment=GITEA_WORK_DIR=/opt/gitea' | sudo tee -a /etc/systemd/system/gitea.service
      echo ''                                      | sudo tee -a /etc/systemd/system/gitea.service
      echo '[Install]'                             | sudo tee -a /etc/systemd/system/gitea.service
      echo 'WantedBy=multi-user.target'            | sudo tee -a /etc/systemd/system/gitea.service

    # Activar y ejecutar el servicio
      echo ""
      echo "    Activando y ejecutando el servicio..."
      echo ""
      sudo systemctl daemon-reexec
      sudo systemctl daemon-reload
      sudo systemctl enable gitea
      sudo systemctl start gitea

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Gitea para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Gitea para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Gitea para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Gitea para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Gitea para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Gitea para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
