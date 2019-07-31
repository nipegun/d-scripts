#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA TRANSFORMAR UN DEBIAN 9 RECIÉN INSTALADO
#  EN UN ROUTER WIFI QUE SIRVA IPs EN LA INTERFAZ INALÁMBRICA
#  ES NECESARIO QUE EL ORDENADOR CUENTE CON, AL MENOS, UNA INTER-
#  FAZ CABLEADA Y UNA INTERFAZ INALÁMBRICA ATHEROS AR9380.
#  ESTE SCRIPT TIENE EN CUENTA QUE EL ROUTER AL QUE ESTÁ CONECTADO
#  EL ORDENADOR ESTÁ EN UNA SUBRED DISTINTA DE 192.168.1 PORQUE AL
#  FINALIZAR LA EJECUCIÓN DEL SCRIPT, EL ORDENADOR PROPORCIONARÁ
#  IPS EN ESA SUBRED (de 192.168.1.100 hasta 192.168.1.255)
#-------------------------------------------------------------------

# !!!! DEBES REEMPLAZAR LOS VALORES DE LAS 2 VARIABLES DE ABAJO !!!!
# !!!!!!!!!!!!!!!!!!! ANTES DE EJECUTAR EL SCRIPT !!!!!!!!!!!!!!!!!!

interfazcableada1=eth0
interfazinalambrica1=wlan0

cmd=(dialog --checklist "Opciones del script:" 22 76 16)
options=(1 "Poner los repositorios correctos" on
         2 "Actualizar el sistema" on
         3 "Instalar paquetes necesarios" on
         4 "Realizar cambios en los archivos" on
         5 "Reiniciar el sistema" on)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
  case $choice in
    1)
      echo ""
      echo "-------------------------------------"
      echo " PONIENDO LOS REPOSITORIOS CORRECTOS"
      echo "-------------------------------------"
      echo ""
      cp /etc/apt/sources.list /etc/apt/sources.list.bak
      echo "deb http://ftp.debian.org/debian/ stretch main contrib non-free" > /etc/apt/sources.list
      echo "deb-src http://ftp.debian.org/debian/ stretch main contrib non-free" >> /etc/apt/sources.list
      echo "" >> /etc/apt/sources.list
      echo "deb http://ftp.debian.org/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list
      echo "deb-src http://ftp.debian.org/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list
      echo "" >> /etc/apt/sources.list
      echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list
      echo "deb-src http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list
      echo "" >> /etc/apt/sources.list
    ;;

    2)
      echo ""
      echo "-------------------------"
      echo " ACTUALIZANDO EL SISTEMA"
      echo "-------------------------"
      echo ""
      apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get autoremove
    ;;

    3)
      echo ""
      echo "---------------------------------"
      echo " INSTALANDO PAQUETES NECESARIOS"
      echo "---------------------------------"
      echo ""
      apt-get -y install isc-dhcp-server hostapd crda
    ;;

    4)
      echo ""
      echo "--------------------------------------------------"
      echo "  CREANDO O REEMPLAZANDO LOS ARCHIVOS NECESARIOS"
      echo "--------------------------------------------------"
      echo ""
      echo "----------------------------------"
      echo "  CREANDO LAS REGLAS DE IPTABLES"
      echo "----------------------------------"
      echo ""
      echo "*mangle" > /root/ReglasIPTablesV4RouterWiFi
      echo ":PREROUTING ACCEPT [0:0]" >> /root/ReglasIPTablesV4RouterWiFi
      echo ":INPUT ACCEPT [0:0]" >> /root/ReglasIPTablesV4RouterWiFi
      echo ":FORWARD ACCEPT [0:0]" >> /root/ReglasIPTablesV4RouterWiFi
      echo ":OUTPUT ACCEPT [0:0]" >> /root/ReglasIPTablesV4RouterWiFi
      echo ":POSTROUTING ACCEPT [0:0]" >> /root/ReglasIPTablesV4RouterWiFi
      echo "COMMIT" >> /root/ReglasIPTablesV4RouterWiFi
      echo "" >> /root/ReglasIPTablesV4RouterWiFi
      echo "*nat" >> /root/ReglasIPTablesV4RouterWiFi
      echo ":PREROUTING ACCEPT [0:0]" >> /root/ReglasIPTablesV4RouterWiFi
      echo ":INPUT ACCEPT [0:0]" >> /root/ReglasIPTablesV4RouterWiFi
      echo ":OUTPUT ACCEPT [0:0]" >> /root/ReglasIPTablesV4RouterWiFi
      echo ":POSTROUTING ACCEPT [0:0]" >> /root/ReglasIPTablesV4RouterWiFi
      echo "-A POSTROUTING -o $interfazcableada1 -j MASQUERADE" >> /root/ReglasIPTablesV4RouterWiFi
      echo "COMMIT" >> /root/ReglasIPTablesV4RouterWiFi
      echo "" >> /root/ReglasIPTablesV4RouterWiFi
      echo "*filter" >> /root/ReglasIPTablesV4RouterWiFi
      echo ":INPUT ACCEPT [0:0]" >> /root/ReglasIPTablesV4RouterWiFi
      echo ":FORWARD ACCEPT [0:0]" >> /root/ReglasIPTablesV4RouterWiFi
      echo ":OUTPUT ACCEPT [0:0]" >> /root/ReglasIPTablesV4RouterWiFi
      echo "-A FORWARD -i $interfazcableada1 -o $interfazinalambrica1 -m state --state RELATED,ESTABLISHED -j ACCEPT" >> /root/ReglasIPTablesV4RouterWiFi
      echo "-A FORWARD -i $interfazinalambrica1 -o $interfazcableada1 -j ACCEPT" >> /root/ReglasIPTablesV4RouterWiFi
      echo "COMMIT" >> /root/ReglasIPTablesV4RouterWiFi
      echo ""
      echo "-----------------------------"
      echo "  HABILITANDO IP FORWARDING"
      echo "-----------------------------"
      echo ""
      cp /etc/sysctl.conf /etc/sysctl.conf.bak
      sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
      echo ""
      echo "------------------------------------"
      echo "    INDICANDO LA UBICACIÓN DE LA"
      echo "  CONFIGURACIÓN DEL DAEMON HOSTAPD"
      echo "------------------------------------"
      echo ""
      cp /etc/default/hostapd /etc/default/hostapd.bak
      sed -i -e 's|#DAEMON_CONF=""|DAEMON_CONF="/etc/hostapd/hostapd.conf"|g' /etc/default/hostapd
      echo ""
      echo "--------------------------------------------"
      echo "   INDICANDO LA UBICACIÓN DEL ARCHIVO DE"
      echo "  CONFIGURACIÓN DEL DEMONIO DHCPD ASI COMO"
      echo "     LA INTERFAZ SOBRE LA QUE CORRERÁ"
      echo "--------------------------------------------"
      echo ""
      cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
      sed -i -e 's|#DHCPDv4_CONF=/etc/dhcp/dhcpd.conf|DHCPDv4_CONF=/etc/dhcp/dhcpd.conf|g' /etc/default/isc-dhcp-server
      sed -i -e 's|INTERFACESv4=""|INTERFACESv4="'$interfazinalambrica1'"|g' /etc/default/isc-dhcp-server
      echo ""
      echo "---------------------------------"
      echo "  CONFIGURANDO EL SERVIDOR DHCP"
      echo "---------------------------------"
      echo ""
      cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
      echo "authoritative;" > /etc/dhcp/dhcpd.conf
      echo "subnet 192.168.1.0 netmask 255.255.255.0 {" >> /etc/dhcp/dhcpd.conf
      echo "  range 192.168.1.100 192.168.1.255;" >> /etc/dhcp/dhcpd.conf
      echo "  option routers 192.168.1.1;" >> /etc/dhcp/dhcpd.conf
      echo "  option domain-name-servers 8.8.8.8, 8.8.4.4;" >> /etc/dhcp/dhcpd.conf
      echo "  default-lease-time 600;" >> /etc/dhcp/dhcpd.conf
      echo "  max-lease-time 7200;" >> /etc/dhcp/dhcpd.conf
      echo "" >> /etc/dhcp/dhcpd.conf
      echo "  host PrimeraReserva {" >> /etc/dhcp/dhcpd.conf
      echo "    hardware ethernet 00:00:00:00:00:01;" >> /etc/dhcp/dhcpd.conf
      echo "    fixed-address 192.168.1.10;" >> /etc/dhcp/dhcpd.conf
      echo "  }" >> /etc/dhcp/dhcpd.conf
      echo "}" >> /etc/dhcp/dhcpd.conf
      echo ""
      echo "-----------------------------------"
      echo "  CONFIGURANDO EL DEMONIO HOSTAPD"
      echo "-----------------------------------"
      echo ""
      echo "#/etc/hostapd/hostapd.conf" > /etc/hostapd/hostapd.conf
      echo "interface=$interfazinalambrica1" >> /etc/hostapd/hostapd.conf
      echo "driver=nl80211" >> /etc/hostapd/hostapd.conf
      echo "hw_mode=a" >> /etc/hostapd/hostapd.conf
      echo "wme_enabled=1" >> /etc/hostapd/hostapd.conf
      echo "ieee80211n=1" >> /etc/hostapd/hostapd.conf
      echo "ieee80211d=1" >> /etc/hostapd/hostapd.conf
      echo "channel=0" >> /etc/hostapd/hostapd.conf
      echo "country_code=ES" >> /etc/hostapd/hostapd.conf
      echo "wmm_enabled=1" >> /etc/hostapd/hostapd.conf
      echo "ht_capab=[RXLDPC][HT20+][HT40+][SHORT-GI-20][SHORT-GI-40][TX-STBC][RX-STBC1][MAX-AMSDU-3839][DSSS_CCK-40]" >> /etc/hostapd/hostapd.conf
      echo "ignore_broadcast_ssid=0" >> /etc/hostapd/hostapd.conf
      echo "ssid=RouterX86" >> /etc/hostapd/hostapd.conf
      echo "eap_reauth_period=360000000" >> /etc/hostapd/hostapd.conf
      echo "wpa=2" >> /etc/hostapd/hostapd.conf
      echo "wpa_key_mgmt=WPA-PSK" >> /etc/hostapd/hostapd.conf
      echo "wpa_pairwise=TKIP" >> /etc/hostapd/hostapd.conf
      echo "rsn_pairwise=CCMP" >> /etc/hostapd/hostapd.conf
      echo "wpa_passphrase=RouterX86" >> /etc/hostapd/hostapd.conf

      echo ""
      echo "----------------------------------"
      echo "  CONFIGURANDO INTERFACES DE RED"
      echo "----------------------------------"
      echo ""
      cp /etc/network/interfaces /etc/network/interfaces.bak
      echo "auto lo" > /etc/network/interfaces
      echo "iface lo inet loopback" >> /etc/network/interfaces
      echo "pre-up iptables-restore < /root/ReglasIPTablesV4RouterWiFi" >> /etc/network/interfaces
      echo "auto $interfazcableada1" >> /etc/network/interfaces
      echo "allow-hotplug $interfazcableada1" >> /etc/network/interfaces
      echo "iface $interfazcableada1 inet dhcp" >> /etc/network/interfaces
      echo "auto $interfazinalambrica1" >> /etc/network/interfaces
      echo "iface $interfazinalambrica1 inet static" >> /etc/network/interfaces
      echo "address 192.168.1.1" >> /etc/network/interfaces
      echo "network 192.168.1.0" >> /etc/network/interfaces
      echo "netmask 255.255.255.0" >> /etc/network/interfaces
      echo "broadcast 192.168.1.255" >> /etc/network/interfaces

      echo ""
      echo "Descargando archivo de nombres de fabricantes..."
      echo ""
      wget -O /usr/local/etc/oui.txt http://standards-oui.ieee.org/oui/oui.txt
    ;;

    5)
      shutdown -r now
    ;;

    esac

done

