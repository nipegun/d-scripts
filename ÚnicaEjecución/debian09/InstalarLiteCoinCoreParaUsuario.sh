#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------
#  Script de NiPeGun para instalar la última versión estable de LiteCoin Core
#------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

EXPECTED_ARGS=1
E_BADARGS=65

if [ $# -ne $EXPECTED_ARGS ]

  then

    echo ""
    echo "---------------------------------------------------------------"
    echo "Mal uso del script. El uso correcto sería:"
    echo "InstalarLiteCoinCoreParaUsuario [NombreDeUsuarioLinux]"
    echo ""
    echo "Ejemplo:"
    echo "InstalarLiteCoinCoreParaUsuario pepe"
    echo "---------------------------------------------------------------"
    echo ""
    exit $E_BADARGS

  else

    # Buscar en litecoin.org una posible URL del archivo para Linux,
    # quedarse con la versión de 64 bits,
    # cortar del texto resultante los datos que no nos sirvan,
    # dejar sólo la URL y asignarla a una variable
    echo ""
    echo -e "${ColorRojo}  Buscando la URL del archivo con la última versión para Linux 64 bits...${FinColor}"
    echo ""
    URLArchUltVersLinux64=$(wget -qO- --no-check-certificate https://litecoin.org/ | grep x86_64-linux-gnu.tar.gz | grep 64bit | cut -d\" -f2)

    echo ""
    echo -e "  URL encontrada: ${ColorVerde}$URLArchUltVersLinux64${FinColor}"
    echo ""

    NombreDelArchivo=${URLArchUltVersLinux64##*linux/}

    echo ""
    echo "  Intentando descargar el archivo: $NombreDelArchivo"
    echo ""
    cd /root
    wget --no-check-certificate $URLArchUltVersLinux64

    echo ""
    echo "  Archivo descargado correctamente. Intentando la descompresión..."
    echo ""

    mkdir -p /root/LitecoinCore
    tar xzf $NombreDelArchivo -C /root/LitecoinCore

    VersionDelCore=${NombreDelArchivo%-x86*}

    echo ""
    echo "  Contenido del archivo descomprimido en la carpeta /root/LitecoinCore/$VersionDelCore"
    echo ""

    echo ""
    echo "  Borrando el archivo comprimido..."
    echo ""
    rm /root/$NombreDelArchivo

    mkdir -p /home/$1/Litecoin
    cp /root/LitecoinCore/$VersionDelCore/bin/litecoin-qt /home/$1/Litecoin
    
    chown $1:$1 /home/$1/Litecoin -R
    chmod +x /home/$1/Litecoin/litecoin-qt

    echo ""
    echo "  Última versión de litecoin-qt instalada en /home/$1/Litecoin"
    echo ""
fi

