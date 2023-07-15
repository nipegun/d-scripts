#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para borrar una base de datos antes de importar una copia de seguridad de la misma
# ----------

cCantArgumEsperados=4


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
    echo "Ejemplo:"
    echo "$0 pepe 12345678 Cuentas"
    echo ""
    exit
  else
    mysqldump -u$1 -p$2 --add-drop-table --no-data $3 | grep ^DROP | sed -e 's/DROP TABLE IF EXISTS/TRUNCATE TABLE/g' | mysql -u$1 -p$2 $3
fi

