#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar XRDP en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Escritorio-xrdp-Instalar.sh | bash
# ----------

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
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

if [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de xrdp para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian...${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de xrdp para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian...${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de xrdp para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  apt-get -y update
  apt-get -y install xrdp

  cp /etc/xrdp/xrdp_keyboard.ini /etc/xrdp/xrdp_keyboard.ini.bak
  sed -i -e 's|rdp_layout_de=0x00000407|rdp_layout_de=0x00000407\nrdp_layout_es=0x0000040A|g' /etc/xrdp/xrdp_keyboard.ini
  sed -i -e 's|rdp_layout_de=de|rdp_layout_de=de\nrdp_layout_es=es|g'                         /etc/xrdp/xrdp_keyboard.ini
  sed -i -e 's|allowed_users=console|allowed_users=anybody|g' /etc/X11/Xwrapper.config    

  echo ""
  echo "    Activando XRDP como servicio..."
  echo ""
  systemctl enable xrdp

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de xrdp para Debian 10 (Buster)...${cFinColor}"
  echo ""

  apt-get -y update 2> /dev/null
  apt-get -y install xrdp

  echo ""
  echo "    Activando XRDP como servicio..."
  echo ""
  systemctl enable xrdp --now

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de xrdp para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  apt-get -y update 2> /dev/null
  apt-get -y install xrdp

  echo ""
  echo "    Activando XRDP como servicio..."
  echo ""
  systemctl enable xrdp --now

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de xrdp para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  apt-get -y update 2> /dev/null
  apt-get -y install xrdp

  echo ""
  echo "    Activando XRDP como servicio..."
  echo ""
  systemctl enable xrdp --now

fi

