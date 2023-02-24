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

vOctetos123="192.168.255."
vMascaraRestrictora="/32"
vMascaraSolicitada="/24"
vPuertoWireGuard="51820"

for vNumPeer in {1..254}
  do
    if [ -f /root/WireGuard/WireGuardUser"$vNumPeer"Private.key ] && [ -f /root/WireGuard/WireGuardUser"$vNumPeer"Public.key ]; then
      echo ""
      echo "El peer User$vNumPeer ya existe. Intentando crear el peer User$(($vNumPeer+1))..."
      echo ""
    else

      # Generar claves para el nuevo peer
        echo ""
        echo "  Generando la clave privada para el peer User$vNumPeer..."
        echo ""
        wg genkey > /root/WireGuard/WireGuardUser"$vNumPeer"Private.key
        echo ""
        echo "  Generando la clave pública para el peer User$vNumPeer..."
        echo ""
        cat /root/WireGuard/WireGuardUser"$vNumPeer"Private.key | wg pubkey > /root/WireGuard/WireGuardUser"$vNumPeer"Public.key

      # Tirar la interfaz wg0
        echo ""
        echo "  Tirando la conexión wg0 antes de hacer los cambios en el archivo /etc/wireguard/wg0.conf..."
        echo ""
        wg-quick down wg0

      # Agregar la sección de configuración del nuevo peer a /etc/wireguard/wg0.conf
        vIPsPermitidasAlPeer="$vOctetos123$vNumPeer$vMascaraRestrictora"
        echo ""
        echo "  Agregando la sección de configuración del nuevo peer a /etc/wireguard/wg0.conf..."
        echo ""
        echo ""                                   >> /etc/wireguard/wg0.conf
        echo "[Peer]"                             >> /etc/wireguard/wg0.conf
        echo "TempPublicKey ="                    >> /etc/wireguard/wg0.conf
        echo "AllowedIPs = $vIPsPermitidasAlPeer" >> /etc/wireguard/wg0.conf

      # Agregar la clave pública del nuevo peer a su correspondiente sección de configuración
        vClavePubNuevoPeer=$(cat /root/WireGuard/WireGuardUser"$vNumPeer"Public.key)
        sed -i -e "s|TempPublicKey =|PublicKey = $vClavePubNuevoPeer|g" /etc/wireguard/wg0.conf

      # Levantar la interfaz wg0
        echo ""
        echo "  Levantando la conexión wg0, porque que los cambios en el archivo /etc/wireguard/wg0.conf ya se han realizado..."
        echo ""
        wg-quick up wg0

      # Crear el archivo de configuración del nuevo peer para importalo en otros dispositivos
        echo ""
        echo "  Creando el archivo de configuración del nuevo peer para importalo en otros dispositivos..."
        echo ""
        # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
          if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
            echo ""
            echo "    El paquete curl no está instalado. Iniciando su instalación..."
            echo ""
            apt-get -y update
            apt-get -y install curl
            echo ""
          fi
        vPeerPrivateKey=$(cat /root/WireGuard/WireGuardUser"$i"Private.key)
        vServPubKey=$(cat /root/WireGuard/WireGuardServerPublic.key)
        vIPwanServidor=$(curl --silent ipinfo.io/ip)
        echo "[Interface]"                                         > /root/WireGuard/WireGuardUser"$vNumPeer".conf
        echo "PrivateKey = $vPeerPrivateKey"                      >> /root/WireGuard/WireGuardUser"$vNumPeer".conf
        echo "Address = $vOctetos123$vNumPeer$vMascaraSolicitada" >> /root/WireGuard/WireGuardUser"$vNumPeer".conf
        echo "DNS = "$vOctetos123"1"                              >> /root/WireGuard/WireGuardUser"$vNumPeer".conf
        echo ""                                                   >> /root/WireGuard/WireGuardUser"$vNumPeer".conf
        echo "[Peer]"                                             >> /root/WireGuard/WireGuardUser"$vNumPeer".conf
        echo "PublicKey = $vServPubKey"                           >> /root/WireGuard/WireGuardUser"$vNumPeer".conf
        echo "AllowedIPs = 0.0.0.0/0, ::/0"                       >> /root/WireGuard/WireGuardUser"$vNumPeer".conf
        echo "Endpoint = $vIPwanServidor:$vPuertoWireGuard"       >> /root/WireGuard/WireGuardUser"$vNumPeer".conf
        echo "PersistentKeepalive = 30"                           >> /root/WireGuard/WireGuardUser"$vNumPeer".conf

      # Crear el código QR para el nuevo peer
        echo ""
        echo "  Generando el código QR para la conexión del peer User$vNumPeer a partir del archivo /root/WireGuard/WireGuardUser$vNumPeer.conf..."
        echo ""
        # Comprobar si el paquete qrencode está instalado. Si no lo está, instalarlo.
          if [[ $(dpkg-query -s qrencode 2>/dev/null | grep installed) == "" ]]; then
            echo ""
            echo "    El paquete qrencode no está instalado. Iniciando su instalación..."
            echo ""
            apt-get -y update
            apt-get -y install qrencode
            echo ""
          fi
        qrencode -t png -o /root/WireGuard/WireGuardUser"$vNumPeer"QR.png -r /root/WireGuard/WireGuardUser"$vNumPeer".conf
        cat /root/WireGuard/WireGuardUser"$vNumPeer".conf | qrencode -t ansiutf8

      # Terminar el script
        exit
    fi
  done

# Otra forma de crear peers
# ClavePúblicaDelNuevoCliente IPDelCliente 
# wg set wg0 peer <Client Public Key> endpoint <Client IP address>:51820 allowed-ips 203.0.113.12/24,fd86:ea04:1115::5/64

