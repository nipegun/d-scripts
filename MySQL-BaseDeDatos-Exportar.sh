#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para exportar bases de datos MySQL
# ----------

# Definir la cantidad de argumentos esperados
  cCantArgsEsperados=4

# Definir la fecha de ejecución del script
  cFechaEjecScript=$(date +a%Ym%md%d@%T)

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}" >&2
    exit 1
  fi

# Comprobar que se hayan ingresado la cantidad de argumentos esperados
  if [ $# -ne $cCantArgsEsperados ]
    then
      echo ""
      echo -e "${cColorRojo}  Mal uso del script.${cFinColor}"
      echo ""
      echo "  El uso correcto sería:"
      echo -e "    $0 ${cColorVerde}[UsuarioBD] [PasswordBD] [NombreBD] [RutaArchivoSQL]${cFinColor}"
      echo ""
      echo "  Ejemplo 1:"
      echo "    $0 pepe 12345678 Cuentas Cuentas.sql"
      echo ""
      echo "  Ejemplo 2:"
      echo "    $0 pepe 12345678 Cuentas '\Copias de seguridad\Base de datos.sql'"   
      echo ""
      exit
    else
      mysqldump --opt --user=$1 --password=$2 $3 > $4
      echo "$cFechaEjecScript - Copia de seguridad de la base de datos $3." >> /var/log/CopiasDeSeguridad.log
  fi

