#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

------------------------------------------------------------------------------------------------------
# Script de NiPeGun para instalar y configurar Transmission en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Torrent-Transmission-InstalarYConfigurar.sh | bash -s -- /var/tmp/transmission/completos /var/tmp/transmission/incompletos 12345678 nico
------------------------------------------------------------------------------------------------------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
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

if [ $cVerSO == "7" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Transmission para Debian 7 (Wheezy)..."  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Transmission para Debian 8 (Jessie)..."  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de Transmission para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de Transmission para Debian 10 (Buster)..."  
  echo ""

  CantArgsRequeridos=4
  

  if [ $# -ne $CantArgsRequeridos ]
    then
      echo ""
      echo "--------------------------------------------------------------------------------------------"
      echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
      echo ""
      echo -e "$0 ${cColorVerde}[CarpetaDeDescargas] [CarpetaDeIncompletos] [Password] [Usuario]${cFinColor}"
      echo ""
      echo "  Ejemplo:"
      echo "  $0 /var/tmp/transmission/completos /var/tmp/transmission/incompletos 12345678 nico"
      echo "--------------------------------------------------------------------------------------------"
      echo ""
      exit
    else
      echo ""
      echo -e "${cColorVerde}Creando las carpetas para las descargas...${cFinColor}"
      echo ""
      mkdir -p $1
      mkdir -p $2
    
      echo ""
      echo -e "${cColorVerde}Instalando el paquete transission-daemon...${cFinColor}"
      echo ""
      apt-get -y install transmission-daemon

      echo ""
      echo -e "${cColorVerde}Deteniendo el servicio transmission-daemon${cFinColor}"
      echo ""
      service transmission-daemon stop

      echo ""
      echo -e "${cColorVerde}Realizando cambios en la configuración...${cFinColor}"
      echo ""
      cp /etc/transmission-daemon/settings.json /etc/transmission-daemon/settings.json.bak
      sed -i -e 's|"download-dir": "/var/lib/transmission-daemon/downloads",|"download-dir": "'$1'",|g'     /etc/transmission-daemon/settings.json
      sed -i -e 's|"incomplete-dir": "/var/lib/transmission-daemon/Downloads",|"incomplete-dir": "'$2'",|g' /etc/transmission-daemon/settings.json
      sed -i -e 's|"incomplete-dir-enabled": false,|"incomplete-dir-enabled": true,|g'                      /etc/transmission-daemon/settings.json
      sed -i -e 's|"ratio-limit-enabled": false,|"ratio-limit-enabled": true,|g'                            /etc/transmission-daemon/settings.json
      sed -i -e 's|^.*"rpc-password":.*|    "rpc-password": "'$3'",|g'                                      /etc/transmission-daemon/settings.json
      sed -i -e 's|"rpc-whitelist": "127.0.0.1",|"rpc-whitelist": "127.0.0.1, 192.168.*.*, 10.0.*.*",|g'    /etc/transmission-daemon/settings.json
      sed -i -e 's|"trash-original-torrent-files": false,|"trash-original-torrent-files": true,|g'          /etc/transmission-daemon/settings.json
      sed -i -e 's|"umask": 18,|"umask": 2,|g'                                                              /etc/transmission-daemon/settings.json

      echo ""
      echo -e "${cColorVerde}Agregando el usuario al grupo transmission-daemon...${cFinColor}"
      echo ""
      usermod -a -G debian-transmission $4

      echo ""
      echo -e "${cColorVerde}Cambiando el grupo propietario de lsa carpetas $1 y $2...${cFinColor}"
      echo ""
      chgrp debian-transmission $1
      chgrp debian-transmission $2
    
      echo ""
      echo -e "${cColorVerde}Dando permisos de escritura al grupo...${cFinColor}"
      echo ""
      chmod 770 $1
      chmod 770 $2

      echo ""
      echo -e "${cColorVerde}Iniciando el servicio transmission-daemon...${cFinColor}"
      echo ""
      service transmission-daemon start

      echo ""
      
      echo "  EL DEMONIO TRANSMISSION HA SIDO INSTALADO E INICIADO."
      echo ""
      echo "  Deberías poder administrarlo mediante web en la IP de"
      echo "  este ordenador seguida por :9091"
      echo ""
      echo "  Ejemplo: 192.168.0.120:9091"
      echo ""
      echo "  Nombre de usuario: transmission"
      echo "  Contraseña: $3"
      
      echo ""
  fi

elif [ $cVerSO == "11" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de Transmission para Debian 11 (Bullseye)..."  
  echo ""

CantArgsRequeridos=4
  

  if [ $# -ne $CantArgsRequeridos ]
    then
      echo ""
      echo "--------------------------------------------------------------------------------------------"
      echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
      echo ""
      echo -e "$0 ${cColorVerde}[CarpetaDeDescargas] [CarpetaDeIncompletos] [Password] [Usuario]${cFinColor}"
      echo ""
      echo "  Ejemplo:"
      echo "  $0 /var/tmp/transmission/completos /var/tmp/transmission/incompletos 12345678 nico"
      echo "--------------------------------------------------------------------------------------------"
      echo ""
      exit
    else
      echo ""
      echo -e "${cColorVerde}Creando las carpetas para las descargas...${cFinColor}"
      echo ""
      mkdir -p $1
      mkdir -p $2
    
      echo ""
      echo -e "${cColorVerde}Instalando el paquete transission-daemon...${cFinColor}"
      echo ""
      apt-get -y install transmission-daemon

      echo ""
      echo -e "${cColorVerde}Deteniendo el servicio transmission-daemon${cFinColor}"
      echo ""
      service transmission-daemon stop

      echo ""
      echo -e "${cColorVerde}Realizando cambios en la configuración...${cFinColor}"
      echo ""
      cp /etc/transmission-daemon/settings.json /etc/transmission-daemon/settings.json.bak
      sed -i -e 's|"download-dir": "/var/lib/transmission-daemon/downloads",|"download-dir": "'$1'",|g'     /etc/transmission-daemon/settings.json
      sed -i -e 's|"incomplete-dir": "/var/lib/transmission-daemon/Downloads",|"incomplete-dir": "'$2'",|g' /etc/transmission-daemon/settings.json
      sed -i -e 's|"incomplete-dir-enabled": false,|"incomplete-dir-enabled": true,|g'                      /etc/transmission-daemon/settings.json
      sed -i -e 's|"ratio-limit-enabled": false,|"ratio-limit-enabled": true,|g'                            /etc/transmission-daemon/settings.json
      sed -i -e 's|^.*"rpc-password":.*|    "rpc-password": "'$3'",|g'                                      /etc/transmission-daemon/settings.json
      sed -i -e 's|"rpc-whitelist": "127.0.0.1",|"rpc-whitelist": "127.0.0.1, 192.168.*.*, 10.0.*.*",|g'    /etc/transmission-daemon/settings.json
      sed -i -e 's|"trash-original-torrent-files": false,|"trash-original-torrent-files": true,|g'          /etc/transmission-daemon/settings.json
      sed -i -e 's|"umask": 18,|"umask": 2,|g'                                                              /etc/transmission-daemon/settings.json

      echo ""
      echo -e "${cColorVerde}Agregando el usuario al grupo transmission-daemon...${cFinColor}"
      echo ""
      usermod -a -G debian-transmission $4

      echo ""
      echo -e "${cColorVerde}Cambiando el grupo propietario de lsa carpetas $1 y $2...${cFinColor}"
      echo ""
      chgrp debian-transmission $1
      chgrp debian-transmission $2
    
      echo ""
      echo -e "${cColorVerde}Dando permisos de escritura al grupo...${cFinColor}"
      echo ""
      chmod 770 $1
      chmod 770 $2

      echo ""
      echo -e "${cColorVerde}Iniciando el servicio transmission-daemon...${cFinColor}"
      echo ""
      service transmission-daemon start

      echo ""
      
      echo "  EL DEMONIO TRANSMISSION HA SIDO INSTALADO E INICIADO."
      echo ""
      echo "  Deberías poder administrarlo mediante web en la IP de"
      echo "  este ordenador seguida por :9091"
      echo ""
      echo "  Ejemplo: 192.168.0.120:9091"
      echo ""
      echo "  Nombre de usuario: transmission"
      echo "  Contraseña: $3"
      
      echo ""

  fi

fi
