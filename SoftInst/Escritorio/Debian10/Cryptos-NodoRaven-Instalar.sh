#!/bin/bash

Archivo=$(curl -s https://github.com/RavenProject/Ravencoin/releases/ | grep linux | grep gnu | grep zip | grep href | grep -v disable | cut -d '"' -f 2)
mkdir -p /root/CodFuente/NodoRaven/Binarios

echo ""
echo "Descargando el archivo zip de la última release..."
echo ""
wget --no-check-certificate https://github.com$Archivo -O /root/CodFuente/NodoRaven/NodoRaven.zip

echo ""
echo "Descomprimiendo el archivo zip..."
echo ""
# Comprobar si el paquete unzip está instalado. Si no está, instalarlo.
if [ $(dpkg-query -W -f='${Status}' unzip 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    echo ""
    echo "NFTables no está instalado. Se procederá a su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install unzip
fi
unzip /root/CodFuente/NodoRaven/NodoRaven.zip -d /root/CodFuente/NodoRaven/
rm -rf /root/CodFuente/NodoRaven/NodoRaven.zip

echo ""
echo "Descomprimiendo el archivo tar.gz de dentro del archivo zip..."
echo ""
find /root/CodFuente/NodoRaven/linux/ -type f -name *.tar.gz -exec mv {} /root/CodFuente/NodoRaven/NodoRaven.tar.gz \;
rm -rf /root/CodFuente/NodoRaven/linux/
rm -rf /root/CodFuente/NodoRaven/__MACOSX/
# Comprobar si el paquete gzip está instalado. Si no está, instalarlo.
if [ $(dpkg-query -W -f='${Status}' gzip 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    echo ""
    echo "NFTables no está instalado. Se procederá a su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install gzip
fi
tar xzvf /root/CodFuente/NodoRaven/NodoRaven.tar.gz --directory /root/CodFuente/NodoRaven/Binarios/

