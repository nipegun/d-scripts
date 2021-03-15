#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------
#  Script de NiPeGun para importar una base de datos de MySQL
#--------------------------------------------------------------

EXPECTED_ARGS=4
E_BADARGS=65

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

FechaDeExp=$(date +A%YM%mD%d@%T)

if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "-------------------------------------------------------------------------"
    echo -e "${ColorRojo}Mal uso del script.${FinColor} El uso correcto sería:"
    echo ""
    echo -e "ibdd ${ColorVerde}[UsuarioBD] [PasswordBD] [NombreBD] [RutaArchivoSQL]${FinColor}"
    echo ""
    echo "Ejemplo 1:"
    echo "ibdd pepe 12345678 Cuentas Cuentas.sql"
    echo ""
    echo "Ejemplo 2:"
    echo "ibdd pepe 12345678 Cuentas '\Copias de seguridad\Base de datos.sql'"   
    echo ""
    echo "-------------------------------------------------------------------------"
    echo ""
    exit $E_BADARGS
  else
    mysql -u$1 -p$2 $3 < $4
fi

