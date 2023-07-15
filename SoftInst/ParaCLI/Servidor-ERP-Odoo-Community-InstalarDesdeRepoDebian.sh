#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

------------------
# Script de NiPeGun para instalar y configurar el servidor ERP de Odoo
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-ERP-Odoo-Community-InstalarDesdeRepoDebian.sh | bash
------------------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

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
  echo "---------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Odoo para Debian 11 (Bullseye)..."  echo "---------------------------------------------------------------------------"
  echo ""
  apt-get -y update 2> /dev/null
  vVersPostgre=$(apt-cache depends postgresql | grep pen | cut -d '-' -f2)
  vVersWkHTMLtoPDF=$(apt-cache policy wkhtmltopdf | grep and | cut -d':' -f2 | sed 's- --g')
  vVersOdoo=$(apt-cache search odoo | grep -v Voo | grep -v python | grep odoo | cut -d '-' -f2)
  echo "Este script instalará el siguiente software:"
  echo "  PostgreSQL v$vVersPostgre"
  echo "  wkhtmltopdf v$vVersWkHTMLtoPDF"
  echo "  Odoo v$vVersOdoo"
  echo ""
  sleep 5

  echo ""
  echo "  Instalando la base de datos PostgreSQL..." 
echo ""
  apt-get -y install postgresql

  echo ""
  echo "  Instalando wkhtmltopdf..." 
echo ""
  apt-get -y install wkhtmltopdf

  echo ""
  echo "  Instalando odoo..." 
echo ""
  apt-get -y install odoo

  echo ""
  echo "  Activando el servicio"
  echo ""
  systemctl enable --now odoo

  echo ""
  echo "  Información de puerto:"
  echo ""
  ss -tunelp | grep 8069

fi

