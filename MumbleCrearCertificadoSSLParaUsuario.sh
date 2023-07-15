#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear certificado SSL para un usuario de mumble-server
# ----------

cCantArgumEsperados=2


cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $cCantArgsEsperados ]
  then
    echo ""
    
    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "MumbleCrearCertificadoSSLParaUsuario ${cColorVerde}[NombreDeUsuario] [MailDeUsuario]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo ' MumbleCrearCertificadoSSLParaUsuario pepito70 pepito70@nipegun.com'
    
    echo ""
    exit
  else
    echo ""
    echo "  Instalando los paquetes necesarios..."
    echo ""
    apt-get -y install openssl ssl-cert

    echo ""
    echo "  Creando la carpeta para los certificados (si es que no existe)..."
    echo ""
    mkdir -p /root/Mumble/CertificadosSSL/

    echo ""
    echo "  Borrando el certificado viejo (si es que existe)..."
    echo ""
    rm -f /root/Mumble/CertificadosSSL/$1*

    echo "  Creando el certificado..."
    echo ""
    openssl req -x509 -nodes -days 3650 -newkey rsa:4096 -out /root/Mumble/CertificadosSSL/$1.pem -keyout /root/Mumble/CertificadosSSL/$1.key

    echo ""
    echo "  Convirtiendo el certificado al formato PKCS12..."
    echo ""
    openssl pkcs12 -export -in /root/Mumble/CertificadosSSL/$1.pem -inkey /root/Mumble/CertificadosSSL/$1.key -certfile /root/Mumble/CertificadosSSL/$1.pem -out /root/Mumble/CertificadosSSL/$1.p12

    echo ""
    echo "  Borrando los archivos .key y .pem..."
    echo ""
    rm -f /root/Mumble/CertificadosSSL/$1.pem
    rm -f /root/Mumble/CertificadosSSL/$1.key

    echo ""
    echo "  Enviando el certificado en formato PKCS12 al usuario..."
    echo ""
    
fi

