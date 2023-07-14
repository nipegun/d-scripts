#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear bases de datos MySQL
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/MySQL-BaseDeDatos-Crear.sh | bash -s NombreBD UsuarioBD PasswordBD
# ----------

CantArgsEsperados=3
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
    echo -e "$0 ${ColorVerde}[NombreBD] [UsuarioBD] [PasswordBD]${FinColor}"
    echo ""
    echo "Ejemplo:"
    echo "$0 wordpress usuariowp 12345678"
    echo ""
    exit $ArgsInsuficientes
  else
    echo ""
    echo "" Ingresa el password del root de MySQL
    echo ""
    MYSQL=`which mysql`
    Q1="CREATE DATABASE IF NOT EXISTS $1;"
    Q2="CREATE USER '$2'@'localhost' IDENTIFIED BY '$3';"
    Q3="GRANT ALL PRIVILEGES ON $1.* TO '$2'@'localhost';"
    Q4="FLUSH PRIVILEGES;"
    SQL="${Q1}${Q2}${Q3}${Q4}"
    $MYSQL -u root -p -e "$SQL"
    ok() { echo -e '\e[32m'$1'\e[m'; } # Green
    ok "\n----------\n\nLa base de datos MySQL con nombre '$1' fue creada correctamente.\nEl usuario MySQL con nombre '$2' fue creado correctamente.\nLa contraseña '$3' fue asignada correctamente al usuario MySQL con nombre '$2'.\nLos permisos para el manejo de la base de datos '$1' fueron asignados al usuario '$2' correctamente.\n\nYa deberías poder usar la base de datos normalmente con las siguientes credenciales:\n\nUsuario: $1\nContraseña: $3\n\n----------\n"
fi

