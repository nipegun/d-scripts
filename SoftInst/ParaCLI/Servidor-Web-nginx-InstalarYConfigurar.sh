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

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

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

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}  dialog no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi

  cmd=(dialog --checklist "Script de NiPeGun para instalar nginx en Debian 11:" 22 76 16)
  options=(
    1 "Instalar el paquete nginx" on
    2 "Instalar y configurar PHP" off
    3 "Activar HTTPS y agregar certificado SSL autofirmado" off
    4 "Instalar certificado SSL de letsencrypt" off
    5 "Configurar y activar el módulo remoteip para estar detrás de un proxy inverso" off
  )
  choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
  clear
  for choice in $choices
  do
    case $choice in

      1)

        echo ""
        echo "  Instalando el paquete nginx..."
        echo ""
        apt-get -y update && apt-get -y install nginx

        echo '<!DOCTYPE html>'                                     > /var/www/html/index.html
        echo '<html lang="es">'                                   >> /var/www/html/index.html
        echo "  <head>"                                           >> /var/www/html/index.html
        echo "    <meta charset='UTF-8'>"                         >> /var/www/html/index.html
        echo "    <title>nginx</title>"                           >> /var/www/html/index.html
        echo "  </head>"                                          >> /var/www/html/index.html
        echo "  <body>"                                           >> /var/www/html/index.html
        echo "    <p>Servidor nginx instalado correctamente.</p>" >> /var/www/html/index.html
        echo "  </body>"                                          >> /var/www/html/index.html
        echo "</html>"                                            >> /var/www/html/index.html
        chown www-data:www-data /var/www/html/index.html
        rm -f /var/www/html/index.nginx-debian.html

      ;;

      2)

        echo ""
        echo "  Instalando y configurando PHP..."
        echo ""
        apt-get -y install php-fpm
        sed -i -e 's|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|g' /etc/php/7.3/fpm/php.ini
        sed -i -e 's|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|g' /etc/php/7.4/fpm/php.ini

        echo ""
        echo "    Configurando el sitio principal para que también sirva PHP..."
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

      ;;

      3)

        echo ""
        echo "  Activando https y agregando certificado SSL autofirmado..."
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

        sed -i -e 's|SSL configuration|SSL configuration\nlisten 443 ssl default_server;\nlisten [::]:443 ssl default_server;\ninclude snippets/self-signed.conf;\ninclude snippets/ssl-params.conf;|g' /etc/nginx/sites-available/default

      ;;

      4)

        echo ""
        echo "  Comandos todavía no preparados."
        echo ""

      ;;

      5)

        echo ""
        echo "  Comandos todavía no preparados."
        echo ""

      ;;

    esac

  done

fi

