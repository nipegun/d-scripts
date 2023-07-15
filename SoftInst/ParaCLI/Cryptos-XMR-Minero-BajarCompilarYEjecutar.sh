#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar diferentes carteras de criptomonedas en Debian
#
# Ejecución remota normal (Se ejecuta con los cores reales que tiene el núcleo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Cryptos-XMR-Minero-BajarCompilarYEjecutar.sh | bash
# Ejecución remota personalizada (Se ejecuta con los cores que le pases como parámetro):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Cryptos-XMR-Minero-BajarCompilarYEjecutar.sh | sed 's-#vHilos=-vHilos=32-g' | bash
# ----------

vDirWallet="451K8ZpJTWdLBKb5uCR1EWM5YfCUxdgxWFjYrvKSTaWpH1zdz22JDQBQeZCw7wZjRm3wqKTjnp9NKZpfyUzncXCJ24H4Xtr"

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Notificar el inicio de ejecución del script
  echo ""
  echo -e "${ColorAzulClaro}  Iniciando el script de compilación y ejecución de XMRig...${cFinColor}"
  echo ""

# Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  git no está instalado. Iniciando su instalación..."    echo ""
    apt-get -y update
    apt-get -y install git
    echo ""
  fi

echo ""
echo "  Descargando el repositorio de XMRig..."echo ""
rm -rf ~/Cryptos/XMR/minero/
mkdir -p ~/Cryptos/XMR/
cd ~/Cryptos/XMR/
git clone https://github.com/xmrig/xmrig.git
cd xmrig

echo ""
echo "  Compilando..."echo ""
# Crear la carpeta
  mkdir build
  cd build
# Instalar el softare para poder compilar
  apt-get -y install cmake
  apt-get -y install libhwloc-dev
  apt-get -y install libuv1-dev
  apt-get -y install libssl-dev
  apt-get -y install g++
  #apt-get -y install build-essential
# Compilar
  #cmake .. -DWITH_HWLOC=OFF
  cmake ..
  make -j $(nproc)

# Preparar la carpeta del minero
  mv ~/Cryptos/XMR/xmrig/build/ ~/Cryptos/XMR/minero/
  rm -rf ~/Cryptos/XMR/xmrig/

echo ""
echo "  Creando ID para el minero..."echo ""
# A partir de la MAC WiFi
   # Obtener MAC de la WiFi
     #vDirMACwlan0=$(ip addr show wlan0 | grep link/ether | cut -d" " -f6 | sed 's/://g')
   # Generar un identificador del minero a partir de la MAC de la WiFi...
     #vIdMinero=$(echo -n $vDirMACwlan0 | md5sum | cut -d" " -f1)
# A partir del ID del procesador
  # Obtener ID del procesador
    vIdProc=$(dmidecode -t 4 | grep ID | cut -d":" -f2 | sed 's/ //g')
  # Generar un identificador del minero a partir del ID del procesador...
    vIdMinero=$(echo -n $vIdProc | md5sum | cut -d" " -f1)
# Guardar el ID del minero en un archivo de texto
   echo "$vIdMinero" > ~/Cryptos/XMR/minero/IdMinero.txt

echo ""
echo "  Creando el script para ejecutar manualmente el minero..."echo ""
echo '#!/bin/bash'                                                                                                > ~/Cryptos/XMR/minero/Minar.sh
echo ""                                                                                                          >> ~/Cryptos/XMR/minero/Minar.sh
echo 'vHilos=$(dmidecode -t processor | grep ore | grep ount | cut -d ":" -f 2 | cut -d " " -f 2)'               >> ~/Cryptos/XMR/minero/Minar.sh
echo "#vHilos=3"                                                                                                 >> ~/Cryptos/XMR/minero/Minar.sh
echo 'vIdMinero=$(cat ~/Cryptos/XMR/minero/IdMinero.txt)'                                                        >> ~/Cryptos/XMR/minero/Minar.sh
echo 'vDirWallet="'"$vDirWallet"'"'                                                                              >> ~/Cryptos/XMR/minero/Minar.sh
echo '#~/Cryptos/XMR/minero/xmrig -o ssl://xmrpool.eu:9999 --threads=$vHilos --rig-id=$vIdMinero -u $vDirWallet' >> ~/Cryptos/XMR/minero/Minar.sh
echo '#~/Cryptos/XMR/minero/xmrig -o xmrpool.eu:3333 --threads=$vHilos --rig-id=$vIdMinero -u $vDirWallet'       >> ~/Cryptos/XMR/minero/Minar.sh
echo '~/Cryptos/XMR/minero/xmrig -o xmrpool.eu:9999 --threads=$vHilos --rig-id=$vIdMinero -u $vDirWallet --tls'  >> ~/Cryptos/XMR/minero/Minar.sh
chmod +x  ~/Cryptos/XMR/minero/Minar.sh

echo ""
echo "  Creando el script para ejecutar manualmente el minero en background..."echo ""
echo '#!/bin/bash'                                                                                                             > ~/Cryptos/XMR/minero/MinarEnBackground.sh
echo ""                                                                                                                       >> ~/Cryptos/XMR/minero/MinarEnBackground.sh
echo 'vHilos=$(dmidecode -t processor | grep ore | grep ount | cut -d ":" -f 2 | cut -d " " -f 2)'                            >> ~/Cryptos/XMR/minero/MinarEnBackground.sh
echo "#vHilos=3"                                                                                                              >> ~/Cryptos/XMR/minero/MinarEnBackground.sh
echo 'vIdMinero=$(cat ~/Cryptos/XMR/minero/IdMinero.txt)'                                                                     >> ~/Cryptos/XMR/minero/MinarEnBackground.sh
echo 'vDirWallet="'"$vDirWallet"'"'                                                                                           >> ~/Cryptos/XMR/minero/MinarEnBackground.sh
echo '#~/Cryptos/XMR/minero/xmrig -o ssl://xmrpool.eu:9999 --threads=$vHilos --rig-id=$vIdMinero -u $vDirWallet --background' >> ~/Cryptos/XMR/minero/MinarEnBackground.sh
echo '#~/Cryptos/XMR/minero/xmrig -o xmrpool.eu:3333 --threads=$vHilos --rig-id=$vIdMinero -u $vDirWallet --background'       >> ~/Cryptos/XMR/minero/MinarEnBackground.sh
echo '~/Cryptos/XMR/minero/xmrig -o xmrpool.eu:9999 --threads=$vHilos --rig-id=$vIdMinero -u $vDirWallet --tls --background'  >> ~/Cryptos/XMR/minero/MinarEnBackground.sh
chmod +x  ~/Cryptos/XMR/minero/MinarEnBackground.sh

echo ""
echo "  Minando con ID $vIdMinero..."echo ""
~/Cryptos/XMR/minero/Minar.sh

