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

cCantArgEsperados=1

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

if [ $# -ne $cCantArgEsperados ]
  then
    echo ""
    echo -e "${cColorRojo}  Mal uso del script!${cFinColor}"
    echo ""
    echo "  El uso correcto sería:"
    echo -e "    $0 ${cColorVerde}[NombreDeUsuario]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo " $0 pepe"
    echo ""
    exit $vArgumentosInsuficientes
  else
    echo ""
    echo -e "${cColorAzulClaro}  Desconectando el usuario $1...${cFinColor}"
    echo ""
    pkill -KILL -u $1
    echo ""
fi

