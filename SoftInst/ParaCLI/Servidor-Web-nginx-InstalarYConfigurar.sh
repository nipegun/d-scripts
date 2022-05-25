#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar nginx en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Web-nginx-InstalarYConfigurar.sh | bash
#----------------------------------------------------------------------------------------------------------------------------------------

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
  echo "-------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de nginx para Debian 7 (Wheezy)..."
  echo "-------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de nginx para Debian 8 (Jessie)..."
  echo "-------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "--------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de nginx para Debian 9 (Stretch)..."
  echo "--------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "--------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de nginx para Debian 10 (Buster)..."
  echo "--------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Actualizando la lista de paquetes..."
  echo ""
  apt-get -y update

  echo ""
  echo "Instalando nginx..."
  echo ""
  apt-get -y install nginx

  echo ""
  echo "Instalando y configurando PHP..."
  echo ""
  apt-get -y install php-fpm
  sed -i -e 's|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|g' /etc/php/7.3/fpm/php.ini

  echo ""
  echo "Configurando el sitio principal para que también sirva PHP..."
  echo ""
  cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
  echo "server {"                                                         > /etc/nginx/sites-available/default
  echo "  listen 80 default_server;"                                     >> /etc/nginx/sites-available/default
  echo "  listen [::]:80 default_server;"                                >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "  #listen 443 ssl default_server;"                               >> /etc/nginx/sites-available/default
  echo "  #listen [::]:443 ssl default_server;"                          >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "  #include snippets/snakeoil.conf;"                              >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "  root /var/www/html;"                                           >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "  index index.php index.html index.htm index.nginx-debian.html;" >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "  server_name _;"                                                >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "  location / {"                                                  >> /etc/nginx/sites-available/default
  echo "    try_files "'$uri'" "'$uri'"/ =404;"                          >> /etc/nginx/sites-available/default
  echo "  }"                                                             >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "  location ~ \.php$ {"                                           >> /etc/nginx/sites-available/default
  echo "    include snippets/fastcgi-php.conf;"                          >> /etc/nginx/sites-available/default
  echo "    fastcgi_pass unix:/run/php/php7.3-fpm.sock;"                 >> /etc/nginx/sites-available/default
  echo "  }"                                                             >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "  location ~ /\.ht {"                                            >> /etc/nginx/sites-available/default
  echo "    deny all;"                                                   >> /etc/nginx/sites-available/default
  echo "  }"                                                             >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "}"                                                               >> /etc/nginx/sites-available/default

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de nginx para Debian 11 (Bullseye)..."
  echo "----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Actualizando la lista de paquetes..."
  echo ""
  apt-get -y update

  echo ""
  echo "Instalando nginx..."
  echo ""
  apt-get -y install nginx

  echo ""
  echo "Instalando y configurando PHP..."
  echo ""
  apt-get -y install php-fpm
  sed -i -e 's|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|g' /etc/php/7.3/fpm/php.ini

  echo ""
  echo "Configurando el sitio principal para que también sirva PHP..."
  echo ""
  cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
  echo "server {"                                                         > /etc/nginx/sites-available/default
  echo "  listen 80 default_server;"                                     >> /etc/nginx/sites-available/default
  echo "  listen [::]:80 default_server;"                                >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "  #listen 443 ssl default_server;"                               >> /etc/nginx/sites-available/default
  echo "  #listen [::]:443 ssl default_server;"                          >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "  #include snippets/snakeoil.conf;"                              >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "  root /var/www/html;"                                           >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "  index index.php index.html index.htm index.nginx-debian.html;" >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "  server_name _;"                                                >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "  location / {"                                                  >> /etc/nginx/sites-available/default
  echo "    try_files "'$uri'" "'$uri'"/ =404;"                          >> /etc/nginx/sites-available/default
  echo "  }"                                                             >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "  location ~ \.php$ {"                                           >> /etc/nginx/sites-available/default
  echo "    include snippets/fastcgi-php.conf;"                          >> /etc/nginx/sites-available/default
  echo "    fastcgi_pass unix:/run/php/php7.4-fpm.sock;"                 >> /etc/nginx/sites-available/default
  echo "  }"                                                             >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "  location ~ /\.ht {"                                            >> /etc/nginx/sites-available/default
  echo "    deny all;"                                                   >> /etc/nginx/sites-available/default
  echo "  }"                                                             >> /etc/nginx/sites-available/default
  echo ""                                                                >> /etc/nginx/sites-available/default
  echo "}"                                                               >> /etc/nginx/sites-available/default

  echo ""
  echo "Agregando certificado SSL autofirmado..."
  echo ""
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginxdefault.key -out /etc/ssl/certs/nginxdefault.pem
  openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

  echo "ssl_certificate /etc/ssl/certs/nginxdefault.pem;"        > /etc/nginx/snippets/self-signed.conf
  echo "ssl_certificate_key /etc/ssl/private/nginxdefault.key;" >> /etc/nginx/snippets/self-signed.conf

  echo "ssl_protocols TLSv1 TLSv1.1 TLSv1.2;"                                         > /etc/nginx/snippets/ssl-params.conf
  echo "ssl_prefer_server_ciphers on;"                                               >> /etc/nginx/snippets/ssl-params.conf
  echo 'ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";'              >> /etc/nginx/snippets/ssl-params.conf
  echo "ssl_ecdh_curve secp384r1;"                                                   >> /etc/nginx/snippets/ssl-params.conf
  echo "ssl_session_cache shared:SSL:10m;"                                           >> /etc/nginx/snippets/ssl-params.conf
  echo "ssl_session_tickets off;"                                                    >> /etc/nginx/snippets/ssl-params.conf
  echo "ssl_stapling off;"                                                           >> /etc/nginx/snippets/ssl-params.conf
  echo "ssl_stapling_verify on;"                                                     >> /etc/nginx/snippets/ssl-params.conf
  echo "resolver 8.8.8.8 8.8.4.4 valid=300s;"                                        >> /etc/nginx/snippets/ssl-params.conf
  echo "resolver_timeout 5s;"                                                        >> /etc/nginx/snippets/ssl-params.conf
  echo 'add_header Strict-Transport-Security "max-age=63072000; includeSubdomains";' >> /etc/nginx/snippets/ssl-params.conf
  echo "add_header X-Frame-Options DENY;"                                            >> /etc/nginx/snippets/ssl-params.conf
  echo "add_header X-Content-Type-Options nosniff;"                                  >> /etc/nginx/snippets/ssl-params.conf
  echo "ssl_dhparam /etc/ssl/certs/dhparam.pem;"                                     >> /etc/nginx/snippets/ssl-params.conf

  sed -i -e 's|#listen 443 ssl default_server;|listen 443 ssl default_server;|g'                                               /etc/nginx/sites-available/default
  sed -i -e 's|#listen [::]:443 ssl default_server;|listen [::]:443 ssl default_server;\ninclude snippets/self-signed.conf;|g' /etc/nginx/sites-available/default
  sed -i -e 's|#include snippets/self-signed.conf;|include snippets/self-signed.conf;\ninclude snippets/ssl-params.conf;|g'     /etc/nginx/sites-available/default

fi

