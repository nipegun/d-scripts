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
    if -f [ /root/WireGuard/WireGuardUser"$i"Private.key ] and -f [ /root/WireGuard/WireGuardUser"$i"Public.key ]
      echo "El peer User$i ya existe. Intentando crear el peer User$(($i+1))"
    else
     # wg genkey >                                                    /root/WireGuard/WireGuardUser"$i"Private.key
     # cat /root/WireGuard/WireGuardUser"$i"Private.key | wg pubkey > /root/WireGuard/WireGuardUser"$i"Public.key
    fi
  done






# Agregar el primer usuario al archivo de configuración
  # echo ""                            >> /etc/wireguard/wg0.conf
  # echo "[Peer]"                      >> /etc/wireguard/wg0.conf
  # echo "User0PublicKey ="            >> /etc/wireguard/wg0.conf
  # echo "AllowedIPs = 192.168.0.0/16" >> /etc/wireguard/wg0.conf # No poner nunca 0.0.0.0/0. wg-quick añade rutas para las IPs permitidas en los peers. Al añadir 0.0.0.0/0 intentará enrutar todo internet a través de ese peer y el servidor se quedará sin conexión.


#ClavePúblicaDelNuevoCliente IPDelCliente 

# wg set wg0 peer <Client Public Key> endpoint <Client IP address>:51820 allowed-ips 203.0.113.12/24,fd86:ea04:1115::5/64
