#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA TRANSFORMAR UN PROXMOXVE 5 RECIÉN INSTALADO
#  EN UN ROUTER QUE SIRVA IPs EN LA SEGUNDA INTERFAZ CABLEADA.
#        ES NECESARIO QUE EL ORDENADOR CUENTE CON, AL MENOS,
#                     DOS INTERFACES CABLEADAS.
#  ESTE SCRIPT TIENE EN CUENTA QUE EL ROUTER AL QUE ESTÁ CONECTADO
#  PROXMOX ESTÁ EN UNA SUBRED DISTINTA DE 192.168.1 PORQUE AL
#  FINALIZAR LA EJECUCIÓN DEL SCRIPT EL ORDENADOR PROPORCIONARÁ
#  IPS EN ESA SUBRED (de 192.168.1.100 hasta 192.168.1.255)
#----------------------------------------------------------------------

# !!!! DEBES REEMPLAZAR LOS VALORES DE LAS 2 VARIABLES DE ABAJO !!!!
# !!!!!!!!!!!!!!!!!!! ANTES DE EJECUTAR EL SCRIPT !!!!!!!!!!!!!!!!!!

interfazcableada1=vmbr0
interfazcableada2=eth1

echo ""
echo "----------------------------------"
echo "  INSTALANDO PAQUETES NECESARIOS"
echo "----------------------------------"
echo ""
apt-get -y install isc-dhcp-server

echo ""
echo "----------------------------------"
echo "  CREANDO LAS REGLAS DE IPTABLES"
echo "----------------------------------"
echo ""
echo "*mangle" > /root/ReglasIPTablesIP4Router
echo ":PREROUTING ACCEPT [0:0]" >> /root/ReglasIPTablesIP4Router
echo ":INPUT ACCEPT [0:0]" >> /root/ReglasIPTablesIP4Router
echo ":FORWARD ACCEPT [0:0]" >> /root/ReglasIPTablesIP4Router
echo ":OUTPUT ACCEPT [0:0]" >> /root/ReglasIPTablesIP4Router
echo ":POSTROUTING ACCEPT [0:0]" >> /root/ReglasIPTablesIP4Router
echo "COMMIT" >> /root/ReglasIPTablesIP4Router
echo "" >> /root/ReglasIPTablesIP4Router
echo "*nat" >> /root/ReglasIPTablesIP4Router
echo ":PREROUTING ACCEPT [0:0]" >> /root/ReglasIPTablesIP4Router
echo ":INPUT ACCEPT [0:0]" >> /root/ReglasIPTablesIP4Router
echo ":OUTPUT ACCEPT [0:0]" >> /root/ReglasIPTablesIP4Router
echo ":POSTROUTING ACCEPT [0:0]" >> /root/ReglasIPTablesIP4Router
echo "-A POSTROUTING -o $interfazcableada1 -j MASQUERADE" >> /root/ReglasIPTablesIP4Router
echo "COMMIT" >> /root/ReglasIPTablesIP4Router
echo "" >> /root/ReglasIPTablesIP4Router
echo "*filter" >> /root/ReglasIPTablesIP4Router
echo ":INPUT ACCEPT [0:0]" >> /root/ReglasIPTablesIP4Router
echo ":FORWARD ACCEPT [0:0]" >> /root/ReglasIPTablesIP4Router
echo ":OUTPUT ACCEPT [0:0]" >> /root/ReglasIPTablesIP4Router
echo "-A FORWARD -i $interfazcableada1 -o $interfazcableada2 -m state --state RELATED,ESTABLISHED -j ACCEPT" >> /root/ReglasIPTablesIP4Router
echo "-A FORWARD -i $interfazcableada2 -o $interfazcableada1 -j ACCEPT" >> /root/ReglasIPTablesIP4Router
echo "COMMIT" >> /root/ReglasIPTablesIP4Router

echo ""
echo "-----------------------------"
echo "  HABILITANDO IP FORWARDING"
echo "-----------------------------"
echo ""
cp /etc/sysctl.conf /etc/sysctl.conf.bak
sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf

echo ""
echo "--------------------------------------"
echo "  CONFIGURANDO LAS INTERFACES DE RED"
echo "--------------------------------------"
echo ""
cp /etc/network/interfaces /etc/network/interfaces.bak
sed -i -e 's|iface lo inet loopback|iface lo inet loopback\npre-up iptables-restore < /root/ReglasIPTablesV4RouterWiFi|g' /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "auto $interfazcableada2" >> /etc/network/interfaces
echo "  iface $interfazcableada2 inet static" >> /etc/network/interfaces
echo "  address 192.168.1.1" >> /etc/network/interfaces
echo "  network 192.168.1.0" >> /etc/network/interfaces
echo "  netmask 255.255.255.0" >> /etc/network/interfaces
echo "  broadcast 192.168.1.255" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces

echo ""
echo "--------------------------------------------"
echo "   INDICANDO LA UBICACIÓN DEL ARCHIVO DE"
echo "  CONFIGURACIÓN DEL DEMONIO DHCPD ASI COMO"
echo "     LA INTERFAZ SOBRE LA QUE CORRERÁ"
echo "--------------------------------------------"
echo ""
cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
sed -i -e 's|#DHCPDv4_CONF=/etc/dhcp/dhcpd.conf|DHCPDv4_CONF=/etc/dhcp/dhcpd.conf|g' /etc/default/isc-dhcp-server
sed -i -e 's|INTERFACESv4=""|INTERFACESv4="'$interfazcableada2'"|g' /etc/default/isc-dhcp-server

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
echo "----------------------------------------------------------------------"
echo "  EJECUCIÓN DEL SCRIPT FINALIZADA"
echo ""
echo "  Para aplicar los cambios reincia el sistema con:"
echo "  shutdown -r now"
echo ""
echo "  DESPUÉS DE REINICIAR TU PROXMOX DEBERÍA ESTAR SIRVIENDO IPs"
echo "  EN LA SEGUNDA INTERFAZ CABLEADA Y OPERANDO COMO ROUTER."
echo "  SI NECESITAS MÁS DE UNA CONEXIÓN ETHERNET PUEDES CONECTARLE UN"
echo "  SWITCH EN MODO PUENTE A ESE SEGUNDO PUERTO ETHERNET."
echo "  SI LO QUE QUIERES ES ADEMÁS TENER WIFI, EN VEZ DE UN SWITCH"
echo "  CONÉCTALE UN ROUTER WIFI EN MODO PUENTE."
echo "----------------------------------------------------------------------"
echo ""

