#!/bin/bash

## Pongo a disposición pública este script bajo el término de "software de dominio público".
## Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
## Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
## No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

##--------------------------------------------------------------
##  Script de NiPeGun para instalar el nodo Argentum en Debian
##--------------------------------------------------------------

echo ""
echo "Descargando el archivo tar.gz de la última release..."
echo ""
## Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "curl no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install curl
fi
Archivo=$(curl -s https://github.com/argentumproject/argentum/releases/ | grep linux | grep gnu | grep tar | grep href | cut -d '"' -f 2 | sed -n 1p)
rm -rf /root/Software/Binarios/Argentum/*
mkdir -p /root/Software/Binarios/Argentum/
## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "wget no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install wget
fi
wget --no-check-certificate https://github.com$Archivo -O /root/Software/Binarios/Argentum/Argentum.tar.gz

echo ""
echo "Descomprimiendo el archivo tar.gz..."
echo ""
## Comprobar si el paquete gzip está instalado. Si no lo está, instalarlo.
if [[ $(dpkg-query -s gzip 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "gzip no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install gzip
fi
tar xzvf /root/Software/Binarios/Argentum/Argentum.tar.gz --directory /root/Software/Binarios/Argentum/
rm -rf /root/Software/Binarios/Argentum/Argentum.tar.gz

echo ""
echo "Creando copia de seguridad de archivos anteriores..."
echo ""
#mkdir -p /root/CopSegArgentum/.config/autostart 2> /dev/null
## Copia de seguridad de los archivos típicos de una instalación normal
#mv /root/.config/QtProject.conf           /root/CopSegRaven/.config/
#mv /root/.config/Raven/                   /root/CopSegRaven/.config/
#mv /root/.config/autostart/raven.desktop  /root/CopSegRaven/.config/autostart/
## Copia de seguridad de las ubicaciones personalizadas
#mv /root/Cryptos/Raven/Datos/ /root/CopSegRaven/

echo ""
echo "Preparando la carpeta final..."
echo ""
find /root/Software/Binarios/Argentum/ -type d -name argentum* -exec cp -r {} /root/Cryptos/Argentum/ \;
mkdir -p /root/Cryptos/Argentum/Datos/ 2> /dev/null
rm -rf /root/Software/Binarios/Argentum/

echo ""
echo "Creando el archivo de autoejecución..."
echo ""
echo "[Desktop Entry]"                              > /root/.config/autostart/argentum.desktop
echo "Type=Application"                            >> /root/.config/autostart/argentum.desktop
echo "Name=Argentum"                               >> /root/.config/autostart/argentum.desktop
echo "Exec=/root/Cryptos/Argentum/bin/argentum-qt" >> /root/.config/autostart/argentum.desktop
echo "Terminal=false"                              >> /root/.config/autostart/argentum.desktop
echo "Hidden=false"                                >> /root/.config/autostart/argentum.desktop

echo ""
echo "Script finalizado. Encontrarás el sofware en:"
echo "/root/Cryptos/Argentum/"
echo ""
echo "Para correrlo desde la terminal, ejecuta:"
echo "/root/Cryptos/Argentum/bin/argentum-cli"
echo ""
echo "Para correrlo desde desde el entorno gráfico ejecuta:"
echo "/root/Cryptos/Argentum/bin/argentum-qt"
echo ""
echo "Es aconsejable que guardes los datos en la carpeta:"
echo "/root/Cryptos/Argentum/Datos/"
echo ""
echo "Recuerda editar el cortafuegos del ordenador para que acepte conexiones TCP en el puerto 8767."
echo "Si has instalado RavenCore en una MV de Proxmox agrega una regla a su cortauegos indicando:"
echo ""
echo "Dirección: out"
echo "Acción: ACCEPT"
echo "Protocolo: tcp"
echo "Puerto destino: 8767"
echo ""
