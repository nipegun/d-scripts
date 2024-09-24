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
  echo "  Iniciando el script de instalación de WireGuard para Debian 11 (Bullseye)..."  
  echo ""

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
    echo "    Luego, para activar la conexión, ejecuta: wg-quick up NombreDeLaConexion"
    echo ""
    echo "    Por ejemplo:"
    echo "      wq-quick up wg0 (Si el archivo de configuración se llama wg.conf)"
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

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de WireGuard para Debian 10 (Buster)..."  
  echo ""

  # Agregar el repositorio back-ports
     echo "deb http://deb.debian.org/debian buster-backports main" > /etc/apt/sources.list.d/backports.lis

  # Instalar el paquete WireGuard desde el repositorio back-ports
     apt-get -y update > /dev/null
     apt-get -y autoremove > /dev/null
     apt-get -y -t buster-backports install wireguard

  # Crear el archivo de configuración
     echo "[Interface]" > /etc/wireguard/wg0.conf
     echo "Address =" >> /etc/wireguard/wg0.conf
     echo "PrivateKey =" >> /etc/wireguard/wg0.conf
     echo "ListenPort = 51820" >> /etc/wireguard/wg0.conf
     echo "PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $InterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
     echo "PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $InterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
     echo "SaveConfig = true    # Para que se guarden los nuevos clientes en este archivo desde la línea de comandos" >> /etc/wireguard/wg0.conf

  # Agregar la dirección IP del servidor al archivo de configuración
     DirIP=$(ip a | grep $InterfazEthernet | grep inet | cut -d '/' -f 1 | cut -d 't' -f 2 | cut -d ' ' -f 2)
     sed -i -e 's|Address =|Address = '$DirIP'|g' /etc/wireguard/wg0.conf

  # Crear las claves pública y privada del servidor
     mkdir /root/WireGuard/
     wg genkey >                                                  /root/WireGuard/WireGuardServerPrivate.key
     cat /root/WireGuard/WireGuardServerPrivate.key | wg pubkey > /root/WireGuard/WireGuardServerPublic.key
     chmod 600 /root/WireGuard/WireGuardServerPrivate.key

  # Agregar la clave privada al archivo de configuración
     VarServerPrivKey=$(cat /root/WireGuard/WireGuardServerPrivate.key)
     sed -i -e 's|PrivateKey =|PrivateKey = '$VarServerPrivKey'|g' /etc/wireguard/wg0.conf

  # Crear las claves para el primer usuario
     wg genkey >                                                 /root/WireGuard/WireGuardUser0Private.key
     cat /root/WireGuard/WireGuardUser0Private.key | wg pubkey > /root/WireGuard/WireGuardUser0Public.key

  # Agregar el primer usuario al archivo de configuración
     echo ""  >> /etc/wireguard/wg0.conf
     echo "[Peer]" >> /etc/wireguard/wg0.conf
     echo "User0PublicKey =" >> /etc/wireguard/wg0.conf
     echo "AllowedIPs = 0.0.0.0/0" >> /etc/wireguard/wg0.conf

  # Agregar la clave pública del primer usuario al archivo de configuración
     VarUser0PubKey=$(cat /root/WireGuard/WireGuardUser0Public.key)
     sed -i -e 's|User0PublicKey =|PublicKey = '$VarUser0PubKey'|g' /etc/wireguard/wg0.conf

# Agregar las reglas para tener salida a Internet desde el servidor
     iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
     iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
     iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT
     iptables -A INPUT -s $DirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
     iptables -A INPUT -s $DirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT

  # Agregar las reglas del cortafuego a los ComandosPostArranque
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

  # Habilitar el forwarding
     sysctl -w net.ipv4.ip_forward=1
     #sysctl -w net.ipv6.conf.all.forwarding=1

  # Hacer permanente el forwarding
     sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
     #sed -i -e 's|#net.ipv6.conf.all.forwarding=1|net.ipv6.conf.all.forwarding=1|g' /etc/sysctl.conf

  # Levantar la conexión
     echo ""
     echo "Levantando la interfaz..."     echo ""
     wg-quick up wg0
     echo ""

  # Activar el servicio
      echo ""
      echo "Activando el servicio..."
      echo ""
      systemctl enable wg-quick@wg0.service
      echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de WireGuard para Debian 9 (Stretch)..."  
  echo ""

  # Instalar el paquete WireGuard
     apt-get -y update
     apt-get -y install wireguard

  # Cargar elmódulo
     modprobe wireguard

  # Crear el archivo de configuración#
     echo "[Interface]" > /etc/wireguard/wg0.conf
     echo "Address =" >> /etc/wireguard/wg0.conf
     echo "PrivateKey =" >> /etc/wireguard/wg0.conf
     echo "ListenPort = 51820" >> /etc/wireguard/wg0.conf
     echo "PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $InterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
     echo "PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $InterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
     echo "SaveConfig = true    # Para que se guarden los nuevos clientes en este archivo desde la línea de comandos" >> /etc/wireguard/wg0.conf

  # Agregar la dirección IP del servidor al archivo de configuración
     DirIP=$(ip a | grep $InterfazEthernet | grep inet | cut -d '/' -f 1 | cut -d 't' -f 2 | cut -d ' ' -f 2)
     sed -i -e 's|Address =|Address = '$DirIP'|g' /etc/wireguard/wg0.conf

  # Crear las claves pública y privada del servidor
     mkdir /root/WireGuard/
     wg genkey >                                                  /root/WireGuard/WireGuardServerPrivate.key
     cat /root/WireGuard/WireGuardServerPrivate.key | wg pubkey > /root/WireGuard/WireGuardServerPublic.key

  # Agregar la clave privada al archivo de configuración
     VarServerPrivKey=$(cat /root/WireGuard/WireGuardServerPrivate.key)
     sed -i -e 's|PrivateKey =|PrivateKey = '$VarServerPrivKey'|g' /etc/wireguard/wg0.conf

  # Crear las claves para el primer usuario
     wg genkey >                                                 /root/WireGuard/WireGuardUser0Private.key
     cat /root/WireGuard/WireGuardUser0Private.key | wg pubkey > /root/WireGuard/WireGuardUser0Public.key

  # Agregar el primer usuario al archivo de configuración
     echo ""  >> /etc/wireguard/wg0.conf
     echo "[Peer]" >> /etc/wireguard/wg0.conf
     echo "User0PublicKey =" >> /etc/wireguard/wg0.conf
     echo "AllowedIPs = 0.0.0.0/0" >> /etc/wireguard/wg0.conf

  # Agregar la clave pública del primer usuario al archivo de configuración
     VarUser0PubKey=$(cat /root/WireGuard/WireGuardUser0Public.key)
     sed -i -e 's|User0PublicKey =|PublicKey = '$VarUser0PubKey'|g' /etc/wireguard/wg0.conf

  # Agregar las reglas para tener salida a Internet desde el servidor
     iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
     iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
     iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT
     iptables -A INPUT -s $DirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
     iptables -A INPUT -s $DirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT

  # Agregar las reglas a los ComandosPostArranque
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

  # Habilitar el forwarding
     sysctl -w net.ipv4.ip_forward=1
     #sysctl -w net.ipv6.conf.all.forwarding=1

  # Hacer permanente el forwarding
     sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
     #sed -i -e 's|#net.ipv6.conf.all.forwarding=1|net.ipv6.conf.all.forwarding=1|g' /etc/sysctl.conf

  # Levantar la conexión
     echo ""
     echo "Levantando la interfaz..."
     echo ""
     wg-quick up wg0
     echo ""

  # Activar el servicio
      echo ""
      echo "Activando el servicio..."
      echo ""
      systemctl enable wg-quick@wg0.service
      echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de WireGuard para Debian 8 (Jessie)..."  
  echo ""

  # Agregar el repositorio inestable
     echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable.list

  # Instalar el paquete WireGuard
     apt-get -y update
     apt-get -y install wireguard

  # Cargar elmódulo
     modprobe wireguard

  # Crear el archivo de configuración#
     echo "[Interface]" > /etc/wireguard/wg0.conf
     echo "Address =" >> /etc/wireguard/wg0.conf
     echo "PrivateKey =" >> /etc/wireguard/wg0.conf
     echo "ListenPort = 51820" >> /etc/wireguard/wg0.conf
     echo "PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $InterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
     echo "PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $InterfazEthernet -j MASQUERADE" >> /etc/wireguard/wg0.conf
     echo "SaveConfig = true    # Para que se guarden los nuevos clientes en este archivo desde la línea de comandos" >> /etc/wireguard/wg0.conf

  # Agregar la dirección IP del servidor al archivo de configuración
     DirIP=$(ip a | grep $InterfazEthernet | grep inet | cut -d '/' -f 1 | cut -d 't' -f 2 | cut -d ' ' -f 2)
     sed -i -e 's|Address =|Address = '$DirIP'|g' /etc/wireguard/wg0.conf

  # Crear las claves pública y privada del servidor
     mkdir /root/WireGuard/
     wg genkey >                                                  /root/WireGuard/WireGuardServerPrivate.key
     cat /root/WireGuard/WireGuardServerPrivate.key | wg pubkey > /root/WireGuard/WireGuardServerPublic.key

  # Agregar la clave privada al archivo de configuración
     VarServerPrivKey=$(cat /root/WireGuard/WireGuardServerPrivate.key)
     sed -i -e 's|PrivateKey =|PrivateKey = '$VarServerPrivKey'|g' /etc/wireguard/wg0.conf

  # Crear las claves para el primer usuario
     wg genkey >                                                 /root/WireGuard/WireGuardUser0Private.key
     cat /root/WireGuard/WireGuardUser0Private.key | wg pubkey > /root/WireGuard/WireGuardUser0Public.key

  # Agregar el primer usuario al archivo de configuración
     echo ""  >> /etc/wireguard/wg0.conf
     echo "[Peer]" >> /etc/wireguard/wg0.conf
     echo "User0PublicKey =" >> /etc/wireguard/wg0.conf
     echo "AllowedIPs = 0.0.0.0/0" >> /etc/wireguard/wg0.conf

  # Agregar la clave pública del primer usuario al archivo de configuración
     VarUser0PubKey=$(cat /root/WireGuard/WireGuardUser0Public.key)
     sed -i -e 's|User0PublicKey =|PublicKey = '$VarUser0PubKey'|g' /etc/wireguard/wg0.conf

  # Agregar las reglas para tener salida a Internet desde el servidor
     iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
     iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
     iptables -A INPUT -p udp -m udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT
     iptables -A INPUT -s $DirIP/24 -p tcp -m tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
     iptables -A INPUT -s $DirIP/24 -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT

  # Agregar las reglas a los ComandosPostArranque
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

  # Habilitar el forwarding
     sysctl -w net.ipv4.ip_forward=1
     #sysctl -w net.ipv6.conf.all.forwarding=1

  # Hacer permanente el forwarding
     sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
     #sed -i -e 's|#net.ipv6.conf.all.forwarding=1|net.ipv6.conf.all.forwarding=1|g' /etc/sysctl.conf

  # Levantar la conexión
     echo ""
     echo "Levantando la interfaz..."     echo ""
     wg-quick up wg0
     echo ""

  # Activar el servicio
      echo ""
      echo "Activando el servicio..."
      echo ""
      systemctl enable wg-quick@wg0.service
      echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de WireGuard para Debian 7 (Wheezy)..."  
  echo ""

fi

