#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar el servidor ERP de Odoo
#
#  Ejecución remota:
#  curl -s x | bash
#------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

UsuarioPSQL="odoo"
BaseDeDatosPSQL="odoo"

# Determinar la versión de Debian

  if [ -f /etc/os-release ]; then
      # Para systemd y freedesktop.org
      . /etc/os-release
      OS_NAME=$NAME
      OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then
      # linuxbase.org
      OS_NAME=$(lsb_release -si)
      OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then
      # Para algunas versiones de Debian sin el comando lsb_release
      . /etc/lsb-release
      OS_NAME=$DISTRIB_ID
      OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then
      # Para versiones viejas de Debian.
      OS_NAME=Debian
      OS_VERS=$(cat /etc/debian_version)
  else
      # Para el viejo uname (También funciona para BSD)
      OS_NAME=$(uname -s)
      OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo "------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Odoo para Debian 7 (Wheezy)..."
  echo "------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Odoo para Debian 8 (Jessie)..."
  echo "------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "-------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Odoo para Debian 9 (Stretch)..."
  echo "-------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "-------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Odoo para Debian 10 (Buster)..."
  echo "-------------------------------------------------------------------------"
  echo ""
  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de nginx para Debian 11 (Bullseye)..."
  echo "----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Actualizando la lista de paquetes..."
  echo ""
  apt-get -y update

  echo ""
  echo "Instalando la base de datos PostgreSQL..."
  echo ""
  #apt-get -y install postgresql

  echo ""
  echo "Creando el usuario y la base de datos para Odoo..."
  echo ""
  # Crear usuario
    #su - postgres -c "createuser $UsuarioPSQL"
  # Crear base de datos
    #su - postgres -c "createdb $BaseDeDatosPSQL"

  echo ""
  echo "Instalando wkhtmltopdf..."
  echo ""
  # Determinar la URL del archivo a bajar
    # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  curl no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update > /dev/null
        apt-get -y install curl
        echo ""
      fi
    vSubURL=$(curl -s https://github.com/wkhtmltopdf/packaging/releases | grep href | grep .deb | grep amd64 | grep stretch | head -n1 | cut -d '"' -f2)
    mkdir -p /root/SoftInst/wkhtmltopdf/
    cd /root/SoftInst/wkhtmltopdf/
    # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  wget no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update > /dev/null
        apt-get -y install wget
        echo ""
      fi
    wget https://github.com/$vSubURL wkhtmltopdf.deb
fi

