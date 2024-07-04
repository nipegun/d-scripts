#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar TOR en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/TOR-Instalar.sh | bash
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
  echo "  Iniciando el script de instalación de TOR para Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de TOR para Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de TOR para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de TOR para Debian 10 (Buster)..."  
  echo ""

  echo ""
  echo "    Instalando paquetes necesarios..." 
  echo ""
  apt-get -y update
  apt-get -y install tor

  echo ""
  echo "    Configurando TOR..." 
  echo ""
  cp /etc/tor/torrc /etc/tor/torrc.bak.ori
  echo "SocksPort 9050"                            > /etc/tor/torrc
  echo "Log notice file /var/log/tor/notices.log" >> /etc/tor/torrc
  echo "Log debug file /var/log/tor/debug.log"    >> /etc/tor/torrc
  echo "RunAsDaemon 1"                            >> /etc/tor/torrc

  echo ""
  echo "    Reiniciando el servicio..." 
  echo ""
  systemctl reload tor.service
  systemctl enable tor.service --now
  systemctl status tor.service --no-pager
  echo ""

  echo ""
  echo "  Comprobando el funcionamiento de TOR..." 
  echo ""
  curl -sL --socks5-hostname localhost:9050 https://check.torproject.org | grep ongrat
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de TOR para Debian 11 (Bullseye)..."  
  echo ""

  echo ""
  echo "  Iniciando el script de instalación de TOR para Debian 10 (Buster)..."  
  echo ""

  echo ""
  echo "    Instalando paquetes necesarios..." 
  echo ""
  apt-get -y update
  apt-get -y install tor

  echo ""
  echo "    Configurando TOR..." 
  echo ""
  cp /etc/tor/torrc /etc/tor/torrc.bak.ori
  echo "SocksPort 9050"                            > /etc/tor/torrc
  echo "Log notice file /var/log/tor/notices.log" >> /etc/tor/torrc
  echo "Log debug file /var/log/tor/debug.log"    >> /etc/tor/torrc
  echo "RunAsDaemon 1"                            >> /etc/tor/torrc

  echo ""
  echo "    Reiniciando el servicio..." 
  echo ""
  systemctl reload tor.service
  systemctl enable tor.service --now
  systemctl status tor.service --no-pager
  echo ""

  echo ""
  echo "  Comprobando el funcionamiento de TOR..." 
  echo ""
  curl -sL --socks5-hostname localhost:9050 https://check.torproject.org | grep ongrat
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación de TOR para Debian 12 (Bookworm)..."  
  echo ""
  echo ""
  echo "  Iniciando el script de instalación de TOR para Debian 10 (Buster)..."  
  echo ""

  echo ""
  echo "    Instalando paquetes necesarios..." 
  echo ""
  apt-get -y update
  apt-get -y install tor

  echo ""
  echo "    Configurando TOR..." 
  echo ""
  cp /etc/tor/torrc /etc/tor/torrc.bak.ori
  echo "SocksPort 9050"                            > /etc/tor/torrc
  echo "Log notice file /var/log/tor/notices.log" >> /etc/tor/torrc
  echo "Log debug file /var/log/tor/debug.log"    >> /etc/tor/torrc
  echo "RunAsDaemon 1"                            >> /etc/tor/torrc

  echo ""
  echo "    Reiniciando el servicio..." 
  echo ""
  systemctl reload tor.service
  systemctl enable tor.service --now
  systemctl status tor.service --no-pager
  echo ""

  echo ""
  echo "  Comprobando el funcionamiento de TOR..." 
  echo ""
  curl -sL --socks5-hostname localhost:9050 https://check.torproject.org | grep ongrat
  echo ""

fi
