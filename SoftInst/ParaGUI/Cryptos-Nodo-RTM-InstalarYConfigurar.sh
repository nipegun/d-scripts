#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar la cadena de bloques de Raptoreum (RTM)
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Nodo-RTM-InstalarYConfigurar.sh | bash
#--------------------------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

vUsuarioNoRoot="nipegun"

echo ""
echo -e "${ColorVerde}------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Iniciando el script de instalación de la cadena de bloques de RTM...${FinColor}"
echo -e "${ColorVerde}------------------------------------------------------------------------${FinColor}"
echo ""

echo ""
echo "  Determinando la última versión estable de raptoreum..."
echo ""
# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  curl no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install curl
    echo ""
  fi
vUltVersRTM=$(curl -sL https://github.com/Raptor3um/raptoreum/releases/latest | sed 's->->\n-g' | grep ".zip" | grep "href" | grep -v indows | cut -d '"' -f2 | cut -d '/' -f7 | sed 's-.zip--g')
echo ""
echo "  La última versión estable de raptoreum es la $vUltVersRTM"
echo ""

echo ""
echo "  Intentando descargar el archivo comprimido de la última versión..."
echo ""
mkdir -p /root/SoftInst/Cryptos/RTM/ 2> /dev/null
rm -rf /root/SoftInst/Cryptos/RTM/*
cd /root/SoftInst/Cryptos/RTM/
## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  wget no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install wget
     echo ""
   fi
vURLArchivo=$(curl -sL https://github.com/Raptor3um/raptoreum/releases/latest | sed 's->->\n-g' | grep .tar.gz | grep href | grep buntu2 | cut -d'"' -f2)
echo ""
echo "  Pidiendo el archivo en formato tar.gz..."
echo ""
wget https://github.com$vURLArchivo -O /root/SoftInst/Cryptos/RTM/Raptoreum.tar.gz

echo ""
echo "  Descomprimiendo el archivo..."
echo ""
# Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  tar no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update > /dev/null && apt-get -y install tar
    echo ""
  fi
tar -xvf /root/SoftInst/Cryptos/RTM/Raptoreum.tar.gz
