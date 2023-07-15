#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para importar una copia de seguridad de una web específica
# ----------

cCantArgsEsperados=4

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $cCantArgsEsperados ]
  then
    echo ""

    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "$0 ${cColorVerde}[NombreDeLaWebEnApache] [UsuarioBD] [PasswordBD] [NombreBD]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo ' $0 pepe.org pepe'

    echo ""
    exit $vArgsInsuficientes
  else
    echo ""
    echo -e "${cColorVerde}  Importando...${cFinColor}"
    echo ""
    /root/scripts/d-scripts/MySQL-BaseDeDatos-Importar.sh
fi
