#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Heimdall Dashboard en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Heimdall-Actualizar.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then                # Para systemd y freedesktop.org
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then    # linuxbase.org
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then             # Para algunas versiones de Debian sin el comando lsb_release
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then          # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                           # Para el viejo uname (También funciona para BSD)
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de actualización de Heimdall para Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de actualización de Heimdall para Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script de actualización de Heimdall para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  
  echo "  Iniciando el script de actualización de Heimdall para Debian 10 (Buster)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de actualización de Heimdall para Debian 11 (Bullseye)..."
  echo ""

  # Parar apache
    echo ""
    echo "   Parando el servicio de Apache..."    echo ""
    systemctl stop apache2
  # Borrar posible archivo de código fuente viejo
    echo ""
    echo "    Borrando posibles archivos de código fuente viejo..."    echo ""
    rm -rf /root/SoftInst/Heimdall/* 2> /dev/null
  # Determinar última versión disponible
    echo ""
    echo "    Determinando la versión de la última release..."    echo ""
    # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "      curl no está instalado. Iniciando su instalación..."        echo ""
        apt-get -y update && apt-get -y install curl
        echo ""
      fi
    vUltVers=$(curl -sL https://github.com/linuxserver/Heimdall/releases/latest/ | sed 's->-\n-g' | grep "/title" | grep elease | cut -d ' ' -f2)
    echo ""
    echo "      La última versión disponible es la $vUltVers"
    echo ""
  # Descargar archivo con la última versión
    echo ""
    echo "    Descargando el archivo..."    echo ""
    # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "      wget no está instalado. Iniciando su instalación..."        echo ""
        apt-get -y update && apt-get -y install wget
        echo ""
      fi
    mkdir -p /root/SoftInst/Heimdall/ 2> /dev/null
    cd /root/SoftInst/Heimdall/
    wget https://github.com/linuxserver/Heimdall/archive/refs/tags/$vUltVers.zip -O /root/SoftInst/Heimdall/source.zip
  # Descomprimir archivo con código fuente nuevo
    echo ""
    echo "    Descomprimiendo el archivo ..."    echo ""
    # Comprobar si el paquete unzip está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "      unzip no está instalado. Iniciando su instalación..."        echo ""
        apt-get -y update && apt-get -y install unzip
        echo ""
      fi
    unzip -qq /root/SoftInst/Heimdall/source.zip
    vCarpetaConCodFuente=$(find /root/SoftInst/Heimdall/ -type f -name *tisan | sed 's-artisan--g')
  # Copiar archivos a la carpeta pública de html de Apache
    echo ""
    echo "    Copiando archivos a la carpeta pública configurada en Apache..."    echo ""
    mv /var/www/heimdall/database/ /tmp/
    mkdir /tmp/backgrounds/
    cp /var/www/heimdall/storage/app/public/backgrounds/* /tmp/backgrounds/
    rm -rf /var/www/heimdall/*
    mv $vCarpetaConCodFuente* /var/www/heimdall/
    mv $vCarpetaConCodFuente.* /var/www/heimdall/ 2> /dev/null
    cp -rf /tmp/database/* /var/www/heimdall/database/
    mkdir /var/www/heimdall/storage/app/public/backgrounds/ 2> /dev/null
    cp /tmp/backgrounds/* /var/www/heimdall/storage/app/public/backgrounds/
    chown www-data:www-data /var/www/heimdall/ -R
    #sed -i -e "s|} elseif ('-' === |//} elseif ('-' === |g" /var/www/heimdall/vendor/symfony/console/Input/ArrayInput.php
    #sed -i -e 's|$this->addShortOption(substr($key, 1), $value);|//$this->addShortOption(substr($key, 1), $value);|g' /var/www/heimdall/vendor/symfony/console/Input/ArrayInput.php
    #cd /var/www/heimdall
    #/usr/bin/php artisan key:generate
    rm -rf /var/www/heimdall/storage/framework/sessions/* 2> /dev/null
  # Reiniciar el sistema
    echo ""
    echo "    Reiniciando el sistema..."    echo ""
    #shutdown -r now
fi

