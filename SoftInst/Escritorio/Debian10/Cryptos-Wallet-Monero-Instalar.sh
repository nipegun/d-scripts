#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------
#  Script de NiPeGun para instalar Monero en Debian
#-------------------------------------------------------

echo ""
echo "Descargando el archivo comprimido de la última release..."
echo ""
# Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "wget no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install wget
fi
mkdir -p /root/Software/Binarios/Monero/ 2> /dev/null
rm -rf /root/Software/Binarios/Monero/*
wget https://downloads.getmonero.org/gui/linux64 -O /root/Software/Binarios/Monero/monero.tar.bz2

echo ""
echo "Descomprimiendo el archivo..."
echo ""
# Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "tar no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install tar
fi
tar xjfv /root/Software/Binarios/Monero/monero.tar.bz2 -C /root/Software/Binarios/Monero/
rm -rf /root/Software/Binarios/Monero/monero.tar.bz2

echo ""
echo "Preparando la carpeta final..."
echo ""
find /root/Software/Binarios/Monero/ -type d -name monero* -exec cp -r {} /root/Cryptos/Monero/ \;
mkdir -p /root/Cryptos/Monero/blockchain/ 2> /dev/null
rm -rf /root/Software/Binarios/Monero/

echo ""
echo "Script finalizado. Encontrarás el sofware en:"
echo "/root/Cryptos/Monero/"
echo ""
echo "Para correrlo desde la terminal, ejecuta:"
echo "/root/Cryptos/Monero/bin/"
echo ""
echo "Para correrlo desde desde el entorno gráfico ejecuta:"
echo "/root/Cryptos/Monero/bin/"
echo ""
echo "Es aconsejable que guardes la cadena de bloques en la carpeta:"
echo "/root/Cryptos/Monero/blockchain/"
echo ""
echo "Recuerda editar el cortafuegos del ordenador para que acepte conexiones TCP en el puerto 8767."
echo "Si has instalado RavenCore en una MV de Proxmox agrega una regla a su cortauegos indicando:"
echo ""
echo "Dirección: out"
echo "Acción: ACCEPT"
echo "Protocolo: tcp"
echo "Puerto destino: 8767"
echo ""
