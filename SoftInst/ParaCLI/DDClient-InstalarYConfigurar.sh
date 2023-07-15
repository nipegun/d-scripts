#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar DDClient en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/DDClient-InstalarYConfigurar.sh | bash
# ----------

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
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de DDClient para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de DDClient para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de DDClient para Debian 9 (Stretch)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de DDClient para Debian 10 (Buster)..."
  
  echo ""

  echo 'run_dhclient="true"'   > /etc/default/ddclient
  echo 'run_ipup="true"'      >> /etc/default/ddclient
  echo 'run_daemon="true"'    >> /etc/default/ddclient
  echo 'daemon_interval="60"' >> /etc/default/ddclient

  touch /etc/ddclient.conf
  echo "protocol=dyndns2"                      > /etc/ddclient.conf
  echo "#use=if, if=eth0"                     >> /etc/ddclient.conf
  echo "#use=if, if=vmbr0"                    >> /etc/ddclient.conf
  echo "#use=web, web=checkip.dyndns.org"     >> /etc/ddclient.conf
  echo "use=web"                              >> /etc/ddclient.conf
  echo "ssl=yes"                              >> /etc/ddclient.conf
  echo "server=dyndns.strato.com/nic/update"  >> /etc/ddclient.conf
  echo "login=dominio.com"                    >> /etc/ddclient.conf
  echo "password='x'"                         >> /etc/ddclient.conf
  echo "web.com"                              >> /etc/ddclient.conf
          
  apt-get -y install ddclient
          
  echo ""
  echo "  Instalación finalizada."
  echo "  Edita el archivo /etc/ddclient.conf para indicar tus credenciales."
  echo ""
  echo "  Para probar la configuración ejecuta:"
  echo "  ddclient -query"
  echo "  o"
  echo "  ddclient "
  echo ""
  echo "  Para ver las actualizaciones en tiempo real, ejecuta:"
  echo "  tail -f /var/log/syslog | grep ddclient"
  echo ""
  echo "  Si no lo has instalado para Strato, reconfigúralo con:"
  echo "  dpkg-reconfigure ddclient"
  echo "" 

elif [ $cVerSO == "11" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de DDClient para Debian 11 (Bullseye)..."
  
  echo ""

  echo 'run_dhclient="true"'   > /etc/default/ddclient
  echo 'run_ipup="true"'      >> /etc/default/ddclient
  echo 'run_daemon="true"'    >> /etc/default/ddclient
  echo 'daemon_interval="60"' >> /etc/default/ddclient

  touch /etc/ddclient.conf
  echo "protocol=dyndns2"                      > /etc/ddclient.conf
  echo "#use=if, if=eth0"                     >> /etc/ddclient.conf
  echo "#use=if, if=vmbr0"                    >> /etc/ddclient.conf
  echo "#use=web, web=checkip.dyndns.org"     >> /etc/ddclient.conf
  echo "use=web"                              >> /etc/ddclient.conf
  echo "ssl=yes"                              >> /etc/ddclient.conf
  echo "server=dyndns.strato.com/nic/update"  >> /etc/ddclient.conf
  echo "login=dominio.com"                    >> /etc/ddclient.conf
  echo "password='x'"                         >> /etc/ddclient.conf
  echo "web.com"                              >> /etc/ddclient.conf
          
  apt-get -y install net-tools
  apt-get -y install ddclient
          
  echo ""
  echo "  Instalación finalizada."
  echo "  Edita el archivo /etc/ddclient.conf para indicar tus credenciales."
  echo ""
  echo "  Para probar la configuración ejecuta:"
  echo "  ddclient -query"
  echo "  o"
  echo "  ddclient"
  echo "  o"
  echo "  ddclient -daemon=0 -debug -verbose -noquiet"
  echo ""
  echo "  Para ver las actualizaciones en tiempo real, ejecuta:"
  echo "  tail -f /var/log/syslog | grep ddclient"
  echo ""
  echo "  Si no lo has instalado para Strato, reconfigúralo con:"
  echo "  dpkg-reconfigure ddclient"
  echo "" 

fi

