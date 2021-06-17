#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar Transmission en Debian
#--------------------------------------------------------------------

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
  echo "  Iniciando el script de instalación de Transmission para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 7 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Transmission para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 8 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Transmission para Debian 9 (Stretch)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 9 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Transmission para Debian 10 (Buster)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  CantArgsRequeridos=4
  ArgumentosInsuficientes=65

  if [ $# -ne $CantArgsRequeridos ]
    then
      echo ""
      echo "--------------------------------------------------------------------------------------------"
      echo -e "${ColorRojo}Mal uso del script.${FinColor} El uso correcto sería:"
      echo ""
      echo -e "$0 ${ColorVerde}[CarpetaDeDescargas] [CarpetaDeIncompletos] [Password] [Usuario]${FinColor}"
      echo ""
      echo "  Ejemplo:"
      echo "  $0 /var/tmp/transmission/completos /var/tmp/transmission/incompletos 12345678 nico"
      echo "--------------------------------------------------------------------------------------------"
      echo ""
      exit $ArgumentosInsuficientes
    else
      echo ""
      echo -e "${ColorVerde}Creando las carpetas para las descargas...${FinColor}"
      echo ""
      mkdir -p $1
      mkdir -p $2
    
      echo ""
      echo -e "${ColorVerde}Instalando el paquete transission-daemon...${FinColor}"
      echo ""
      apt-get -y install transmission-daemon

      echo ""
      echo -e "${ColorVerde}Deteniendo el servicio transmission-daemon${FinColor}"
      echo ""
      service transmission-daemon stop

      echo ""
      echo -e "${ColorVerde}Realizando cambios en la configuración...${FinColor}"
      echo ""
      cp /etc/transmission-daemon/settings.json /etc/transmission-daemon/settings.json.bak
      sed -i -e 's|"download-dir": "/var/lib/transmission-daemon/downloads",|"download-dir": "'$1'",|g' /etc/transmission-daemon/settings.json
      sed -i -e 's|"incomplete-dir": "/var/lib/transmission-daemon/Downloads",|"incomplete-dir": "'$2'",|g' /etc/transmission-daemon/settings.json
      sed -i -e 's|"incomplete-dir-enabled": false,|"incomplete-dir-enabled": true,|g' /etc/transmission-daemon/settings.json
      sed -i -e 's|"ratio-limit-enabled": false,|"ratio-limit-enabled": true,|g' /etc/transmission-daemon/settings.json
      sed -i -e 's|^.*"rpc-password":.*|    "rpc-password": "'$3'",|g' /etc/transmission-daemon/settings.json
      sed -i -e 's|"rpc-whitelist": "127.0.0.1",|"rpc-whitelist": "127.0.0.1, 192.168.*.*, 10.0.*.*",|g' /etc/transmission-daemon/settings.json
      sed -i -e 's|"trash-original-torrent-files": false,|"trash-original-torrent-files": true,|g' /etc/transmission-daemon/settings.json
      sed -i -e 's|"umask": 18,|"umask": 2,|g' /etc/transmission-daemon/settings.json

      echo ""
      echo -e "${ColorVerde}Agregando el usuario al grupo transmission-daemon...${FinColor}"
      echo ""
      usermod -a -G debian-transmission $4

      echo ""
      echo -e "${ColorVerde}Cambiando el grupo propietario de lsa carpetas $1 y $2...${FinColor}"
      echo ""
      chgrp debian-transmission $1
      chgrp debian-transmission $2
    
      echo ""
      echo -e "${ColorVerde}Dando permisos de escritura al grupo...${FinColor}"
      echo ""
      chmod 770 $1
      chmod 770 $2

      echo ""
      echo -e "${ColorVerde}Iniciando el servicio transmission-daemon...${FinColor}"
      echo ""
      service transmission-daemon start

      echo ""
      echo "---------------------------------------------------------"
      echo "  EL DEMONIO TRANSMISSION HA SIDO INSTALADO E INICIADO."
      echo ""
      echo "  Deberías poder administrarlo mediante web en la IP de"
      echo "  este ordenador seguida por :9091"
      echo ""
      echo "  Ejemplo: 192.168.0.120:9091"
      echo ""
      echo "  Nombre de usuario: transmission"
      echo "  Contraseña: $3"
      echo "---------------------------------------------------------"
      echo ""
  fi

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Transmission para Debian 11 (Bullseye)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 11 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

fi
