#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------
#  Script de NiPeGun para instalar y configurar WireGuard
#----------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo "Iniciando ..."
apt-get -y update > /dev/null
echo "..."
apt-get -y install dialog > /dev/null
menu=(dialog --timeout 5 --checklist "¿En que versión de Debian quieres instalar xxx?:" 22 76 16)
  opciones=(1 "Debian  8, Jessie" off
            2 "Debian  9, Stretch" off
            3 "Debian 10, Buster" off
            4 "Debian 11, Bullseye" off)
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  clear

  for choice in $choices
    do
      case $choice in

        1)
          echo ""
          echo -e "${ColorRojo}Script para Debian 8 (Jessie) todavía no disponible.${FinColor}"
          echo ""
        ;;

        2)
          echo ""
          echo -e "${ColorRojo}Script para Debian 9 (Stretch) todavía no disponible.${FinColor}"
          echo ""
        ;;

        3)
          echo ""
          echo -e "${ColorVerde}Instalando WireGuard en Debian 10 (Buster)...${FinColor}"
          echo ""
          echo "deb http://deb.debian.org/debian buster-backports main" > /etc/apt/sources.list.d/backports.list
          apt-get -y update > /dev/null
          apt-get -y autoremove > /dev/null
          apt-get -y -t buster-backports install wireguard
          # Generar la llave Privada
            cd /etc/wireguard
            umask 077
            wg genkey > private.key
            chmod 600 private.key
          # Generar la llave Pública en base a la llave privada
            wg pubkey < private.key > public.key
          # Editar el archivo de configuración
            echo "[Interface]" > /etc/wireguard/wg0.conf
            echo "Address =" >> /etc/wireguard/wg0.conf
            #echo "SaveConfig = true" >> /etc/wireguard/wg0.conf
            echo "PrivateKey =" >> /etc/wireguard/wg0.conf
            echo "ListenPort = 51820" >> /etc/wireguard/wg0.conf
            echo "PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" >> /etc/wireguard/wg0.conf
            echo "PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE" >> /etc/wireguard/wg0.conf
            echo "" >> /etc/wireguard/wg0.conf
            echo "#[Peer]" >> /etc/wireguard/wg0.conf
            echo "#PublicKey =" >> /etc/wireguard/wg0.conf
            echo "#AllowedIPs = 0.0.0.0/0" >> /etc/wireguard/wg0.conf
            echo "" >> /etc/wireguard/wg0.conf
            echo "#[Peer]" >> /etc/wireguard/wg0.conf
            echo "#PublicKey =" >> /etc/wireguard/wg0.conf
            echo "#AllowedIPs = 0.0.0.0/0" >> /etc/wireguard/wg0.conf
          # Agregar la dirección IP del servidor al archivo de configuración
            DirIP=$(ip a | grep eth0 | grep inet | cut -d '/' -f 1 | cut -d 't' -f 2 | cut -d ' ' -f 2)
            sed -i -e 's|Address =|Address = '$DirIP'|g' /etc/wireguard/wg0.conf
          # Agregar la clave privada al archivo de configuración
            ClavePub=$(cat /etc/wireguard/private.key)
            sed -i -e 's|PrivateKey =|PrivateKey = '$ClavePub'|g' /etc/wireguard/wg0.conf
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
        ;;

        4)
          echo ""
          echo -e "${ColorRojo}Script para Debian 11 (Bullseye) todavía no disponible.${FinColor}"
          echo ""
          #apt-get -y update
          #apt-get -y install wireguard
        ;;
        
      esac
    done

