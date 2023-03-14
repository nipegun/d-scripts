#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar Coder en Debian
#
#  Ejecución remota:
#  curl -s x | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' x | bash
#
#  Ejecución remota con parámetros:
#  curl -s x | bash -s Parámetro1 Parámetro2
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}  curl no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install curl
    echo ""
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    OS_NAME=$NAME
    OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    OS_NAME=$(lsb_release -si)
    OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    OS_NAME=$DISTRIB_ID
    OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    OS_NAME=Debian
    OS_VERS=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    OS_NAME=$(uname -s)
    OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Coder para Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Coder para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Coder para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Coder para Debian 10 (Buster)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Coder para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  # Instalar usando script
    curl -fsSL https://coder.com/install.sh | sh

  # Configurar
    sed -i -e 's|CODER_ACCESS_URL=|CODER_ACCESS_URL=|g'               /etc/coder.d/coder.env
    sed -i -e 's|CODER_ADDRESS=|CODER_ADDRESS=|g'                     /etc/coder.d/coder.env
    sed -i -e 's|CODER_PG_CONNECTION_URL=|CODER_PG_CONNECTION_URL=|g' /etc/coder.d/coder.env
    sed -i -e 's|CODER_TLS_CERT_FILE=|CODER_TLS_CERT_FILE=|g'         /etc/coder.d/coder.env
    sed -i -e 's|CODER_TLS_ENABLE=|CODER_TLS_ENABLE=|g'               /etc/coder.d/coder.env
    sed -i -e 's|CODER_TLS_KEY_FILE=|CODER_TLS_KEY_FILE=|g'           /etc/coder.d/coder.env   

  # Activar y lanzar el servicio
    systemctl enable --now coder

  # ?
    journalctl -u coder.service -b

  # Loguearse para crear el primer usuario
    echo ""
    echo "    Intentando loguearse en http://127.0.0.1:3000..."
    echo "    Sigue los pasos para la creación del primer usuario."
    echo ""
    coder login http://127.0.0.1:3000

  # Crear el primer espacio de trabajo
    echo ""
    echo "    Creando el primer espacio de trabajo..."
    echo '      Aconsejado: Elegir "code-server en docker"'
    echo ""
    coder template init

  # Crear la plantilla
    echo ""
    echo "    Creando la plantilla para docker code-server..."
    echo "    Responde yes cuando sea necesario."
    echo ""
    cd ./docker-code-server && coder templates create       

  echo ""
  echo "    Coder instalado y configurado."
  echo "    Conéctate a la interfaz desde este ordenador accediendo a: http://127.0.0.1:3000"
  echo "    o desde otro ordenador accediendo a: "
  echo ""


fi

