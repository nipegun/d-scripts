#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar Matrix Synapse en Debian
#
#  Ejecución remota
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/MatrixSynapse-Instalar.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

## Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       cNomSO=$NAME
       cVerSO=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       cNomSO=$(lsb_release -si)
       cVerSO=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       cNomSO=$DISTRIB_ID
       cVerSO=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       cNomSO=Debian
       cVerSO=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       cNomSO=$(uname -s)
       cVerSO=$(uname -r)
   fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Matrix Synapse para Debian 7 (Wheezy)..."
  echo "----------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Matrix Synapse para Debian 8 (Jessie)..."
  echo "----------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""

  echo "  Iniciando el script de instalación de Matrix Synapse para Debian 9 (Stretch)..."

  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""

  echo "  Iniciando el script de instalación de Matrix Synapse para Debian 10 (Buster)..."

  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Matrix Synapse para Debian 11 (Bullseye)..."
  echo "-------------------------------------------------------------------------------------"
  echo ""

  apt-get -y install lsb-release
  apt-get -y install wget
  apt-get -y install apt-transport-https
  apt-get -y install build-essential
  apt-get -y install python3-dev
  apt-get -y install libffi-dev
  apt-get -y install python3-pip
  apt-get -y install python3-setuptools
  apt-get -y install sqlite3
  apt-get -y install libssl-dev
  apt-get -y install virtualenv
  apt-get -y install libjpeg-dev
  apt-get -y install libxslt1-dev
  apt-get -y install libpq5
  apt-get -y install postgresql
  wget -O /usr/share/keyrings/matrix-org-archive-keyring.gpg https://packages.matrix.org/debian/matrix-org-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/matrix-org-archive-keyring.gpg] https://packages.matrix.org/debian/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/matrix-org.list
  apt-get -y update
  apt-get -y install matrix-synapse-py3
  echo ""
  echo "  Instalación finalizada."
  echo "  Revisa el script porque hay comandos que tendrás que ejecutar manualmente."
  echo ""
  ## Base de datos PostGreSQL
     ## Crear usuario
        su - postgres -c "createuser synapse"
     ## Crear base de datos
        su - postgres -c "createdb synapse"
     echo ""
     echo "  Se han creado el usuario y la base de datos para synapse."
     echo ""
     echo "  Ahora tendrás que agregar el password y los privilegios manualmente."
     echo "  Para ello, arranca la línea de comandos de PostgreSQL con:"
     echo ""
     echo 'su - postgres -c "psql"'
     echo ""
     echo "  y luego simplemente copia, pega y ejecuta estas dos líneas:"
     echo ""
     echo "alter user synapse with encrypted password 'password';"
     echo "grant all privileges on database synapse to synapse;"
     echo ""
     echo "  Para salir ejecuta exit y no te olvides de abrir el puerto 5432 en el cortafuegos."
     echo ""
  
fi

