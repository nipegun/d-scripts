#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# -------------
#  SCRIPT DE NIPEGUN PARA BLOQUEAR UN MÓDULO ESPECÍFICO Y TODOS LOS QUE DEPENDAN DE ÉL
# -------------

cCantArgsCorrectos=1


if [ $# -ne $cCantArgsCorrectos ]
  then
    echo ""
    
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 [NombreDelMódulo]"
    echo ""
    echo "Ejemplo:"
    echo ' $0 igb'
    
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
    echo "install $1 /bin/true" >> /etc/modprobe.d/$1.conf
    update-initramfs -u
    echo ""
fi

