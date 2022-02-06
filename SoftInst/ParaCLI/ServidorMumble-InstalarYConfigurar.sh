#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar el servidor mumble
#
#  Ejecución remota:
#  curl -s | bash
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
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  # Actualizar los repositorios
    apt-get -y update

  # Instalar el paquete
    apt-get -y install mumble-server

  # Reconfigurarlo
    echo ""
    echo "----------------------------------------------------------------------"
    echo "  RECONFIGURANDO EL SERVIDOR MUMBLE..."
    echo "  TE PEDIRÁ QUE INGRESES DOS VECES LA NUEVA CONTRASEÑA DEL SuperUser"
    echo "----------------------------------------------------------------------"
    dpkg-reconfigure mumble-server

  # Detener el servicio para hacerle cambios a la configuración
    service mumble-server stop

  # Hacer copia de seguridad del archivo de configuración
    cp /etc/mumble-server.ini /etc/mumble-server.ini.bak

  # Modificar el archivo de configuración
    sed -i -e 's|welcometext="<br />Welcome to this server running <b>Murmur</b>.<br />Enjoy your stay!<br />"|welcometext="<br />Bienvenido al servidor <b>Mumble</b>.<br />"|g' /etc/mumble-server.ini
    sed -i -e 's|#bonjour=True|bonjour=True|g' /etc/mumble-server.ini
    sed -i -e 's|#sslCert=|#sslCert=/etc/letsencrypt/live/dominioejemplo.com/cert.pem|g' /etc/mumble-server.ini
    sed -i -e 's|#sslKey=|#sslKey=/etc/letsencrypt/live/dominioejemplo.com/privkey.pem|g' /etc/mumble-server.ini
    sed -i "/#sslKey=/a #sslCA=/etc/letsencrypt/live/dominioejemplo.com/fullchain.pem" /etc/mumble-server.ini

  # Borrar los datos del certificado SSL autogenerado
  # Hacer siempre despùés de que se agregue el certificado en /etc/mumble-server.ini
  # De hecho, lo correcto, después de modificar /etc/mumble-server.ini, sería hacer:
  # service mumble-server stop
  # murmurd -wipessl
  # pkill murmurd
  # service mumble-server start
    murmurd -wipessl

  # Matar todos los procesos murmurd
    pkill murmurd

  # Re-arrancar el servicio
    service mumble-server start

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 9 (Stretch)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  # Actualizar los repositorios
  apt-get -y update

  # Instalar el paquete
  apt-get -y install mumble-server

  # Reconfigurarlo
  echo ""
  echo "----------------------------------------------------------------------"
  echo "  RECONFIGURANDO EL SERVIDOR MUMBLE..."
  echo "  TE PEDIRÁ QUE INGRESES DOS VECES LA NUEVA CONTRASEÑA DEL SuperUser"
  echo "----------------------------------------------------------------------"
  dpkg-reconfigure mumble-server

  # Detener el servicio para hacerle cambios a la configuración
  service mumble-server stop

  # Hacer copia de seguridad del archivo de configuración
  cp /etc/mumble-server.ini /etc/mumble-server.ini.bak

  # Modificar el archivo de configuración
  sed -i -e 's|welcometext="<br />Welcome to this server running <b>Murmur</b>.<br />Enjoy your stay!<br />"|welcometext="<br />Bienvenido al servidor <b>Mumble</b>.<br />"|g' /etc/mumble-server.ini
  sed -i -e 's|#bonjour=True|bonjour=True|g'                                            /etc/mumble-server.ini
  sed -i -e 's|#sslCert=|#sslCert=/etc/letsencrypt/live/dominioejemplo.com/cert.pem|g'  /etc/mumble-server.ini
  sed -i -e 's|#sslKey=|#sslKey=/etc/letsencrypt/live/dominioejemplo.com/privkey.pem|g' /etc/mumble-server.ini
  sed -i "/#sslKey=/a #sslCA=/etc/letsencrypt/live/dominioejemplo.com/fullchain.pem"    /etc/mumble-server.ini

  # Borrar los datos del certificado SSL autogenerado
  # Hacer siempre despùés de que se agregue el certificado en /etc/mumble-server.ini
  # De hecho, lo correcto, después de modificar /etc/mumble-server.ini, sera hacer:
  # service mumble-server stop
  # murmurd -wipessl
  # pkill murmurd
  # service mumble-server start
  murmurd -wipessl

  # Matar todos los procesos murmurd
  pkill murmurd

  # Re-arrancar el servicio
  service mumble-server start

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 10 (Buster)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  # Actualizar los repositorios
    apt-get -y update

  # Instalar el paquete
    apt-get -y install mumble-server

  # Reconfigurarlo
    echo ""
    echo "----------------------------------------------------------------------"
    echo "  RECONFIGURANDO EL SERVIDOR MUMBLE..."
    echo "  TE PEDIRÁ QUE INGRESES DOS VECES LA NUEVA CONTRASEÑA DEL SuperUser"
    echo "----------------------------------------------------------------------"
    dpkg-reconfigure mumble-server

  # Detener el servicio para hacerle cambios a la configuración
    service mumble-server stop

  # Hacer copia de seguridad del archivo de configuración
    cp /etc/mumble-server.ini /etc/mumble-server.ini.bak

  # Modificar el archivo de configuración
    sed -i -e 's|welcometext="<br />Welcome to this server running <b>Murmur</b>.<br />Enjoy your stay!<br />"|welcometext="<br />Bienvenido al servidor <b>Mumble</b>.<br />"|g' /etc/mumble-server.ini
    sed -i -e 's|bandwidth=72000|bandwidth=128000|g' /etc/mumble-server.ini
    sed -i -e 's|;bonjour=True|bonjour=True|g' /etc/mumble-server.ini
    sed -i -e 's|;sslCert=|;sslCert=/etc/letsencrypt/live/dominioejemplo.com/cert.pem|g' /etc/mumble-server.ini
    sed -i -e 's|;sslKey=|;sslKey=/etc/letsencrypt/live/dominioejemplo.com/privkey.pem|g' /etc/mumble-server.ini
    sed -i "/;sslKey=/a ;sslCA=/etc/letsencrypt/live/dominioejemplo.com/fullchain.pem" /etc/mumble-server.ini

  # Borrar los datos del certificado SSL autogenerado
  # Hacer siempre despùés de que se agregue el certificado en /etc/mumble-server.ini
  # De hecho, lo correcto, después de modificar /etc/mumble-server.ini, sera hacer:
  # service mumble-server stop
  # murmurd -wipessl
  # pkill murmurd
  # service mumble-server start
    murmurd -wipessl

  # Matar todos los procesos murmurd
    pkill murmurd

  # Re-arrancar el servicio
    service mumble-server start

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 11 (Bullseye)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  # Actualizar los repositorios
    apt-get -y update

  # Instalar el paquete
    apt-get -y install mumble-server

  # Detener el servicio para hacerle cambios a la configuración
    service mumble-server stop

  # Reconfigurarlo
    echo ""
    echo "----------------------------------------------------------------------"
    echo "  RECONFIGURANDO EL SERVIDOR MUMBLE..."
    echo "  TE PEDIRÁ QUE INGRESES DOS VECES LA NUEVA CONTRASEÑA DEL SuperUser"
    echo "----------------------------------------------------------------------"
    dpkg-reconfigure mumble-server

  # Hacer copia de seguridad del archivo de configuración
    cp /etc/mumble-server.ini /etc/mumble-server.ini.bak

  # Modificar el archivo de configuración
    sed -i -e 's|welcometext="<br />Welcome to this server running <b>Murmur</b>.<br />Enjoy your stay!<br />"|welcometext="<br />Bienvenido al servidor <b>Mumble</b>.<br />"|g' /etc/mumble-server.ini
    sed -i -e 's|#bonjour=True|bonjour=True|g'                                            /etc/mumble-server.ini
    sed -i -e 's|#sslCert=|#sslCert=/etc/letsencrypt/live/dominioejemplo.com/cert.pem|g'  /etc/mumble-server.ini
    sed -i -e 's|#sslKey=|#sslKey=/etc/letsencrypt/live/dominioejemplo.com/privkey.pem|g' /etc/mumble-server.ini
    sed -i "/#sslKey=/a #sslCA=/etc/letsencrypt/live/dominioejemplo.com/fullchain.pem"    /etc/mumble-server.ini

  # Borrar los datos del certificado SSL autogenerado
  # Hacer siempre despùés de que se agregue el certificado en /etc/mumble-server.ini
  # De hecho, lo correcto, después de modificar /etc/mumble-server.ini, sera hacer:
  # service mumble-server stop
  # murmurd -wipessl
  # pkill murmurd
  # service mumble-server start
    murmurd -wipessl

  # Matar todos los procesos murmurd
    pkill murmurd

  # Re-arrancar el servicio
    service mumble-server start

fi

