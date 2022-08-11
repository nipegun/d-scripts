#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar WireGuard en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-VPN-WireGuard-InstalarYConfigurar.sh | bash
# ----------

# Determinar la primera interfaz ethernet
vInterfazEthernet=$(ip route | grep "default via" | sed 's-dev -\n-g' | tail -n 1 | cut -d ' ' -f1)
#vInterfazEthernet="venet0"

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}Este script está preparado para ejecutarse como root y no lo has ejecutado como root....${vFinColor}" >&2
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
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de WireGuard para Debian 7 (Wheezy)...${vFinColor}"
  echo "  "
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de WireGuard para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  # Borrar WireGuard si ya está instalado
    echo ""
    echo "  Borrando la instalación anterior de WireGuard..."
    echo ""
    mv /etc/wireguard/wg0.conf /etc/wireguard/wg0.conf.bak 2> /dev/null
    mv /root/WireGuard/WireGuardServerPrivate.key /root/WireGuard/WireGuardServerPrivate.key.bak 2> /dev/null
    mv /root/WireGuard/WireGuardServerPublic.key  /root/WireGuard/WireGuardServerPublic.key.bak  2> /dev/null
    mv /root/WireGuard/WireGuardUser0Private.key  /root/WireGuard/WireGuardUser0Private.key.bak  2> /dev/null
    mv /root/WireGuard/WireGuardUser0Public.key   /root/WireGuard/WireGuardUser0Public.key.bak   2> /dev/null
    apt-get -y purge wireguard
    apt-get -y purge
    apt-get -y autoremove

  # Agregar el repositorio inestable
    echo ""
    echo "  Agregando el repositorio inestable..."
    echo ""
    echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable.list

  # Instalar el paquete WireGuard
    echo ""
    echo "  Instalando el paquete wireguard..."
    echo ""
    apt-get -y update
    apt-get -y install linux-headers-"$(uname -r)" 
    apt-get -y install wireguard
    apt-get -y install qrencode

  # Cargar elmódulo
    echo ""
    echo "  Cargando el módulo..."
    echo ""
    modprobe wireguard

  # Crear el archivo de configuración#
    echo ""
    echo "  Creando el archivo de configuración..."
    echo ""
    echo "[Interface]"                                                                                                                                                                                                                      > /etc/wireguard/wg0.conf
    echo "Address ="                                                                                                                                                                                                                       >> /etc/wireguard/wg0.conf
    echo "PrivateKey ="                                                                                                                                                                                                                    >> /etc/wireguard/wg0.conf
    echo "ListenPort = 51820"                                                                                                                                                                                                              >> /etc/wireguard/wg0.conf
    echo "PostUp =   iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o $vInterfazEthernet -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o $vInterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
    echo "PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o $vInterfazEthernet -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o $vInterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
    echo "SaveConfig = true # Para que se guarden los nuevos clientes en este archivo desde la línea de comandos"                                                                                                                          >> /etc/wireguard/wg0.conf
    
  # Agregar la dirección IP del servidor al archivo de configuración
    echo ""
    echo "  Agregando la ip del ordenador/servidor al archivo de configuración..."
    echo ""
    DirIP=$(ip a | grep $vInterfazEthernet | grep inet | cut -d '/' -f 1 | cut -d 't' -f 2 | cut -d ' ' -f 2)
    sed -i -e "s|Address =|Address = $vDirIP|g" /etc/wireguard/wg0.conf

  # Crear las claves pública y privada del servidor
    echo ""
    echo "  Creando las claves pública y privada del servidor..."
    echo ""
    mkdir /root/WireGuard/
    wg genkey >                                                  /root/WireGuard/WireGuardServerPrivate.key
    cat /root/WireGuard/WireGuardServerPrivate.key | wg pubkey > /root/WireGuard/WireGuardServerPublic.key

  # Agregar la clave privada al archivo de configuración
    echo ""
    echo "  Agregando la clave privada del servidor al archivo de configuración..."
    echo ""
    vServerPrivKey=$(cat /root/WireGuard/WireGuardServerPrivate.key)
    sed -i -e "s|PrivateKey =|PrivateKey = $vServerPrivKey|g" /etc/wireguard/wg0.conf

  # Agregar las reglas para tener salida a Internet desde el servidor
    echo ""
    echo "  Creando las reglas del cortafuegos para la sesión actual..."
    echo ""
    iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT
    iptables -A INPUT -s $vDirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
    iptables -A INPUT -s $vDirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT

  # Agregar las reglas a los ComandosPostArranque
    echo ""
    echo "  Agregando las reglas del cortaduegos a los ComandosPostArranque..."
    echo ""
    touch /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                         > /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                      >> /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT"            >> /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A INPUT -s $vDirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A INPUT -s $vDirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
    chmod +x /root/scripts/ReglasIPTablesWireGuard.sh
    touch /root/scripts/ComandosPostArranque.sh
    echo "/root/scripts/ReglasIPTablesWireGuard.sh" >> /root/scripts/ComandosPostArranque.sh
    chmod +x /root/scripts/ComandosPostArranque.sh

  # Habilitar el forwarding
    echo ""
    echo "  Activando el fordwarding para la sesión actual..."
    echo ""
    sysctl -w net.ipv4.ip_forward=1
    #sysctl -w net.ipv6.conf.all.forwarding=1

  # Hacer permanente el forwarding
    echo ""
    echo "  Haciendo permanente el forwarding para que quede activo post-reinicio..."
    echo ""
    sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
    #sed -i -e 's|#net.ipv6.conf.all.forwarding=1|net.ipv6.conf.all.forwarding=1|g' /etc/sysctl.conf

  # Levantar la conexión
    echo ""
    echo "  Levantando la interfaz..."
    echo ""
    wg-quick up wg0
    echo ""

  # Activar el servicio
    echo ""
    echo "  Activando el servicio..."
    echo ""
    systemctl enable wg-quick@wg0.service
    echo ""

  # Mostrar info sobre como crear el primer cliente
    echo ""
    echo -e "${vColorVerde}Instalación finalizada.${vFinColor}"
    echo -e "${vColorVerde}Para crear el primer cliente ejecuta:${vFinColor}"
    echo ""
    echo -e "${vColorVerde}  /root/scripts/d-scripts/VPN-WireGuard-Clientes-Nuevo.sh${vFinColor}"
    echo "  "
    echo -e "${vColorVerde}  o${vFinColor}"
    echo ""
    echo -e "${vColorVerde}  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/VPN-WireGuard-Clientes-Nuevo.sh | bash${vFinColor}"
    echo "  "
    echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de WireGuard para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  # Borrar WireGuard si ya está instalado
    mv /etc/wireguard/wg0.conf /etc/wireguard/wg0.conf.bak 2> /dev/null
    mv /root/WireGuard/WireGuardServerPrivate.key /root/WireGuard/WireGuardServerPrivate.key.bak 2> /dev/null
    mv /root/WireGuard/WireGuardServerPublic.key  /root/WireGuard/WireGuardServerPublic.key.bak  2> /dev/null
    mv /root/WireGuard/WireGuardUser0Private.key  /root/WireGuard/WireGuardUser0Private.key.bak  2> /dev/null
    mv /root/WireGuard/WireGuardUser0Public.key   /root/WireGuard/WireGuardUser0Public.key.bak   2> /dev/null
    apt-get -y purge wireguard
    apt-get -y purge
    apt-get -y autoremove

  # Instalar el paquete WireGuard
    apt-get -y update
    apt-get -y install wireguard
    apt-get -y install qrencode

  # Cargar elmódulo
    modprobe wireguard

  # Crear el archivo de configuración#
    echo "[Interface]"                                                                                                                                                                                                                    > /etc/wireguard/wg0.conf
    echo "Address ="                                                                                                                                                                                                                     >> /etc/wireguard/wg0.conf
    echo "PrivateKey ="                                                                                                                                                                                                                  >> /etc/wireguard/wg0.conf
    echo "ListenPort = 51820"                                                                                                                                                                                                            >> /etc/wireguard/wg0.conf
    echo "PostUp =   iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o $vInterfazEthernet -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o $vInterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
    echo "PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o $vInterfazEthernet -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o $vInterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
    echo "SaveConfig = true # Para que se guarden los nuevos clientes en este archivo desde la línea de comandos"                                                                                                                        >> /etc/wireguard/wg0.conf

  # Agregar la dirección IP del servidor al archivo de configuración
    DirIP=$(ip a | grep $vInterfazEthernet | grep inet | cut -d '/' -f 1 | cut -d 't' -f 2 | cut -d ' ' -f 2)
    sed -i -e "s|Address =|Address = $vDirIP|g" /etc/wireguard/wg0.conf

  # Crear las claves pública y privada del servidor
    mkdir /root/WireGuard/
    wg genkey >                                                  /root/WireGuard/WireGuardServerPrivate.key
    cat /root/WireGuard/WireGuardServerPrivate.key | wg pubkey > /root/WireGuard/WireGuardServerPublic.key

  # Agregar la clave privada al archivo de configuración
    vServerPrivKey=$(cat /root/WireGuard/WireGuardServerPrivate.key)
    sed -i -e "s|PrivateKey =|PrivateKey = $vServerPrivKey|g" /etc/wireguard/wg0.conf

  # Agregar las reglas para tener salida a Internet desde el servidor
    iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT
    iptables -A INPUT -s $vDirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
    iptables -A INPUT -s $vDirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT

  # Agregar las reglas a los ComandosPostArranque
    touch /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                        > /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                     >> /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT"           >> /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A INPUT -s $vDirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A INPUT -s $vDirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
    chmod +x /root/scripts/ReglasIPTablesWireGuard.sh
    touch /root/scripts/ComandosPostArranque.sh
    echo "/root/scripts/ReglasIPTablesWireGuard.sh" >> /root/scripts/ComandosPostArranque.sh
    chmod +x /root/scripts/ComandosPostArranque.sh

  # Habilitar el forwarding
    sysctl -w net.ipv4.ip_forward=1
    #sysctl -w net.ipv6.conf.all.forwarding=1

  # Hacer permanente el forwarding
    sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
    #sed -i -e 's|#net.ipv6.conf.all.forwarding=1|net.ipv6.conf.all.forwarding=1|g' /etc/sysctl.conf

  # Levantar la conexión
    echo ""
    echo "  Levantando la interfaz..."
    echo ""
    wg-quick up wg0
    echo ""

  # Activar el servicio
    echo ""
    echo "  Activando el servicio..."
    echo ""
    systemctl enable wg-quick@wg0.service
    echo ""

  # Mostrar info sobre como crear el primer cliente
    echo ""
    echo -e "${vColorVerde}Instalación finalizada.${vFinColor}"
    echo -e "${vColorVerde}Para crear el primer cliente ejecuta:${vFinColor}"
    echo ""
    echo -e "${vColorVerde}  /root/scripts/d-scripts/VPN-WireGuard-Clientes-Nuevo.sh${vFinColor}"
    echo "  "
    echo -e "${vColorVerde}  o${vFinColor}"
    echo ""
    echo -e "${vColorVerde}  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/VPN-WireGuard-Clientes-Nuevo.sh | bash${vFinColor}"
    echo "  "
    echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de WireGuard para Debian 10 (Buster)...${vFinColor}"
  echo ""

  # Borrar WireGuard si ya está instalado
    mv /etc/wireguard/wg0.conf /etc/wireguard/wg0.conf.bak 2> /dev/null
    mv /root/WireGuard/WireGuardServerPrivate.key /root/WireGuard/WireGuardServerPrivate.key.bak 2> /dev/null
    mv /root/WireGuard/WireGuardServerPublic.key  /root/WireGuard/WireGuardServerPublic.key.bak  2> /dev/null
    mv /root/WireGuard/WireGuardUser0Private.key  /root/WireGuard/WireGuardUser0Private.key.bak  2> /dev/null
    mv /root/WireGuard/WireGuardUser0Public.key   /root/WireGuard/WireGuardUser0Public.key.bak   2> /dev/null
    apt-get -y purge wireguard
    apt-get -y purge
    apt-get -y autoremove

  # Agregar el repositorio back-ports
    echo "deb http://deb.debian.org/debian buster-backports main" > /etc/apt/sources.list.d/backports.lis

  # Instalar el paquete WireGuard desde el repositorio back-ports
    apt-get -y update > /dev/null
    apt-get -y autoremove > /dev/null
    apt-get -y -t buster-backports install wireguard
    apt-get -y install qrencode

  # Crear el archivo de configuración#
    echo "[Interface]"                                                                                                                                                                                                                    > /etc/wireguard/wg0.conf
    echo "Address ="                                                                                                                                                                                                                     >> /etc/wireguard/wg0.conf
    echo "PrivateKey ="                                                                                                                                                                                                                  >> /etc/wireguard/wg0.conf
    echo "ListenPort = 51820"                                                                                                                                                                                                            >> /etc/wireguard/wg0.conf
    echo "PostUp =   iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o $vInterfazEthernet -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o $vInterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
    echo "PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o $vInterfazEthernet -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o $vInterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
    echo "SaveConfig = true    # Para que se guarden los nuevos clientes en este archivo desde la línea de comandos"                                                                                                                     >> /etc/wireguard/wg0.conf

  # Agregar la dirección IP del servidor al archivo de configuración
    DirIP=$(ip a | grep $vInterfazEthernet | grep inet | cut -d '/' -f 1 | cut -d 't' -f 2 | cut -d ' ' -f 2)
    sed -i -e "s|Address =|Address = $vDirIP|g" /etc/wireguard/wg0.conf

  # Crear las claves pública y privada del servidor
    mkdir /root/WireGuard/
    wg genkey >                                                  /root/WireGuard/WireGuardServerPrivate.key
    cat /root/WireGuard/WireGuardServerPrivate.key | wg pubkey > /root/WireGuard/WireGuardServerPublic.key
    chmod 600 /root/WireGuard/WireGuardServerPrivate.key

  # Agregar la clave privada al archivo de configuración
    vServerPrivKey=$(cat /root/WireGuard/WireGuardServerPrivate.key)
    sed -i -e "s|PrivateKey =|PrivateKey = $vServerPrivKey|g" /etc/wireguard/wg0.conf

  # Agregar las reglas para tener salida a Internet desde el servidor
    iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT
    iptables -A INPUT -s $vDirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
    iptables -A INPUT -s $vDirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT

  # Agregar las reglas a los ComandosPostArranque
    touch /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                         > /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                      >> /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT"            >> /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A INPUT -s $vDirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A INPUT -s $vDirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
    chmod +x /root/scripts/ReglasIPTablesWireGuard.sh
    touch /root/scripts/ComandosPostArranque.sh
    echo "/root/scripts/ReglasIPTablesWireGuard.sh" >> /root/scripts/ComandosPostArranque.sh
    chmod +x /root/scripts/ComandosPostArranque.sh

  # Habilitar el forwarding
    sysctl -w net.ipv4.ip_forward=1
    #sysctl -w net.ipv6.conf.all.forwarding=1

  # Hacer permanente el forwarding
    sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
    #sed -i -e 's|#net.ipv6.conf.all.forwarding=1|net.ipv6.conf.all.forwarding=1|g' /etc/sysctl.conf

  # Levantar la conexión
    echo ""
    echo "  Levantando la interfaz..."
    echo ""
    wg-quick up wg0
    echo ""

  # Activar el servicio
    echo ""
    echo "  Activando el servicio..."
    echo ""
    systemctl enable wg-quick@wg0.service
    echo ""

  # Mostrar info sobre como crear el primer cliente
    echo ""
    echo -e "${vColorVerde}Instalación finalizada.${vFinColor}"
    echo -e "${vColorVerde}Para crear el primer cliente ejecuta:${vFinColor}"
    echo ""
    echo -e "${vColorVerde}  /root/scripts/d-scripts/VPN-WireGuard-Clientes-Nuevo.sh${vFinColor}"
    echo "  "
    echo -e "${vColorVerde}  o${vFinColor}"
    echo ""
    echo -e "${vColorVerde}  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/VPN-WireGuard-Clientes-Nuevo.sh | bash${vFinColor}"
    echo "  "
    echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de WireGuard para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  # Borrar WireGuard si ya está instalado
    mv /etc/wireguard/wg0.conf /etc/wireguard/wg0.conf.bak 2> /dev/null
    mv /root/WireGuard/WireGuardServerPrivate.key /root/WireGuard/WireGuardServerPrivate.key.bak 2> /dev/null
    mv /root/WireGuard/WireGuardServerPublic.key  /root/WireGuard/WireGuardServerPublic.key.bak  2> /dev/null
    mv /root/WireGuard/WireGuardUser0Private.key  /root/WireGuard/WireGuardUser0Private.key.bak  2> /dev/null
    mv /root/WireGuard/WireGuardUser0Public.key   /root/WireGuard/WireGuardUser0Public.key.bak   2> /dev/null
    apt-get -y purge wireguard
    apt-get -y purge
    apt-get -y autoremove

# Instalar el paquete WireGuard
    apt-get -y update > /dev/null
    apt-get -y autoremove > /dev/null
    apt-get -y install wireguard
    apt-get -y install qrencode

  # Crear el archivo de configuración#
    echo "[Interface]"                                                                                                                                                                                                                    > /etc/wireguard/wg0.conf
    echo "Address ="                                                                                                                                                                                                                     >> /etc/wireguard/wg0.conf
    echo "PrivateKey ="                                                                                                                                                                                                                  >> /etc/wireguard/wg0.conf
    echo "ListenPort = 51820"                                                                                                                                                                                                            >> /etc/wireguard/wg0.conf
    echo "PostUp =   iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o $vInterfazEthernet -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o $vInterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
    echo "PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o $vInterfazEthernet -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o $vInterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
    echo "SaveConfig = true    # Para que se guarden los nuevos clientes en este archivo desde la línea de comandos"                                                                                                                     >> /etc/wireguard/wg0.conf

  # Agregar la dirección IP del servidor al archivo de configuración
    vDirIP=$(ip a | grep $vInterfazEthernet | grep inet | cut -d '/' -f 1 | cut -d 't' -f 2 | cut -d ' ' -f 2)
    sed -i -e "s|Address =|Address = $vDirIP|g" /etc/wireguard/wg0.conf

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
      if [[ $(dpkg-query -s iptables 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${vColorRojo}  iptables no está instalado. Iniciando su instalación...${vFinColor}"
        echo ""
        apt-get -y update && apt-get -y install iptables
        echo ""
      fi
    iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT
    iptables -A INPUT -s $vDirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
    iptables -A INPUT -s $vDirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT

  # Agregar las reglas a los ComandosPostArranque
    touch /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                        > /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                     >> /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT"           >> /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A INPUT -s $vDirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
    echo "iptables -A INPUT -s $vDirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
    chmod +x /root/scripts/ReglasIPTablesWireGuard.sh
    touch /root/scripts/ComandosPostArranque.sh
    echo "/root/scripts/ReglasIPTablesWireGuard.sh" >> /root/scripts/ComandosPostArranque.sh
    chmod +x /root/scripts/ComandosPostArranque.sh

  # Habilitar el forwarding
    sysctl -w net.ipv4.ip_forward=1
    #sysctl -w net.ipv6.conf.all.forwarding=1

  # Hacer permanente el forwarding
    sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
    #sed -i -e 's|#net.ipv6.conf.all.forwarding=1|net.ipv6.conf.all.forwarding=1|g' /etc/sysctl.conf

  # Levantar la conexión
    echo ""
    echo "  Levantando la interfaz..."
    echo ""
    wg-quick up wg0
    echo ""

  # Activar el servicio
    echo ""
    echo "  Activando el servicio..."
    echo ""
    systemctl enable wg-quick@wg0.service
    echo ""

  # Mostrar info sobre como crear el primer cliente
    echo ""
    echo -e "${vColorVerde}Instalación finalizada.${vFinColor}"
    echo -e "${vColorVerde}Para crear el primer cliente ejecuta:${vFinColor}"
    echo ""
    echo -e "${vColorVerde}  /root/scripts/d-scripts/VPN-WireGuard-Clientes-Nuevo.sh${vFinColor}"
    echo "  "
    echo -e "${vColorVerde}  o${vFinColor}"
    echo ""
    echo -e "${vColorVerde}  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/VPN-WireGuard-Clientes-Nuevo.sh | bash${vFinColor}"
    echo "  "
    echo ""

fi

