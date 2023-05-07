#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para desconectar usuarios conectados a Debian
#
# Ejecución remota:
#  curl -sL x | bash -s  pepe
# ----------

vArgumentosEsperados=1
vArgumentosInsuficientes=65

vColorRojo='\033[1;31m'
vColorVerde='\033[1;32m'
vFinColor='\033[0m'

if [ $# -ne $vArgumentosEsperados ]
  then
    echo ""
    echo -e "${vColorRojo}  Mal uso del script!${vFinColor}"
    echo ""
    echo "  El uso correcto sería:"
    echo -e "    $0 ${vColorVerde}[NombreDeUsuario]${vFinColor}"
    echo ""
    echo "Ejemplo:"
    echo " $0 pepe"
    echo ""
    exit $vArgumentosInsuficientes
  else
    pkill -KILL -u "$1"
fi

