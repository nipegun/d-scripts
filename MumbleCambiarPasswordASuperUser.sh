#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para cambiar la contraseña del SuperUser en mumble-server
# ----------

cCantArgumEsperados=1


cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $cCantArgsEsperados ]
  then
    echo ""
    
    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "CambiarPasswordASuperUserEnMumble ${cColorVerde}[PasswordNuevo]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo ' CambiarPasswordASuperUserEnMumble 12345678'
    
    echo ""
    exit
  else
    /usr/sbin/murmurd -ini /etc/mumble-server.ini -supw $1
fi

