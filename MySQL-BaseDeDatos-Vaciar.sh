#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para borrar una base de datos antes de importar una copia de seguridad de la misma
# ----------

CantArgsEsperados=4
ArgsInsuficientes=65

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

if [ $# -ne $CantArgsEsperados ]
  then
    echo ""
    echo -e "${ColorRojo}Mal uso del script.${FinColor}"
    echo ""
    echo "El uso correcto sería:"
    echo -e "$0 ${ColorVerde}[UsuarioBD] [PasswordBD] [NombreBD] [RutaArchivoSQL]${FinColor}"
    echo ""
    echo "Ejemplo:"
    echo "$0 pepe 12345678 Cuentas"
    echo ""
    exit $ArgsInsuficientes
  else
    mysqldump -u$1 -p$2 --add-drop-table --no-data $3 | grep ^DROP | sed -e 's/DROP TABLE IF EXISTS/TRUNCATE TABLE/g' | mysql -u$1 -p$2 $3
fi

