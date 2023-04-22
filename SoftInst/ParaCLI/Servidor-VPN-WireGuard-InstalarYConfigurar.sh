#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar WireGuard en Debian
#
# Ejecución remota:
#   curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-VPN-WireGuard-InstalarYConfigurar.sh | bash
# ----------

# Determinar la primera interfaz ethernet
vInterfazEthernet=$(ip route | grep "default via" | sed 's-dev -\n-g' | tail -n 1 | cut -d ' ' -f1)
#vInterfazEthernet="venet0"
vDirIPintWG="192.168.255.1"
vDirIPDefaultGateway=$(ip r | grep efault | cut -d' ' -f3)

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root....${vFinColor}" >&2
    exit 1
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
      . /etc/os-release
      OS_NAME=$NAME
      OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
      OS_NAME=$(lsb_release -si)
      OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
      . /etc/lsb-release
      OS_NAME=$DISTRIB_ID
      OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
      OS_NAME=Debian
      OS_VERS=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
      OS_NAME=$(uname -s)
      OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de WireGuard para Debian 7 (Wheezy)...${vFinColor}"
  echo "  "
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de WireGuard para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de WireGuard para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de WireGuard para Debian 10 (Buster)...${vFinColor}"
  echo ""

  # Borrar WireGuard si ya está instalado
    echo ""
    echo "    Borrando posible instalación anterior..."
    echo ""
    # Ejecutar primero copia de seguridad de posible instalación anterior
    mkdir -p /root/WireGuard/CopSegInstAnt/ 2> /dev/null
    mv /root/WireGuard/* /root/WireGuard/CopSegInstAnt/
    apt-get -y purge wireguard
    apt-get -y purge
    apt-get -y autoremove

# Instalar el paquete WireGuard
    echo ""
    echo "    Instalando paquetes..."
    echo ""
    apt-get -y update > /dev/null
    apt-get -y autoremove > /dev/null
    apt-get -y install wireguard
    apt-get -y install qrencode

  # Crear el archivo de configuración#
    echo ""
    echo "    Creando el archivo de configuración de la interfaz..."
    echo ""
    echo "[Interface]"                                                                                                > /etc/wireguard/wg0.conf
    echo "Address = $vDirIPintWG/24"                                                                                 >> /etc/wireguard/wg0.conf
    echo "PrivateKey ="                                                                                              >> /etc/wireguard/wg0.conf
    echo "ListenPort = 51820"                                                                                        >> /etc/wireguard/wg0.conf
    echo "PostUp =   /root/scripts/ReglasIPTablesWireGuard-PostUp.sh"                                                >> /etc/wireguard/wg0.conf
    echo "PostDown = /root/scripts/ReglasIPTablesWireGuard-PostDown.sh"                                              >> /etc/wireguard/wg0.conf
    echo "SaveConfig = true    # Para que se guarden los nuevos clientes en este archivo desde la línea de comandos" >> /etc/wireguard/wg0.conf

  # Crear los scripts con las reglas de IPTables
    # Reglas PostUp
      echo "iptables -A FORWARD -i wg0 -j ACCEPT"                                 > /root/scripts/ReglasIPTablesWireGuard-PostUp.sh
      echo "iptables -t nat -A POSTROUTING -o $vInterfazEthernet -j MASQUERADE"  >> /root/scripts/ReglasIPTablesWireGuard-PostUp.sh
      echo "ip6tables -A FORWARD -i wg0 -j ACCEPT"                               >> /root/scripts/ReglasIPTablesWireGuard-PostUp.sh
      echo "ip6tables -t nat -A POSTROUTING -o $vInterfazEthernet -j MASQUERADE" >> /root/scripts/ReglasIPTablesWireGuard-PostUp.sh
      echo "ip route del default"                                                >> /root/scripts/ReglasIPTablesWireGuard-PostUp.sh
      echo "ip route add default via $vDirIPDefaultGateway"                      >> /root/scripts/ReglasIPTablesWireGuard-PostUp.sh
      chmod +x /root/scripts/ReglasIPTablesWireGuard-PostUp.sh
    # Reglas PostDown
      echo "iptables -D FORWARD -i wg0 -j ACCEPT"                                 > /root/scripts/ReglasIPTablesWireGuard-PostDown.sh
      echo "iptables -t nat -D POSTROUTING -o $vInterfazEthernet -j MASQUERADE"  >> /root/scripts/ReglasIPTablesWireGuard-PostDown.sh
      echo "ip6tables -D FORWARD -i wg0 -j ACCEPT"                               >> /root/scripts/ReglasIPTablesWireGuard-PostDown.sh
      echo "ip6tables -t nat -D POSTROUTING -o $vInterfazEthernet -j MASQUERADE" >> /root/scripts/ReglasIPTablesWireGuard-PostDown.sh
      echo "ip route del default"                                                >> /root/scripts/ReglasIPTablesWireGuard-PostDown.sh
      echo "ip route add default via $vDirIPDefaultGateway"                      >> /root/scripts/ReglasIPTablesWireGuard-PostDown.sh
      chmod +x /root/scripts/ReglasIPTablesWireGuard-PostDown.sh

  # Crear las claves pública y privada del servidor
    mkdir /root/WireGuard/
    wg genkey >                                                  /root/WireGuard/WireGuardServerPrivate.key
    cat /root/WireGuard/WireGuardServerPrivate.key | wg pubkey > /root/WireGuard/WireGuardServerPublic.key
    chmod 600 /root/WireGuard/WireGuardServerPrivate.key

  # Agregar la clave privada al archivo de configuración
    vServerPrivKey=$(cat /root/WireGuard/WireGuardServerPrivate.key)
    sed -i -e "s|PrivateKey =|PrivateKey = $vServerPrivKey|g" /etc/wireguard/wg0.conf

  # Agregar las reglas para tener salida a Internet desde el servidor
    # Comprobar si el paquete iptables está instalado. Si no lo está, instalarlo.
      #if [[ $(dpkg-query -s iptables 2>/dev/null | grep installed) == "" ]]; then
      #  echo ""
      #  echo -e "${vColorRojo}    iptables no está instalado. Iniciando su instalación...${vFinColor}"
      #  echo ""
      #  apt-get -y update && apt-get -y install iptables
      #  echo ""
      #fi
    #iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    #iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    #iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT
    #iptables -A INPUT -s $vDirIPintWG/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
    #iptables -A INPUT -s $vDirIPintWG/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT

  # Agregar las reglas a los ComandosPostArranque
    #touch /root/scripts/ReglasIPTablesWireGuard.sh
    #echo "iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                              > /root/scripts/ReglasIPTablesWireGuard.sh
    #echo "iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                           >> /root/scripts/ReglasIPTablesWireGuard.sh
    #echo "iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT"                 >> /root/scripts/ReglasIPTablesWireGuard.sh
    #echo "iptables -A INPUT -s $vDirIPintWG/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
    #echo "iptables -A INPUT -s $vDirIPintWG/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
    #chmod +x /root/scripts/ReglasIPTablesWireGuard.sh
    #touch /root/scripts/ComandosPostArranque.sh
    #echo "/root/scripts/ReglasIPTablesWireGuard.sh" >> /root/scripts/ComandosPostArranque.sh
    #chmod +x /root/scripts/ComandosPostArranque.sh

  # Habilitar el forwarding
    sysctl -w net.ipv4.ip_forward=1
    #sysctl -w net.ipv6.conf.all.forwarding=1

  # Hacer permanente el forwarding
    sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
    #sed -i -e 's|#net.ipv6.conf.all.forwarding=1|net.ipv6.conf.all.forwarding=1|g' /etc/sysctl.conf

  # Levantar la conexión
    echo ""
    echo "    Levantando la interfaz..."
    echo ""
    wg-quick up wg0
    echo ""

  # Activar el servicio
    echo ""
    echo "    Activando el servicio..."
    echo ""
    systemctl enable wg-quick@wg0.service
    echo ""

  # Mostrar info sobre como crear el primer cliente
    echo ""
    echo -e "${vColorVerde}    Instalación finalizada.${vFinColor}"
    echo -e "${vColorVerde}    Para crear el primer cliente ejecuta:${vFinColor}"
    echo ""
    echo -e "${vColorVerde}      /root/scripts/d-scripts/VPN-WireGuard-Clientes-Nuevo.sh${vFinColor}"
    echo "  "
    echo -e "${vColorVerde}    o${vFinColor}"
    echo ""
    echo -e "${vColorVerde}      curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/VPN-WireGuard-Clientes-Nuevo.sh | bash${vFinColor}"
    echo "  "
    echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de WireGuard para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  # Borrar WireGuard si ya está instalado
    echo ""
    echo "    Borrando posible instalación anterior..."
    echo ""
    # Ejecutar primero copia de seguridad de posible instalación anterior
    mkdir -p /root/WireGuard/CopSegInstAnt/ 2> /dev/null
    mv /root/WireGuard/* /root/WireGuard/CopSegInstAnt/
    apt-get -y purge wireguard
    apt-get -y purge
    apt-get -y autoremove

# Instalar el paquete WireGuard
    echo ""
    echo "    Instalando paquetes..."
    echo ""
    apt-get -y update > /dev/null
    apt-get -y autoremove > /dev/null
    apt-get -y install wireguard
    apt-get -y install qrencode

  # Crear el archivo de configuración#
    echo ""
    echo "    Creando el archivo de configuración de la interfaz..."
    echo ""
    echo "[Interface]"                                                                                                > /etc/wireguard/wg0.conf
    echo "Address = $vDirIPintWG/24"                                                                                 >> /etc/wireguard/wg0.conf
    echo "PrivateKey ="                                                                                              >> /etc/wireguard/wg0.conf
    echo "ListenPort = 51820"                                                                                        >> /etc/wireguard/wg0.conf
    echo "PostUp =    /root/scripts/ReglasNFTablesWireGuard-PostUp.sh"                                               >> /etc/wireguard/wg0.conf
    echo "PostDown =  /root/scripts/ReglasNFTablesWireGuard-PostDown.sh"                                             >> /etc/wireguard/wg0.conf
    echo "SaveConfig = true    # Para que se guarden los nuevos clientes en este archivo desde la línea de comandos" >> /etc/wireguard/wg0.conf

  # Crear los scripts con las reglas de NFTables
    # Reglas PostUp
      echo '#/bin/bash'                                                                                 > /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo ""                                                                                          >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo "# IPv4 e IPv6"                                                                             >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  #nft add table inet filter'                                                              >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  #nft add chain inet filter forward { type filter hook forward priority filter \; }'      >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  #nft add rule  inet filter forward iifname "wg0" counter accept'                         >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  #nft add table inet nat'                                                                 >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  #nft add chain inet nat postrouting { type nat hook postrouting priority srcnat \; }'    >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  #nft add rule  inet nat postrouting oifname "'"$vInterfazEthernet"'" counter masquerade' >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo "# IPv4"                                                                                    >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  nft add table ip filter'                                                                 >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  nft add chain ip filter forward { type filter hook forward priority filter \; }'         >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  nft add rule  ip filter forward iifname "wg0" counter accept'                            >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  nft add table ip nat'                                                                    >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  nft add chain ip nat postrouting { type nat hook postrouting priority srcnat \; }'       >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  nft add rule  ip nat postrouting oifname "'"$vInterfazEthernet"'" counter masquerade'    >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo "# IPv6"                                                                                    >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  nft add table ip6 filter'                                                                >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  nft add chain ip6 filter forward { type filter hook forward priority filter \; }'        >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  nft add rule  ip6 filter forward iifname "wg0" counter accept'                           >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  nft add table ip6 nat'                                                                   >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  nft add chain ip6 nat postrouting { type nat hook postrouting priority srcnat \; }'      >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo '  nft add rule  ip6 nat postrouting oifname "'"$vInterfazEthernet"'" counter masquerade'   >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo "# Rutas"                                                                                   >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo "  ip route del default"                                                                    >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      echo "  ip route add default via $vDirIPDefaultGateway"                                          >> /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
      chmod +x /root/scripts/ReglasNFTablesWireGuard-PostUp.sh
    # Reglas PostDown
      echo '#/bin/bash'                                                                                   > /root/scripts/ReglasNFTablesWireGuard-PostDown.sh
      echo ""                                                                                            >> /root/scripts/ReglasNFTablesWireGuard-PostDown.sh
      echo "# IPv4 e IPv6"                                                                               >> /root/scripts/ReglasNFTablesWireGuard-PostDown.sh
      echo '  #nft del rule inet filter forward     iifname "wg0" counter accept'                        >> /root/scripts/ReglasNFTablesWireGuard-PostDown.sh
      echo '  #nft del rule inet nat    postrouting oifname "'"$vInterfazEthernet"'" counter masquerade' >> /root/scripts/ReglasNFTablesWireGuard-PostDown.sh
      echo "# IPv4"                                                                                      >> /root/scripts/ReglasNFTablesWireGuard-PostDown.sh
      echo '  nft del rule ip   filter forward     iifname "wg0" counter accept'                         >> /root/scripts/ReglasNFTablesWireGuard-PostDown.sh
      echo '  nft del rule ip   nat    postrouting oifname "'"$vInterfazEthernet"'" counter masquerade'  >> /root/scripts/ReglasNFTablesWireGuard-PostDown.sh
      echo "# IPv6"                                                                                      >> /root/scripts/ReglasNFTablesWireGuard-PostDown.sh
      echo '  nft del rule ip6  filter forward     iifname "wg0" counter accept'                         >> /root/scripts/ReglasNFTablesWireGuard-PostDown.sh
      echo '  nft del rule ip6  nat    postrouting oifname "'"$vInterfazEthernet"'" counter masquerade'  >> /root/scripts/ReglasNFTablesWireGuard-PostDown.sh
      echo "# Rutas"                                                                                     >> /root/scripts/ReglasNFTablesWireGuard-PostDown.sh
      echo "  ip route del default"                                                                      >> /root/scripts/ReglasNFTablesWireGuard-PostDown.sh
      echo "  ip route add default via $vDirIPDefaultGateway"                                            >> /root/scripts/ReglasNFTablesWireGuard-PostDown.sh
      chmod +x /root/scripts/ReglasNFTablesWireGuard-PostDown.sh

  # Crear las claves pública y privada del servidor
    mkdir /root/WireGuard/
    wg genkey >                                                  /root/WireGuard/WireGuardServerPrivate.key
    cat /root/WireGuard/WireGuardServerPrivate.key | wg pubkey > /root/WireGuard/WireGuardServerPublic.key
    chmod 600 /root/WireGuard/WireGuardServerPrivate.key

  # Agregar la clave privada al archivo de configuración
    vServerPrivKey=$(cat /root/WireGuard/WireGuardServerPrivate.key)
    sed -i -e "s|PrivateKey =|PrivateKey = $vServerPrivKey|g" /etc/wireguard/wg0.conf

  # Agregar las reglas para tener salida a Internet desde el servidor
    #nft add rule ip filter INPUT ct state related,established counter accept
    #nft add rule ip filter FORWARD ct state related,established counter accept
    #nft add rule ip filter INPUT udp dport 51820 ct state new counter accept
    #nft add rule ip filter INPUT ip saddr $vDirIPintWG/24 tcp dport 53 ct state new counter accept
    #nft add rule ip filter INPUT ip saddr $vDirIPintWG/24 udp dport 53 ct state new counter accept

  # Agregar las reglas a los ComandosPostArranque
    #touch /root/scripts/ReglasNFTablesWireGuard.sh
    #echo "nft add rule ip filter INPUT ct state related,established counter accept"                        > /root/scripts/ReglasNFTablesWireGuard.sh
    #echo "nft add rule ip filter FORWARD ct state related,established counter accept"                     >> /root/scripts/ReglasNFTablesWireGuard.sh
    #echo "nft add rule ip filter INPUT udp dport 51820 ct state new counter accept"                       >> /root/scripts/ReglasNFTablesWireGuard.sh
    #echo "nft add rule ip filter INPUT ip saddr $vDirIPintWG/24 tcp dport 53 ct state new counter accept" >> /root/scripts/ReglasNFTablesWireGuard.sh
    #echo "nft add rule ip filter INPUT ip saddr $vDirIPintWG/24 udp dport 53 ct state new counter accept" >> /root/scripts/ReglasNFTablesWireGuard.sh
    #chmod +x /root/scripts/ReglasNFTablesWireGuard.sh
    #touch /root/scripts/ComandosPostArranque.sh
    #echo "/root/scripts/ReglasNFTablesWireGuard.sh" >> /root/scripts/ComandosPostArranque.sh
    #chmod +x /root/scripts/ComandosPostArranque.sh

  # Habilitar el forwarding
    sysctl -w net.ipv4.ip_forward=1
    #sysctl -w net.ipv6.conf.all.forwarding=1

  # Hacer permanente el forwarding
    sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
    #sed -i -e 's|#net.ipv6.conf.all.forwarding=1|net.ipv6.conf.all.forwarding=1|g' /etc/sysctl.conf

  # Levantar la conexión
    echo ""
    echo "    Levantando la interfaz..."
    echo ""
    wg-quick up wg0
    echo ""

  # Activar el servicio
    echo ""
    echo "    Activando el servicio..."
    echo ""
    systemctl enable wg-quick@wg0.service
    echo ""

  # Mostrar info sobre como crear el primer cliente
    echo ""
    echo -e "${vColorVerde}    Instalación finalizada.${vFinColor}"
    echo -e "${vColorVerde}    Para crear el primer cliente ejecuta:${vFinColor}"
    echo ""
    echo -e "${vColorVerde}      /root/scripts/d-scripts/VPN-WireGuard-Clientes-Nuevo.sh${vFinColor}"
    echo "  "
    echo -e "${vColorVerde}    o${vFinColor}"
    echo ""
    echo -e "${vColorVerde}      curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/VPN-WireGuard-Clientes-Nuevo.sh | bash${vFinColor}"
    echo "  "
    echo ""

fi

