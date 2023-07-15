#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para importar una base de datos de MySQL
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/MySQL-BaseDeDatos-Importar.sh | bash -s UsuarioBD PasswordBD NombreBD RutaArchivoSQL
# ----------

cCantArgsEsperados=4


cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $cCantArgsEsperados ]
  then
    echo ""
    echo -e "${cColorRojo}Mal uso del script.${cFinColor}"
    echo ""
    echo "El uso correcto sería:"
    echo -e "$0 ${cColorVerde}[UsuarioBD] [PasswordBD] [NombreBD] [RutaArchivoSQL]${cFinColor}"
    echo ""
    echo "Ejemplo 1:"
    echo "$0 pepe 12345678 Cuentas Cuentas.sql"
    echo ""
    echo "Ejemplo 2:"
    echo "$0 pepe 12345678 Cuentas '\Copias de seguridad\Base de datos.sql'"   
    echo ""
    exit
  else
    mysql -u$1 -p$2 $3 < $4
fi

