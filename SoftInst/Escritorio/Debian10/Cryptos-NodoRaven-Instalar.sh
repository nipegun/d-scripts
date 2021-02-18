#!/bin/bash

# Comprobar si el paquete curl está instalado. Si no está, instalarlo.
if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "curl no está instalado. Se procederá a su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install curl
fi

Archivo=$(curl -s https://github.com/RavenProject/Ravencoin/releases/ | grep linux | grep gnu | grep zip | grep href | grep -v disable | cut -d '"' -f 2)
rm -rf /root/Software/Binarios/NodoRaven/*
mkdir -p /root/Software/Binarios/NodoRaven/

echo ""
echo "Descargando el archivo zip de la última release..."
echo ""
wget --no-check-certificate https://github.com$Archivo -O /root/Software/Binarios/NodoRaven/NodoRaven.zip

echo ""
echo "Descomprimiendo el archivo zip..."
echo ""
# Comprobar si el paquete unzip está instalado. Si no está, instalarlo.
if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "unzip no está instalado. Se procederá a su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install unzip
fi
unzip /root/Software/Binarios/NodoRaven/NodoRaven.zip -d /root/Software/Binarios/NodoRaven/
rm -rf /root/Software/Binarios/NodoRaven/NodoRaven.zip

echo ""
echo "Descomprimiendo el archivo tar.gz de dentro del archivo zip..."
echo ""
find /root/Software/Binarios/NodoRaven/linux/ -type f -name *.tar.gz -exec mv {} /root/Software/Binarios/NodoRaven/NodoRaven.tar.gz \;
rm -rf /root/Software/Binarios/NodoRaven/linux/
rm -rf /root/Software/Binarios/NodoRaven/__MACOSX/
# Comprobar si el paquete gzip está instalado. Si no está, instalarlo.
if [[ $(dpkg-query -s gzip 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "gzip no está instalado. Se procederá a su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install gzip
fi
tar xzvf /root/Software/Binarios/NodoRaven/NodoRaven.tar.gz --directory /root/Software/Binarios/NodoRaven/
rm -rf /root/Software/Binarios/NodoRaven/NodoRaven.tar.gz

echo ""
echo "Preparando la carpeta final..."
echo ""
find /root/Software/Binarios/NodoRaven/ -type d -name raven* -exec cp -r {} /root/RavenCore/ \;
mkdir -p /root/RavenCore/Blockchain/ 2> /dev/null
rm -rf /root/Software/Binarios/NodoRaven/

echo ""
echo "Script finalizado. Encontrarás tu nodo en:"
echo "/root/RavenCore/"
echo ""
echo "Para correrlo desde la terminal, ejecuta:"
echo "/root/RavenCore/bin/raven-cli"
echo ""
echo "Para correrlo desde la interfaz gráfica, desde el entorno gráfico ejecuta:"
echo "/root/RavenCore/bin/raven-qt"
echo ""
echo "Recuerda editar el cortafuegos del ordenador para que acepte conexiones"
echo "que tengan como destino el puerto 8767."
echo ""

