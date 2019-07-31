#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA TRANSFORMAR UN DEBIAN 9 RECIÉN INSTALADO
#  EN UN ROUTER QUE REEMPLACE EL ROUTER QUE PROPORCIONA VODAFONE
#        ES NECESARIO QUE EL ORDENADOR CUENTE CON, AL MENOS,
#                     DOS INTERFACES CABLEADAS.
#-------------------------------------------------------------------

# !!!! DEBES REEMPLAZAR LOS VALORES DE LAS 4 VARIABLES DE ABAJO !!!!
# !!!!!!!!!!!!!!!!!!! ANTES DE EJECUTAR EL SCRIPT !!!!!!!!!!!!!!!!!!

interfazcableada1=eth0
interfazcableada2=eth1
usuariopppvodafone=xxx
clavepppvodafone=xxxx
macdelroutervodafone=00:00:00:00:00:00

apt-get update

echo ""
echo "----------------------------------"
echo "  INSTALANDO HERRAMIENTAS DE RED"
echo "----------------------------------"
echo ""
apt-get -y install vlan pppoe isc-dhcp-server
echo 8021q >> /etc/modules

echo ""
echo "-------------------------------------"
echo "  CONFIGURANDO LA INTERFAZ LOOPBACK"
echo "-------------------------------------"
echo ""
echo "auto lo" > /etc/network/interfaces
echo "  iface lo inet loopback" >> /etc/network/interfaces
echo "  pre-up iptables-restore < /root/ReglasIPTablesIP4RouterVodafone" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces

echo ""
echo "---------------------------------------------"
echo "  CONFIGURANDO LA PRIMERA INTERFAZ CABLEADA"
echo "---------------------------------------------"
echo ""
echo "auto $interfazcableada1" >> /etc/network/interfaces
echo "  allow-hotplug $interfazcableada1" >> /etc/network/interfaces
echo "  iface $interfazcableada1 inet dhcp" >> /etc/network/interfaces
echo "  hwaddress ether $macdelroutervodafone # Necesario para evitar futuros problemas" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces

echo ""
echo "---------------------------------------------"
echo "  CONFIGURANDO LA SEGUNDA INTERFAZ CABLEADA"
echo "---------------------------------------------"
echo ""
echo "auto $interfazcableada2" >> /etc/network/interfaces
echo "  iface $interfazcableada2 inet static" >> /etc/network/interfaces
echo "  address 192.168.0.1" >> /etc/network/interfaces
echo "  network 192.168.0.0" >> /etc/network/interfaces
echo "  netmask 255.255.255.0" >> /etc/network/interfaces
echo "  broadcast 192.168.0.255" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces

echo ""
echo "------------------------------------------------------"
echo "  CONFIGURANDO LA VLAN 100 PARA VODAFONE DATOS Y VOZ"
echo "------------------------------------------------------"
echo ""
echo "auto $interfazcableada1.100" >> /etc/network/interfaces
echo "  iface $interfazcableada1.100 inet manual" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces

echo ""
echo "--------------------------------"
echo "  CONFIGURANDO LA CONEXIÓN PPP"
echo "--------------------------------"
echo ""
echo "auto vodafonewan" >> /etc/network/interfaces
echo "  iface vodafonewan inet ppp" >> /etc/network/interfaces
echo "  pre-up /bin/ip link set $interfazcableada1.100 up" >> /etc/network/interfaces
echo "  provider vodafonewan" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces

#echo ""
#echo "--------------------------------------------------"
#echo "  CONFIGURANDO LA VLAN 105 PARA LA TELEVISIÓN IP"
#echo "--------------------------------------------------"
#echo ""
#echo "auto $interfazcableada1.105" >> /etc/network/interfaces
#echo "  iface $interfazcableada1.105 inet dhcp" >> /etc/network/interfaces
#echo "#  vlan-raw-device $interfazcableada1 # Necesario si la vlan se crea con un nombre no convencional" >> /etc/network/interfaces
#echo "  mtu 1500" >> /etc/network/interfaces

echo ""
echo "----------------------------------------------"
echo "  CREANDO EL ARCHIVO PARA EL PROVEEDOR PPPoE"
echo "----------------------------------------------"
echo ""
echo "noipdefault" > /etc/ppp/peers/vodafonewan
echo "defaultroute" >> /etc/ppp/peers/vodafonewan
echo "replacedefaultroute" >> /etc/ppp/peers/vodafonewan
echo "hide-password" >> /etc/ppp/peers/vodafonewan
echo "#lcp-echo-interval 30" >> /etc/ppp/peers/vodafonewan
echo "#lcp-echo-failure 4" >> /etc/ppp/peers/vodafonewan
echo "noauth" >> /etc/ppp/peers/vodafonewan
echo "persist" >> /etc/ppp/peers/vodafonewan
echo "#mtu 1492" >> /etc/ppp/peers/vodafonewan
echo "#maxfail 0" >> /etc/ppp/peers/vodafonewan
echo "#holdoff 20" >> /etc/ppp/peers/vodafonewan
echo "plugin rp-pppoe.so" >> /etc/ppp/peers/vodafonewan
echo "nic-$interfazcableada1.100" >> /etc/ppp/peers/vodafonewan
echo 'user "'$usuariopppvodafone'"' >> /etc/ppp/peers/vodafonewan
echo "usepeerdns" >> /etc/ppp/peers/vodafonewan

echo ""
echo "-----------------------------------"
echo "  CREANDO EL ARCHIVO CHAP-SECRETS"
echo "-----------------------------------"
echo ""
echo '"'$usuariopppvodafone'" * "'$clavepppvodafone'"' > /etc/ppp/chap-secrets

echo ""
echo "------------------------------------------"
echo "  AGREGANDO DATOS AL ARCHIVO PAP-SECRETS"
echo "------------------------------------------"
echo ""
echo '"'$usuariopppvodafone'" * "'$clavepppvodafone'"' >> /etc/ppp/pap-secrets

echo ""
echo "------------------------------"
echo "  INSTALANDO EL SERVIDOR SSH"
echo "------------------------------"
echo ""
apt-get -y install tasksel
tasksel install ssh-server

echo ""
echo "-----------------------------"
echo "  DESHABILITANDO EL SPEAKER"
echo "-----------------------------"
echo ""
cp /etc/inputrc /etc/inputrc.bak
sed -i 's|^# set bell-style none|set bell-style none|g' /etc/inputrc

echo ""
echo "----------------------------------"
echo "  CREANDO LAS REGLAS DE IPTABLES"
echo "----------------------------------"
echo ""
echo "*mangle" > /root/ReglasIPTablesIP4RouterVodafone
echo ":PREROUTING ACCEPT [0:0]" >> /root/ReglasIPTablesIP4RouterVodafone
echo ":INPUT ACCEPT [0:0]" >> /root/ReglasIPTablesIP4RouterVodafone
echo ":FORWARD ACCEPT [0:0]" >> /root/ReglasIPTablesIP4RouterVodafone
echo ":OUTPUT ACCEPT [0:0]" >> /root/ReglasIPTablesIP4RouterVodafone
echo ":POSTROUTING ACCEPT [0:0]" >> /root/ReglasIPTablesIP4RouterVodafone
echo "COMMIT" >> /root/ReglasIPTablesIP4RouterVodafone
echo "" >> /root/ReglasIPTablesIP4RouterVodafone
echo "*nat" >> /root/ReglasIPTablesIP4RouterVodafone
echo ":PREROUTING ACCEPT [0:0]" >> /root/ReglasIPTablesIP4RouterVodafone
echo ":INPUT ACCEPT [0:0]" >> /root/ReglasIPTablesIP4RouterVodafone
echo ":OUTPUT ACCEPT [0:0]" >> /root/ReglasIPTablesIP4RouterVodafone
echo ":POSTROUTING ACCEPT [0:0]" >> /root/ReglasIPTablesIP4RouterVodafone
echo "-A POSTROUTING -o ppp0 -j MASQUERADE" >> /root/ReglasIPTablesIP4RouterVodafone
echo "COMMIT" >> /root/ReglasIPTablesIP4RouterVodafone
echo "" >> /root/ReglasIPTablesIP4RouterVodafone
echo "*filter" >> /root/ReglasIPTablesIP4RouterVodafone
echo ":INPUT ACCEPT [0:0]" >> /root/ReglasIPTablesIP4RouterVodafone
echo ":FORWARD ACCEPT [0:0]" >> /root/ReglasIPTablesIP4RouterVodafone
echo ":OUTPUT ACCEPT [0:0]" >> /root/ReglasIPTablesIP4RouterVodafone
echo "-A FORWARD -i ppp0 -o $interfazcableada2 -m state --state RELATED,ESTABLISHED -j ACCEPT" >> /root/ReglasIPTablesIP4RouterVodafone
echo "-A FORWARD -i $interfazcableada2 -o ppp0 -j ACCEPT" >> /root/ReglasIPTablesIP4RouterVodafone
echo "COMMIT" >> /root/ReglasIPTablesIP4RouterVodafone

echo ""
echo "-----------------------------"
echo "  HABILITANDO IP FORWARDING"
echo "-----------------------------"
echo ""
cp /etc/sysctl.conf /etc/sysctl.conf.bak
sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf

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
echo "subnet 192.168.0.0 netmask 255.255.255.0 {" >> /etc/dhcp/dhcpd.conf
echo "  range 192.168.0.100 192.168.0.255;" >> /etc/dhcp/dhcpd.conf
echo "  option routers 192.168.0.1;" >> /etc/dhcp/dhcpd.conf
echo "  option domain-name-servers 8.8.8.8, 8.8.4.4;" >> /etc/dhcp/dhcpd.conf
echo "  default-lease-time 600;" >> /etc/dhcp/dhcpd.conf
echo "  max-lease-time 7200;" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "  host PrimeraReserva {" >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:00:01;" >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.10;" >> /etc/dhcp/dhcpd.conf
echo "  }" >> /etc/dhcp/dhcpd.conf
echo "}" >> /etc/dhcp/dhcpd.conf

echo ""
echo "Descargando archivo de nombres de fabricantes..."
echo ""
wget -O /usr/local/etc/oui.txt http://standards-oui.ieee.org/oui/oui.txt

echo ""
echo "----------------------------------------------------------------------"
echo "  FINALIZADO."
echo "  AHORA, EL CABLE ETHERNET QUE VA DEL ORDENADOR AL ROUTER SERCOMM,"
echo "  DESCONÉCTALO DEL ROUTER Y CONÉCTASELO DIRECTAMENTE A LA ONT"
echo ""
echo "  DESPUÉS DE HACERLO REINICIA EL SISTEMA EJECUTANDO:"
echo "  shutdown -r now"
echo "  Y DESPUÉS DE REINICIAR TU DEBIAN DEBERÍA ESTAR CONECTADO A LA RED"
echo "  DE VODAFONE Y YA ESTAR OPERANDO COMO ROUTER."
echo "  PODRÁS CONECTARLE AL 2DO PUERTO ETHERNET TANTO UN PUNTO DE ACCESO"
echo "  COMO UN ROUTER EN MODO PUENTE Y YA PODRÄS TENER WIFI"
echo "----------------------------------------------------------------------"
echo ""

