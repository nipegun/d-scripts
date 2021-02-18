#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------
#  Script de NiPeGun para instalar RavenCore en Debian
#-------------------------------------------------------

echo ""
echo "Descargando el archivo zip de la última release..."
echo ""
# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "curl no está instalado. Se procederá a su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install curl
fi
Archivo=$(curl -s https://github.com/RavenProject/Ravencoin/releases/ | grep linux | grep gnu | grep zip | grep href | grep -v disable | cut -d '"' -f 2)
rm -rf /root/Software/Binarios/Raven/*
mkdir -p /root/Software/Binarios/Raven/
wget --no-check-certificate https://github.com$Archivo -O /root/Software/Binarios/Raven/Raven.zip

echo ""
echo "Descomprimiendo el archivo zip..."
echo ""
# Comprobar si el paquete unzip está instalado. Si no lo está, instalarlo.
if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "unzip no está instalado. Se procederá a su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install unzip
fi
unzip /root/Software/Binarios/Raven/Raven.zip -d /root/Software/Binarios/Raven/
rm -rf /root/Software/Binarios/Raven/Raven.zip

echo ""
echo "Descomprimiendo el archivo tar.gz de dentro del archivo zip..."
echo ""
# Comprobar si el paquete gzip está instalado. Si no lo está, instalarlo.
if [[ $(dpkg-query -s gzip 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "gzip no está instalado. Se procederá a su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install gzip
fi
find /root/Software/Binarios/Raven/linux/ -type f -name *.tar.gz -exec mv {} /root/Software/Binarios/Raven/Raven.tar.gz \;
rm -rf /root/Software/Binarios/Raven/linux/
rm -rf /root/Software/Binarios/Raven/__MACOSX/
tar xzvf /root/Software/Binarios/Raven/Raven.tar.gz --directory /root/Software/Binarios/Raven/
rm -rf /root/Software/Binarios/Raven/Raven.tar.gz

echo ""
echo "Preparando la carpeta final..."
echo ""
find /root/Software/Binarios/Raven/ -type d -name raven* -exec cp -r {} /root/RavenCore/ \;
mkdir -p /root/RavenCore/Blockchain/ 2> /dev/null
rm -rf /root/Software/Binarios/Raven/

echo ""
echo "Script finalizado. Encontrarás el sofware en:"
echo "/root/RavenCore/"
echo ""
echo "Para correrlo desde la terminal, ejecuta:"
echo "/root/RavenCore/bin/raven-cli"
echo ""
echo "Para correrlo desde la interfaz gráfica, desde el entorno gráfico ejecuta:"
echo "/root/RavenCore/bin/raven-qt"
echo ""
echo "Recuerda editar el cortafuegos del ordenador para que acepte conexiones TCP en el puerto 8767."
echo ""
echo "Si has instalado RavenCore en una MV de Proxmox agrega una regla a su cortauegos indicando:"
echo ""
echo "Dirección: out"
echo "Acción: ACCEPT"
echo "Protocolo: tcp"
echo "Puerto destino: 8767"
echo ""

