#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar WireGuard en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-VPN-WireGuard-InstalarYConfigurar.sh | bash
# ----------

# Determinar la primera interfaz ethernet
vInterfazWAN=$(ip route | grep "default via" | sed 's-dev -\n-g' | tail -n 1 | cut -d ' ' -f1)
#vInterfazWAN="venet0"
vDirIPintWG="192.168.255.1"
vDirIPDefaultGateway=$(ip r | grep efault | cut -d' ' -f3)

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root....${cFinColor}"
    exit
  fi

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
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de WireGuard para Debian 7 (Wheezy)...${cFinColor}"
  echo "  "
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de WireGuard para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de WireGuard para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de WireGuard para Debian 10 (Buster)...${cFinColor}"
  echo ""

  # Borrar WireGuard si ya está instalado
    echo ""
    echo "    Borrando posible instalación anterior..."    echo ""
    # Ejecutar primero copia de seguridad de posible instalación anterior
    mkdir -p /root/WireGuard/CopSegInstAnt/ 2> /dev/null
    mv /root/WireGuard/* /root/WireGuard/CopSegInstAnt/
    apt-get -y purge wireguard
    apt-get -y purge
    apt-get -y autoremove

# Instalar el paquete WireGuard
    echo ""
    echo "    Instalando paquetes..."    echo ""
    apt-get -y update > /dev/null
    apt-get -y autoremove > /dev/null
    apt-get -y install wireguard
    apt-get -y install qrencode

  # Crear el archivo de configuración#
    echo ""
    echo "    Creando el archivo de configuración de la interfaz..."    echo ""
    echo "[Interface]"                                             > /etc/wireguard/wg0.conf
    echo "Address = $vDirIPintWG/24"                              >> /etc/wireguard/wg0.conf
    echo "PrivateKey ="                                           >> /etc/wireguard/wg0.conf
    echo "ListenPort = 51820"                                     >> /etc/wireguard/wg0.conf
    echo "PostUp =   /root/WireGuard/ReglasWireGuard-PostUp.sh"   >> /etc/wireguard/wg0.conf
    echo "PostDown = /root/WireGuard/ReglasWireGuard-PostDown.sh" >> /etc/wireguard/wg0.conf
    echo "SaveConfig = true"                                      >> /etc/wireguard/wg0.conf  # Para que se guarden los nuevos clientes en este archivo desde la línea de comandos

  # Crear los scripts con las reglas de IPTables
    # Comprobar si el paquete iptables está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s iptables 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}    iptables no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        apt-get -y update
        apt-get -y install iptables
        echo ""
      fi
    # Reglas PostUp
      echo "iptables -A FORWARD -i wg0 -j ACCEPT"                                                                 > /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "iptables -t nat -A POSTROUTING -o $vInterfazWAN -j MASQUERADE"                                       >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "#ip6tables -A FORWARD -i wg0 -j ACCEPT"                                                              >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "#ip6tables -t nat -A POSTROUTING -o $vInterfazWAN -j MASQUERADE"                                     >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "#iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                             >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "#iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                           >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "#iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT"                 >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "#iptables -A INPUT -s $vDirIPintWG/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "#iptables -A INPUT -s $vDirIPintWG/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "ip route del default"                                                                                >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "ip route add default via $vDirIPDefaultGateway"                                                      >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      chmod +x /root/WireGuard/ReglasWireGuard-PostUp.sh
    # Reglas PostDown
      echo "iptables -D FORWARD -i wg0 -j ACCEPT"                             > /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo "iptables -t nat -D POSTROUTING -o $vInterfazWAN -j MASQUERADE"   >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo "#ip6tables -D FORWARD -i wg0 -j ACCEPT"                          >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo "#ip6tables -t nat -D POSTROUTING -o $vInterfazWAN -j MASQUERADE" >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo "ip route del default"                                            >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo "ip route add default via $vDirIPDefaultGateway"                  >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      chmod +x /root/WireGuard/ReglasWireGuard-PostDown.sh

  # Crear las claves pública y privada del servidor
    mkdir /root/WireGuard/
    wg genkey >                                                  /root/WireGuard/WireGuardServerPrivate.key
    cat /root/WireGuard/WireGuardServerPrivate.key | wg pubkey > /root/WireGuard/WireGuardServerPublic.key
    chmod 600 /root/WireGuard/WireGuardServerPrivate.key

  # Agregar la clave privada al archivo de configuración
    vServerPrivKey=$(cat /root/WireGuard/WireGuardServerPrivate.key)
    sed -i -e "s|PrivateKey =|PrivateKey = $vServerPrivKey|g" /etc/wireguard/wg0.conf

  # Habilitar el forwarding
    sysctl -w net.ipv4.ip_forward=1
    #sysctl -w net.ipv6.conf.all.forwarding=1

  # Hacer permanente el forwarding
    sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
    #sed -i -e 's|#net.ipv6.conf.all.forwarding=1|net.ipv6.conf.all.forwarding=1|g' /etc/sysctl.conf

  # Levantar la conexión
    echo ""
    echo "    Levantando la interfaz..."    echo ""
    wg-quick up wg0
    echo ""

  # Activar el servicio
    echo ""
    echo "    Activando el servicio..."    echo ""
    systemctl enable wg-quick@wg0.service
    echo ""

  # Mostrar info sobre como crear el primer cliente
    echo ""
    echo -e "${cColorVerde}    Instalación finalizada.${cFinColor}"
    echo -e "${cColorVerde}    Para crear el primer cliente ejecuta:${cFinColor}"
    echo ""
    echo -e "${cColorVerde}      /root/scripts/d-scripts/VPN-WireGuard-Clientes-Nuevo.sh${cFinColor}"
    echo "  "
    echo -e "${cColorVerde}    o${cFinColor}"
    echo ""
    echo -e "${cColorVerde}      curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/VPN-WireGuard-Clientes-Nuevo.sh | bash${cFinColor}"
    echo "  "
    echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de WireGuard para Debian 11 (Bullseye)...${cFinColor}"
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
    echo "[Interface]"                                             > /etc/wireguard/wg0.conf
    echo "Address = $vDirIPintWG/24"                              >> /etc/wireguard/wg0.conf
    echo "PrivateKey ="                                           >> /etc/wireguard/wg0.conf
    echo "ListenPort = 51820"                                     >> /etc/wireguard/wg0.conf
    echo "PostUp =   /root/WireGuard/ReglasWireGuard-PostUp.sh"   >> /etc/wireguard/wg0.conf
    echo "PostDown = /root/WireGuard/ReglasWireGuard-PostDown.sh" >> /etc/wireguard/wg0.conf
    echo "SaveConfig = true"                                      >> /etc/wireguard/wg0.conf # Para que se guarden los nuevos clientes en este archivo desde la línea de comandos

  # Crear los scripts con las reglas de NFTables
    # Reglas PostUp
      echo '#/bin/bash'                                                                                                           > /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo ""                                                                                                                    >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "# IPv4 e IPv6"                                                                                                       >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add table inet filter'                                                                                        >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add chain inet filter forward { type filter hook forward priority filter \; }'                                >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add rule  inet filter forward iifname "wg0" counter accept'                                                   >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add table inet nat'                                                                                           >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add chain inet nat postrouting { type nat hook postrouting priority srcnat \; }'                              >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add rule  inet nat postrouting oifname "'"$vInterfazWAN"'" ip saddr "'"$vDirIPintWG"'"/24 counter masquerade' >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "# IPv4"                                                                                                              >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  nft add table ip filter'                                                                                           >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  nft add chain ip filter forward { type filter hook forward priority filter \; }'                                   >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  nft add rule  ip filter forward iifname "wg0" counter accept'                                                      >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  nft add table ip nat'                                                                                              >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  nft add chain ip nat postrouting { type nat hook postrouting priority srcnat \; }'                                 >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add rule  ip nat postrouting oifname "'"$vInterfazWAN"'" ip saddr "'"$vDirIPintWG"'"/24 counter masquerade'   >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  nft add rule  ip nat postrouting oifname "'"$vInterfazWAN"'" iifname "wg0" counter masquerade'                     >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "# IPv6"                                                                                                              >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add table ip6 filter'                                                                                         >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add chain ip6 filter forward { type filter hook forward priority filter \; }'                                 >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add rule  ip6 filter forward iifname "wg0" counter accept'                                                    >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add table ip6 nat'                                                                                            >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add chain ip6 nat postrouting { type nat hook postrouting priority srcnat \; }'                               >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add rule  ip6 nat postrouting oifname "'"$vInterfazWAN"'" ip saddr "'"$vDirIPintWG"'"/24 counter masquerade'  >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add rule  ip6 nat postrouting oifname "'"$vInterfazWAN"'" iifname "wg0" counter masquerade'                   >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "# Otras"                                                                                                             >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "  #nft add rule ip filter INPUT ct state related,established counter accept"                                         >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "  #nft add rule ip filter FORWARD ct state related,established counter accept"                                       >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "  #nft add rule ip filter INPUT udp dport 51820 ct state new counter accept"                                         >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "  #nft add rule ip filter INPUT ip saddr $vDirIPintWG/24 tcp dport 53 ct state new counter accept"                   >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "  #nft add rule ip filter INPUT ip saddr $vDirIPintWG/24 udp dport 53 ct state new counter accept"                   >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "# Rutas"                                                                                                             >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "  ip route del default"                                                                                              >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "  ip route add default via $vDirIPDefaultGateway"                                                                    >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      chmod +x /root/WireGuard/ReglasWireGuard-PostUp.sh
    # Reglas PostDown
      echo '#/bin/bash'                                                                         > /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo ""                                                                                  >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo "# IPv4 e IPv6"                                                                     >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  #vReglaForwardIP4y6=$(nft -a list table inet filter | grep wg0 | cut -d"#" -f2)' >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  #nft delete rule inet filter forward $vReglaForwardIP4y6'                        >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  #vReglaNATip4y6=$(nft -a list table inet nat | grep wg0 | cut -d"#" -f2)'        >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  #nft delete rule inet nat postrouting $vReglaNATip4y6'                           >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo "# IPv4"                                                                            >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  vReglaForwardIP4=$(nft -a list table ip filter | grep wg0 | cut -d"#" -f2)'      >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  nft delete rule ip filter forward $vReglaForwardIP4'                             >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  vReglaNATip4=$(nft -a list table ip nat | grep wg0 | cut -d"#" -f2)'             >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  nft delete rule ip nat postrouting $vReglaNATip4'                                >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo "# IPv6"                                                                            >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  #vReglaForwardIP6=$(nft -a list table ip6 filter | grep wg0 | cut -d"#" -f2)'    >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  #nft delete rule ip6 filter forward $vReglaForwardIP6'                           >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  #vReglaNATip6=$(nft -a list table ip6 nat | grep wg0 | cut -d"#" -f2)'           >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  #nft delete rule ip6 nat postrouting $vReglaNATip6'                              >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo "# Rutas"                                                                           >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo "  ip route del default"                                                            >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo "  ip route add default via $vDirIPDefaultGateway"                                  >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      chmod +x /root/WireGuard/ReglasWireGuard-PostDown.sh

  # Crear las claves pública y privada del servidor
    mkdir /root/WireGuard/
    wg genkey >                                                  /root/WireGuard/WireGuardServerPrivate.key
    cat /root/WireGuard/WireGuardServerPrivate.key | wg pubkey > /root/WireGuard/WireGuardServerPublic.key
    chmod 600 /root/WireGuard/WireGuardServerPrivate.key

  # Agregar la clave privada al archivo de configuración
    vServerPrivKey=$(cat /root/WireGuard/WireGuardServerPrivate.key)
    sed -i -e "s|PrivateKey =|PrivateKey = $vServerPrivKey|g" /etc/wireguard/wg0.conf

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
    echo -e "${cColorVerde}    Instalación finalizada.${cFinColor}"
    echo -e "${cColorVerde}    Para crear el primer cliente ejecuta:${cFinColor}"
    echo ""
    echo -e "${cColorVerde}      /root/scripts/d-scripts/VPN-WireGuard-Clientes-Nuevo.sh${cFinColor}"
    echo "  "
    echo -e "${cColorVerde}    o${cFinColor}"
    echo ""
    echo -e "${cColorVerde}      curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/VPN-WireGuard-Clientes-Nuevo.sh | bash${cFinColor}"
    echo "  "
    echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de WireGuard para Debian 12 (Bookworm)...${cFinColor}"
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
    echo "[Interface]"                                             > /etc/wireguard/wg0.conf
    echo "Address = $vDirIPintWG/24"                              >> /etc/wireguard/wg0.conf
    echo "PrivateKey ="                                           >> /etc/wireguard/wg0.conf
    echo "ListenPort = 51820"                                     >> /etc/wireguard/wg0.conf
    echo "PostUp =   /root/WireGuard/ReglasWireGuard-PostUp.sh"   >> /etc/wireguard/wg0.conf
    echo "PostDown = /root/WireGuard/ReglasWireGuard-PostDown.sh" >> /etc/wireguard/wg0.conf
    echo "SaveConfig = true"                                      >> /etc/wireguard/wg0.conf # Para que se guarden los nuevos clientes en este archivo desde la línea de comandos

  # Crear los scripts con las reglas de NFTables
    # Reglas PostUp
      echo '#/bin/bash'                                                                                                           > /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo ""                                                                                                                    >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "# IPv4 e IPv6"                                                                                                       >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add table inet filter'                                                                                        >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add chain inet filter forward { type filter hook forward priority filter \; }'                                >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add rule  inet filter forward iifname "wg0" counter accept'                                                   >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add table inet nat'                                                                                           >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add chain inet nat postrouting { type nat hook postrouting priority srcnat \; }'                              >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add rule  inet nat postrouting oifname "'"$vInterfazWAN"'" ip saddr "'"$vDirIPintWG"'"/24 counter masquerade' >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "# IPv4"                                                                                                              >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  nft add table ip filter'                                                                                           >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  nft add chain ip filter forward { type filter hook forward priority filter \; }'                                   >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  nft add rule  ip filter forward iifname "wg0" counter accept'                                                      >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  nft add table ip nat'                                                                                              >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  nft add chain ip nat postrouting { type nat hook postrouting priority srcnat \; }'                                 >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add rule  ip nat postrouting oifname "'"$vInterfazWAN"'" ip saddr "'"$vDirIPintWG"'"/24 counter masquerade'   >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  nft add rule  ip nat postrouting oifname "'"$vInterfazWAN"'" iifname "wg0" counter masquerade'                     >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "# IPv6"                                                                                                              >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add table ip6 filter'                                                                                         >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add chain ip6 filter forward { type filter hook forward priority filter \; }'                                 >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add rule  ip6 filter forward iifname "wg0" counter accept'                                                    >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add table ip6 nat'                                                                                            >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add chain ip6 nat postrouting { type nat hook postrouting priority srcnat \; }'                               >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add rule  ip6 nat postrouting oifname "'"$vInterfazWAN"'" ip saddr "'"$vDirIPintWG"'"/24 counter masquerade'  >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo '  #nft add rule  ip6 nat postrouting oifname "'"$vInterfazWAN"'" iifname "wg0" counter masquerade'                   >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "# Otras"                                                                                                             >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "  #nft add rule ip filter INPUT ct state related,established counter accept"                                         >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "  #nft add rule ip filter FORWARD ct state related,established counter accept"                                       >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "  #nft add rule ip filter INPUT udp dport 51820 ct state new counter accept"                                         >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "  #nft add rule ip filter INPUT ip saddr $vDirIPintWG/24 tcp dport 53 ct state new counter accept"                   >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "  #nft add rule ip filter INPUT ip saddr $vDirIPintWG/24 udp dport 53 ct state new counter accept"                   >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "# Rutas"                                                                                                             >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "  ip route del default"                                                                                              >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      echo "  ip route add default via $vDirIPDefaultGateway"                                                                    >> /root/WireGuard/ReglasWireGuard-PostUp.sh
      chmod +x /root/WireGuard/ReglasWireGuard-PostUp.sh
    # Reglas PostDown
      echo '#/bin/bash'                                                                         > /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo ""                                                                                  >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo "# IPv4 e IPv6"                                                                     >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  #vReglaForwardIP4y6=$(nft -a list table inet filter | grep wg0 | cut -d"#" -f2)' >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  #nft delete rule inet filter forward $vReglaForwardIP4y6'                        >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  #vReglaNATip4y6=$(nft -a list table inet nat | grep wg0 | cut -d"#" -f2)'        >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  #nft delete rule inet nat postrouting $vReglaNATip4y6'                           >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo "# IPv4"                                                                            >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  vReglaForwardIP4=$(nft -a list table ip filter | grep wg0 | cut -d"#" -f2)'      >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  nft delete rule ip filter forward $vReglaForwardIP4'                             >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  vReglaNATip4=$(nft -a list table ip nat | grep wg0 | cut -d"#" -f2)'             >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  nft delete rule ip nat postrouting $vReglaNATip4'                                >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo "# IPv6"                                                                            >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  #vReglaForwardIP6=$(nft -a list table ip6 filter | grep wg0 | cut -d"#" -f2)'    >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  #nft delete rule ip6 filter forward $vReglaForwardIP6'                           >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  #vReglaNATip6=$(nft -a list table ip6 nat | grep wg0 | cut -d"#" -f2)'           >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo '  #nft delete rule ip6 nat postrouting $vReglaNATip6'                              >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo "# Rutas"                                                                           >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo "  ip route del default"                                                            >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      echo "  ip route add default via $vDirIPDefaultGateway"                                  >> /root/WireGuard/ReglasWireGuard-PostDown.sh
      chmod +x /root/WireGuard/ReglasWireGuard-PostDown.sh

  # Crear las claves pública y privada del servidor
    mkdir /root/WireGuard/
    wg genkey >                                                  /root/WireGuard/WireGuardServerPrivate.key
    cat /root/WireGuard/WireGuardServerPrivate.key | wg pubkey > /root/WireGuard/WireGuardServerPublic.key
    chmod 600 /root/WireGuard/WireGuardServerPrivate.key

  # Agregar la clave privada al archivo de configuración
    vServerPrivKey=$(cat /root/WireGuard/WireGuardServerPrivate.key)
    sed -i -e "s|PrivateKey =|PrivateKey = $vServerPrivKey|g" /etc/wireguard/wg0.conf

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
    echo -e "${cColorVerde}    Instalación finalizada.${cFinColor}"
    echo -e "${cColorVerde}    Para crear el primer cliente ejecuta:${cFinColor}"
    echo ""
    echo -e "${cColorVerde}      /root/scripts/d-scripts/VPN-WireGuard-Clientes-Nuevo.sh${cFinColor}"
    echo "  "
    echo -e "${cColorVerde}    o${cFinColor}"
    echo ""
    echo -e "${cColorVerde}      curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/VPN-WireGuard-Clientes-Nuevo.sh | bash${cFinColor}"
    echo "  "
    echo ""

fi

