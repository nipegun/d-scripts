#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# -----------
#  Script de NiPeGun para crear un pendrive con la última versión de clonezilla Live
# -----------



#
# ----------
#  SCRIPT POR TERMINAR !!!!!!!!!!!!!!!!!!
# ----------
#

cCantArgsCorrectos=1


if [ $# -ne $cCantArgsCorrectos ]
  then
    echo ""
    
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 [DevYParticiónDelPendrive]"
    echo ""
    echo "Ejemplo:"
    echo ' CrearPendriveCloneZilla /dev/sdf1'
    
    echo ""
    exit
  else
    echo ""
    echo "  Creando pendrive de CloneZilla Live..."
    echo ""
    echo ""
    echo "  Instalando los paquetes necesarios..."
    apt-get -y install libc6-i386
    URLUltVersCloneZilla=$(wget -qO- --no-check-certificate https://www.kernel.org | grep zip | head -n1 | cut -d\" -f2)
    wget --no-check-certificate $URLUltVersCloneZilla
    mkfs.vfat -F 32 $1
    mkdir -p /media/PenCloneZillaLive; mount $1 /media/PenCloneZillaLive/
    unzip clonezilla-live-2.4.2-32-i686-pae.zip -d /media/PenCloneZillaLive/
    cd /media/PenCloneZillaLive/utils/linux
    bash makeboot.sh $1
    echo ""
fi
