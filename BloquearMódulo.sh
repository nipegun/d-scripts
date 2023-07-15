#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para bloquear un módulo específico
# ----------

cCantArgsEsperados=3


cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $cCantArgsEsperados ]
  then
    echo ""
    
    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "$0 ${cColorVerde}[NombreDelMódulo]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo " $0 igb"
    
    echo ""
    exit
  else
    echo ""
    echo "  Estás a punto de bloquear el módulo $1"
    echo ""
    echo "  Lo siguientes módulos dependen de él"
    echo ""
    modinfo -F depends $1
    echo ""
    echo "  No es bueno bloquear módulos que sirvan a otros módulos"
    echo "blacklist $1" >> /etc/modprobe.d/$1.conf
    update-initramfs -u
    echo ""
fi

