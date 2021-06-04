#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para borrar una base de datos antes de importar una copia de seguridad de la misma
#--------------------------------------------------------------------------------------------------------

CantArgsEsperados=4
ArgsInsuficientes=65

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

if [ $# -ne $CantArgsEsperados ]
  then
    echo ""
    echo "-------------------------------------------------------------------------"
    echo -e "${ColorRojo}Mal uso del script.${FinColor} El uso correcto sería:"
    echo ""
    echo -e "$0 ${ColorVerde}[UsuarioBD] [PasswordBD] [NombreBD] [RutaArchivoSQL]${FinColor}"
    echo ""
    echo "Ejemplo 1:"
    echo "$0 pepe 12345678 Cuentas"
    echo ""
    echo "-------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    mysqldump -u$1 -p$2 --add-drop-table --no-data $3 | grep ^DROP | sed -e 's/DROP TABLE IF EXISTS/TRUNCATE TABLE/g' | mysql -u$1 -p$2 $3
fi

