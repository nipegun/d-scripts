#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para crear nuevas webs en /var/www
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Web-Apache-NuevaVarWWW.sh | bash -s Extension Dominio Password
# ----------

vCantParamCorr=3

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $vCantParamCorr ]; then
  echo ""
  echo -e "${cColorRojo}Mal uso del script. Se le deben pasar tres parámetros obligatorios:${cFinColor}"
  echo ""
  echo -e "${cColorVerde}[ExtensionDelDominio] [NombreDeLaWeb] y [Password]${cFinColor}"
  echo ""
  echo "Ejemplo:"
  echo ""
  echo -e "$0 ${cColorVerde}.org unawebcualquiera 12345678${cFinColor}"
  echo ""
  echo "NOTA: El nombre de la Web también se utilizará como nombre de usuario MySQL."
  echo ""
  exit
else
  # Comprobar si el nombre de usuario MySQL deseado tiene mas de 16 caracteres
    nombre_mysql_deseado=$2

  if [ ${#nombre_mysql_deseado} -gt 16 ]; then

    # Acortar nombre de usuario MySQL a 16 caracteres
      nombre_mysql_ok=`expr substr $nombre_mysql_deseado 1 16`

    # Advertir al usuario de que se va a usar un nombre de usuario MySQL acortado
      clear
      echo ""
      echo "Has intentado usar $nombre_mysql_deseado como nombre para el usuario"
      echo "de la base de datos pero MySQL no admite nombres de usuario"
      echo "de más de 16 caracteres. En su lugar se utilizará $nombre_mysql_ok"
      echo ""

    # Crear la base de datos
      echo ""
      echo "$(tput setaf 1)Creando la base de datos con su usuario... $(tput sgr 0)"
      echo ""
      /root/scripts/d-scripts/MySQL-BaseDeDatos-Crear.sh $2 $nombre_mysql_ok $3

    # Crear las carpetas de la web
      mkdir -p /var/www/$2$1/_/logs/
      echo "WEB OK" > /var/www/$2$1/index.html

    # Crear la web en Apache
      cp /etc/apache2/sites-available/nuevawebvar.conf /etc/apache2/sites-available/$2$1.conf
      sed -i -e "s/nuevawebvar.com/$2$1/g" /etc/apache2/sites-available/$2$1.conf

    # Activar la configuración de la nueva Web en Apache
      echo ""
      echo "$(tput setaf 1)Activando la web en apache... $(tput sgr 0)"
      echo ""
      a2ensite $2$1

    # Crear el certificado SSL, deteninendo Apache
      echo ""
      echo "$(tput setaf 1)Creando el certificado SSL... $(tput sgr 0)"
      echo ""
      iptables -A INPUT -p tcp --dport 443 -j ACCEPT
      service apache2 stop
      apt-get update
      apt-get -y install
      apt-get -y install certbot
      apt-get -y install python3-certbot-apache
      certbot --apache -d $2$1 -d www.$2$1

    # Volver a arrancar Apache
      echo ""
      echo "$(tput setaf 1)Re-arrancando Apache... $(tput sgr 0)"
      echo ""
      service apache2 start

    # Crear el archivo .htaccess con algunas opciones
      echo "# BEGIN Medidas de seguridad"                                              > /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "  # IMPEDIR ACCESO NO AUTORIZADO AL ARCHIVO .HTACCESS"                    >> /var/www/$2$1/.htaccess
      echo '    <files ~ "^.*\.([Hh][Tt][Aa])">'                                      >> /var/www/$2$1/.htaccess
      echo "      order allow,deny"                                                   >> /var/www/$2$1/.htaccess
      echo "      deny from all"                                                      >> /var/www/$2$1/.htaccess
      echo "      satisfy all"                                                        >> /var/www/$2$1/.htaccess
      echo "    </files>"                                                             >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "  # DESHABILITAR LA NAVEGACIÓN POR CARPETAS QUE NO TENGAN INDEX"          >> /var/www/$2$1/.htaccess
      echo "    Options -Indexes"                                                     >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "  # IMPEDIR EL ACCESO DE CIERTAS IPS"                                     >> /var/www/$2$1/.htaccess
      echo "    <Limit GET POST>"                                                     >> /var/www/$2$1/.htaccess
      echo "      order allow,deny"                                                   >> /var/www/$2$1/.htaccess
      echo "      deny from 45.45.45.45"                                              >> /var/www/$2$1/.htaccess
      echo "      allow from all"                                                     >> /var/www/$2$1/.htaccess
      echo "    </Limit>"                                                             >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "  # PROTEGER EL ARCHIVO DE CONFIGURACIÓN DE WORDPRESS"                    >> /var/www/$2$1/.htaccess
      echo "    <files wp-config.php>"                                                >> /var/www/$2$1/.htaccess
      echo "      order allow,deny"                                                   >> /var/www/$2$1/.htaccess
      echo "      deny from all"                                                      >> /var/www/$2$1/.htaccess
      echo "    </files>"                                                             >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "  <IfModule mod_rewrite.c>"                                               >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "    RewriteEngine On"                                                     >> /var/www/$2$1/.htaccess
      echo "    RewriteBase /"                                                        >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "    # BLOQUEAR EL ESCANEO DE AUTORES EN WORDPRESS"                        >> /var/www/$2$1/.htaccess
      echo "      RewriteCond %{QUERY_STRING} (author=\d+) [NC]"                      >> /var/www/$2$1/.htaccess
      echo "      RewriteRule .* - [F]"                                               >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "    # IMPEDIR EL HOTLINKING DE IMÁGENES"                                  >> /var/www/$2$1/.htaccess
      echo "      RewriteCond %{HTTP_REFERER} !^$"                                    >> /var/www/$2$1/.htaccess
      echo "      RewriteCond %{HTTP_REFERER} !^http(s)?://(www\.)?nuevaweb.com [NC]" >> /var/www/$2$1/.htaccess
      echo "      RewriteCond %{HTTP_REFERER} !^http(s)?://(www\.)?google.com [NC]"   >> /var/www/$2$1/.htaccess
      echo "      RewriteRule \.(jpg|jpeg|png|gif)$ – [NC,F,L]"                       >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "  </IfModule>"                                                            >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "# END Medidas de seguridad"                                               >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "# BEGIN Redirigir www. a sin www."                                        >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "  <IfModule mod_rewrite.c>"                                               >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "      RewriteEngine On"                                                   >> /var/www/$2$1/.htaccess
      echo "      RewriteBase /"                                                      >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "      RewriteCond %{HTTP_HOST} ^www\.(.*)$ [NC]"                          >> /var/www/$2$1/.htaccess
      echo "      RewriteRule ^(.*)$ http://%1/$1 [R=301,L]"                          >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "  </IfModule>"                                                            >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "# END Redirigir www. a sin www."                                          >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess

    # Proteger los logs para que sólo se puedan ver con la sesión en WordPress iniciada
      echo "#<Files *>"                                                    > /var/www/$2$1/_/logs/.htaccess
      echo "#"                                                            >> /var/www/$2$1/_/logs/.htaccess
      echo "#  Order Deny,Allow"                                          >> /var/www/$2$1/_/logs/.htaccess
      echo "#  #Allow from 127.0.0.1"                                     >> /var/www/$2$1/_/logs/.htaccess
      echo "#  Deny from all"                                             >> /var/www/$2$1/_/logs/.htaccess
      echo "#"                                                            >> /var/www/$2$1/_/logs/.htaccess
      echo "#</Files>"                                                    >> /var/www/$2$1/_/logs/.htaccess
      echo ""                                                             >> /var/www/$2$1/_/logs/.htaccess
      echo "RewriteEngine On"                                             >> /var/www/$2$1/_/logs/.htaccess
      echo ""                                                             >> /var/www/$2$1/_/logs/.htaccess
      echo "# Si alguien llega a la web desde otro lugar que no sea $2$1" >> /var/www/$2$1/_/logs/.htaccess
      echo "RewriteCond %{HTTP_REFERER} !^http://(www\.)?$2\\$1/ [NC]"    >> /var/www/$2$1/_/logs/.htaccess
      echo ""                                                             >> /var/www/$2$1/_/logs/.htaccess
      echo "#, pide directamente por un archivo con extension log"        >> /var/www/$2$1/_/logs/.htaccess
      echo "RewriteCond %{REQUEST_URI} !hotlink\.(log) [NC]"              >> /var/www/$2$1/_/logs/.htaccess
      echo ""                                                             >> /var/www/$2$1/_/logs/.htaccess
      echo "# y no tiene la sesion iniciada en WordPress"                 >> /var/www/$2$1/_/logs/.htaccess
      echo "RewriteCond %{HTTP_COOKIE} !^.*wordpress_logged_in.*$ [NC]"   >> /var/www/$2$1/_/logs/.htaccess
      echo ""                                                             >> /var/www/$2$1/_/logs/.htaccess
      echo "# Redirigirlo a google.com"                                   >> /var/www/$2$1/_/logs/.htaccess
      echo "RewriteRule .*\.(log)$ http://google.com/ [NC]"               >> /var/www/$2$1/_/logs/.htaccess

    # Reparar permisos y propietario de la carpeta
      chown www-data:www-data /var/www/$2$1/ -R
      find /var/www/$2$1/ -type d -exec chmod 755 {} \;
      find /var/www/$2$1/ -type f -exec chmod 644 {} \;
      chown -v root:root /var/www

    # Mostrar el resultado de la operacion
      echo "--------------------------------"
      echo ""
      echo "Toda La operación de agregar una nueva web se completó correctamente. Los datos son los siguientes:"
      echo ""
      echo "BASE DE DATOS MYSQL:"
      echo "Nombre: $2"
      echo "Usuario: $nombre_mysql_ok"
      echo "Contraseña: $3"
      echo ""
      echo "--------------------------------"
      echo ""
    exit

  else

    # Crear la base de datos
      echo ""
      echo "$(tput setaf 1)Creando la base de datos con su usuario... $(tput sgr 0)"
      echo ""
      /root/scripts/d-scripts/MySQL-BaseDeDatos-Crear.sh $2 $2 $3

    # Crear las carpetas de la web
      mkdir -p /var/www/$2$1/_/logs/
      echo "WEB OK" > /var/www/$2$1/index.html

    # Crear la web en Apache
      cp /etc/apache2/sites-available/nuevawebvar.conf /etc/apache2/sites-available/$2$1.conf
      sed -i -e "s/nuevawebvar.com/$2$1/g" /etc/apache2/sites-available/$2$1.conf

    # Activar la configuración de la nueva Web en Apache
      echo ""
      echo "$(tput setaf 1)Activando la web en apache... $(tput sgr 0)"
      echo ""
      a2ensite $2$1

    # Crear el certificado SSL, deteninendo Apache
      echo ""
      echo "$(tput setaf 1)Creando el certificado SSL... $(tput sgr 0)"
      echo ""
      iptables -A INPUT -p tcp --dport 443 -j ACCEPT
      service apache2 stop
      apt-get update
      apt-get -y install certbot
      apt-get -y install python3-certbot-apache
      certbot --apache -d $2$1 -d www.$2$1

    # Volver a arrancar Apache
      echo ""
      echo "$(tput setaf 1)Re-arrancando Apache... $(tput sgr 0)"
      echo ""
      service apache2 start

    # Crear el archivo .htaccess con algunas opciones
      echo "# BEGIN Medidas de seguridad"                                              > /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "  # IMPEDIR ACCESO NO AUTORIZADO AL ARCHIVO .HTACCESS"                    >> /var/www/$2$1/.htaccess
      echo '    <files ~ "^.*\.([Hh][Tt][Aa])">'                                      >> /var/www/$2$1/.htaccess
      echo "      order allow,deny"                                                   >> /var/www/$2$1/.htaccess
      echo "      deny from all"                                                      >> /var/www/$2$1/.htaccess
      echo "      satisfy all"                                                        >> /var/www/$2$1/.htaccess
      echo "    </files>"                                                             >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "  # DESHABILITAR LA NAVEGACIÓN POR CARPETAS QUE NO TENGAN INDEX"          >> /var/www/$2$1/.htaccess
      echo "    Options -Indexes"                                                     >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "  # IMPEDIR EL ACCESO DE CIERTAS IPS"                                     >> /var/www/$2$1/.htaccess
      echo "    <Limit GET POST>"                                                     >> /var/www/$2$1/.htaccess
      echo "      order allow,deny"                                                   >> /var/www/$2$1/.htaccess
      echo "      deny from 45.45.45.45"                                              >> /var/www/$2$1/.htaccess
      echo "      allow from all"                                                     >> /var/www/$2$1/.htaccess
      echo "    </Limit>"                                                             >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "  # PROTEGER EL ARCHIVO DE CONFIGURACIÓN DE WORDPRESS"                    >> /var/www/$2$1/.htaccess
      echo "    <files wp-config.php>"                                                >> /var/www/$2$1/.htaccess
      echo "      order allow,deny"                                                   >> /var/www/$2$1/.htaccess
      echo "      deny from all"                                                      >> /var/www/$2$1/.htaccess
      echo "    </files>"                                                             >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "  <IfModule mod_rewrite.c>"                                               >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "    RewriteEngine On"                                                     >> /var/www/$2$1/.htaccess
      echo "    RewriteBase /"                                                        >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "    # BLOQUEAR EL ESCANEO DE AUTORES EN WORDPRESS"                        >> /var/www/$2$1/.htaccess
      echo "      RewriteCond %{QUERY_STRING} (author=\d+) [NC]"                      >> /var/www/$2$1/.htaccess
      echo "      RewriteRule .* - [F]"                                               >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "    # IMPEDIR EL HOTLINKING DE IMÁGENES"                                  >> /var/www/$2$1/.htaccess
      echo "      RewriteCond %{HTTP_REFERER} !^$"                                    >> /var/www/$2$1/.htaccess
      echo "      RewriteCond %{HTTP_REFERER} !^http(s)?://(www\.)?nuevaweb.com [NC]" >> /var/www/$2$1/.htaccess
      echo "      RewriteCond %{HTTP_REFERER} !^http(s)?://(www\.)?google.com [NC]"   >> /var/www/$2$1/.htaccess
      echo "      RewriteRule \.(jpg|jpeg|png|gif)$ – [NC,F,L]"                       >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "  </IfModule>"                                                            >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "# END Medidas de seguridad"                                               >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "# BEGIN Redirigir www. a sin www."                                        >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "  <IfModule mod_rewrite.c>"                                               >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "      RewriteEngine On"                                                   >> /var/www/$2$1/.htaccess
      echo "      RewriteBase /"                                                      >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "      RewriteCond %{HTTP_HOST} ^www\.(.*)$ [NC]"                          >> /var/www/$2$1/.htaccess
      echo "      RewriteRule ^(.*)$ http://%1/$1 [R=301,L]"                          >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "  </IfModule>"                                                            >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess
      echo "# END Redirigir www. a sin www."                                          >> /var/www/$2$1/.htaccess
      echo ""                                                                         >> /var/www/$2$1/.htaccess

    # Proteger los logs para que sólo se puedan ver con la sesión en WordPress iniciada
      echo "#<Files *>"                                                    > /var/www/$2$1/_/logs/.htaccess
      echo "#"                                                            >> /var/www/$2$1/_/logs/.htaccess
      echo "#  Order Deny,Allow"                                          >> /var/www/$2$1/_/logs/.htaccess
      echo "#  #Allow from 127.0.0.1"                                     >> /var/www/$2$1/_/logs/.htaccess
      echo "#  Deny from all"                                             >> /var/www/$2$1/_/logs/.htaccess
      echo "#"                                                            >> /var/www/$2$1/_/logs/.htaccess
      echo "#</Files>"                                                    >> /var/www/$2$1/_/logs/.htaccess
      echo ""                                                             >> /var/www/$2$1/_/logs/.htaccess
      echo "RewriteEngine On"                                             >> /var/www/$2$1/_/logs/.htaccess
      echo ""                                                             >> /var/www/$2$1/_/logs/.htaccess
      echo "# Si alguien llega a la web desde otro lugar que no sea $2$1" >> /var/www/$2$1/_/logs/.htaccess
      echo "RewriteCond %{HTTP_REFERER} !^http://(www\.)?$2\\$1/ [NC]"    >> /var/www/$2$1/_/logs/.htaccess
      echo ""                                                             >> /var/www/$2$1/_/logs/.htaccess
      echo "#, pide directamente por un archivo con extension log"        >> /var/www/$2$1/_/logs/.htaccess
      echo "RewriteCond %{REQUEST_URI} !hotlink\.(log) [NC]"              >> /var/www/$2$1/_/logs/.htaccess
      echo ""                                                             >> /var/www/$2$1/_/logs/.htaccess
      echo "# y no tiene la sesion iniciada en WordPress"                 >> /var/www/$2$1/_/logs/.htaccess
      echo "RewriteCond %{HTTP_COOKIE} !^.*wordpress_logged_in.*$ [NC]"   >> /var/www/$2$1/_/logs/.htaccess
      echo ""                                                             >> /var/www/$2$1/_/logs/.htaccess
      echo "# Redirigirlo a google.com"                                   >> /var/www/$2$1/_/logs/.htaccess
      echo "RewriteRule .*\.(log)$ http://google.com/ [NC]"               >> /var/www/$2$1/_/logs/.htaccess

    # Reparar permisos y propietario de la carpeta
      chown www-data:www-data /var/www/$2$1/ -R
      find /var/www/$2$1/ -type d -exec chmod 755 {} \;
      find /var/www/$2$1/ -type f -exec chmod 644 {} \;
      chown -v root:root /var/www

    # Mostrar el resultado de la operacion
      echo ""
      echo "--------------------------------"
      echo ""
      echo "Toda La operación de agregar una nueva web se completó correctamente. Los datos son los siguientes:"
      echo ""
      echo "BASE DE DATOS MYSQL:"
      echo "Nombre: $2"
      echo "Usuario: $2"
      echo "Contraseña: $3"
      echo ""
      echo "--------------------------------"
      echo ""
  fi
fi

