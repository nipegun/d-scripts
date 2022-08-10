#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para agregar un nuevo cliente al servidor WireGuard
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/VPN-WireGuard-Clientes-Nuevo.sh | bash
# ----------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

vIPsClientes="192.168.255."
vMascaraServer="/32"
vMascaraClientes="/24"

for i in {1..9}
  do
    if [ -f /root/WireGuard/WireGuardUser"$i"Private.key ] && [ -f /root/WireGuard/WireGuardUser"$i"Public.key ]; then
      echo ""
      echo "El peer User$i ya existe. Intentando crear el peer User$(($i+1))..."
      echo ""
    else
      # Generar claves para el nuevo peer
        echo ""
        echo "  Generando la clave privada para el peer User$i"
        echo ""
        wg genkey >                                                    /root/WireGuard/WireGuardUser"$i"Private.key
        echo ""
        echo "  Generando la clave pública para el peer User$i"
        echo ""
        cat /root/WireGuard/WireGuardUser"$i"Private.key | wg pubkey > /root/WireGuard/WireGuardUser"$i"Public.key
      # Agregar la configuración del nuevo peer a /etc/wireguard/wg0.conf
        echo ""                                            >> /etc/wireguard/wg0.conf
        echo "[Peer]"                                      >> /etc/wireguard/wg0.conf
        echo "TempPublicKey ="                             >> /etc/wireguard/wg0.conf
        echo "AllowedIPs = $vIPsClientes$i$vMascaraServer" >> /etc/wireguard/wg0.conf # Direcciones IPs que se le permiten pedir al cliente
      # Agregar la clave pública del primer usuario al archivo de configuración
        vClavePubNuevoUsuario=$(cat /root/WireGuard/WireGuardUser"$i"Public.key)
        sed -i -e "s|TempPublicKey =|PublicKey = $vClavePubNuevoUsuario|g" /etc/wireguard/wg0.conf
      # Crear el archivo de configuración para el nuevo peer
        vPeerPrivateKey=$(cat /root/WireGuard/WireGuardUser"$i"Private.key)
        vSerPubKey=$(cat /root/WireGuard/WireGuardServerPublic.key)
        vServIPWAN=$(curl --silent ipinfo.io/ip)
        echo "[Interface]"                                 > /root/WireGuard/WireGuardUser"$i".conf
        echo "PrivateKey = $vPeerPrivateKey"              >> /root/WireGuard/WireGuardUser"$i".conf
        echo "Address = $vIPsClientes$i$vMascaraClientes" >> /root/WireGuard/WireGuardUser"$i".conf
        echo "DNS = 192.168.1.1"                          >> /root/WireGuard/WireGuardUser"$i".conf
        echo ""                                           >> /root/WireGuard/WireGuardUser"$i".conf
        echo "[Peer]"                                     >> /root/WireGuard/WireGuardUser"$i".conf
        echo "PublicKey = $vSerPubKey"                    >> /root/WireGuard/WireGuardUser"$i".conf
        echo "AllowedIPs = 0.0.0.0/0, ::/0"               >> /root/WireGuard/WireGuardUser"$i".conf
        echo "Endpoint = $vServIPWAN:51820"               >> /root/WireGuard/WireGuardUser"$i".conf
        echo "PersistentKeepalive = 30"                   >> /root/WireGuard/WireGuardUser"$i".conf
      # Crear el código QR para el nuevo peer
        # Comprobar si el paquete qrencode está instalado. Si no lo está, instalarlo.
          if [[ $(dpkg-query -s qrencode 2>/dev/null | grep installed) == "" ]]; then
            echo ""
            echo "  qrencode no está instalado. Iniciando su instalación..."
            echo ""
            apt-get -y update && apt-get -y install qrencode
            echo ""
          fi
        echo ""
        echo "  Generando el código QR para la conexión del peer User$i a partir del archivo /root/WireGuard/WireGuardUser$i.conf..."
        echo ""
        qrencode -t png -o /root/WireGuard/WireGuardUser"$i"QR.png -r /root/WireGuard/WireGuardUser"$i".conf
        cat /root/WireGuard/WireGuardUser"$i".conf | qrencode -t ansiutf8
      # Terminar el script
        exit
    fi
  done




# Otra forma de crear peers
# ClavePúblicaDelNuevoCliente IPDelCliente 
# wg set wg0 peer <Client Public Key> endpoint <Client IP address>:51820 allowed-ips 203.0.113.12/24,fd86:ea04:1115::5/64
