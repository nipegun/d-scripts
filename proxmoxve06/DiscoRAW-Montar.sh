#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------
#  Script de NiPeGun para montar el disco de una MV de ProxmoxVE en una carpeta indicada del host
#------------------------------------------------------------------------------------------------

CantArgsEsperados=2
ArgsInsuficientes=65

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

if [ $# -ne $CantArgsEsperados ]
  then
    echo ""
    echo "------------------------------------------------------------------------------"
    echo -e "${ColorRojo}Mal uso del script.${FinColor} El uso correcto sería:"
    echo ""
    echo -e "  $0 ${ColorVerde}[ArchivoRAW] [CarpetaDeMontaje]${FinColor}"
    echo ""
    echo "Ejemplo:"
    echo "  $0 /Discos/DiscosDeMVs/images/241/vm-241-disk-0.raw"
    echo "------------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    apt-get -y install kpartx

    echo ""
    echo -e "  $0 ${ColorVerde}Montando disco RAW en el loop0...${FinColor}"
    echo ""
    mkdir -p $2
    losetup /dev/loop0 $1
    kpartx -a /dev/loop0  
    mount /dev/mapper/loop0p1 $2
fi

