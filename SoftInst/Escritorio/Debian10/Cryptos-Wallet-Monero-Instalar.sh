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
echo "Creando copia de seguridad de archivos anteriores..."
echo ""
mkdir -p /root/CopSegMonero/.config/ 2> /dev/null
mv /root/.config/monero-project/         /root/CopSegMonero/.config/
mv /root/Monero/                         /root/CopSegMonero/
mv /root/monero-storage/                 /root/CopSegMonero/
mv /root/.bitmonero/                     /root/CopSegMonero/
mv /root/Cryptos/Monero/CadenaDeBloques/ /root/CopSegMonero/
mv /root/Cryptos/Monero/Carteras/        /root/CopSegMonero/

echo ""
echo "Preparando la carpeta final..."
echo ""
mkdir -p /root/Cryptos/Monero/CadenaDeBloques/ 2> /dev/null
mkdir -p /root/Cryptos/Monero/Carteras/ 2> /dev/null
find /root/Software/Binarios/Monero/ -type d -name monero* -exec cp -r {}/. /root/Cryptos/Monero/ \;
rm -rf /root/Software/Binarios/Monero/
mkdir -p /root/.config/monero-project/ 2> /dev/null
echo "[General]"                                               > /root/.config/monero-project/monero-core.conf
echo "account_name=root"                                      >> /root/.config/monero-project/monero-core.conf
echo "askPasswordBeforeSending=true"                          >> /root/.config/monero-project/monero-core.conf
echo "autosave=true"                                          >> /root/.config/monero-project/monero-core.conf
echo "autosaveMinutes=10"                                     >> /root/.config/monero-project/monero-core.conf
echo "blackTheme=true"                                        >> /root/.config/monero-project/monero-core.conf
echo "blockchainDataDir=/root/Cryptos/Monero/CadenaDeBloques" >> /root/.config/monero-project/monero-core.conf
echo "checkForUpdates=true"                                   >> /root/.config/monero-project/monero-core.conf
echo "customDecorations=true"                                 >> /root/.config/monero-project/monero-core.conf
echo "fiatPriceEnabled=true"                                  >> /root/.config/monero-project/monero-core.conf
echo "fiatPriceProvider=kraken"                               >> /root/.config/monero-project/monero-core.conf
echo "language=Espa\xf1ol"                                    >> /root/.config/monero-project/monero-core.conf
echo "language_wallet=Espa\xf1ol"                             >> /root/.config/monero-project/monero-core.conf
echo "locale=es_ES"                                           >> /root/.config/monero-project/monero-core.conf
echo "lockOnUserInActivity=true"                              >> /root/.config/monero-project/monero-core.conf
echo "lockOnUserInActivityInterval=1"                         >> /root/.config/monero-project/monero-core.conf
echo "transferShowAdvanced=true"                              >> /root/.config/monero-project/monero-core.conf
echo "useRemoteNode=false"                                    >> /root/.config/monero-project/monero-core.conf
echo "walletMode=2"                                           >> /root/.config/monero-project/monero-core.conf

echo ""
echo "Script finalizado. Encontrarás el sofware en:"
echo "/root/Cryptos/Monero/"
echo ""
echo "Para correrlo desde desde el entorno gráfico ejecuta:"
echo "/root/Cryptos/Monero/monero-wallet-gui"
echo ""
echo "Es aconsejable que guardes la cadena de bloques en la carpeta:"
echo "/root/Cryptos/Monero/CadenaDeBloques/"
echo "y las carteras en la carpeta:"
echo "/root/Cryptos/Monero/Carteras/"
echo ""
echo "Recuerda editar el cortafuegos del ordenador para que acepte conexiones TCP en el puerto 18080."
echo "Si has instalado Monero en una MV de Proxmox agrega una regla a su cortauegos indicando:"
echo ""
echo "Dirección: out"
echo "Acción: ACCEPT"
echo "Protocolo: tcp"
echo "Puerto destino: 18080"
echo ""

