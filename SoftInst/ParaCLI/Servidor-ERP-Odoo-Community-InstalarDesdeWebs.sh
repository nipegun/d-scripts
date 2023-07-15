#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

------------
# Script de NiPeGun para instalar y configurar el servidor ERP de Odoo
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-ERP-Odoo-Community-InstalarDesdeWebs.sh | bash
------------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

UsuarioPSQL="odoo"
BaseDeDatosPSQL="odoo"

# Determinar la versión de Debian

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
  echo "------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Odoo para Debian 7 (Wheezy)..."  echo "------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Odoo para Debian 8 (Jessie)..."  echo "------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Odoo para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Odoo para Debian 10 (Buster)..."  
  echo ""
  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de nginx para Debian 11 (Bullseye)..."  echo "----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Instalando la base de datos PostgreSQL..." 
echo ""
  # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo "  wget no está instalado. Iniciando su instalación..."
      echo ""
      apt-get -y update > /dev/null
      apt-get -y install wget
      echo ""
    fi
  # Descargar la llave para firmar el repositorio
    mkdir -p /root/aptkeys/ 2> /dev/null
    wget -q -O- https://www.postgresql.org/media/keys/ACCC4CF8.asc -O /root/aptkeys/postgresql.key
    # Comprobar si el paquete gnupg2 está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s gnupg2 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  gnupg2 no está instalado. Iniciando su instalación..."        echo ""
        apt-get -y update > /dev/null
        apt-get -y install gnupg2
        echo ""
      fi
    gpg --dearmor /root/aptkeys/postgresql.key
    cp /root/aptkeys/postgresql.key.gpg /usr/share/keyrings/postgresql.gpg
  # Crear el archivo de repositorio
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt bullseye-pgdg main" > /etc/apt/sources.list.d/postgresql.list
  # Actualizar el cache de paquetes
    apt-get -y update
  # Instalar la última versión de PostreSQL
    apt-get -y install postgresql
  # Crear usuario
    #su - postgres -c "createuser $UsuarioPSQL"
  # Crear base de datos
    #su - postgres -c "createdb $BaseDeDatosPSQL"

  echo ""
  echo "  Instalando wkhtmltopdf..." 
echo ""
  # Instalar paquetes necesarios
    apt-get -y install fontconfig
    apt-get -y install libjpeg62-turbo
    apt-get -y install xfonts-75dpi
    apt-get -y install xfonts-base
  # Determinar la URL del archivo a bajar
    # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  curl no está instalado. Iniciando su instalación..."        echo ""
        apt-get -y update > /dev/null
        apt-get -y install curl
        echo ""
      fi
    vSubURL=$(curl -sL https://github.com/wkhtmltopdf/packaging/releases | grep href | grep .deb | grep amd64 | grep buster | head -n1 | cut -d '"' -f2)
    rm -rf /root/SoftInst/wkhtmltopdf/
    mkdir -p /root/SoftInst/wkhtmltopdf/ 2> /dev/null
    cd /root/SoftInst/wkhtmltopdf/
    wget https://github.com/$vSubURL -O wkhtmltopdf.deb
    dpkg -i /root/SoftInst/wkhtmltopdf/wkhtmltopdf.deb

  echo ""
  echo "  Iniciando la instalación de Odoo..." 
echo ""
  # Agregar llave para firmar repositorio
    mkdir -p /root/aptkeys/ 2> /dev/null
    wget -q -O- https://nightly.odoo.com/odoo.key -O /root/aptkeys/odoo.key
    gpg --dearmor /root/aptkeys/odoo.key
    cp /root/aptkeys/odoo.key.gpg /usr/share/keyrings/odoo.gpg
  # Agregar repositorio
    # Comprobar si el paquete gnupg2 está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s gnupg2 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  gnupg2 no está instalado. Iniciando su instalación..."        echo ""
        apt-get -y update > /dev/null
        apt-get -y install gnupg2
        echo ""
      fi
    vUltVersOdoo=$(curl -sL http://nightly.odoo.com/ | grep blob | grep -v master | head -n1 | cut -d '"' -f2 | sed 's-blob/-\n-g' | grep -v http | cut -d '/' -f1)
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/odoo.gpg] http://nightly.odoo.com/$vUltVersOdoo/nightly/deb/ ./" > /etc/apt/sources.list.d/odoo.list
  # Actualizar el cache de paquetes
    apt-get -y update
  # Instalar la última versión de Odoo
    apt-get -y install odoo
    systemctl enable --now odoo
    echo ""
    ss -tunelp | grep 8069
    echo ""
fi

