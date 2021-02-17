#!/bin/bash

# Comprobar si el paquete unzip está instalado. Si no está, instalarlo.
if [ $(dpkg-query -W -f='${Status}' unzip 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    echo ""
    echo "NFTables no está instalado. Se procederá a su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install unzip
fi

Archivo=$(curl -s https://github.com/RavenProject/Ravencoin/releases/ | grep linux | grep gnu | grep zip | grep href | grep -v disable | cut -d '"' -f 2)
mkdir -p /root/CodFuente/NodoRaven/
wget --no-check-certificate https://github.com$Archivo -O /root/CodFuente/NodoRaven/NodoRaven.zip
unzip -q /root/CodFuente/NodoRaven/NodoRaven.zip -d /root/CodFuente/NodoRaven/

