#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

-----
# Script de NiPeGun para instalar y configurar el servidor VPN IKEv2 en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-VPN-IKEv2-InstalarYConfigurar.sh | bash
-----

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 9 (Stretch)..."  
  echo ""

cCantArgumEsperados=1


if [ $# -ne $cCantArgsEsperados ]
  then
    echo ""
    
    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "  $0${cColorVerde}[DominioOIPDelOrdenador]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo "  $0 pepe"
    
    echo ""
    exit
  else
    menu=(dialog --timeout 5 --checklist "Que VPN quieres instalar:" 22 76 16)
    opciones=(
  1 "IKEv2 basada en IP" off
              2 "IKEv2 basada en nombre de dominio" off
              3 "IKEv2 basada en nombre de dominio con LetsEncrypt" off
)
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
    clear

    for choice in $choices
      do
        case $choice in

          1)
            apt-get -y update
            apt-get -y install strongswan strongswan-pki
            mkdir -p /root/pki/{cacerts,certs,private}
            chmod 700 /root/pki
            ipsec pki --gen --type rsa --size 4096 --outform pem > /root/pki/private/ca-key.pem
            ipsec pki --self --ca --lifetime 3650 --in /root/pki/private/ca-key.pem --type rsa --dn "CN=StrongSwan" --outform pem > /root/pki/cacerts/ca-cert.pem
            ipsec pki --gen --type rsa --size 4096 --outform pem > /root/pki/private/server-key.pem
            ipsec pki --pub --in /root/pki/private/server-key.pem --type rsa | ipsec pki --issue --lifetime 1825 --cacert /root/pki/cacerts/ca-cert.pem --cakey /root/pki/private/ca-key.pem --dn "CN=$1" --san "$1" --flag serverAuth --flag ikeIntermediate --outform pem > /root/pki/certs/server-cert.pem
            cp -r /root/pki/* /etc/ipsec.d/
            
            echo ""
            echo -e "${cColorRojo}Haciendo cambios en el archivo de configuración...${cFinColor}"
            echo ""
            mv /etc/ipsec.conf{,.original}
            echo "config setup" > /etc/ipsec.conf
            echo '  charondebug="ike 1, knl 1, cfg 0"' >> /etc/ipsec.conf
            echo "  uniqueids=no" >> /etc/ipsec.conf
            echo "conn ikev2-vpn" >> /etc/ipsec.conf
            echo "  auto=add" >> /etc/ipsec.conf
            echo "  compress=no" >> /etc/ipsec.conf
            echo "  type=tunnel" >> /etc/ipsec.conf
            echo "  keyexchange=ikev2" >> /etc/ipsec.conf
            echo "  fragmentation=yes" >> /etc/ipsec.conf
            echo "  forceencaps=yes" >> /etc/ipsec.conf
            echo "  dpdaction=clear" >> /etc/ipsec.conf
            echo "  dpddelay=300s" >> /etc/ipsec.conf
            echo "  rekey=no" >> /etc/ipsec.conf
            echo "" >> /etc/ipsec.conf
            echo "  # Lado del servidor" >> /etc/ipsec.conf
            echo "  left=%any" >> /etc/ipsec.conf
            echo "  leftid=$1" >> /etc/ipsec.conf # Si es dominio va con la arroba, si es IP sin la arroba.
            echo "  leftcert=server-cert.pem" >> /etc/ipsec.conf
            echo "  leftsendcert=always" >> /etc/ipsec.conf
            echo "  leftsubnet=0.0.0.0/0" >> /etc/ipsec.conf
            echo "" >> /etc/ipsec.conf
            echo "  # Lado del cliente" >> /etc/ipsec.conf
            echo "  right=%any" >> /etc/ipsec.conf
            echo "  rightid=%any" >> /etc/ipsec.conf
            echo "  rightauth=eap-mschapv2" >> /etc/ipsec.conf
            echo "  rightsourceip=10.10.10.0/24" >> /etc/ipsec.conf # Subnet asignada a los clientes
            echo "  rightdns=1.1.1.1,1.0.0.1" >> /etc/ipsec.conf
            echo "  rightsendcert=never" >> /etc/ipsec.conf
            echo "  eap_identity=%identity" >> /etc/ipsec.conf

            echo ""
            echo -e "${cColorRojo}Configurando los usuarios...${cFinColor}"
            echo ""
            echo ': RSA "server-key.pem"' >> /etc/ipsec.secrets
            echo 'usuario : EAP "password"' >> /etc/ipsec.secrets
            echo ""
            echo "Se ha creado un usuario de prueba llamado: usuario"
            echo "Su clave es: password"
            echo ""
            echo "Si quieres agregar o modificar usuarios, modifica el archivo /etc/ipsec.secrets"
            
            echo ""
            echo -e "${cColorRojo}Re-leyendo los cambios hechos en los usuarios...${cFinColor}"
            echo ""
            ipsec rereadsecrets

            echo ""
            echo -e "${cColorRojo}Modificando strongswan.conf para activar los logs...${cFinColor}"
            echo ""
            cp /etc/strongswan.conf /etc/strongswan.conf.bak
            touch /var/log/StrongSwan.log
            echo "charon {" > /etc/strongswan.conf
            echo "" >> /etc/strongswan.conf
            echo "  load_modular = yes" >> /etc/strongswan.conf
            echo "" >> /etc/strongswan.conf
            echo "  plugins {" >> /etc/strongswan.conf
            echo "    include strongswan.d/charon/*.conf" >> /etc/strongswan.conf
            echo "  }" >> /etc/strongswan.conf
            echo "" >> /etc/strongswan.conf
            echo "  filelog {" >> /etc/strongswan.conf
            echo "    /var/log/StrongSwan.log {" >> /etc/strongswan.conf
            echo "      time_format = %Y-%m-%dT%T%z" >> /etc/strongswan.conf
            echo "      append = yes" >> /etc/strongswan.conf
            echo "      default = 1" >> /etc/strongswan.conf
            echo "      flush_line = yes" >> /etc/strongswan.conf
            echo "    }" >> /etc/strongswan.conf
            echo "  }" >> /etc/strongswan.conf
            echo "" >> /etc/strongswan.conf
            echo "}" >> /etc/strongswan.conf
            echo "" >> /etc/strongswan.conf
            echo "include strongswan.d/*.conf" >> /etc/strongswan.conf

            echo ""
            echo -e "${cColorRojo}Reiniciando StrongSwan...${cFinColor}"
            echo ""
            systemctl restart strongswan
            
            echo ""
            echo -e "${cColorRojo}Preparando el certificado para importar en los dispositivos...${cFinColor}"
            echo ""
            mkdir /root/VPN
            cp /etc/ipsec.d/cacerts/ca-cert.pem /root/VPN/CertificadoVPN.pem
            echo "Certificado listo. Lo puedes encontrar en /root/VPN/CertificadoVPN.pem"
            echo ""
            echo "Su contenido es:"
            cat /root/VPN/CertificadoVPN.pem
            echo ""
            
            echo ""
            echo -e "${cColorRojo}Activando el forwarding...${cFinColor}"
            echo ""
            sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf

            echo ""
            echo -e "${cColorRojo}Creando los comandos para IPTables...${cFinColor}"
            echo ""
            echo "iptables -A INPUT -p udp --dport 500 -j ACCEPT" >> /root/ComandosIPTables
            echo "iptables -A INPUT -p udp --dport 4500 -j ACCEPT" >> /root/ComandosIPTables
            echo "iptables -A INPUT -p 50 -j ACCEPT" >> /root/ComandosIPTables
            echo "iptables -A INPUT -p 51 -j ACCEPT" >> /root/ComandosIPTables
            echo "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" >> /root/ComandosIPTables
            
          ;;

          2)
            apt-get -y update
            apt-get -y install strongswan strongswan-pki
            mkdir -p /root/pki/{cacerts,certs,private}
            chmod 700 /root/pki
            ipsec pki --gen --type rsa --size 4096 --outform pem > /root/pki/private/ca-key.pem
            ipsec pki --self --ca --lifetime 3650 --in /root/pki/private/ca-key.pem --type rsa --dn "CN=VPN root CA" --outform pem > /root/pki/cacerts/ca-cert.pem
            ipsec pki --gen --type rsa --size 4096 --outform pem > /root/pki/private/server-key.pem
            ipsec pki --pub --in /root/pki/private/server-key.pem --type rsa | ipsec pki --issue --lifetime 1825 --cacert /root/pki/cacerts/ca-cert.pem --cakey /root/pki/private/ca-key.pem --dn "CN=$1" --san "$1" --flag serverAuth --flag ikeIntermediate --outform pem > /root/pki/certs/server-cert.pem
            cp -r /root/pki/* /etc/ipsec.d/
            mv /etc/ipsec.conf{,.original}
            echo "config setup" > /etc/ipsec.conf
            echo '  charondebug="ike 1, knl 1, cfg 0"' >> /etc/ipsec.conf
            echo "  uniqueids=no" >> /etc/ipsec.conf
            echo "conn ikev2-vpn" >> /etc/ipsec.conf
            echo "  auto=add" >> /etc/ipsec.conf
            echo "  compress=no" >> /etc/ipsec.conf
            echo "  type=tunnel" >> /etc/ipsec.conf
            echo "  keyexchange=ikev2" >> /etc/ipsec.conf
            echo "  fragmentation=yes" >> /etc/ipsec.conf
            echo "  forceencaps=yes" >> /etc/ipsec.conf
            echo "  dpdaction=clear" >> /etc/ipsec.conf
            echo "  dpddelay=300s" >> /etc/ipsec.conf
            echo "  rekey=no" >> /etc/ipsec.conf
            echo "  left=%any" >> /etc/ipsec.conf
            echo "  leftid=@$1" >> /etc/ipsec.conf # Si es dominio va con la arroba, si es IP sin la arroba.
            echo "  leftcert=server-cert.pem" >> /etc/ipsec.conf
            echo "  leftsendcert=always" >> /etc/ipsec.conf
            echo "  leftsubnet=0.0.0.0/0" >> /etc/ipsec.conf
            echo "  right=%any" >> /etc/ipsec.conf
            echo "  rightid=%any" >> /etc/ipsec.conf
            echo "  rightauth=eap-mschapv2" >> /etc/ipsec.conf
            echo "  rightsourceip=10.10.10.0/24" >> /etc/ipsec.conf
            echo "  rightdns=1.1.1.1,1.0.0.1" >> /etc/ipsec.conf
            echo "  rightsendcert=never" >> /etc/ipsec.conf
            echo "  eap_identity=%identity" >> /etc/ipsec.conf
            echo ""
            echo "Configurando los usuarios..."
            echo ""
            echo ': RSA "server-key.pem"' >> /etc/ipsec.secrets
            echo 'usuarioprueba : EAP "passwordprueba"' >> /etc/ipsec.secrets
            echo ""
            echo "Se ha creado un usuario de prueba llamado: usuarioprueba"
            echo "Su clave es: passwordprueba"
            echo ""
            echo "Si quieres agregar o modificar usuarios, modifica el archivo /etc/ipsec.secrets"
            echo ""
            echo ""
            echo "Activando el forwarding..."
            echo ""
            sed -i -e 's|# net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
            echo ""
            echo "Creando los comandos para IPTables..."
            echo ""
            echo "iptables -A INPUT -p udp --dport 500 -j ACCEPT" >> /root/ComandosIPTables
            echo "iptables -A INPUT -p udp --dport 4500 -j ACCEPT" >> /root/ComandosIPTables
            echo "iptables -A INPUT -p 50 -j ACCEPT" >> /root/ComandosIPTables
            echo "iptables -A INPUT -p 51 -j ACCEPT" >> /root/ComandosIPTables
            echo "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" >> /root/ComandosIPTables
            echo ""
            echo "Reiniciando StrongSwan..."
            echo ""
            systemctl restart strongswan
          ;;

          3)
            apt-get update
            apt-get -y install strongswan libcharon-extra-plugins
            apt-get -y install build-essential gcc make git
            mkdir /root/git/
            cd /root/git/
            git clone https://github.com/letsencrypt/letsencrypt
            cd /root/git/letsencrypt
            iptables -A INPUT -p tcp --dport 443 -j ACCEPT
            service apache2 stop
            /root/git/letsencrypt/letsencrypt-auto certonly --standalone
            cp /etc/letsencrypt/live/ejemplodedominio.com/fullchain.pem /etc/ipsec.d/certs/
            cp /etc/letsencrypt/live/ejemplodedominio.com/privkey.pem /etc/ipsec.d/private/
            ipsec listall
            echo "" > /etc/ipsec.conf
            echo "config setup" >> /etc/ipsec.conf
            echo ""
            echo "conn %default" >> /etc/ipsec.conf
            echo "    keyexchange=ikev2" >> /etc/ipsec.conf
            echo "    auto=add" >> /etc/ipsec.conf
            echo ""
            echo "    # LADO DEL SERVIDOR" >> /etc/ipsec.conf
            echo "    leftid=dominioejemplo.com" >> /etc/ipsec.conf
            echo "    leftcert=fullchain.pem # Nombre del certificado ubicado en /etc/ipsec.d/certs/" >> /etc/ipsec.conf
            echo "    leftsubnet=0.0.0.0/0  # Routes pushed to clients." >> /etc/ipsec.conf
            echo "    leftsendcert=always" >> /etc/ipsec.conf
            echo ""
            echo "    # LADO DEL CLIENTE" >> /etc/ipsec.conf
            echo "    right=%any" >> /etc/ipsec.conf
            echo "    rightsourceip=10.11.12.0/24 # Subnet asignada a los clientes" >> /etc/ipsec.conf
            echo "    rightdns=1.1.1.1" >> /etc/ipsec.conf
            echo "    dpdaction=clear" >> /etc/ipsec.conf
            echo "    eap_identity=%identity" >> /etc/ipsec.conf
            echo ""
            echo "# CLIENTES" >> /etc/ipsec.conf
            echo "conn ikev2-mschapv2" >> /etc/ipsec.conf
            echo "    rightauth=eap-mschapv2" >> /etc/ipsec.conf
            echo "" >> /etc/ipsec.conf
            echo ": RSA privkey.pem" /etc/ipsec.secrets
            echo 'usuario1 : EAP "clave"' /etc/ipsec.secrets
            ipsec rereadsecrets
            sed -i -e 's|# net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
            echo "iptables -A INPUT -p udp --dport 500 -j ACCEPT" >> /root/ComandosIPTables
            echo "iptables -A INPUT -p udp --dport 4500 -j ACCEPT" >> /root/ComandosIPTables
            echo "iptables -A INPUT -p 50 -j ACCEPT" >> /root/ComandosIPTables
            echo "iptables -A INPUT -p 51 -j ACCEPT" >> /root/ComandosIPTables
            echo "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" >> /root/ComandosIPTables
            echo ""
            echo "Activando el servicio strongswan..."
            echo ""
            systemctl enable strongswan
            echo ""
            echo "Reiniciando el sistema..."
            echo ""
            shutdown -r now
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
