#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para desconectar usuarios conectados a Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Usuario-Desconectar.sh | bash -s pepe
# ----------

vArgumentosEsperados=1
vArgumentosInsuficientes=65

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
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
    echo ""
    echo -e "${vColorAzulClaro}  Desconectando al usuario $1...${vFinColor}"
    echo ""
    pkill -KILL -u $1
fi

