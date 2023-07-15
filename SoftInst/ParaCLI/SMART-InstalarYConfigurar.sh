#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar la monitorización SMART
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/SMART-InstalarYConfigurar.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       cNomSO=$NAME
       cVerSO=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       cNomSO=$(lsb_release -si)
       cVerSO=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       cNomSO=$DISTRIB_ID
       cVerSO=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       cNomSO=Debian
       cVerSO=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       cNomSO=$(uname -s)
       cVerSO=$(uname -r)
   fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 9 (Stretch)..."
  
  echo ""

  cCantArgumEsperados=2
  

  if [ $# -ne $EXPECTED_ARGS ]
    then
      echo ""
      echo "--------------------------------------------------------------------------------------------"
      echo "  Mal uso del script."
      echo ""
      echo "  El uso correcto sería:"
      echo "  $0 DiscoAMonitorizar MailANotificar"
      echo ""
      echo "  Ejemplo:"
      echo "  $0 /dev/sda pepe@pepe.com"
      echo "--------------------------------------------------------------------------------------------"
      echo ""
      exit
    else
      echo ""
      echo "----------------------------------------"
      echo "  PREPARANDO LA MONITORIZACIÓN DEL SSD"
      echo "----------------------------------------"
      echo ""
      echo "---------------------------------------"
      echo "  INSTALANDO EL PAQUETE smartmontools"
      echo "---------------------------------------"
      echo ""
      apt-get -y install smartmontools
    
      echo ""
      echo "---------------------------------------"
      echo "  ACTIVANDO SMART EN EL DISCO $1"
      echo "---------------------------------------"
      echo ""
      smartctl -s on $1
    
      echo ""
      echo "----------------------------"
      echo "  CONFIGURANDO EL SERVICIO"
      echo "----------------------------"
      echo ""
    sed -i -e 's|#start_smartd=yes|start_smartd=yes|g' /etc/default/smartmontools
      cp /etc/smartd.conf /etc/smartd.conf.bak
      echo "$1 -a -m $2 -M exec /root/deb-scripts/nofadis" > /etc/smartd.conf
      echo ""
  fi

elif [ $cVerSO == "10" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 10 (Buster)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 11 (Bullseye)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi

