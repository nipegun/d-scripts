#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar el servidor de bases InfluxDB en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-InfluxDB-Instalar.sh | bash
#
# Ejecución remota con root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-InfluxDB-Instalar.sh | sed 's-sudo--g' | bash
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

if [ $cVerSO == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor InfluxDB para Debian 13 (x)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutar el script en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor InfluxDB para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  # Paquetes influx
    echo ""
    echo "    Instalando paquetes influx..."
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install influxdb
    sudo apt-get -y install influxdb-client

  # Paquetes 
    echo ""
    echo "    Instalando paquetes de Python..."
    echo ""
    sudo apt-get -y install python3-dev
    sudo apt-get -y install python3-pip
    sudo apt-get -y install python3-influxdb
    #pip3 install influxdb --upgrade --break-system-packages

  # Activar el servicio
    echo ""
    echo "    Activando el servicio"
    echo ""
    systemctl enable influxdb.service --now

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor InfluxDB para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  # Paquetes influx
    echo ""
    echo "    Instalando paquetes influx..."
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install influxdb
    sudo apt-get -y install influxdb-client

  # Paquetes 
    echo ""
    echo "    Instalando paquetes de Python..."
    echo ""
    sudo apt-get -y install python3-dev
    sudo apt-get -y install python3-pip
    sudo apt-get -y install python3-influxdb
    #pip3 install influxdb --upgrade --break-system-packages

  # Activar el servicio
    echo ""
    echo "    Activando el servicio"
    echo ""
    systemctl enable influxdb.service --now

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor InfluxDB para Debian 10 (Buster)...${cFinColor}"
  echo ""

  # Paquetes influx
    echo ""
    echo "    Instalando paquetes influx..."
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install influxdb
    sudo apt-get -y install influxdb-client

  # Paquetes 
    echo ""
    echo "    Instalando paquetes de Python..."
    echo ""
    sudo apt-get -y install python3-dev
    sudo apt-get -y install python3-pip
    sudo apt-get -y install python3-influxdb
    #pip3 install influxdb --upgrade --break-system-packages

  # Activar el servicio
    echo ""
    echo "    Activando el servicio"
    echo ""
    systemctl enable influxdb.service --now

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor InfluxDB para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor InfluxDB para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor InfluxDB para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian.${cFinColor}"
  echo ""

fi

