#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar NextCloud en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-NextCloud-InstalarYConfigurar.sh
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

  contraseña=12345678

  echo ""
  echo "---------------------------------------"
  echo "  INSTALANDO Y CONFIGURANDO nextcloud"
  echo "---------------------------------------"
  echo ""

  mkdir -p /Nube/
  apt-get -y install wget
  wget hacks4geeks.com/_/premium/descargas/pc/linux/debian8/etc/php5/apache2/php.ini -O /etc/php5/apache2/php.ini
  wget hacks4geeks.com/_/premium/descargas/pc/linux/nextcloud.zip -P /tmp/
  unzip /tmp/nextcloud.zip -d /var/www/html/
  chown -v -R www-data:www-data /var/www/html/nextcloud/
  echo 'Alias /nextcloud "/var/www/html/nextcloud/"' > /etc/apache2/sites-available/nextcloud.conf
  echo "" >> /etc/apache2/sites-available/nextcloud.conf
  echo "<Directory /var/www/html/nextcloud/>" >> /etc/apache2/sites-available/nextcloud.conf
  echo " Options +FollowSymlinks" >> /etc/apache2/sites-available/nextcloud.conf
  echo " AllowOverride All" >> /etc/apache2/sites-available/nextcloud.conf
  echo "" >> /etc/apache2/sites-available/nextcloud.conf
  echo " <IfModule mod_dav.c>" >> /etc/apache2/sites-available/nextcloud.conf
  echo " Dav off" >> /etc/apache2/sites-available/nextcloud.conf
  echo " </IfModule>" >> /etc/apache2/sites-available/nextcloud.conf
  echo "" >> /etc/apache2/sites-available/nextcloud.conf
  echo " SetEnv HOME /var/www/html/nextcloud" >> /etc/apache2/sites-available/nextcloud.conf
  echo " SetEnv HTTP_HOME /var/www/html/nextcloud" >> /etc/apache2/sites-available/nextcloud.conf
  echo "" >> /etc/apache2/sites-available/nextcloud.conf
  echo "</Directory>" >> /etc/apache2/sites-available/nextcloud.conf
  ln -s /etc/apache2/sites-available/nextcloud.conf /etc/apache2/sites-enabled/nextcloud.conf
  a2enmod rewrite
  a2enmod headers
  a2enmod env
  a2enmod dir
  a2enmod mime
  service apache2 restart
  mkdir -p /root/scripts/
  sh /root/scripts/d-scripts/CrearBaseDeDatosYUsuario.sh nextcloud nextcloud $contraseña
  chown -v -R www-data:www-data /Nube/

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 9 (Stretch)..."
  
  echo ""

  cCantArgumEsperados=1
  

  if [ $# -ne $cCantArgumEsperados ]
    then
      echo ""
      
      echo "Mal uso del script."
      echo ""
      echo "El uso correcto sería: InstalarYConfigurarServidorNextCloud [Password]"
      echo ""
      echo "Ejemplo:"
      echo ' InstalarYConfigurarServidorNextCloud ausdhg76atsd'
      
      echo ""
      exit
    else
      echo ""
      
      echo "  Instalando y configurando el servidor NextCloud..."
      
      echo ""
      apt-get -y update
      tasksel install web-server
      systemctl enable apache2
      apt-get -y install mariadb-server
      systemctl enable mysql
      apt-get -y install php7.0-xml php7.0-cgi php7.0-cli php7.0-gd php7.0-curl php7.0-zip php7.0-mysql php7.0-mbstring 
      systemctl start apache2
      systemctl start mysql
      mysql_secure_installation
      cbddyu nextcloud nextcloud $1
      mkdir /var/www/html/nextcloud
      cd /var/www/html
      apt-get -y install wget
      wget --no-check-certificate http://hacks4geeks.com/_/premium/descargas/debian/root/paquetes/nextcloud/nextcloud.zip
      apt-get -y install unzip
      unzip nextcloud.zip
  
  fi

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

