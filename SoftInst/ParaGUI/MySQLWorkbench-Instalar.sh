#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar MySQL WorkBench en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/MySQLWorkbench-Instalar.sh | bash
# ----------

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

  echo "  Iniciando el script de instalación de MySQL Workbench para Debian 7 (Wheezy)..."

  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""

  echo "  Iniciando el script de instalación de MySQL Workbench para Debian 8 (Jessie)..."

  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""

  echo "  Iniciando el script de instalación de MySQL Workbench para Debian 9 (Stretch)..."

  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""

  echo "  Iniciando el script de instalación de MySQL Workbench para Debian 10 (Buster)..."

  echo ""

  # Actualizar el sistema
     apt-get -y update
     apt-get -y upgrade
     apt-get -y dist-upgrade

  # Instalar dependencias necesarias
     apt-get -y install libatkmm-1.6-1v5
     apt-get -y install libglibmm-2.4-1v5
     apt-get -y install libgtkmm-3.0-1v5
     apt-get -y install libsigc++-2.0-0v5
     apt-get -y install libtinfo5
     apt-get -y install libcairomm-1.0-1v5
     apt-get -y install libpangomm-1.4-1v5
     apt-get -y install libpcrecpp0v5
     apt-get -y install libproj-dev
     apt-get -y install proj-bin

  # Descargar el archivo .deb
     mkdir -p /root/InstSoft/MySQLWorkbench
     cd /root/InstSoft/MySQLWorkbench
     wget https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-dbgsym_8.0.27-1ubuntu20.04_amd64.deb

  # Instalar el archivo .deb
     dpkg -i /root/InstSoft/MySQLWorkbench/mysql-workbench-community_8.0.23-1ubuntu18.04_amd64.deb

elif [ $cVerSO == "11" ]; then

  echo ""

  echo "  Iniciando el script de instalación de MySQL Workbench para Debian 11 (Bullseye)..."

  echo ""

  apt-get -y install snapd
  snap install core
  snap install mysql-workbench-community

  # Crear icono en el menú
    echo ""
    echo "  Creando icono en el menú"
    echo ""
    mkdir -p ~/.local/share/applications/ 2> /dev/null
    echo "[Desktop Entry]"                                                   > ~/.local/share/applications/MySQLWorkbench.desktop
    echo "Type=Application"                                                 >> ~/.local/share/applications/MySQLWorkbench.desktop
    echo "Name=MySQL Workbench"                                             >> ~/.local/share/applications/MySQLWorkbench.desktop
    echo "Exec=snap run mysql-workbench-community"                          >> ~/.local/share/applications/MySQLWorkbench.desktop
    echo "Icon=/snap/mysql-workbench-community/current/mysql-workbench.png" >> ~/.local/share/applications/MySQLWorkbench.desktop
    echo "Terminal=false"                                                   >> ~/.local/share/applications/MySQLWorkbench.desktop
    gio set ~/.local/share/applications/MySQLWorkbench.desktop "metadata::trusted" yes

  # Habilitar conexiones SSH y password manager
    snap connect mysql-workbench-community:password-manager-service
    snap connect mysql-workbench-community:ssh-keys

  #ln -s /etc/profile.d/apps-bin-path.sh /etc/X11/Xsession.d/99snap
  #echo "ENV_PATH PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin" >> /etc/login.defs

fi

