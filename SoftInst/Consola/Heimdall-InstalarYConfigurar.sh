#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar Heimdall Dashboard en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/Consola/Heimdall-InstalarYConfigurar.sh | bash
#
#----------------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

## Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       OS_NAME=$NAME
       OS_VERS=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       OS_NAME=$(lsb_release -si)
       OS_VERS=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       OS_NAME=$DISTRIB_ID
       OS_VERS=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       OS_NAME=Debian
       OS_VERS=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       OS_NAME=$(uname -s)
       OS_VERS=$(uname -r)
   fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Heimdall para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 7 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Heimdall para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 8 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Heimdall para Debian 9 (Stretch)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 9 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Heimdall para Debian 10 (Buster)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 10 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Heimdall para Debian 11 (Bullseye)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  ## Instalar el servidor web
     #apt-get -y update
     #tasksel install web-server
  ## Instalar el motor de bases de datos de sqlite
     #apt-get -y install sqlite3
  ## Instalar PHP
     VersPHP=$(apt-cache search php | grep server-side | grep meta | cut -d ' ' -f1)
     apt-get -y install $VersPHP
     #apt-get -y install libapache2-mod-php
  ## Instalar dependencias php para heimdall
     #apt-get -y install php-mbstring
     #apt-get -y install php-tokenizer
     #apt-get -y install php-xml
     #apt-get -y install php-json
     apt-get -y install php-sqlite3
     apt-get -y install php-zip
     #phpenmod openssl
     #phpenmod pdo
     #phpenmod filter
     #phpenmod mbstring
     #phpenmod tokenizer
     #phpenmod xml
     #phpenmod json
     #phpenmod sqlite3
     #phpenmod zip

  ## Borrar posible archivo de código fuente viejo
     rm -f /root/SoftInst/Heimdall/source.zip 2> /dev/null
  ## Crear carpeta y posicionarse
     mkdir -p /root/SoftInst/Heimdall/ 2> /dev/null
     cd /root/SoftInst/Heimdall/
  ## Determinar último archivo de código fuente
     UltArchivoZip=$(curl -s https://github.com/linuxserver/Heimdall/releases/ | grep href | grep .zip | cut -d '"' -f2 | head -n1)
  ## Descargar archivo de código fuente nuevo
     ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  wget no está instalado. Iniciando su instalación..."
          echo ""
          apt-get -y update > /dev/null
          apt-get -y install wget
          echo ""
        fi
     wget https://github.com$UltArchivoZip -O /root/SoftInst/Heimdall/source.zip
  ## Descomprimir archivo con código fuente nuevo
     ## Comprobar si el paquete unzip está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  unzip no está instalado. Iniciando su instalación..."
          echo ""
          apt-get -y update > /dev/null
          apt-get -y install unzip
          echo ""
        fi
     unzip -qq /root/SoftInst/Heimdall/source.zip
     CarpetaConCodFuente=$(find /root/SoftInst/Heimdall/ -maxdepth 1 -type d -print | sed 1d)
     mv $CarpetaConCodFuente /var/www/heimdall/
  ## Copiar archivos a la carpeta pública de html de Apache
     chown www-data:www-data /var/www/heimdall/ -R
     sed -i -e "s|} elseif ('-' === |//} elseif ('-' === |g" /var/www/heimdall/vendor/symfony/console/Input/ArrayInput.php
     sed -i -e 's|$this->addShortOption(substr($key, 1), $value);|//$this->addShortOption(substr($key, 1), $value);|g' /var/www/heimdall/vendor/symfony/console/Input/ArrayInput.php
  ## Crear el servicio de systemd
     echo "[Unit]"                                                             > /etc/systemd/system/heimdall.service
     echo "Description=Heimdall"                                              >> /etc/systemd/system/heimdall.service
     echo "After=network.target"                                              >> /etc/systemd/system/heimdall.service
     echo ""                                                                  >> /etc/systemd/system/heimdall.service
     echo "[Service]"                                                         >> /etc/systemd/system/heimdall.service
     echo "Restart=always"                                                    >> /etc/systemd/system/heimdall.service
     echo "RestartSec=5"                                                      >> /etc/systemd/system/heimdall.service
     echo "Type=simple"                                                       >> /etc/systemd/system/heimdall.service
     echo "User=www-data"                                                     >> /etc/systemd/system/heimdall.service
     echo "Group=www-data"                                                    >> /etc/systemd/system/heimdall.service
     echo "WorkingDirectory=/var/www/heimdall"                                >> /etc/systemd/system/heimdall.service
     echo 'ExecStart="/usr/bin/php" artisan serve --port 7889 --host 0.0.0.0' >> /etc/systemd/system/heimdall.service
     echo "TimeoutStopSec=30"                                                 >> /etc/systemd/system/heimdall.service
     echo ""                                                                  >> /etc/systemd/system/heimdall.service
     echo "[Install]"                                                         >> /etc/systemd/system/heimdall.service
     echo "WantedBy=multi-user.target"                                        >> /etc/systemd/system/heimdall.service
     systemctl enable --now heimdall.service
  ## Reiniciar el sistema
     shutdown -r now
fi

