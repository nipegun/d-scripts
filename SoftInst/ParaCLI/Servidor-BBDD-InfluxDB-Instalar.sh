#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar el servidor de bases InfluxDB en Debian
#
# Ejecución remota
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-InfluxDB-Instalar.sh | bash
# ----------

# Definir variables de color
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

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD)
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación del servidor InfluxDB para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación del servidor InfluxDB para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación del servidor InfluxDB para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación del servidor InfluxDB para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo "    Instalando paquetes..."
  echo ""
  apt-get -y update
  apt-get -y install influxdb
  apt-get -y install influxdb-client
  apt-get -y install python3-influxdb

  echo ""
  echo "    Activando el servicio"
  echo ""
  systemctl enable influxdb.service --now

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación del servidor InfluxDB para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  echo ""
  echo "    Instalando paquetes de InfluxDB..."
  echo ""
  apt-get -y update
  apt-get -y install influxdb
  apt-get -y install influxdb-client

  echo ""
  echo "    Instalando paquetes de Python..."
  echo ""
  apt-get -y install python3-dev
  apt-get -y install python3-pip
  apt-get -y install python3-influxdb
  pip3 install influxdb

  echo ""
  echo "    Activando el servicio"
  echo ""
  systemctl enable influxdb.service --now

fi

