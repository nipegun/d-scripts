#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

-------
#  Script de NiPeGun para instalar y configurar OpenVPN
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-VPN-OpenVPN-InstalarYConfigurar.sh | bash
-------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

## Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       cNomSO=$NAME
       cVerSO=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       cNomSO=$(lsb_release -si)
       cVerSO=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       cNomSO=$DISTRIB_ID
       cVerSO=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       cNomSO=Debian
       cVerSO=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       cNomSO=$(uname -s)
       cVerSO=$(uname -r)
   fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

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
  
  echo "  COPIANDO EL CERTIFICADO Y LA LLAVE DEL SERVIDOR AL LUGAR CORRECTO"
  
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

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 9 (Stretch)..."
  
  echo ""

cCantArgsEsperados=1


if [ $# -ne $cCantArgsEsperados ]
  then
    echo ""
    
    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "  $0${cColorVerde}[IPDelServidorOpenVPN] [IPDelOrdenadorConLaAutoridadCertificadora]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo "  $0 192.168.0.10"
    echo "o"
    echo "  $0 pepe.com"
    
    echo ""
    exit
  else
    menu=(dialog --timeout 5 --checklist "Que VPN quieres instalar:" 22 76 16)
    opciones=(1 "OpenVPN con Autoridad Certificadora en la misma máquina" off
              2 "OpenVPN con Autoridad Certificadora en otra máquina" off
              3 "otra" off)
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
    clear

    for choice in $choices
      do
        case $choice in

          1)
            echo ""
            echo "Borrando archivos y configuraciones antiguas..."
            echo ""
            apt-get -y purge openvpn easy-rsa
            apt-get -y autoremove
            rm -rf /etc/openvpn
            rm -rf /root/EasyRSA
            rm -rf /root/VPN

            echo ""
            echo "Instalando OpenVPN..."
            echo ""
            aso
            apt-get -y install openvpn
            
            echo ""
            echo "Descargando EasyRSA..."
            echo ""
            wget --no-check-certificate -P /root/ https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.6/EasyRSA-unix-v3.0.6.tgz
            tar xvf /root/EasyRSA-unix-v3.0.6.tgz -C /root/
            mv /root/EasyRSA-v3.0.6 /root/EasyRSA
            
            echo ""
            echo "Preparando EasyRSA..."
            echo ""
            cd /root/EasyRSA/
            /root/EasyRSA/easyrsa init-pki
            
            echo ""
            echo "Construyendo la Autoridad Certificadora..."
            echo ""
            /root/EasyRSA/easyrsa build-ca nopass
            /root/EasyRSA/easyrsa import-req /root/EasyRSA/pki/reqs/server.req server-ca
            /root/EasyRSA/easyrsa sign-req server server-ca
            cp /root/EasyRSA/pki/ca.crt /etc/openvpn/
            cp /root/EasyRSA/pki/issued/server-ca.crt /etc/openvpn/
            
            echo ""
            echo "Generando el certificado del servidor OpenVPN"
            echo ""
            /root/EasyRSA/easyrsa gen-req server nopass
            cp /root/EasyRSA/pki/private/server.key /etc/openvpn/
            /root/EasyRSA/easyrsa sign-req server server
            cp /root/EasyRSA/pki/issued/server.crt /etc/openvpn/
            
            /root/EasyRSA/easyrsa gen-dh
            openvpn --genkey --secret ta.key
            cp /root/EasyRSA/ta.key /etc/openvpn/
            cp /root/EasyRSA/pki/dh.pem /etc/openvpn/
            mkdir -p /root/VPN/client-configs/keys
            chmod -R 700 /root/VPN/client-configs
            
            echo ""
            echo "Creando el cliente1..."
            echo ""
            /root/EasyRSA/easyrsa gen-req client1 nopass
            cp /root/EasyRSA/pki/private/client1.key /root/VPN/client-configs/keys/
            /root/EasyRSA/easyrsa sign-req client client1
            cp /root/EasyRSA/pki/issued/client1.crt /root/VPN/client-configs/keys/
            cp /root/EasyRSA/ta.key /root/VPN/client-configs/keys/
            cp /etc/openvpn/ca.crt /root/VPN/client-configs/keys/

            echo ""
            echo "Configurando el servicio..."
            echo ""
            cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz /etc/openvpn/
            gzip -d /etc/openvpn/server.conf.gz
            sed -i -e's|tls-auth ta.key 0 # This file is secret|tls-auth ta.key 0 # This file is secret\nkey-direction 0|g' /etc/openvpn/server.conf
            sed -i -e's|cipher AES-256-CBC|cipher AES-256-CBC\nauth SHA256|g' /etc/openvpn/server.conf
            sed -i -e's|dh dh2048.pem|dh dh.pem|g' /etc/openvpn/server.conf
            sed -i -e's|;user nobody|user nobody|g' /etc/openvpn/server.conf
            sed -i -e's|;group nogroup|group nogroup|g' /etc/openvpn/server.conf
            sed -i -e's|;push "redirect-gateway def1 bypass-dhcp"|push "redirect-gateway def1 bypass-dhcp"|g' /etc/openvpn/server.conf
            sed -i -e's|;push "dhcp-option DNS 208.67.222.222"|push "dhcp-option DNS 208.67.222.222"|g' /etc/openvpn/server.conf
            sed -i -e's|;push "dhcp-option DNS 208.67.220.220"|push "dhcp-option DNS 208.67.220.220"|g' /etc/openvpn/server.conf
            sed -i -e's|;log-append  openvpn.log|log-append /var/log/OpenVPN.log|g' /etc/openvpn/server.conf
            # Las siguientes dos líneas es por si se ha elegido un nombre diferente a server
            # sed -i -e's|cert server.crt|cert ServidorOpenVPN.crt|g' /etc/openvpn/server.conf
            # sed -i -e's|key server.key  # This file should be kept secret|key ServidorOpenVPN.key|g' /etc/openvpn/server.conf
            
            echo ""
            echo -e "${cColorVerde}Activando el forwarding...${cFinColor}"
            echo ""
            sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
            
            echo ""
            echo -e "${cColorVerde}Creando las reglas IPTables...${cFinColor}"
            echo ""
            echo "# OpenVPN" >> /root/ComandosIPTables
            echo "iptables -t nat-A POSTROUTING -s 10.8.0.0/8 -o eth0 -j MASQUERADE" >> /root/ComandosIPTables
            
            echo ""
            echo -e "${cColorVerde}Activando el servicio...${cFinColor}"
            echo ""
            systemctl enable openvpn
            
            echo ""
            echo -e "${cColorVerde}Creando la infraestructura de configuración de los clientes...${cFinColor}"
            echo ""
            mkdir -p /root/VPN/client-configs/files
            cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf /root/VPN/client-configs/base.conf
            sed -i -e's|remote my-server-1 1194|remote $1 1194|g' /root/VPN/client-configs/base.conf
            sed -i -e's|;user nobody|user nobody|g' /root/VPN/client-configs/base.conf
            sed -i -e's|;group nogroup|group nogroup|g' /root/VPN/client-configs/base.conf
            sed -i -e's|ca ca.crt|#ca ca.crt|g' /root/VPN/client-configs/base.conf
            sed -i -e's|cert client.crt|#cert client.crt|g' /root/VPN/client-configs/base.conf
            sed -i -e's|key client.key|#key client.key|g' /root/VPN/client-configs/base.conf
            sed -i -e's|tls-auth ta.key 1|#tls-auth ta.key 1|g' /root/VPN/client-configs/base.conf
            sed -i -e's|cipher AES-256-CBC|cipher AES-256-CBC\nauth SHA256|g' /root/VPN/client-configs/base.conf
            sed -i -e's|;mute 20|;mute 20\nkey-direction 1|g' /root/VPN/client-configs/base.conf
            echo "# script-security 2" >> /root/VPN/client-configs/base.conf
            echo "# up /etc/openvpn/update-resolv-conf" >> /root/VPN/client-configs/base.conf
            echo "# down /etc/openvpn/update-resolv-conf" >> /root/VPN/client-configs/base.conf
            
            echo ""
            echo -e "${cColorVerde}Creando el script para agregar usuarios...${cFinColor}"
            echo ""
            echo '#!/bin/bash' > /root/VPN/client-configs/make_config.sh
            echo "" >> /root/VPN/client-configs/make_config.sh
            echo "# First argument: Client identifier" >> /root/VPN/client-configs/make_config.sh
            echo "" >> /root/VPN/client-configs/make_config.sh
            echo "KEY_DIR=/root/VPN/client-configs/keys" >> /root/VPN/client-configs/make_config.sh
            echo "OUTPUT_DIR=/root/VPN/client-configs/files" >> /root/VPN/client-configs/make_config.sh
            echo "BASE_CONFIG=/root/VPN/client-configs/base.conf" >> /root/VPN/client-configs/make_config.sh
            echo "" >> /root/VPN/client-configs/make_config.sh
            echo 'cat ${BASE_CONFIG}      <(echo -e '"'"'<ca>'"'"') \' >> /root/VPN/client-configs/make_config.sh
            echo '    ${KEY_DIR}/ca.crt   <(echo -e '"'"'</ca>\n<cert>'"'"') \' >> /root/VPN/client-configs/make_config.sh
            echo '    ${KEY_DIR}/${1}.crt <(echo -e '"'"'</cert>\n<key>'"'"') \' >> /root/VPN/client-configs/make_config.sh
            echo '    ${KEY_DIR}/${1}.key <(echo -e '"'"'</key>\n<tls-auth>'"'"') \' >> /root/VPN/client-configs/make_config.sh
            echo '    ${KEY_DIR}/ta.key   <(echo -e '"'"'</tls-auth>'"'"')> \' >> /root/VPN/client-configs/make_config.sh
            echo '    ${OUTPUT_DIR}/${1}.ovpn' >> /root/VPN/client-configs/make_config.sh
            chmod 700 /root/VPN/client-configs/make_config.sh
            
            #echo ""
            #echo "Agregando usuarios con..."
            #echo ""
            #/root/VPN/client-configs/make_config.sh client1
          ;;

          2)
            echo ""
            echo "Asegúrate de haber primero ejecutado en el ordenador con la Autoridad Certificadora el archivo:"
            echo "/root/scripts/d-scripts/ÚnicaEjecución/CrearAutoridadCertificadora.sh"
            echo ""
            echo "Si NO lo has ejecutado presiona Ctrl-C"
            read -p "Si SI lo has ejecutado, presiona ENTER."
            aso
            apt-get -y install openvpn
            
            echo ""
            echo -e "${cColorRojo}Creando la entidad certificadora...${cFinColor}"
            echo ""
            wget --no-check-certificate -P /root/ https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.6/EasyRSA-unix-v3.0.6.tgz
            tar xvf /root/EasyRSA-unix-v3.0.6.tgz -C /root/
            mv /root/EasyRSA-v3.0.6 /root/EasyRSA
            cd /root/EasyRSA/
            /root/EasyRSA/easyrsa init-pki
            /root/EasyRSA/easyrsa gen-req server nopass
            cp /root/EasyRSA/pki/private/server.key /etc/openvpn/
            
            echo ""
            echo "Copiando el archivo server.req al servidor que tiene la Autoridad Certificadora"
            echo ""
            scp /root/EasyRSA/pki/reqs/server.req root@$1:/root/EasyRSA/imported/
            # si scp no funciona, prueba con rsync:
            # rsync -avz /root/EasyRSA/pki/reqs/server.req root@$1:/root/EasyRSA/imported/
            # Si rsync no funciona, entonces borra el archivo /root/.bashrc del ordenador de la CA e inténtalo de nuevo
          
          cp /root/EasyRSA/vars.example /root/EasyRSA/vars
          sed -i -e 's|#set_var EASYRSA_REQ_COUNTRY    "US"|set_var EASYRSA_REQ_COUNTRY    "ES"|g' /root/EasyRSA/vars
          sed -i -e 's|#set_var EASYRSA_REQ_PROVINCE   "California"|set_var EASYRSA_REQ_PROVINCE   "Madrid"|g' /root/EasyRSA/vars
          sed -i -e 's|#set_var EASYRSA_REQ_CITY       "San Francisco"|set_var EASYRSA_REQ_CITY       "Madrid"|g' /root/EasyRSA/vars
          sed -i -e 's|#set_var EASYRSA_REQ_ORG        "Copyleft Certificate Co"|set_var EASYRSA_REQ_ORG        "Empresa"|g' /root/EasyRSA/vars
          sed -i -e 's|#set_var EASYRSA_REQ_EMAIL      "me@example.net"|set_var EASYRSA_REQ_EMAIL      "mail@empresa.com"|g' /root/EasyRSA/vars
          sed -i -e 's|#set_var EASYRSA_REQ_OU         "My Organizational Unit"|set_var EASYRSA_REQ_OU         "Departamento"|g' /root/EasyRSA/vars
          
          /root/EasyRSA/easyrsa gen-req server nopass
          cp /root/EasyRSA/pki/reqs/server.req
            
          echo ""
          echo -e "${cColorRojo}Creando el certificado del servidor, la llave y los archivos de encriptación...${cFinColor}"
          echo ""
          cd /etc/openvpn/EasyRSA-v3.0.6/
          ./easyrsa init-pki
          ./easyrsa gen-req server nopass
          cp /etc/openvpn/EasyRSA-v3.0.6/pki/private/server.key /etc/openvpn/
           
          ;;
          
          3)
          ;;
          
        esac

  done

fi


elif [ $cVerSO == "10" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 10 (Buster)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 11 (Bullseye)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi

