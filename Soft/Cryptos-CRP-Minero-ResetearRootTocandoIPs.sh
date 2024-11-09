#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para resetear el minero de Crypton instalado en Debian
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

#DirCartera="C24C4B77698578B46CDB1C109996B0299984FEE46AAC5CD6025786F5C5C61415" #npg
#DirCartera="02BA53D255C31B626D32EB14C57AC71B65B387BBE7E7F4A5290F849824DBB15A" #abru
#DirCartera="F62FF04B8849C4ADD45CC5980499168A1B8ADF2C329C602443CD34AA97B55727" #edpik
DirCartera="248C22E649C37C46A03F6A255212CADE2D1569DBB39FC8CEC03A3D6D1F919D22" #feriz

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
  
  echo "  Iniciando el script para resetear el minero de Utopia instalado en Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  
  echo "  Iniciando el script para resetear el minero de Utopia instalado en Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script para resetear el minero de Utopia instalado en Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  
  echo "  Iniciando el script para resetear el minero de Utopia instalado en Debian 10 (Buster)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------------"
  echo "  Iniciando el script para resetear el minero de Crypton instalado en Debian 11 (Bullseye)..."  echo "-----------------------------------------------------------------------------------------------"
  echo ""

  # Terminar cualquier proceso del minero que pueda estar ejecutándose
     echo ""
     echo "  Terminando posibles procesos activos del antiguo minero..."     echo ""
     # Comprobar si el paquete psmisc está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s psmisc 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  psmisc no está instalado. Iniciando su instalación..."          echo ""
          apt-get -y update
          apt-get -y install psmisc
          echo ""
        fi
     killall -9 uam

  # Hacer copia de seguridad del archio uam.ini
     mv /root/.uam/uam.ini /root/

  # Borrar todos los datos del anterior minero
     echo ""
     echo "  Borrando todos los datos del anterior minero..."     echo ""
     rm -rf /root/.uam/*

  # Actualizar el minero a la última versión
     echo ""
     echo "  Actualizando el minero a la última versión..."     echo ""
     # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  curl no está instalado. Iniciando su instalación..."          echo ""
          apt-get -y update
          apt-get -y install curl
          echo ""
        fi
     curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/Consola/Cryptos-CRP-Minero-InstalarOActualizar.sh | bash

# Preparar el archivo .ini del nuevo minero
     echo ""
     echo "  Preparando el archivo .ini del nuevo minero..."     echo ""
     IPYPuerto=$(cat /root/uam.ini | grep listens)
     echo "[net]"       > /root/uam.ini
     echo "$IPYPuerto" >> /root/uam.ini
     mv /root/uam.ini /root/.uam/

  # Activar la auto-ejecución
     echo ""
     echo "  Activando la auto-ejecución..."     echo ""
     #sed -i -e 's|#~/Cryptos/CRP/minero/Minar.sh|~/Cryptos/CRP/minero/Minar.sh|g' /root/.bash_profile
     echo "~/Cryptos/CRP/minero/Minar.sh" /root/.bash_profile

  # Re-escribir la dirección de cartera
     sed -i -e "s|C24C4B77698578B46CDB1C109996B0299984FEE46AAC5CD6025786F5C5C61415|$DirCartera|g" ~/Cryptos/CRP/minero/Minar.sh

  # Reiniciar el sistema
     echo ""
     echo "  Apagando el sistema..."     echo ""
     shutdown -h now

  fi
  
fi
