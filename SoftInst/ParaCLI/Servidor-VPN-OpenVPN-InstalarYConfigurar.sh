#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA INSTALAR Y CONFIGURAR OPENVPN
#--------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

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
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  apt-get -y update
  apt-get -y install openvpn
  gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > /etc/openvpn/server.conf
  sed -i -e 's|dh dh1024.pem|dh dh2048.pem|g' /etc/openvpn/server.conf
  sed -i -e 's|;push "redirect-gateway def1 bypass-dhcp"|push "redirect-gateway def1 bypass-dhcp"|g' /etc/openvpn/s$
  sed -i -e 's|;push "dhcp-option DNS 208.67.222.222"|push "dhcp-option DNS 1.1.1.1"|g' /etc/openvpn/server.$
  sed -i -e 's|;push "dhcp-option DNS 208.67.220.220"|push "dhcp-option DNS 1.0.0.1"|g' /etc/openvpn/server.$
  sed -i -e 's|;user nobody|user nobody|g' /etc/openvpn/server.conf
  sed -i -e 's|;group nogroup|group nogroup|g' /etc/openvpn/server.conf

  echo ""
  echo "-----------------------------------------------"
  echo "  ACTIVANDO EL REDIRECCIONAMIENTO DE PAQUETES"
  echo "-----------------------------------------------"
  echo ""
  sleep 2
  echo 1 > /proc/sys/net/ipv4/ip_forward
  sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf

  echo "-----------------------------------------------------"
  echo "  CREANDO Y CONFIGURANDO LA AUTORIDAD CERTIFICADORA"
  echo "-----------------------------------------------------"
  echo ""
  sleep 2
  apt-get -y install easy-rsa
  cp -r /usr/share/easy-rsa/ /etc/openvpn/
  mkdir /etc/openvpn/easy-rsa/keys/
  sed -i -e 's|export KEY_COUNTRY="US"|export KEY_COUNTRY="ES"|g' /etc/openvpn/easy-rsa/vars
  sed -i -e 's|export KEY_PROVINCE="CA"|export KEY_PROVINCE="Madrid"|g' /etc/openvpn/easy-rsa/vars
  sed -i -e 's|export KEY_CITY="SanFrancisco"|export KEY_CITY="Madrid"|g' /etc/openvpn/easy-rsa/vars
  sed -i -e 's|export KEY_ORG="Fort-Funston"|export KEY_ORG="VPN"|g' /etc/openvpn/easy-rsa/vars
  sed -i -e 's|export KEY_EMAIL="me@myhost.mydomain"|export KEY_EMAIL="vpn@gmail.com"|g' /etc/openvpn/easy-rsa/vars
  sed -i -e 's|export KEY_OU="MyOrganizationalUnit"|export KEY_OU="VPN"|g' /etc/openvpn/easy-rsa/vars
  sed -i -e 's|export KEY_NAME="EasyRSA"|export KEY_NAME="OpenVPN"|g' /etc/openvpn/easy-rsa/vars

  echo ""
  echo "------------------------------------------"
  echo "  GENERANDO EL CERTIFICADO Diffie-Helman"
  echo ""
  echo "  Puede tardar bastantes minutos."
  echo "------------------------------------------"
  echo ""
  sleep 2
  openssl dhparam -out /etc/openvpn/dh2048.pem 2048

  echo ""
  echo "-----------------------------------------"
  echo "            GENERANDO LA CLAVE"
  echo ""
  echo "  No hace falta que rellenes los datos."
  echo "  Cuando te pregunte, simplemente dale"
  echo "  todo a [Enter]."
  echo "-----------------------------------------"
  echo ""
  sleep 2
  cd /etc/openvpn/easy-rsa
  . ./vars
  ./clean-all
  ./build-ca

  echo ""
  echo "--------------------------------------------------------"
  echo "  GENERANDO EL CERTIFICADO Y LA LLAVE PARA EL SERVIDOR"
  echo ""
  echo "  Dale 10 veces a [Enter] cuando te lo pida y luego"
  echo "  [y] [Enter] e [y] [Enter] otra vez."
  echo "--------------------------------------------------------"
  echo ""
  sleep 2
  ./build-key-server OpenVPN

  echo ""
  echo "---------------------------------------------------------------------"
  echo "  COPIANDO EL CERTIFICADO Y LA LLAVE DEL SERVIDOR AL LUGAR CORRECTO"
  echo "---------------------------------------------------------------------"
  echo ""
  sleep 2
  cp /etc/openvpn/easy-rsa/keys/{OpenVPN.crt,OpenVPN.key,ca.crt} /etc/openvpn

  echo ""
  echo "------------------------------------"
  echo "   ARRANCANDO EL SERVIDOR OPENVPN"
  echo ""
  echo "  Al terminar deberías ver algo así:"
  echo ""
  echo "  Active: active (exited) since..."
  echo ""
  echo "  en vez de:"
  echo ""
  echo "  Active: Inactive (dead) since..."
  echo "------------------------------------"
  echo ""
  sleep 2
  service openvpn start
  service openvpn status

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 9 (Stretch)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 10 (Buster)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 11 (Bullseye)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi

