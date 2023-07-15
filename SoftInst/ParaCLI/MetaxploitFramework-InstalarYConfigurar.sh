#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

------
#  Script de NiPeGun para instalar y configurar el framework Metaxploit
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/MetaxploitFramework-InstalarYConfigurar.sh | bash
------

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
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 9 (Stretch)..."
  
  echo ""

  apt-get install default-jre default-jdk software-properties-common
  add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main"
  apt-get update
  apt-get install oracle-java8-installer
  apt-get install build-essential libreadline-dev libssl-dev libpq5 libpq-dev libreadline5 libsqlite3-dev libpcap-dev git-core autoconf postgresql pgadmin3 curl zlib1g-dev libxml2-dev libxslt1-dev vncviewer libyaml-dev
  curl -sSL https://rvm.io/mpapis.asc | gpg --import -
  curl -L https://get.rvm.io | bash -s stable
  source /usr/local/rvm/scripts/rvm
  echo "source /usr/local/rvm/scripts/rvm" >> ~/.bashrc
  source ~/.bashrc
  RUBYVERSION=$(wget https://raw.githubusercontent.com/rapid7/metasploit-framework/master/.ruby-version -q -O - )
  rvm install $RUBYVERSION
  rvm use $RUBYVERSION --default
  mkdir /root/git
  cd /root/git
  git clone git://github.com/sstephenson/rbenv.git .rbenv
  git clone git://github.com/sstephenson/rbenv.git .rbenv
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  exec $SHELL
  git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
  git clone git://github.com/dcarley/rbenv-sudo.git ~/.rbenv/plugins/rbenv-sudo
  exec $SHELL
  RUBYVERSION=$(wget https://raw.githubusercontent.com/rapid7/metasploit-framework/master/.ruby-version -q -O - )
  rbenv install $RUBYVERSION
  rbenv global $RUBYVERSION
  mkdir /root/dev
  cd /root/dev
  git clone https://github.com/nmap/nmap.git
  ./configure
  make
  make install
  make clean
  su postgres
  createuser msf -P -S -R -D
  createdb -O msf msf
  psql -c "ALTER USER msf WITH ENCRYPTED PASSWORD 'blah';"
  exit
  cd /opt/
  git clone https://github.com/rapid7/metasploit-framework.git
  cd metasploit-framework/
  rvm --default use ruby-${RUBYVERSION}@metasploit-framework
  gem install bundler
  bundle install
  bash -c 'for MSF in $(ls msf*); do ln -s /opt/metasploit-framework/$MSF /usr/local/bin/$MSF;done'
  echo "production" > /opt/metasploit-framework/config/database.yml
  echo " adapter: postgresql" >> /opt/metasploit-framework/config/database.yml
  echo " database: msf" >> /opt/metasploit-framework/config/database.yml
  echo " username: msf" >> /opt/metasploit-framework/config/database.yml
  echo " password: blah" >> /opt/metasploit-framework/config/database.yml
  echo " host: 127.0.0.1" >> /opt/metasploit-framework/config/database.yml
  echo " port: 5432" >> /opt/metasploit-framework/config/database.yml
  echo " pool: 75" >> /opt/metasploit-framework/config/database.yml
  echo " timeout: 5" >> /opt/metasploit-framework/config/database.yml
  sh -c "echo export MSF_DATABASE_CONFIG=/opt/metasploit-framework/config/database.yml >> /etc/profile"
  source /etc/profile
  msfconsole...

elif [ $cVerSO == "10" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 10 (Buster)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 11 (Bullseye)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi

