#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear nuevas webs en /var/www
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/Apache-NuevaVarWWW.sh | bash -s Extension Dominio Password
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/Apache-NuevaVarWWW.sh | sed 's-sudo--g' | bash -s Extension Dominio Password
# ----------

cPassBD=""
cDominio=""
cExt=""

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Definir la cantidad de argumentos esperados
  cCantArgsEsperados=3

# Comprobar que se hayan pasado la cantidad de argumentos esperados. Abortar el script si no.
  if [ $# -ne $cCantArgsEsperados ]
    then
      echo ""
      echo -e "${cColorRojo}  Mal uso del script. El uso correcto sería: ${cFinColor}"
      echo ""
      if [[ "$0" == "bash" ]]; then
        vNombreDelScript="script.sh"
      else
        vNombreDelScript="$0"
      fi
      echo "    $vNombreDelScript [ExtensionDelDominio] [Dominio] y [Password]"
      echo ""
      echo "  Ejemplo:"
      echo ""
      echo "    $vNombreDelScript '.org' 'unawebcualquiera' '12345678'"
      echo ""
      echo "  NOTA: El nombre de la Web también se utilizará como nombre de usuario MySQL."
      echo ""
      exit
  fi

# Comprobar si el nombre de usuario MySQL deseado tiene mas de 16 caracteres
  nombre_mysql_deseado="$cDominio"
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
      echo "    Creando la base de datos con su usuario..."
      echo ""
      /root/scripts/d-scripts/MySQL-BaseDeDatos-Crear.sh "$cDominio" $nombre_mysql_ok "$cPassBD"

    # Crear las carpetas de la web
      mkdir -p /var/www/"$cDominio""$cExt"/_/logs/
      echo "WEB OK" > /var/www/"$cDominio""$cExt"/index.html

    # Crear la web en Apache
      cp /etc/apache2/sites-available/nuevawebvar.conf /etc/apache2/sites-available/"$cDominio""$cExt".conf
      sed -i -e "s/nuevawebvar.com/"$cDominio""$cExt"/g" /etc/apache2/sites-available/"$cDominio""$cExt".conf

    # Activar la configuración de la nueva Web en Apache
      echo ""
      echo "    Activando la web en apache..."
      echo ""
      a2ensite "$cDominio""$cExt"

    # Crear el certificado SSL, deteninendo Apache
      echo ""
      echo "    Creando el certificado SSL..."
      echo ""
      iptables -A INPUT -p tcp --dport 443 -j ACCEPT
      service apache2 stop
      apt-get update
      apt-get -y install
      apt-get -y install certbot
      apt-get -y install python3-certbot-apache
      certbot --apache -d "$cDominio""$cExt" -d www."$cDominio""$cExt"

    # Volver a arrancar Apache
      echo ""
      echo "  Re-arrancando Apache..."
      echo ""
      service apache2 start

    # Crear el archivo .htaccess con algunas opciones
      echo "# BEGIN Medidas de seguridad"                                              > /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "  # IMPEDIR ACCESO NO AUTORIZADO AL ARCHIVO .HTACCESS"                    >> /var/www/"$cDominio""$cExt"/.htaccess
      echo '    <files ~ "^.*\.([Hh][Tt][Aa])">'                                      >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      order allow,deny"                                                   >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      deny from all"                                                      >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      satisfy all"                                                        >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    </files>"                                                             >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "  # DESHABILITAR LA NAVEGACIÓN POR CARPETAS QUE NO TENGAN INDEX"          >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    Options -Indexes"                                                     >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "  # IMPEDIR EL ACCESO DE CIERTAS IPS"                                     >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    <Limit GET POST>"                                                     >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      order allow,deny"                                                   >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      deny from 45.45.45.45"                                              >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      allow from all"                                                     >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    </Limit>"                                                             >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "  # PROTEGER EL ARCHIVO DE CONFIGURACIÓN DE WORDPRESS"                    >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    <files wp-config.php>"                                                >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      order allow,deny"                                                   >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      deny from all"                                                      >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    </files>"                                                             >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "  <IfModule mod_rewrite.c>"                                               >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    RewriteEngine On"                                                     >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    RewriteBase /"                                                        >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    # BLOQUEAR EL ESCANEO DE AUTORES EN WORDPRESS"                        >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteCond %{QUERY_STRING} (author=\d+) [NC]"                      >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteRule .* - [F]"                                               >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    # IMPEDIR EL HOTLINKING DE IMÁGENES"                                  >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteCond %{HTTP_REFERER} !^$"                                    >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteCond %{HTTP_REFERER} !^http(s)?://(www\.)?nuevaweb.com [NC]" >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteCond %{HTTP_REFERER} !^http(s)?://(www\.)?google.com [NC]"   >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteRule \.(jpg|jpeg|png|gif)$ – [NC,F,L]"                       >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "  </IfModule>"                                                            >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "# END Medidas de seguridad"                                               >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "# BEGIN Redirigir www. a sin www."                                        >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "  <IfModule mod_rewrite.c>"                                               >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteEngine On"                                                   >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteBase /"                                                      >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteCond %{HTTP_HOST} ^www\.(.*)$ [NC]"                          >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteRule ^(.*)$ http://%1/"$cExt" [R=301,L]"                     >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "  </IfModule>"                                                            >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "# END Redirigir www. a sin www."                                          >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess

    # Proteger los logs para que sólo se puedan ver con la sesión en WordPress iniciada
      echo "#<Files *>"                                                    > /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "#"                                                            >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "#  Order Deny,Allow"                                          >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "#  #Allow from 127.0.0.1"                                     >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "#  Deny from all"                                             >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "#"                                                            >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "#</Files>"                                                    >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo ""                                                             >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "RewriteEngine On"                                             >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo ""                                                             >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "# Si alguien llega a la web desde otro lugar que no sea "$cDominio""$cExt"" >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "RewriteCond %{HTTP_REFERER} !^http://(www\.)?"$cDominio"\\"$cExt"/ [NC]"    >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo ""                                                             >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "#, pide directamente por un archivo con extension log"        >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "RewriteCond %{REQUEST_URI} !hotlink\.(log) [NC]"              >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo ""                                                             >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "# y no tiene la sesion iniciada en WordPress"                 >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "RewriteCond %{HTTP_COOKIE} !^.*wordpress_logged_in.*$ [NC]"   >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo ""                                                             >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "# Redirigirlo a google.com"                                   >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "RewriteRule .*\.(log)$ http://google.com/ [NC]"               >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess

    # Reparar permisos y propietario de la carpeta
      chown www-data:www-data /var/www/"$cDominio""$cExt"/ -R
      find /var/www/"$cDominio""$cExt"/ -type d -exec chmod 755 {} \;
      find /var/www/"$cDominio""$cExt"/ -type f -exec chmod 644 {} \;
      chown -v root:root /var/www

    # Mostrar el resultado de la operacion
      echo "--------------------------------"
      echo ""
      echo "Toda La operación de agregar una nueva web se completó correctamente. Los datos son los siguientes:"
      echo ""
      echo "BASE DE DATOS MYSQL:"
      echo "Nombre: "$cDominio""
      echo "Usuario: $nombre_mysql_ok"
      echo "Contraseña: "$cPassBD""
      echo ""
      echo "--------------------------------"
      echo ""
    exit

  else

    # Crear la base de datos
      echo ""
      echo "    Creando la base de datos con su usuario..."
      echo ""
      /root/scripts/d-scripts/MySQL-BaseDeDatos-Crear.sh "$cDominio" "$cDominio" "$cPassBD"

    # Crear las carpetas de la web
      mkdir -p /var/www/"$cDominio""$cExt"/_/logs/
      echo "WEB OK" > /var/www/"$cDominio""$cExt"/index.html

    # Crear la web en Apache
      cp /etc/apache2/sites-available/nuevawebvar.conf /etc/apache2/sites-available/"$cDominio""$cExt".conf
      sed -i -e "s/nuevawebvar.com/"$cDominio""$cExt"/g" /etc/apache2/sites-available/"$cDominio""$cExt".conf

    # Activar la configuración de la nueva Web en Apache
      echo ""
      echo "    Activando la web en apache..."
      echo ""
      a2ensite "$cDominio""$cExt"

    # Crear el certificado SSL, deteninendo Apache
      echo ""
      echo "    Creando el certificado SSL..."
      echo ""
      iptables -A INPUT -p tcp --dport 443 -j ACCEPT
      service apache2 stop
      apt-get update
      apt-get -y install certbot
      apt-get -y install python3-certbot-apache
      certbot --apache -d "$cDominio""$cExt" -d www."$cDominio""$cExt"

    # Volver a arrancar Apache
      echo ""
      echo "    Re-arrancando Apache..."
      echo ""
      service apache2 start

    # Crear el archivo .htaccess con algunas opciones
      echo "# BEGIN Medidas de seguridad"                                              > /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "  # IMPEDIR ACCESO NO AUTORIZADO AL ARCHIVO .HTACCESS"                    >> /var/www/"$cDominio""$cExt"/.htaccess
      echo '    <files ~ "^.*\.([Hh][Tt][Aa])">'                                      >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      order allow,deny"                                                   >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      deny from all"                                                      >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      satisfy all"                                                        >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    </files>"                                                             >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "  # DESHABILITAR LA NAVEGACIÓN POR CARPETAS QUE NO TENGAN INDEX"          >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    Options -Indexes"                                                     >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "  # IMPEDIR EL ACCESO DE CIERTAS IPS"                                     >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    <Limit GET POST>"                                                     >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      order allow,deny"                                                   >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      deny from 45.45.45.45"                                              >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      allow from all"                                                     >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    </Limit>"                                                             >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "  # PROTEGER EL ARCHIVO DE CONFIGURACIÓN DE WORDPRESS"                    >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    <files wp-config.php>"                                                >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      order allow,deny"                                                   >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      deny from all"                                                      >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    </files>"                                                             >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "  <IfModule mod_rewrite.c>"                                               >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    RewriteEngine On"                                                     >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    RewriteBase /"                                                        >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    # BLOQUEAR EL ESCANEO DE AUTORES EN WORDPRESS"                        >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteCond %{QUERY_STRING} (author=\d+) [NC]"                      >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteRule .* - [F]"                                               >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "    # IMPEDIR EL HOTLINKING DE IMÁGENES"                                  >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteCond %{HTTP_REFERER} !^$"                                    >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteCond %{HTTP_REFERER} !^http(s)?://(www\.)?nuevaweb.com [NC]" >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteCond %{HTTP_REFERER} !^http(s)?://(www\.)?google.com [NC]"   >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteRule \.(jpg|jpeg|png|gif)$ – [NC,F,L]"                       >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "  </IfModule>"                                                            >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "# END Medidas de seguridad"                                               >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "# BEGIN Redirigir www. a sin www."                                        >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "  <IfModule mod_rewrite.c>"                                               >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteEngine On"                                                   >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteBase /"                                                      >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteCond %{HTTP_HOST} ^www\.(.*)$ [NC]"                          >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "      RewriteRule ^(.*)$ http://%1/"$cExt" [R=301,L]"                          >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "  </IfModule>"                                                            >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess
      echo "# END Redirigir www. a sin www."                                          >> /var/www/"$cDominio""$cExt"/.htaccess
      echo ""                                                                         >> /var/www/"$cDominio""$cExt"/.htaccess

    # Proteger los logs para que sólo se puedan ver con la sesión en WordPress iniciada
      echo "#<Files *>"                                                    > /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "#"                                                            >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "#  Order Deny,Allow"                                          >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "#  #Allow from 127.0.0.1"                                     >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "#  Deny from all"                                             >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "#"                                                            >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "#</Files>"                                                    >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo ""                                                             >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "RewriteEngine On"                                             >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo ""                                                             >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "# Si alguien llega a la web desde otro lugar que no sea "$cDominio""$cExt"" >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "RewriteCond %{HTTP_REFERER} !^http://(www\.)?"$cDominio"\\"$cExt"/ [NC]"    >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo ""                                                             >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "#, pide directamente por un archivo con extension log"        >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "RewriteCond %{REQUEST_URI} !hotlink\.(log) [NC]"              >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo ""                                                             >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "# y no tiene la sesion iniciada en WordPress"                 >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "RewriteCond %{HTTP_COOKIE} !^.*wordpress_logged_in.*$ [NC]"   >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo ""                                                             >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "# Redirigirlo a google.com"                                   >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess
      echo "RewriteRule .*\.(log)$ http://google.com/ [NC]"               >> /var/www/"$cDominio""$cExt"/_/logs/.htaccess

    # Reparar permisos y propietario de la carpeta
      chown www-data:www-data /var/www/"$cDominio""$cExt"/ -R
      find /var/www/"$cDominio""$cExt"/ -type d -exec chmod 755 {} \;
      find /var/www/"$cDominio""$cExt"/ -type f -exec chmod 644 {} \;
      chown -v root:root /var/www

    # Mostrar el resultado de la operacion
      echo ""
      echo "--------------------------------"
      echo ""
      echo "Toda La operación de agregar una nueva web se completó correctamente. Los datos son los siguientes:"
      echo ""
      echo "BASE DE DATOS MYSQL:"
      echo "Nombre: "$cDominio""
      echo "Usuario: "$cDominio""
      echo "Contraseña: "$cPassBD""
      echo ""
      echo "--------------------------------"
      echo ""
  fi
