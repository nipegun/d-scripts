#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.


# Script de NiPeGun para instalar el servidor de bases de datos PostgreSQL en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-PostgreSQL-Instalar.sh | bash
#
# Ejecución remota con cambio de nombre:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-PostgreSQL-Instalar.sh | sed 's/UsuarioPrueba/nipegun/g' | sed 's/BDPrueba/nipegun/g' | bash


cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

UsuarioPSQL="UsuarioPrueba"
BaseDeDatosPSQL="BDPrueba"

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor PostgreSQL para Debian 7 (Wheezy)..." 
echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor PostgreSQL para Debian 8 (Jessie)..." 
echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor PostgreSQL para Debian 9 (Stretch)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor PostgreSQL para Debian 10 (Buster)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación del servidor PostgreSQL para Debian 11 (Bullseye)..."  
  echo ""

  apt-get -y update 
  apt-get -y install postgresql
  
  # Crear usuario
     su - postgres -c "createuser $UsuarioPSQL"
  # Crear base de datos
     su - postgres -c "createdb $BaseDeDatosPSQL"
  echo ""
  echo "  Se han creado el usuario y la base de datos de prueba."
  echo ""
  echo "  Ahora tendrás que agregar el password y los privilegios manualmente."
  echo "  Para ello, arranca la línea de comandos de PostgreSQL con:"
  echo ""
  echo 'su - postgres -c "psql"'
  echo ""
  echo "  y luego simplemente copia, pega y ejecuta estas dos líneas:"
  echo ""
  echo "alter user $UsuarioPSQL with encrypted password 'password';"
  echo "grant all privileges on database $BaseDeDatosPSQL to $UsuarioPSQL;"
  echo ""
  echo "  Para salir ejecuta exit y no te olvides de abrir el puerto 5432 en el cortafuegos."
  echo ""

fi

