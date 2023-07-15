#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para desinstalar ZeroTier de Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-VPN-ZeroTier-Desinstalar.sh | bash
# ----------

vFechaDeEjec=$(date +a%Ym%md%d@%T)

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
  echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de ZeroTier para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de ZeroTier para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de ZeroTier para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de ZeroTier para Debian 10 (Buster)...${cFinColor}"
  echo ""

  # Quitar de todas las redes a las que está unido el host
    echo ""
    echo "    Quitando este host de todas las redes a las que se ha unido..."
    echo ""
    zerotier-cli listnetworks | grep -v type >> /tmp/RedesZeroTier.txt
    while read linea
      do
        echo ""
        echo "      Saliendo de la red $linea..."
        echo ""
        zerotier-cli leave "$linea"
      done < /tmp/RedesZeroTier.txt
  # Desinstalar el paquete
    echo ""
    echo "    Desinstalando el paquete zerotier-one..."
    echo ""
    apt-get -y remove zerotier-one
  # Hacer copia de seguridad de la configuración
    echo ""
    echo "    Haciendo copia de seguridad de la configuración..."
    echo ""
    mkdir -p /CopSegInt/$vFechaDeEjec/ZeroTierOne/var/lib/zerotier-one/
    cp -r /var/lib/zerotier-one/* /CopSegInt/$vFechaDeEjec/ZeroTierOne/var/lib/zerotier-one/
  # Borrar toda la configuración
    echo ""
    echo "    Borrando toda la configuración..."
    echo ""
    rm -rf /var/lib/zerotier-one/
  # Limpiar el sistema
    echo ""
    echo "    Limpiando el sistema..."
    echo ""
    apt-get -y autoremove
    apt-get -y purge

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de ZeroTier para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  # Quitar de todas las redes a las que está unido el host
    echo ""
    echo "    Quitando este host de todas las redes a las que se ha unido..."
    echo ""
    zerotier-cli listnetworks | grep -v type >> /tmp/RedesZeroTier.txt
    while read linea
      do
        echo ""
        echo "      Saliendo de la red $linea..."
        echo ""
        zerotier-cli leave "$linea"
      done < /tmp/RedesZeroTier.txt
  # Desinstalar el paquete
    echo ""
    echo "    Desinstalando el paquete zerotier-one..."
    echo ""
    apt-get -y remove zerotier-one
  # Hacer copia de seguridad de la configuración
    echo ""
    echo "    Haciendo copia de seguridad de la configuración..."
    echo ""
    mkdir -p /CopSegInt/$vFechaDeEjec/ZeroTierOne/var/lib/zerotier-one/
    cp -r /var/lib/zerotier-one/* /CopSegInt/$vFechaDeEjec/ZeroTierOne/var/lib/zerotier-one/
  # Borrar toda la configuración
    echo ""
    echo "    Borrando toda la configuración..."
    echo ""
    rm -rf /var/lib/zerotier-one/
  # Limpiar el sistema
    echo ""
    echo "    Limpiando el sistema..."
    echo ""
    apt-get -y autoremove
    apt-get -y purge

fi

