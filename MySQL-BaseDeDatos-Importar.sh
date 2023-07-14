#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para importar una base de datos de MySQL
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/MySQL-BaseDeDatos-Importar.sh | bash -s UsuarioBD PasswordBD NombreBD RutaArchivoSQL
# ----------

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

# Comprobar que se hayan ingresado la cantidad de argumentos esperados
  vCantArgsEsperados=4
  if [ $# -ne $vCantArgsEsperados ]
    then
      echo ""
      echo -e "${vColorRojo}  Mal uso del script.${vFinColor}"
      echo ""
      echo "  El uso correcto sería:"
      echo -e "    $0 ${vColorVerde}[UsuarioBD] [PasswordBD] [NombreBD] [RutaArchivoSQL]${vFinColor}"
      echo ""
      echo "  Ejemplo 1:"
      echo "    $0 pepe 12345678 Cuentas Cuentas.sql"
      echo ""
      echo "  Ejemplo 2:"
      echo "    $0 pepe 12345678 Cuentas '\Copias de seguridad\Base de datos.sql'"   
      echo ""
      exit
    else
      mysql -u$1 -p$2 $3 < $4
  fi

