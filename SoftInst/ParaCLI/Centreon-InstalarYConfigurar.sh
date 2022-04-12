#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar Calibre en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Centreon-InstalarYConfigurar.sh | bash
#------------------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

## Determinar la versión de Debian

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
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Centreon para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Centreon para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Centreon para Debian 9 (Stretch)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Centreon para Debian 10 (Buster)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Centreon para Debian 11 (Bullseye)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  hostnamectl set-hostname centreon

  echo ""
  echo "  Agregando el repositorio de Centreon..."
  echo ""
  echo "deb https://apt.centreon.com/repository/centreon-bullseye/ bullseye main" > /etc/apt/sources.list.d/centreon.list

  echo ""
  echo "  Actualizando la lsita de paquetes diponibles..."
  echo ""
  apt-get -y update

  echo ""
  echo " Instalando paquetes necesarios..."
  echo ""
  apt-get -y install wget
  apt-get -y install gnupg2

  echo ""
  echo "  Descargando las llaves para firmar el repositorio..."
  echo ""
  wget -O- https://apt-key.centreon.com | gpg --dearmor | tee /etc/apt/trusted.gpg.d/centreon.gpg

  echo ""
  echo "  Re-actualizando la lsita de paquetes diponibles..."
  echo ""
  apt-get -y update

  echo ""
  echo " Instalando centreon..."
  echo ""
  apt-get -y install centreon-broker
  apt-get -y install centreon-broker-cbmod
  apt-get -y install centreon-broker-core
  apt-get -y install centreon-clib
  apt-get -y install centreon-common
  apt-get -y install centreon-connector
  apt-get -y install centreon-connector-perl
  apt-get -y install centreon-connector-ssh
  apt-get -y install centreon-engine
  apt-get -y install centreon-engine-extcommands
  apt-get -y install centreon-gorgone
  apt-get -y install centreon-perl-libs
  apt-get -y install libzmq-constants-perl
  apt-get -y install zmq-libzmq4-perl

  echo ""
  echo "  Activando los servicios en systemd..."
  echo ""
  systemctl enable centreon
  systemctl enable centengine

  echo ""
  echo "  Agregando el usuario centreon a sudoers..."
  echo ""
  echo "## BEGIN: CENTREON SUDO"                                            >> /etc/sudoers
  echo ""                                                                   >> /etc/sudoers
  echo "User_Alias      CENTREON=%centreon"                                 >> /etc/sudoers
  echo "Defaults:CENTREON !requiretty"                                      >> /etc/sudoers
  echo ""                                                                   >> /etc/sudoers
  echo "# centreontrapd"                                                    >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /sbin/service centreontrapd start"       >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /sbin/service centreontrapd stop"        >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /sbin/service centreontrapd restart"     >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /sbin/service centreontrapd reload"      >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/sbin/service centreontrapd start"   >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/sbin/service centreontrapd stop"    >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/sbin/service centreontrapd restart" >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/sbin/service centreontrapd reload"  >> /etc/sudoers
  echo ""                                                                   >> /etc/sudoers
  echo "# Centreon Engine"                                                  >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /sbin/service centengine start"          >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /sbin/service centengine stop"           >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /sbin/service centengine restart"        >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /sbin/service centengine reload"         >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/sbin/service centengine start"      >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/sbin/service centengine stop"       >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/sbin/service centengine restart"    >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/sbin/service centengine reload"     >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /bin/systemctl start centengine"         >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /bin/systemctl stop centengine"          >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /bin/systemctl restart centengine"       >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /bin/systemctl reload centengine"        >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/bin/systemctl start centengine"     >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/bin/systemctl stop centengine"      >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/bin/systemctl restart centengine"   >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/bin/systemctl reload centengine"    >> /etc/sudoers
  echo ""                                                                   >> /etc/sudoers
  echo "# Centreon Broker"                                                  >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /sbin/service cbd start"                 >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /sbin/service cbd stop"                  >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /sbin/service cbd restart"               >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /sbin/service cbd reload"                >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/sbin/service cbd start"             >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/sbin/service cbd stop"              >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/sbin/service cbd restart"           >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/sbin/service cbd reload"            >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /bin/systemctl start cbd"                >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /bin/systemctl stop cbd"                 >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /bin/systemctl restart cbd"              >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /bin/systemctl reload cbd"               >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/bin/systemctl start cbd"            >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/bin/systemctl stop cbd"             >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/bin/systemctl restart cbd"          >> /etc/sudoers
  echo "CENTREON   ALL = NOPASSWD: /usr/bin/systemctl reload cbd"           >> /etc/sudoers
  echo ""                                                                   >> /etc/sudoers
  echo "## END: CENTREON SUDO"                                              >> /etc/sudoers

fi

