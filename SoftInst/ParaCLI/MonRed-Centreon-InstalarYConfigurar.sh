#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Centreon en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/MonRed-Centreon-InstalarYConfigurar.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

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
  echo "  Iniciando el script de instalación de Centreon para Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Centreon para Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Centreon para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Centreon para Debian 10 (Buster)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Centreon para Debian 11 (Bullseye)..."  
  echo ""

  hostnamectl set-hostname centreon

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
  echo "  Agregando el repositorio de Centreon..." 
echo ""
  echo "deb https://apt.centreon.com/repository/centreon-bullseye/ bullseye main" > /etc/apt/sources.list.d/centreon.list

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
  echo "# BEGIN: CENTREON SUDO"                                            >> /etc/sudoers
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
  echo "# END: CENTREON SUDO"                                              >> /etc/sudoers

  echo ""
  echo "  Corrigiendo permisos..." 
echo ""
  chown -R centreon-engine:centreon-gorgone /etc/centreon-engine/
  chmod -R g+w /etc/centreon-engine/
  chown -R centreon-broker:centreon-gorgone /etc/centreon-broker/
  chmod -R g+w /etc/centreon-broker/
  chown -R centreon:centreon /var/cache/centreon
  chmod -R g+w /var/cache/centreon

  echo ""
  echo "  Reiniciando los servicios..." 
echo ""
  systemctl restart centengine
  systemctl restart gorgoned

  echo ""
  echo "  Centreon instalado"
  echo "  No te olvides de agregar un Poller siguiendo estas instrucciones:"
  echo "  Más info aquí: https://docs.centreon.com/docs/monitoring/monitoring-servers/add-a-poller-to-configuration/"
  echo ". Then Add a Poller to configuration by selecting Add a Centreon Poller then Create new Poller  from the Centreon official documentation."

  echo ""
  echo "  Si quieres instalar plug-ins puedes hacerlo de la siguiente forma:"
  echo "  apt-get install centreon-plugin-NombreDelPlugin"
  echo ""

  echo "In my lab environment, I had to adapt the groups for the centreon-engine and centreon-gorgone user"
  echo ""
  echo "adduser centreon-gorgone centreon-engine"
  echo "adduser centreon-gorgone centreon-broker"
  echo "adduser centreon-engine centreon"
  echo "adduser centreon-engine centreon-broker"
  echo "After plugin installed, I had to create and change the ownership of the  directory  /var/lib/centreon/centplugins"
  echo ""
  echo "mkdir -p /var/lib/centreon/centplugins"
  echo "chown centreon: /var/lib/centreon/centplugins"
  echo "chmod 775 /var/lib/centreon/centplugins"
  echo "finally, I had to change the permissions of all Centreon plugins that are not executable during their installation"

apt-get -y install liblwp-useragent-perl
apt-get -y install libhttp-proxypac-perl
apt-get -y install libemail-send-smtp-gmail-perl
apt-get -y install libssh-session-perl
apt-get -y install centreon-plugin-applications-protocol-http
apt-get -y install centreon-plugin-applications-protocol-smtp
apt-get -y install centreon-plugin-applications-protocol-ssh

fi

