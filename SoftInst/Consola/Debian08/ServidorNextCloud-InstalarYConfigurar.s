#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA INSTALAR Y CONFIGURAR NEXTCLOUD
#----------------------------------------------------------

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

