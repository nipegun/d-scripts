#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar MLDonkey en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/MLDonkey-InstalarYConfigurar.sh | bash
# ----------

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
  echo "  Iniciando el script de instalación de MLDonkey para Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de MLDonkey para Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de MLDonkey para Debian 9 (Stretch)..."  
  echo ""

  cCantArgumEsperados=1
  

  if [ $# -ne $cCantArgsEsperados ]
    then
      echo ""
      
      echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
      echo ""
      echo -e "InstalarYConfigurarMLDonkey ${cColorVerde}[IPDesdeLaQueSeVaAControlar]${cFinColor}"
      echo ""
      echo "Ejemplo:"
      echo ' InstalarYConfigurarMLDonkey 192.168.0.51'
      
      echo ""
      exit
    else
      echo ""
      echo "  Instalando el paquete mldonkey-server..."
      echo ""
      apt-get update
      apt-get -y install mldonkey-server
      echo ""
      echo "  Deteninendo el servicio..."
      echo ""
      service mldonkey-server stop
      echo ""
      echo "  Realizando cambios en la configuración..."
      echo ""
      cp /var/lib/mldonkey/downloads.ini /var/lib/mldonkey/downloads.ini.bak
      sed -i -e 's| allowed_ips = \[| allowed_ips = ["127.0.0.1"; "'"$1"'";]|g' /var/lib/mldonkey/downloads.ini
      sed -i -e 's|  "127.0.0.1";]| |g' /var/lib/mldonkey/downloads.ini
      sed -i -e 's| nolimit_ips = \[| nolimit_ips = ["127.0.0.1";]|g' /var/lib/mldonkey/downloads.ini
      echo ""
      echo "  Re-arrancando el servicio..."
      echo ""
      service mldonkey-server start
      echo ""
      echo "  Ejecución del script, finalizada."
      echo "  Ya deberías ser capaz de controlar MLDonkey desde la IP $1."
      echo ""
  fi

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de MLDonkey para Debian 10 (Buster)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de MLDonkey para Debian 11 (Bullseye)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi

