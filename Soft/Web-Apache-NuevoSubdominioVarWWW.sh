#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear un subdominio para una web de /var/www
# ----------

vCantParamCorr=3

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $vCantParamCorr ]; then

  echo ""
  echo -e "${cColorRojo}Mal uso del script. Se le deben pasar tres parámetros obligatorios:${cFinColor}"
  echo ""
  echo -e "${cColorVerde}[SubDominioConPunto] [Dominio] [ExtensionDelDominio]${cFinColor}"
  echo ""
  echo "Ejemplo:"
  echo ""
  echo -e "$0 ${cColorVerde}nube. unawebcualquiera .org${cFinColor}"
  echo ""
  exit

else

  # Crear las carpetas para el subdominio
  echo ""
  echo "$(tput setaf 2)Creando las carpetas para el subdominio... $(tput sgr 0)"
  echo ""
  mkdir /var/www/$1$2$3/
  mkdir /var/www/$1$2$3/logs/
  echo "WEB OK" > /var/www/$1$2$3/index.html

  # Crear el archivo de configuración del subdominio en Apache
  echo ""
  echo "$(tput setaf 2)Creando el archivo de configuración del subdominio en Apache... $(tput sgr 0)"
  echo ""
  cp /etc/apache2/sites-available/nuevawebvar.conf /etc/apache2/sites-available/$1$2$3.conf
  sed -i -e "s/nuevawebvar.com/$1$2$3/g" /etc/apache2/sites-available/$1$2$3.conf

  # Activar la configuración del subdominio en Apache
  echo ""
  echo "$(tput setaf 2)Activando el subdominio en Apache... $(tput sgr 0)"
  echo ""
  a2ensite $1$2$3

  # Crear el certificado SSL, deteniendo Apache
  echo ""
  echo "$(tput setaf 2)Creando el certificado SSL con LetsEncrypt... $(tput sgr 0)"
  echo ""
  iptables -A INPUT -p tcp --dport 443 -j ACCEPT
  service apache2 stop
  /root/git/letsencrypt/letsencrypt-auto --apache -d $1$2$3

  # Volver a arrancar Apache
  echo ""
  echo "$(tput setaf 2)Re-arrancando Apache... $(tput sgr 0)"
  echo ""
  service apache2 start

  # Crear el archivo .htaccess con algunas opciones
  echo ""
  echo "$(tput setaf 2)Creando el archivo .htaccess... $(tput sgr 0)"
  echo ""
  echo "# BEGIN Medidas de seguridad"                                     > /var/www/$1$2$3/.htaccess
  echo ""                                                                >> /var/www/$1$2$3/.htaccess
  echo "  # IMPEDIR ACCESO NO AUTORIZADO AL ARCHIVO .HTACCESS"           >> /var/www/$1$2$3/.htaccess
  echo '    <files ~ "^.*\.([Hh][Tt][Aa])">'                             >> /var/www/$1$2$3/.htaccess
  echo "      order allow,deny"                                          >> /var/www/$1$2$3/.htaccess
  echo "      deny from all"                                             >> /var/www/$1$2$3/.htaccess
  echo "      satisfy all"                                               >> /var/www/$1$2$3/.htaccess
  echo "    </files>"                                                    >> /var/www/$1$2$3/.htaccess
  echo ""                                                                >> /var/www/$1$2$3/.htaccess
  echo "  # DESHABILITAR LA NAVEGACIÓN POR CARPETAS QUE NO TENGAN INDEX" >> /var/www/$1$2$3/.htaccess
  echo "    Options -Indexes"                                            >> /var/www/$1$2$3/.htaccess
  echo ""                                                                >> /var/www/$1$2$3/.htaccess
  echo "  # IMPEDIR EL ACCESO DE CIERTAS IPS"                            >> /var/www/$1$2$3/.htaccess
  echo "    <Limit GET POST>"                                            >> /var/www/$1$2$3/.htaccess
  echo "      order allow,deny"                                          >> /var/www/$1$2$3/.htaccess
  echo "      deny from 45.45.45.45"                                     >> /var/www/$1$2$3/.htaccess
  echo "      allow from all"                                            >> /var/www/$1$2$3/.htaccess
  echo "    </Limit>"                                                    >> /var/www/$1$2$3/.htaccess
  echo ""                                                                >> /var/www/$1$2$3/.htaccess
  echo "# END Medidas de seguridad"                                      >> /var/www/$1$2$3/.htaccess
  echo ""                                                                >> /var/www/$1$2$3/.htaccess

  # Proteger los logs
  echo ""
  echo "$(tput setaf 2)Protegiendo los logs con un .htaccess específico... $(tput sgr 0)"
  echo ""
  echo "#<Files *>"                                                      > /var/www/$1$2$3/logs/.htaccess
  echo "#"                                                              >> /var/www/$1$2$3/logs/.htaccess
  echo "#  Order Deny,Allow"                                            >> /var/www/$1$2$3/logs/.htaccess
  echo "#  #Allow from 127.0.0.1"                                       >> /var/www/$1$2$3/logs/.htaccess
  echo "#  Deny from all"                                               >> /var/www/$1$2$3/logs/.htaccess
  echo "#"                                                              >> /var/www/$1$2$3/logs/.htaccess
  echo "#</Files>"                                                      >> /var/www/$1$2$3/logs/.htaccess
  echo ""                                                               >> /var/www/$1$2$3/logs/.htaccess
  echo "RewriteEngine On"                                               >> /var/www/$1$2$3/logs/.htaccess
  echo ""                                                               >> /var/www/$1$2$3/logs/.htaccess
  echo "# Si alguien llega a la web desde otro lugar que no sea $1$2$3" >> /var/www/$1$2$3/logs/.htaccess
  echo "RewriteCond %{HTTP_REFERER} !^http://(www\.)?$2\\$1/ [NC]"      >> /var/www/$1$2$3/logs/.htaccess
  echo ""                                                               >> /var/www/$1$2$3/logs/.htaccess
  echo "y pide directamente por un archivo con extension log"           >> /var/www/$1$2$3/logs/.htaccess
  echo "RewriteCond %{REQUEST_URI} !hotlink\.(log) [NC]"                >> /var/www/$1$2$3/logs/.htaccess
  echo ""                                                               >> /var/www/$1$2$3/logs/.htaccess
  echo "# Redirigirlo a google.com"                                     >> /var/www/$1$2$3/logs/.htaccess
  echo "RewriteRule .*\.(log)$ http://google.com/ [NC]"                 >> /var/www/$1$2$3/logs/.htaccess

  # Reparar permisos y propietario de la carpeta
  echo ""
  echo "$(tput setaf 2)Reparando permisos... $(tput sgr 0)"
  echo ""
  chown www-data:www-data /var/www/$1$2$3/ -R
  find /var/www/$1$2$3/ -type d -exec chmod 755 {} \;
  find /var/www/$1$2$3/ -type f -exec chmod 644 {} \;
  chown -v root:root /var/www

fi

