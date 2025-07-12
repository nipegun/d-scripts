#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

-----------------
# Script de NiPeGun para instalar y configurar WireGuard en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-VPN-WireGuard-Cliente-InstalarYConfigurar.sh | bash
-----------------

vInterfazEthernet="eth0"
#vInterfazEthernet="venet0"

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


if [ $cVerSO == "13" ]; then

  echo ""
  echo "  Iniciando el script de instalación de WireGuard para Debian 13 (x)..."  
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación de WireGuard para Debian 12 (Bookworm)..."  
  echo ""

  # Instalar el paquete WireGuard
    apt-get -y update
    apt-get -y install wireguard
    apt-get -y install resolvconf

  # Indicar que se proporcione el archivo de configuración del par
    echo ""
    echo "  Paquete Wireguard instalado."
    echo ""
    echo "    Para conectarse en modo cliente no hace falta crear claves privada y pública de servidor."
    echo "    Simplemente debes crear en el servidor Wireguard remoto un archivo de configuración para este par"
    echo "    y guardar el archivo de configuración en la carpeta /etc/wireguard/ de este Debian"
    echo "    Luego, para activar la conexión, ejecuta cada vez: wg-quick up NombreDeLaConexion"
    echo ""
    echo "    Por ejemplo:"
    echo "      wq-quick up wg0 (Si el archivo de configuración se llama wg.conf)"
    echo ""
    echo "    Si quieres que la conexión se levante cada vez que inicies Debian, ejecuta:"
    echo "      systemctl enable wg-quick@wg0"
    echo ""

  # Agregar las reglas del cortafuego a los ComandosPostArranque
    #touch /root/scripts/ReglasIPTablesWireGuard.sh
    #echo "iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                        > /root/scripts/ReglasIPTablesWireGuard.sh
    #echo "iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                     >> /root/scripts/ReglasIPTablesWireGuard.sh
    #echo "iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT"           >> /root/scripts/ReglasIPTablesWireGuard.sh
    #echo "iptables -A INPUT -s $DirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
    #echo "iptables -A INPUT -s $DirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
    #chmod +x /root/scripts/ReglasIPTablesWireGuard.sh
    #touch /root/scripts/ComandosPostArranque.sh
    #echo "/root/scripts/ReglasIPTablesWireGuard.sh" >> /root/scripts/ComandosPostArranque.sh
    #chmod +x /root/scripts/ComandosPostArranque.sh

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de WireGuard para Debian 11 (Bookworm)..."  
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de WireGuard para Debian 10 (Buster)..."  
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de WireGuard para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de WireGuard para Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de WireGuard para Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

fi

