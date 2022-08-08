#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar WireGuard en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-VPN-WireGuard-Cliente-InstalarYConfigurar.sh | bash
#----------------------------------------------------------------------------------------------------------------------------------------------------

InterfazEthernet="eth0"
#InterfazEthernet="venet0"

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
  echo "  Iniciando el script de instalación de WireGuard para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de WireGuard para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  ## Agregar el repositorio inestable
     echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable.list

  ## Instalar el paquete WireGuard
     apt-get -y update
     apt-get -y install wireguard

  ## Cargar elmódulo
     modprobe wireguard

  ## Crear el archivo de configuración#
     echo "[Interface]" > /etc/wireguard/wg0.conf
     echo "Address =" >> /etc/wireguard/wg0.conf
     echo "PrivateKey =" >> /etc/wireguard/wg0.conf
     echo "ListenPort = 51820" >> /etc/wireguard/wg0.conf
     echo "PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $InterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
     echo "PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $InterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
     echo "SaveConfig = true    # Para que se guarden los nuevos clientes en este archivo desde la línea de comandos" >> /etc/wireguard/wg0.conf

  ## Agregar la dirección IP del servidor al archivo de configuración
     DirIP=$(ip a | grep $InterfazEthernet | grep inet | cut -d '/' -f 1 | cut -d 't' -f 2 | cut -d ' ' -f 2)
     sed -i -e 's|Address =|Address = '$DirIP'|g' /etc/wireguard/wg0.conf

  ## Crear las claves pública y privada del servidor
     mkdir /root/WireGuard/
     wg genkey >                                                  /root/WireGuard/WireGuardServerPrivate.key
     cat /root/WireGuard/WireGuardServerPrivate.key | wg pubkey > /root/WireGuard/WireGuardServerPublic.key

  ## Agregar la clave privada al archivo de configuración
     VarServerPrivKey=$(cat /root/WireGuard/WireGuardServerPrivate.key)
     sed -i -e 's|PrivateKey =|PrivateKey = '$VarServerPrivKey'|g' /etc/wireguard/wg0.conf

  ## Crear las claves para el primer usuario
     wg genkey >                                                 /root/WireGuard/WireGuardUser0Private.key
     cat /root/WireGuard/WireGuardUser0Private.key | wg pubkey > /root/WireGuard/WireGuardUser0Public.key

  ## Agregar el primer usuario al archivo de configuración
     echo ""  >> /etc/wireguard/wg0.conf
     echo "[Peer]" >> /etc/wireguard/wg0.conf
     echo "User0PublicKey =" >> /etc/wireguard/wg0.conf
     echo "AllowedIPs = 0.0.0.0/0" >> /etc/wireguard/wg0.conf

  ## Agregar la clave pública del primer usuario al archivo de configuración
     VarUser0PubKey=$(cat /root/WireGuard/WireGuardUser0Public.key)
     sed -i -e 's|User0PublicKey =|PublicKey = '$VarUser0PubKey'|g' /etc/wireguard/wg0.conf

  ## Agregar las reglas para tener salida a Internet desde el servidor
     iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
     iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
     iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT
     iptables -A INPUT -s $DirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
     iptables -A INPUT -s $DirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT

  ## Agregar las reglas a los ComandosPostArranque
     touch /root/scripts/ReglasIPTablesWireGuard.sh
     echo "iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                        > /root/scripts/ReglasIPTablesWireGuard.sh
     echo "iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                     >> /root/scripts/ReglasIPTablesWireGuard.sh
     echo "iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT"           >> /root/scripts/ReglasIPTablesWireGuard.sh
     echo "iptables -A INPUT -s $DirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
     echo "iptables -A INPUT -s $DirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
     chmod +x /root/scripts/ReglasIPTablesWireGuard.sh
     touch /root/scripts/ComandosPostArranque.sh
     echo "/root/scripts/ReglasIPTablesWireGuard.sh" >> /root/scripts/ComandosPostArranque.sh
     chmod +x /root/scripts/ComandosPostArranque.sh

  ## Habilitar el forwarding
     sysctl -w net.ipv4.ip_forward=1
     #sysctl -w net.ipv6.conf.all.forwarding=1

  ## Hacer permanente el forwarding
     sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
     #sed -i -e 's|#net.ipv6.conf.all.forwarding=1|net.ipv6.conf.all.forwarding=1|g' /etc/sysctl.conf

  ## Levantar la conexión
     echo ""
     echo "Levantando la interfaz..."
     echo ""
     wg-quick up wg0
     echo ""

  ## Activar el servicio
      echo ""
      echo "Activando el servicio..."
      echo ""
      systemctl enable wg-quick@wg0.service
      echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de WireGuard para Debian 9 (Stretch)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  ## Instalar el paquete WireGuard
     apt-get -y update
     apt-get -y install wireguard

  ## Cargar elmódulo
     modprobe wireguard

  ## Crear el archivo de configuración#
     echo "[Interface]" > /etc/wireguard/wg0.conf
     echo "Address =" >> /etc/wireguard/wg0.conf
     echo "PrivateKey =" >> /etc/wireguard/wg0.conf
     echo "ListenPort = 51820" >> /etc/wireguard/wg0.conf
     echo "PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $InterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
     echo "PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $InterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
     echo "SaveConfig = true    # Para que se guarden los nuevos clientes en este archivo desde la línea de comandos" >> /etc/wireguard/wg0.conf

  ## Agregar la dirección IP del servidor al archivo de configuración
     DirIP=$(ip a | grep $InterfazEthernet | grep inet | cut -d '/' -f 1 | cut -d 't' -f 2 | cut -d ' ' -f 2)
     sed -i -e 's|Address =|Address = '$DirIP'|g' /etc/wireguard/wg0.conf

  ## Crear las claves pública y privada del servidor
     mkdir /root/WireGuard/
     wg genkey >                                                  /root/WireGuard/WireGuardServerPrivate.key
     cat /root/WireGuard/WireGuardServerPrivate.key | wg pubkey > /root/WireGuard/WireGuardServerPublic.key

  ## Agregar la clave privada al archivo de configuración
     VarServerPrivKey=$(cat /root/WireGuard/WireGuardServerPrivate.key)
     sed -i -e 's|PrivateKey =|PrivateKey = '$VarServerPrivKey'|g' /etc/wireguard/wg0.conf

  ## Crear las claves para el primer usuario
     wg genkey >                                                 /root/WireGuard/WireGuardUser0Private.key
     cat /root/WireGuard/WireGuardUser0Private.key | wg pubkey > /root/WireGuard/WireGuardUser0Public.key

  ## Agregar el primer usuario al archivo de configuración
     echo ""  >> /etc/wireguard/wg0.conf
     echo "[Peer]" >> /etc/wireguard/wg0.conf
     echo "User0PublicKey =" >> /etc/wireguard/wg0.conf
     echo "AllowedIPs = 0.0.0.0/0" >> /etc/wireguard/wg0.conf

  ## Agregar la clave pública del primer usuario al archivo de configuración
     VarUser0PubKey=$(cat /root/WireGuard/WireGuardUser0Public.key)
     sed -i -e 's|User0PublicKey =|PublicKey = '$VarUser0PubKey'|g' /etc/wireguard/wg0.conf

  ## Agregar las reglas para tener salida a Internet desde el servidor
     iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
     iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
     iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT
     iptables -A INPUT -s $DirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
     iptables -A INPUT -s $DirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT

  ## Agregar las reglas a los ComandosPostArranque
     touch /root/scripts/ReglasIPTablesWireGuard.sh
     echo "iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                        > /root/scripts/ReglasIPTablesWireGuard.sh
     echo "iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                     >> /root/scripts/ReglasIPTablesWireGuard.sh
     echo "iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT"           >> /root/scripts/ReglasIPTablesWireGuard.sh
     echo "iptables -A INPUT -s $DirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
     echo "iptables -A INPUT -s $DirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
     chmod +x /root/scripts/ReglasIPTablesWireGuard.sh
     touch /root/scripts/ComandosPostArranque.sh
     echo "/root/scripts/ReglasIPTablesWireGuard.sh" >> /root/scripts/ComandosPostArranque.sh
     chmod +x /root/scripts/ComandosPostArranque.sh

  ## Habilitar el forwarding
     sysctl -w net.ipv4.ip_forward=1
     #sysctl -w net.ipv6.conf.all.forwarding=1

  ## Hacer permanente el forwarding
     sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
     #sed -i -e 's|#net.ipv6.conf.all.forwarding=1|net.ipv6.conf.all.forwarding=1|g' /etc/sysctl.conf

  ## Levantar la conexión
     echo ""
     echo "Levantando la interfaz..."
     echo ""
     wg-quick up wg0
     echo ""

  ## Activar el servicio
      echo ""
      echo "Activando el servicio..."
      echo ""
      systemctl enable wg-quick@wg0.service
      echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de WireGuard para Debian 10 (Buster)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  ## Agregar el repositorio back-ports
     echo "deb http://deb.debian.org/debian buster-backports main" > /etc/apt/sources.list.d/backports.lis

  ## Instalar el paquete WireGuard desde el repositorio back-ports
     apt-get -y update > /dev/null
     apt-get -y autoremove > /dev/null
     apt-get -y -t buster-backports install wireguard

  ## Crear el archivo de configuración
     echo "[Interface]" > /etc/wireguard/wg0.conf
     echo "Address =" >> /etc/wireguard/wg0.conf
     echo "PrivateKey =" >> /etc/wireguard/wg0.conf
     echo "ListenPort = 51820" >> /etc/wireguard/wg0.conf
     echo "PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $InterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
     echo "PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $InterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
     echo "SaveConfig = true    # Para que se guarden los nuevos clientes en este archivo desde la línea de comandos" >> /etc/wireguard/wg0.conf

  ## Agregar la dirección IP del servidor al archivo de configuración
     DirIP=$(ip a | grep $InterfazEthernet | grep inet | cut -d '/' -f 1 | cut -d 't' -f 2 | cut -d ' ' -f 2)
     sed -i -e 's|Address =|Address = '$DirIP'|g' /etc/wireguard/wg0.conf

  ## Crear las claves pública y privada del servidor
     mkdir /root/WireGuard/
     wg genkey >                                                  /root/WireGuard/WireGuardServerPrivate.key
     cat /root/WireGuard/WireGuardServerPrivate.key | wg pubkey > /root/WireGuard/WireGuardServerPublic.key
     chmod 600 /root/WireGuard/WireGuardServerPrivate.key

  ## Agregar la clave privada al archivo de configuración
     VarServerPrivKey=$(cat /root/WireGuard/WireGuardServerPrivate.key)
     sed -i -e 's|PrivateKey =|PrivateKey = '$VarServerPrivKey'|g' /etc/wireguard/wg0.conf

  ## Crear las claves para el primer usuario
     wg genkey >                                                 /root/WireGuard/WireGuardUser0Private.key
     cat /root/WireGuard/WireGuardUser0Private.key | wg pubkey > /root/WireGuard/WireGuardUser0Public.key

  ## Agregar el primer usuario al archivo de configuración
     echo ""  >> /etc/wireguard/wg0.conf
     echo "[Peer]" >> /etc/wireguard/wg0.conf
     echo "User0PublicKey =" >> /etc/wireguard/wg0.conf
     echo "AllowedIPs = 0.0.0.0/0" >> /etc/wireguard/wg0.conf

  ## Agregar la clave pública del primer usuario al archivo de configuración
     VarUser0PubKey=$(cat /root/WireGuard/WireGuardUser0Public.key)
     sed -i -e 's|User0PublicKey =|PublicKey = '$VarUser0PubKey'|g' /etc/wireguard/wg0.conf

## Agregar las reglas para tener salida a Internet desde el servidor
     iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
     iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
     iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT
     iptables -A INPUT -s $DirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
     iptables -A INPUT -s $DirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT

  ## Agregar las reglas del cortafuego a los ComandosPostArranque
     touch /root/scripts/ReglasIPTablesWireGuard.sh
     echo "iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                        > /root/scripts/ReglasIPTablesWireGuard.sh
     echo "iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                     >> /root/scripts/ReglasIPTablesWireGuard.sh
     echo "iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT"           >> /root/scripts/ReglasIPTablesWireGuard.sh
     echo "iptables -A INPUT -s $DirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
     echo "iptables -A INPUT -s $DirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >> /root/scripts/ReglasIPTablesWireGuard.sh
     chmod +x /root/scripts/ReglasIPTablesWireGuard.sh
     touch /root/scripts/ComandosPostArranque.sh
     echo "/root/scripts/ReglasIPTablesWireGuard.sh" >> /root/scripts/ComandosPostArranque.sh
     chmod +x /root/scripts/ComandosPostArranque.sh

  ## Habilitar el forwarding
     sysctl -w net.ipv4.ip_forward=1
     #sysctl -w net.ipv6.conf.all.forwarding=1

  ## Hacer permanente el forwarding
     sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
     #sed -i -e 's|#net.ipv6.conf.all.forwarding=1|net.ipv6.conf.all.forwarding=1|g' /etc/sysctl.conf

  ## Levantar la conexión
     echo ""
     echo "Levantando la interfaz..."
     echo ""
     wg-quick up wg0
     echo ""

  ## Activar el servicio
      echo ""
      echo "Activando el servicio..."
      echo ""
      systemctl enable wg-quick@wg0.service
      echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de WireGuard para Debian 11 (Bullseye)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  # Instalar el paquete WireGuard
    apt-get -y update
    apt-get -y install wireguard

  # Crear las claves pública y privada del cliente
    mkdir /root/WireGuard/
    wg genkey >                                                  /root/WireGuard/WireGuardClientPrivate.key
    cat /root/WireGuard/WireGuardClientPrivate.key | wg pubkey > /root/WireGuard/WireGuardClientPublic.key
    chmod 600 /root/WireGuard/WireGuardClientPrivate.key

  # Agregar la clave privada al archivo de configuración
    VarClientPrivKey=$(cat /root/WireGuard/WireGuardClientPrivate.key)
    sed -i -e 's|PrivateKey =|PrivateKey = '$VarClientPrivKey'|g' /etc/wireguard/wg0.conf

    echo ""
    echo "  Ingresa la IP o el dominio del servidor al que quieras conectarte y presiona Enter."
    echo ""
    echo "  La información se guardará en el archivo /etc/wireguard/wg0.conf"
    echo "  Si te equivocas, puedes modificar ese archivo a posteriori."
    echo ""
    read -p "IP o nombre de dominio: "

    echo ""
    echo "La IP o dominio que ingresaste es: $IPoDominio"
    echo ""

    # Crear el archivo de configuración
      echo "# Datos del cliente"                           > /etc/wireguard/wg0.conf
      echo "[Interface]"                                  >> /etc/wireguard/wg0.conf
      echo "# Clave privada del cliente"                  >> /etc/wireguard/wg0.conf
      echo "PrivateKey = $VarClientPrivKey"               >> /etc/wireguard/wg0.conf
      echo "# IP deseada por el cliente"                  >> /etc/wireguard/wg0.conf
      echo "Address = 10.0.0.2/24"                        >> /etc/wireguard/wg0.conf
      echo ""                                             >> /etc/wireguard/wg0.conf
      echo "# Datos del servidor"                         >> /etc/wireguard/wg0.conf
      echo "[Peer]"                                       >> /etc/wireguard/wg0.conf
      echo "# Clave pública del servidor"                 >> /etc/wireguard/wg0.conf
      echo "PublicKey = $ClavePubServidor"                >> /etc/wireguard/wg0.conf
      echo "# Lista de control de acceso"                 >> /etc/wireguard/wg0.conf
      echo "AllowedIPs = 192.168.10.0/24"                 >> /etc/wireguard/wg0.conf
      echo "# Dirección IP pública y puerto del servidor" >> /etc/wireguard/wg0.conf
      echo "Endpoint = $IPPubServ"                        >> /etc/wireguard/wg0.conf #172.105.112.120:51194
      echo "# Key connection alive"                       >> /etc/wireguard/wg0.conf
      echo "PersistentKeepalive = 20"                     >> /etc/wireguard/wg0.conf

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

  # Arrancar wireguard
    wg-quick up wg0

fi

