#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------
#  Script de NiPeGun para agregar un nuevo cliente al servidor WireGuard
#-------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

vIPsPermitidas=$(cat /etc/wireguard/wg0.conf | grep Allowed | head -n1 | cut -d'=' -f2 | sed 's- --g')

for i in {0..9}
  do
    if [ -f /root/WireGuard/WireGuardUser"$i"Private.key ] and [ -f /root/WireGuard/WireGuardUser"$i"Public.key ]; then
      echo "El peer User$i ya existe. Intentando crear el peer User$(($i+1))..."
    else
      # Generar claves para el nuevo usuario
        wg genkey >                                                    /root/WireGuard/WireGuardUser"$i"Private.key
        cat /root/WireGuard/WireGuardUser"$i"Private.key | wg pubkey > /root/WireGuard/WireGuardUser"$i"Public.key
      # Agregar la configuración a /etc/wireguard/wg0.conf
        echo ""                             >> /etc/wireguard/wg0.conf
        echo "[Peer]"                       >> /etc/wireguard/wg0.conf
        echo 'User"$i"PublicKey ='          >> /etc/wireguard/wg0.conf
        echo "AllowedIPs = $vIPsPermitidas" >> /etc/wireguard/wg0.conf
      # Agregar la clave pública del primer usuario al archivo de configuración
        vUser"$i"PubKey=$(cat /root/WireGuard/WireGuardUser"$i"Public.key)
        sed -i -e 's|User"$i"PublicKey =|PublicKey = "$vUser"$i"PubKey"|g' /etc/wireguard/wg0.conf
      # Terminar el script
        exit
    fi
  done

# Otra forma de crear peers
# ClavePúblicaDelNuevoCliente IPDelCliente 
# wg set wg0 peer <Client Public Key> endpoint <Client IP address>:51820 allowed-ips 203.0.113.12/24,fd86:ea04:1115::5/64
