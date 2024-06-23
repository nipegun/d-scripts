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
  echo -e "${cColorAzulClaro}  Iniciando el script de compilación y ejecución de XMRig...${cFinColor}"
  echo ""

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    echo ""
    exit
  fi

# Matar todos los procesos de xmrig
  echo ""
  echo "  Matando el proceso xmrig (si es que se está ejecutando)..."
  echo ""
  # Comprobar si el paquete psmisc instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s psmisc 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete psmisc no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install psmisc
      echo ""
    fi
  killall -9 xmrig

# Descargar el repositorio
  echo ""
  echo "    Descargando el repositorio de XMRig..."
  echo ""
  rm -rf ~/Cryptos/XMR/Minero/
  mkdir -p ~/Cryptos/XMR/
  cd ~/Cryptos/XMR/
  # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo "    El paquete git no está instalado. Iniciando su instalación..."
      echo ""
      apt-get -y update
      apt-get -y install git
      echo ""
    fi
  git clone https://github.com/xmrig/xmrig.git
  cd xmrig

# Compilar
  echo ""
  echo "    Compilando..."
  echo ""
  # Crear la carpeta
    mkdir build
    cd build
  # Instalar el softare para poder compilar
    apt-get -y update
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
  echo ""
  echo "    Preparando la carpeta del minero..."
  echo ""
  mv ~/Cryptos/XMR/xmrig/build/ ~/Cryptos/XMR/Minero/
  rm -rf ~/Cryptos/XMR/xmrig/

# Crear ID para el minero
  echo ""
  echo "    Creando ID para el minero..."
  echo ""
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
     echo "$vIdMinero" > ~/Cryptos/XMR/Minero/IdMinero.txt

# Obtener el número de sockets
  echo ""
  echo "    Obteniendo el número de sockets..."
  echo ""
  # comprobar que util-linux esté instalado
    if [[ $(dpkg-query -s "util-linux" 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo "      El paquete util-linux no está instalado. Iniciando su instalación..."
      echo ""
      apt-get -y update
      apt-get -y install util-linux
      echo ""
    fi
  vCantSockets=$(lscpu | grep ocket | grep -v "ocket»" | cut -d':' -f2 | sed 's- --g')
  echo "    La cantidad de sockets es: $vCantSockets."
  echo ""

# Obtener el número de cores
  echo ""
  echo "    Obteniendo el número de cores..."
  echo ""
  vCantCores=$(lscpu | grep "ocket»" | cut -d':' -f2 | sed 's- --g')
  echo "    La cantidad de cores es: $vCantCores."
  echo ""

# Obtener el número de hilos
  echo ""
  echo "    Obteniendo el número de hilos..."
  echo ""
  vCantHilosPorCore=$(lscpu | grep ilo | cut -d':' -f2| sed 's- --g')
  #vCantTotalDeHilos=$(echo "$vCantHilosPorCore * $vCantCores" | bc)
  vCantTotalDeHilos=$(($vCantHilosPorCore * $vCantCores))
  echo "    La cantidad de hilos es: $vCantTotalDeHilos."
  echo ""

# Asignar los hilos calculados al conteo de cores reales
  echo ""
  echo "    Calculando los hilos totales que se asignarán al minero..."
  echo ""
  vHilosCalculados=$(($vCantCores * $vCantSockets))
  echo "      Los hilos totales son: $vHilosCalculados"
  echo

# Crear el script de ejecución manual
  echo ""
  echo "    Creando el script para ejecutar manualmente el minero (con cores reales)..."
  echo ""
  echo '#!/bin/bash'                                                                                              > /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales.sh
  echo ""                                                                                                        >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales.sh
  echo "vHilos=$vHilosCalculados"                                                                                >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales.sh
  echo 'vIdMinero=$(cat /$HOME/Cryptos/XMR/Minero/IdMinero.txt)'                                                 >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales.sh
  echo 'vDirWallet="'"$vDirWallet"'"'                                                                            >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales.sh
  echo '/$HOME/Cryptos/XMR/Minero/xmrig -o xmrpool.eu:3333 --threads=$vHilos --rig-id=$vIdMinero -u $vDirWallet' >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales.sh
  chmod +x                                                                                                          /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales.sh

# Crear el script de ejecución manual
  echo ""
  echo "    Creando el script para ejecutar manualmente el minero (con cores reales) (Background)..."
  echo ""
  echo '#!/bin/bash'                                                                                                                                         > /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-Background.sh
  echo ""                                                                                                                                                   >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-Background.sh
  echo "vHilos=$vHilosCalculados"                                                                                                                           >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-Background.sh
  echo 'vIdMinero=$(cat /$HOME/Cryptos/XMR/Minero/IdMinero.txt)'                                                                                            >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-Background.sh
  echo 'vDirWallet="'"$vDirWallet"'"'                                                                                                                       >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-Background.sh
  echo '/$HOME/Cryptos/XMR/Minero/xmrig -o xmrpool.eu:3333 --threads=$vHilos --rig-id=$vIdMinero -u $vDirWallet --background --log-file=/var/log/xmrig.log' >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-Background.sh
  chmod +x                                                                                                                                                     /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-Background.sh

# Crear el script de ejecución manual
  echo ""
  echo "    Creando el script para ejecutar manualmente el minero (con cores reales) (TLS)..."
  echo ""
  echo '#!/bin/bash'                                                                                                    > /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-TLS.sh
  echo ""                                                                                                              >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-TLS.sh
  echo "vHilos=$vHilosCalculados"                                                                                      >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-TLS.sh
  echo 'vIdMinero=$(cat /$HOME/Cryptos/XMR/Minero/IdMinero.txt)'                                                       >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-TLS.sh
  echo 'vDirWallet="'"$vDirWallet"'"'                                                                                  >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-TLS.sh
  echo '/$HOME/Cryptos/XMR/Minero/xmrig -o xmrpool.eu:9999 --threads=$vHilos --rig-id=$vIdMinero -u $vDirWallet --tls' >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-TLS.sh
  chmod +x                                                                                                                /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-TLS.sh

# Crear el script de ejecución manual
  echo ""
  echo "    Creando el script para ejecutar manualmente el minero (con cores reales) (TLS) (Background)..."
  echo ""
  echo '#!/bin/bash'                                                                                                                                               > /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-TLS-Background.sh
  echo ""                                                                                                                                                         >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-TLS-Background.sh
  echo "vHilos=$vHilosCalculados"                                                                                                                                 >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-TLS-Background.sh
  echo 'vIdMinero=$(cat /$HOME/Cryptos/XMR/Minero/IdMinero.txt)'                                                                                                  >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-TLS-Background.sh
  echo 'vDirWallet="'"$vDirWallet"'"'                                                                                                                             >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-TLS-Background.sh
  echo '/$HOME/Cryptos/XMR/Minero/xmrig -o xmrpool.eu:9999 --threads=$vHilos --rig-id=$vIdMinero -u $vDirWallet --tls --background --log-file=/var/log/xmrig.log' >> /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-TLS-Background.sh
  chmod +x                                                                                                                                                           /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-TLS-Background.sh


# Crear el script de ejecución manual
  echo ""
  echo "    Creando el script para ejecutar manualmente el minero (con rendimiento máximo)..."
  echo ""
  echo '#!/bin/bash'                                                                            > /$HOME/Cryptos/XMR/Minero/Minar-ATope.sh
  echo ""                                                                                      >> /$HOME/Cryptos/XMR/Minero/Minar-ATope.sh
  echo 'vIdMinero=$(cat /$HOME/Cryptos/XMR/Minero/IdMinero.txt)'                               >> /$HOME/Cryptos/XMR/Minero/Minar-ATope.sh
  echo 'vDirWallet="'"$vDirWallet"'"'                                                          >> /$HOME/Cryptos/XMR/Minero/Minar-ATope.sh
  echo '/$HOME/Cryptos/XMR/Minero/xmrig -o xmrpool.eu:3333 --rig-id=$vIdMinero -u $vDirWallet' >> /$HOME/Cryptos/XMR/Minero/Minar-ATope.sh
  chmod +x                                                                                        /$HOME/Cryptos/XMR/Minero/Minar-ATope.sh

# Crear el script de ejecución manual
  echo ""
  echo "    Creando el script para ejecutar manualmente el minero (con rendimiento máximo) (Background)..."
  echo ""
  echo '#!/bin/bash'                                                                                                                       > /$HOME/Cryptos/XMR/Minero/Minar-ATope-Background.sh
  echo ""                                                                                                                                 >> /$HOME/Cryptos/XMR/Minero/Minar-ATope-Background.sh
  echo 'vIdMinero=$(cat /$HOME/Cryptos/XMR/Minero/IdMinero.txt)'                                                                          >> /$HOME/Cryptos/XMR/Minero/Minar-ATope-Background.sh
  echo 'vDirWallet="'"$vDirWallet"'"'                                                                                                     >> /$HOME/Cryptos/XMR/Minero/Minar-ATope-Background.sh
  echo '/$HOME/Cryptos/XMR/Minero/xmrig -o xmrpool.eu:3333 --rig-id=$vIdMinero -u $vDirWallet --background --log-file=/var/log/xmrig.log' >> /$HOME/Cryptos/XMR/Minero/Minar-ATope-Background.sh
  chmod +x                                                                                                                                   /$HOME/Cryptos/XMR/Minero/Minar-ATope-Background.sh

# Crear el script de ejecución manual
  echo ""
  echo "    Creando el script para ejecutar manualmente el minero (con rendimiento máximo) (TLS)..."
  echo ""
  echo '#!/bin/bash'                                                                                  > /$HOME/Cryptos/XMR/Minero/Minar-ATope-TLS.sh
  echo ""                                                                                            >> /$HOME/Cryptos/XMR/Minero/Minar-ATope-TLS.sh
  echo 'vIdMinero=$(cat /$HOME/Cryptos/XMR/Minero/IdMinero.txt)'                                     >> /$HOME/Cryptos/XMR/Minero/Minar-ATope-TLS.sh
  echo 'vDirWallet="'"$vDirWallet"'"'                                                                >> /$HOME/Cryptos/XMR/Minero/Minar-ATope-TLS.sh
  echo '/$HOME/Cryptos/XMR/Minero/xmrig -o xmrpool.eu:9999 --rig-id=$vIdMinero -u $vDirWallet --tls' >> /$HOME/Cryptos/XMR/Minero/Minar-ATope-TLS.sh
  chmod +x                                                                                              /$HOME/Cryptos/XMR/Minero/Minar-ATope-TLS.sh

# Crear el script de ejecución manual
  echo ""
  echo "    Creando el script para ejecutar manualmente el minero (con rendimiento máximo) (TLS) (Background)..."
  echo ""
  echo '#!/bin/bash'                                                                                                                             > /$HOME/Cryptos/XMR/Minero/Minar-ATope-TLS-Background.sh
  echo ""                                                                                                                                       >> /$HOME/Cryptos/XMR/Minero/Minar-ATope-TLS-Background.sh
  echo 'vIdMinero=$(cat /$HOME/Cryptos/XMR/Minero/IdMinero.txt)'                                                                                >> /$HOME/Cryptos/XMR/Minero/Minar-ATope-TLS-Background.sh
  echo 'vDirWallet="'"$vDirWallet"'"'                                                                                                           >> /$HOME/Cryptos/XMR/Minero/Minar-ATope-TLS-Background.sh
  echo '/$HOME/Cryptos/XMR/Minero/xmrig -o xmrpool.eu:9999 --rig-id=$vIdMinero -u $vDirWallet --tls --background --log-file=/var/log/xmrig.log' >> /$HOME/Cryptos/XMR/Minero/Minar-ATope-TLS-Background.sh
  chmod +x                                                                                                                                         /$HOME/Cryptos/XMR/Minero/Minar-ATope-TLS-Background.sh

# Crear el archivo para mostrar el log
  echo '#!/bin/bash'                 > /$HOME/Cryptos/XMR/Minero/Log-Mostrar.sh
  echo ""                           >> /$HOME/Cryptos/XMR/Minero/Log-Mostrar.sh
  echo 'echo ""'                    >> /$HOME/Cryptos/XMR/Minero/Log-Mostrar.sh
  echo 'tail -f /var/log/xmrig.log' >> /$HOME/Cryptos/XMR/Minero/Log-Mostrar.sh
  echo 'echo ""'                    >> /$HOME/Cryptos/XMR/Minero/Log-Mostrar.sh
  chmod +x                             /$HOME/Cryptos/XMR/Minero/Log-Mostrar.sh

# Crear el archivo de logs
  echo ""
  echo "  Creando el archivo de logs..."
  echo ""
  touch /var/log/xmrig.log
  chmod 777 /var/log/xmrig.log

# Lanzar el minero
  echo ""
  echo "    Minando con ID $vIdMinero..."
  echo ""
  /$HOME/Cryptos/XMR/Minero/Minar-ConCoresReales-TLS.sh

