#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para importar una copia de seguridad de una web específica
# ----------

vCantArgsEsperados=4
vArgsInsuficientes=65

vColorAdvertencia='\033[1;31m'
vColorArgumentos='\033[1;32m'
vFinColor='\033[0m'

if [ $# -ne $vCantArgsEsperados ]
  then
    echo ""
    echo "------------------------------------------------------------------------------"
    echo -e "${vColorAdvertencia}Mal uso del script.${vFinColor} El uso correcto sería:"
    echo ""
    echo -e "$0 ${vColorArgumentos}[NombreDeLaWebEnApache] [UsuarioBD] [PasswordBD] [NombreBD]${vFinColor}"
    echo ""
    echo "Ejemplo:"
    echo ' $0 pepe.org pepe'
    echo "------------------------------------------------------------------------------"
    echo ""
    exit $vArgsInsuficientes
  else
    echo ""
    echo -e "${vColorArgumentos}  Importando...${vFinColor}"
    echo ""
    /root/scripts/d-scripts/MySQL-BaseDeDatos-Importar.sh
fi
