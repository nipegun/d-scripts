#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Heimdall en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Heimdall-InstalarYConfigurar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Heimdall-InstalarYConfigurar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Heimdall-InstalarYConfigurar.sh | nano -
# ----------

cPuerto='11080'

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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Heimdall para Debian 13 (x)...${cFinColor}"
    echo ""

    # Instalar PHP
      echo ""
      echo "    Instalando PHP..."
      echo ""
      vVersPHP=$(apt-cache search php | grep server-side | grep meta | cut -d ' ' -f1)
      sudo apt-get -y install $vVersPHP
    # Instalar dependencias php para heimdall
      echo ""
      echo "    Instalando dependencias..."
      echo ""
      sudo apt-get -y install php-sqlite3
      sudo apt-get -y install php-zip
      sudo apt-get -y install php-xml
      sudo apt-get -y install php-mbstring
    # Borrar posible archivo de código fuente viejo
      echo ""
      echo "    Borrando posibles archivos de código fuente viejo..."
      echo ""
      sudo rm -rf /root/SoftInst/Heimdall/* 2> /dev/null
    # Crear carpeta y posicionarse
      sudo mkdir -p /root/SoftInst/Heimdall/ 2> /dev/null
      sudo cd /root/SoftInst/Heimdall/
    # Determinar última versión disponible
      echo ""
      echo "    Determinando la versión de la última release..."
      echo ""
      # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "      El paquete curl no está instalado. Iniciando su instalación..."
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install curl
          echo ""
        fi
      vUltVers=$(curl -sL https://github.com/linuxserver/Heimdall/releases/latest/ | sed 's->-\n-g' | grep "/title" | grep elease | cut -d ' ' -f2)
      echo ""
      echo "      La última versión disponible es la $vUltVers"
      echo ""
    # Descargar archivo con la última versión
      echo ""
      echo "    Descargando el archivo..."
      echo ""
      sudo mkdir -p /root/SoftInst/Heimdall/ 2> /dev/null
      sudo cd /root/SoftInst/Heimdall/
      sudo curl -L https://github.com/linuxserver/Heimdall/archive/refs/tags/$vUltVers.zip -o /root/SoftInst/Heimdall/source.zip
    # Descomprimir archivo con código fuente nuevo
      echo ""
      echo "    Descomprimiendo el archivo ..."
      echo ""
      # Comprobar si el paquete unzip está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "      El paquete unzip no está instalado. Iniciando su instalación..."
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install unzip
          echo ""
        fi
      sudo unzip -qq /root/SoftInst/Heimdall/source.zip
      vCarpetaConCodFuente=$(sudo find /root/SoftInst/Heimdall/ -type f -name *tisan | sed 's-artisan--g')
      #echo $vCarpetaConCodFuente
    # Copiar archivos a la carpeta pública de html de Apache
      echo ""
      echo "    Copiando archivos a la carpeta pública configurada en Apache..."
      echo ""
      sudo mv -fv /var/www/heimdall/database/ /tmp/ 2> /dev/null
      sudo rm -rf /var/www/heimdall/ 2> /dev/null
      sudo mkdir /var/www/heimdall/
      sudo mv -fv $vCarpetaConCodFuente* /var/www/heimdall/
      sudo mv -fv $vCarpetaConCodFuente.* /var/www/heimdall/ 2> /dev/null
      #sudo mv /tmp/database/ /var/www/heimdall/
      sudo chown www-data:www-data /var/www/heimdall/ -R
      #sudo sed -i -e "s|} elseif ('-' === |//} elseif ('-' === |g" /var/www/heimdall/vendor/symfony/console/Input/ArrayInput.php
      #sudo sed -i -e 's|$this->addShortOption(substr($key, 1), $value);|//$this->addShortOption(substr($key, 1), $value);|g' /var/www/heimdall/vendor/symfony/console/Input/ArrayInput.php
      #sudo cd /var/www/heimdall
      #sudo /usr/bin/php artisan key:generate
      sudo rm -rfv /var/www/heimdall/storage/framework/sessions/* 2> /dev/null
    # Crear el servicio de systemd
      echo ""
      echo "    Creando el servicio en SystemD..."
      echo ""
      echo "[Unit]"                                                                | sudo tee    /etc/systemd/system/heimdall.service
      echo "Description=Heimdall"                                                  | sudo tee -a /etc/systemd/system/heimdall.service
      echo "After=network.target"                                                  | sudo tee -a /etc/systemd/system/heimdall.service
      echo ""                                                                      | sudo tee -a /etc/systemd/system/heimdall.service
      echo "[Service]"                                                             | sudo tee -a /etc/systemd/system/heimdall.service
      echo "Restart=always"                                                        | sudo tee -a /etc/systemd/system/heimdall.service
      echo "RestartSec=5"                                                          | sudo tee -a /etc/systemd/system/heimdall.service
      echo "Type=simple"                                                           | sudo tee -a /etc/systemd/system/heimdall.service
      echo "User=www-data"                                                         | sudo tee -a /etc/systemd/system/heimdall.service
      echo "Group=www-data"                                                        | sudo tee -a /etc/systemd/system/heimdall.service
      echo "WorkingDirectory=/var/www/heimdall"                                    | sudo tee -a /etc/systemd/system/heimdall.service
      echo "ExecStart='/usr/bin/php' artisan serve --port $cPuerto --host 0.0.0.0" | sudo tee -a /etc/systemd/system/heimdall.service
      echo "TimeoutStopSec=30"                                                     | sudo tee -a /etc/systemd/system/heimdall.service
      echo ""                                                                      | sudo tee -a /etc/systemd/system/heimdall.service
      echo "[Install]"                                                             | sudo tee -a /etc/systemd/system/heimdall.service
      echo "WantedBy=multi-user.target"                                            | sudo tee -a /etc/systemd/system/heimdall.service
      sudo systemctl enable --now heimdall.service
      sudo cd /var/www/heimdall/
      sudo /usr/bin/php artisan key:generate
      sudo rm -rf /var/www/heimdall/storage/framework/sessions/* 2> /dev/null
      sudo chown -R www-data:www-data /var/www/heimdall/storage
      sudo chown -R www-data:www-data /var/www/heimdall/bootstrap/cache
      sudo systemctl restart heimdall.service
    # Notificar fin de la instalación
      vIPDelHost="$(ip -4 route get 1.1.1.1 | sed -n 's/.* src \([0-9.]*\).*/\1/p' | head -n 1)"
      echo ''
      echo '    Script de instalación de Heimdall, finalizado.'
      echo ''
      echo '      Para conectarte a la web:'
      echo "        http://$vIPDelHost:$cPuerto"
      echo ''

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Heimdall para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Heimdall para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Heimdall para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Heimdall para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Heimdall para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Heimdall para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
