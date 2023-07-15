#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para activar el logueo como root en Gnome
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Gnome-LogueoRoot-Activar.sh | bash
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
  echo "---------------------------------------------------------------"
  echo "  Activando el logueo root en Gnome para Debian 7 (Wheezy)..."
  echo "---------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "---------------------------------------------------------------"
  echo "  Activando el logueo root en Gnome para Debian 8 (Jessie)..."
  echo "---------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "----------------------------------------------------------------"
  echo "  Activando el logueo root en Gnome para Debian 9 (Stretch)..."
  echo "----------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "----------------------------------------------------------------"
  echo "  Activando el logueo root en Gnome para Debian 10 (Buster)..."
  echo "----------------------------------------------------------------"
  echo ""
  ## Hacer copia de seguridad antes de reemplazar
     cp /etc/pam.d/gdm-password /etc/pam.d/gdm-password.bak
  ## Reemplazar toda la línea que tenga la palabra root
     sed -i -e '/root/c#auth required pam_succeed_if.so user != root quiet_success' /etc/pam.d/gdm-password

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "------------------------------------------------------------------"
  echo "  Activando el logueo root en Gnome para Debian 11 (Bullseye)..."
  echo "------------------------------------------------------------------"
  echo ""
  ## Hacer copia de seguridad antes de reemplazar
     cp /etc/pam.d/gdm-password /etc/pam.d/gdm-password.bak
  ## Reemplazar toda la línea que tenga la palabra root
     sed -i -e '/root/c#auth required pam_succeed_if.so user != root quiet_success' /etc/pam.d/gdm-password

fi

