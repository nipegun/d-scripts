#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar el servidor web con apache2 en Debian
#
# Ejecución remota
#   curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Web-apache2-InstalarYConfigurar.sh | bash
# ----------

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    OS_NAME=$NAME
    OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    OS_NAME=$(lsb_release -si)
    OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    OS_NAME=$DISTRIB_ID
    OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    OS_NAME=Debian
    OS_VERS=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    OS_NAME=$(uname -s)
    OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación del servidor web con Apache2 para Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación del servidor web con Apache2 para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  apt-get -y update > /dev/null
  apt-get -y install dialog > /dev/null
  cmd=(dialog --checklist "Script de hacks4geeks.com para instalación de servidor Web:" 22 76 16)
  options=(
    1 "Instalar con certificado SSL autofirmado" on
    2 "Agregar certificado LetsEncrypt encima (Requiere DDNS)" off        
    3 "Configurar y activar el módulo remoteip para estar detrás de un proxy inverso" off
  )
  choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
  clear
  for choice in $choices
  do
    case $choice in

      1)
        echo ""
        echo -e "${ColorVerde}----------------------------------------------------------${FinColor}"
        echo -e "${ColorVerde}Instalando servidor web con certificado SSL autofirmado...${FinColor}"
        echo -e "${ColorVerde}----------------------------------------------------------${FinColor}"
        echo ""
        echo -e "${ColorVerde}Actualizando el sistema...${FinColor}"
        echo ""
        apt-get -y update
        apt-get -y upgrade
        apt-get -y dist-upgrade
        apt-get -y autoremove
        echo ""

        echo -e "${ColorVerde}Instalando el servidor web con Apache y PHP 5...${FinColor}"
        echo ""
        apt-get install tasksel
        tasksel install ssh-server
        tasksel install web-server
        apt-get -y install apache2-utils redis-server imagemagick
        apt-get -y install php5-common
        apt-get -y install php5-gd
        apt-get -y install php5-curl
        apt-get -y install php5-cli
        apt-get -y install php5-dev
        apt-get -y install php5-json
        apt-get -y install php5-mysql
        apt-get -y install php5-mcrypt
        apt-get -y install php-mbstring
        apt-get -y install php5-intl
        apt-get -y install php5-redis
        apt-get -y install php5-imagick
        apt-get -y install php-pear
        apt-get -y install libapache2-mod-php5
        apt-get -y install phpsysinfo
        phpenmod gd
        phpenmod curl
        phpenmod json
        phpenmod mbstring
        phpenmod mcrypt
        phpenmod intl
        phpenmod redis
        phpenmod imagick
        a2enmod rewrite
        a2enmod ssl
        a2enmod headers
        a2enmod env
        a2enmod dir
        a2enmod mime
        a2ensite default-ssl
        cp /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.bak
        sed -i -e 's|max_execution_time = 30|max_execution_time = 300|g' /etc/php5/apache2/php.ini
        sed -i -e 's|memory_limit = 128M|memory_limit = 300M|g' /etc/php5/apache2/php.ini
        sed -i -e 's|post_max_size = 8M|post_max_size = 64M|g' /etc/php5/apache2/php.ini
        sed -i -e 's|upload_max_filesize = 2M|upload_max_filesize = 64M|g' /etc/php5/apache2/php.ini
        mkdir /var/www/html/logs
        cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak
        sed -i -e 's|${APACHE_LOG_DIR}|/var/www/html/logs|g' /etc/apache2/sites-available/000-default.conf
        echo "RewriteEngine On" > /var/www/html/logs/.htaccess
        echo '  RewriteCond %{REQUEST_URI} !hotlink\.(log) [NC]' >> /var/www/html/logs/.htaccess
        echo "  RewriteRule .*\.(log)$ http://google.com [NC]" >> /var/www/html/logs/.htaccess
      
        cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
        echo "" >> /etc/ssh/sshd_config
        echo "Match Group webmasters"       >> /etc/ssh/sshd_config
        echo "  ChrootDirectory /var/www"   >> /etc/ssh/sshd_config
        echo "  AllowTCPForwarding no"      >> /etc/ssh/sshd_config
        echo "  X11Forwarding no"           >> /etc/ssh/sshd_config
        echo "  ForceCommand internal-sftp" >> /etc/ssh/sshd_config
        echo ""
      
        echo -e "${ColorVerde}Ahora tendrás que ingresar veces en nuevo password para el usuario www-data.${FinColor}"
        echo -e "${ColorVerde}Acuérdate de apuntarlo en un lugar seguro porque tendrás que loguearte con él mediante sftp.${FinColor}"
        echo ""
        passwd www-data
        usermod -s /bin/bash www-data
        groupadd webmasters
        usermod -a -G webmasters www-data
        chown root:root /var/www
        service ssh restart
      
        echo "" > /etc/apache2/sites-available/nuevawebvar.conf
        echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "  ServerName nuevawebvar.com" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "  ServerAlias www.nuevawebvar.com" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "  DocumentRoot /var/www/nuevawebvar.com" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "  #Redirect permanent / https://nuevawebvar.com/" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo '  <Directory "/var/www/nuevawebvar.com">' >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "    Require all granted" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "    Options FollowSymLinks" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "    AllowOverride All" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "  </Directory>" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "  ServerAdmin webmaster@nuevawebvar.com" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "  ErrorLog /var/www/nuevawebvar.com/logs/error.log" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "  CustomLog /var/www/nuevawebvar.com/logs/access.log combined" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "</VirtualHost>" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo ""
      
        echo -e "${ColorVerde}Instalando el certificado SSL autofirmado para https...${FinColor}"
        echo ""
        mkdir -p /etc/apache2/ssl/
        openssl req -x509 -nodes -days 365 -newkey rsa:8192 -out /etc/apache2/ssl/autocertssl.pem -keyout /etc/apache2/ssl/autocertssl.key
        chmod 600 /etc/apache2/ssl/*
        cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak
        sed -i -e 's|${APACHE_LOG_DIR}|/var/www/html/logs|g' /etc/apache2/sites-available/default-ssl.conf
        sed -i -e 's|ssl/certs/ssl-cert-snakeoil.pem|apache2/ssl/autocertssl.pem|g' /etc/apache2/sites-available/default-ssl.conf
        sed -i -e 's|ssl/private/ssl-cert-snakeoil.key|apache2/ssl/autocertssl.key|g' /etc/apache2/sites-available/default-ssl.conf
        service apache2 restart
      
        echo ""
        echo -e "${ColorVerde}Instalando el servidor de bases de datos...${FinColor}"
        echo ""
        apt-get -y install mariadb-server
        echo ""
        echo -e "${ColorVerde}Asegurando el servidor de bases de datos...${FinColor}"
        echo ""
        mysql_secure_installation
        echo ""
      
        echo -e "${ColorVerde}Instalando PHPMyAdmin para administrar bases de datos...${FinColor}"
        echo ""
        apt-get -y install phpmyadmin
        cp /etc/apache2/conf-available/phpmyadmin.conf /etc/apache2/conf-available/phpmyadmin.conf.bak
        sed -i "7 a AllowOverride All" /etc/apache2/conf-available/phpmyadmin.conf
        service apache2 restart
        echo ""
        echo "--------------------------------------------------------"
        echo " ASEGURANDO PHPMYADMIN CON BLOQUEO WEB"
        echo ""
        echo " Si quieres agregar un usuario adicional al bloqueo web"
        echo " de phpmyadmin ejecuta el comando sin -c. Por ej:"
        echo ""
        echo " htpasswd /etc/phpmyadmin/.htpasswd usuarioadicional"
        echo ""
        echo "--------------------------------------------------------"
        echo ""
        echo 'AuthType Basic' > /usr/share/phpmyadmin/.htaccess
        echo 'AuthName "Restricted Files"' >> /usr/share/phpmyadmin/.htaccess
        echo 'AuthUserFile /etc/phpmyadmin/.htpasswd' >> /usr/share/phpmyadmin/.htaccess
        echo 'Require valid-user' >> /usr/share/phpmyadmin/.htaccess
        htpasswd -c /etc/phpmyadmin/.htpasswd phpmyadmin
        service apache2 restart
        echo ""
      
        echo -e "${ColorVerde}El script ha terminado de ejecutarse.${FinColor}"
        echo ""
        echo -e "${ColorVerde}Reinicia el sistema ejecutando: shutdown -r now${FinColor}"
        echo ""
      ;;
    
      2)
        echo ""
        echo -e "${ColorVerde}Instalando el certificado SSL de letsencrypt y configurando Apache para que lo use...${FinColor}"
        echo ""
        apt-get update
        apt-get -y install build-essential gcc make git
        mkdir /root/git/
        cd /root/git/
        git clone https://github.com/letsencrypt/letsencrypt
        cd /root/git/letsencrypt
        iptables -A INPUT -p tcp --dport 443 -j ACCEPT
        service apache2 stop
        /root/git/letsencrypt/letsencrypt-auto certonly --standalone
        dominio_servidor=$(dialog --title "Actualizar la configuración de default-ssl.conf" --inputbox "Ingresa el nombre de dominio exactamente como se lo pusiste a LetsEncrypt:" 8 60 3>&1 1>&2 2>&3 3>&- )
        echo ""
        echo "SE ACTUALIZARÁ EL ARCHIVO default-ssl.conf con el dominio $dominio_servidor"
        echo ""
        sleep 3
        sed -i -e 's|apache2/ssl/autocertssl.pem|letsencrypt/live/'"$dominio_servidor"'/fullchain.pem|g' /etc/apache2/sites-available/default-ssl.conf
        sed -i -e 's|apache2/ssl/autocertssl.key|letsencrypt/live/'"$dominio_servidor"'/privkey.pem|g' /etc/apache2/sites-available/default-ssl.conf
        chmod 600 /etc/letsencrypt/live/$dominio_servidor/*
        sed -i -e 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html\n        Redirect permanent / https://'"$dominio_servidor"'/|g' /etc/apache2/sites-available/000-default.conf
        service apache2 start
      ;;

      3)
        a2enmod remoteip
        a2enmod headers
        echo "RemoteIPHeader X-Forwarded-For" > /etc/apache2/conf-available/remoteip.conf
        echo "#RemoteIPInternalProxy 0.0.0.0" >> /etc/apache2/conf-available/remoteip.conf
        echo "#RemoteIPTrustedProxy 0.0.0.0" >> /etc/apache2/conf-available/remoteip.conf
        echo 'LogFormat "%a %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined' >> /etc/apache2/conf-available/remoteip.conf
        a2enconf remoteip
        service apache2 restart
        echo ""
        echo "El modulo remoteip está activado. Para configurarlo edita el archivo:"
        echo ""
        echo "/etc/apache2/conf-available/remoteip.conf"
        echo ""
        echo "descomenta la línea que te interese de las dos que están comentadas,"
        echo "reemplaza la ip que aparece como 0.0.0.0 con la ip del host del proxy inverso"
        echo "y reinicia apache 2 ejecutando:"
        echo ""
        echo "service apache2 restart"
        echo ""
        echo "Para más información sobre este punto, revisa:"
        echo ""
        echo "http://hacks4geeks.com/pasar-ips-reales-de-clientes-http-de-haproxy-a-backends-con-apache/"
        echo ""
      ;;

      esac

  done

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación del servidor web con Apache2 para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  apt-get -y update > /dev/null
  apt-get -y install dialog > /dev/null
  cmd=(dialog --checklist "Script de hacks4geeks.com para instalación de servidor Web:" 22 76 16)
  options=(
    1 "Instalar con certificado SSL autofirmado" on
    2 "Agregar certificado LetsEncrypt encima (Requiere DDNS)" off
    3 "Configurar y activar el módulo remoteip para estar detrás de un proxy inverso" off
  )
  choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
  clear
  for choice in $choices
    do
      case $choice in

        1)
          echo ""
          echo -e "${ColorVerde}----------------------------------------------------------${FinColor}"
          echo -e "${ColorVerde}Instalando servidor web con certificado SSL autofirmado...${FinColor}"
          echo -e "${ColorVerde}----------------------------------------------------------${FinColor}"
          echo ""
          echo -e "${ColorVerde}Actualizando el sistema...${FinColor}"
          echo ""
          apt-get -y update
          apt-get -y upgrade
          apt-get -y dist-upgrade
          apt-get -y autoremove
          echo ""

          echo -e "${ColorVerde}Instalando el servidor web con Apache y PHP 7.0...${FinColor}"
          echo ""
          apt-get install tasksel
          tasksel install ssh-server
          tasksel install web-server
          apt-get -y install apache2-utils redis-server imagemagick
          apt-get -y install php7.0-common
          apt-get -y install php7.0-gd
          apt-get -y install php7.0-curl
      apt-get -y install php7.0-cli
      apt-get -y install php7.0-dev
      apt-get -y install php7.0-json
      apt-get -y install php7.0-mysql
      apt-get -y install php7.0-mcrypt
      apt-get -y install php7.0-mbstring
      apt-get -y install php-intl
      apt-get -y install php-redis
      apt-get -y install php-imagick
      apt-get -y install php-pear
      apt-get -y install libapache2-mod-php7.0
      phpenmod gd
      phpenmod curl
      phpenmod json
      phpenmod mbstring
      phpenmod mcrypt
      phpenmod intl
      phpenmod redis
      phpenmod imagick
      a2enmod rewrite
      a2enmod ssl
      a2enmod headers
      a2enmod env
      a2enmod dir
      a2enmod mime
      a2ensite default-ssl
      cp /etc/php/7.0/apache2/php.ini /etc/php/7.0/apache2/php.ini.bak
      sed -i -e 's|max_execution_time = 30|max_execution_time = 300|g' /etc/php/7.0/apache2/php.ini
      sed -i -e 's|memory_limit = 128M|memory_limit = 300M|g' /etc/php/7.0/apache2/php.ini
      sed -i -e 's|post_max_size = 8M|post_max_size = 64M|g' /etc/php/7.0/apache2/php.ini
      sed -i -e 's|upload_max_filesize = 2M|upload_max_filesize = 64M|g' /etc/php/7.0/apache2/php.ini
      mkdir /var/www/html/logs
      cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak
      sed -i -e 's|${APACHE_LOG_DIR}|/var/www/html/logs|g' /etc/apache2/sites-available/000-default.conf
      echo "RewriteEngine On" > /var/www/html/logs/.htaccess
      echo '  RewriteCond %{REQUEST_URI} !hotlink\.(log) [NC]' >> /var/www/html/logs/.htaccess
      echo "  RewriteRule .*\.(log)$ http://google.com [NC]" >> /var/www/html/logs/.htaccess
      
      cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
      echo "" >> /etc/ssh/sshd_config
      echo "Match Group webmasters" >> /etc/ssh/sshd_config
      echo "  ChrootDirectory /var/www" >> /etc/ssh/sshd_config
      echo "  AllowTCPForwarding no" >> /etc/ssh/sshd_config
      echo "  X11Forwarding no" >> /etc/ssh/sshd_config
      echo "  ForceCommand internal-sftp" >> /etc/ssh/sshd_config
      echo ""
      
      echo -e "${ColorVerde}Ahora tendrás que ingresar veces en nuevo password para el usuario www-data.${FinColor}"
      echo -e "${ColorVerde}Acuérdate de apuntarlo en un lugar seguro porque tendrás que loguearte con él mediante sftp.${FinColor}"
      echo ""
      passwd www-data
      usermod -s /bin/bash www-data
      groupadd webmasters
      usermod -a -G webmasters www-data
      chown root:root /var/www
      service ssh restart
      
      echo "" > /etc/apache2/sites-available/nuevawebvar.conf
      echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "  ServerName nuevawebvar.com" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "  ServerAlias www.nuevawebvar.com" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "  DocumentRoot /var/www/nuevawebvar.com" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "  #Redirect permanent / https://nuevawebvar.com/" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo '  <Directory "/var/www/nuevawebvar.com">' >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "    Require all granted" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "    Options FollowSymLinks" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "    AllowOverride All" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "  </Directory>" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "  ServerAdmin webmaster@nuevawebvar.com" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "  ErrorLog /var/www/nuevawebvar.com/logs/error.log" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "  CustomLog /var/www/nuevawebvar.com/logs/access.log combined" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "</VirtualHost>" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo "" >> /etc/apache2/sites-available/nuevawebvar.conf
      echo ""
      
      echo -e "${ColorVerde}Instalando el certificado SSL autofirmado para https...${FinColor}"
      echo ""
      mkdir -p /etc/apache2/ssl/
      openssl req -x509 -nodes -days 365 -newkey rsa:8192 -out /etc/apache2/ssl/autocertssl.pem -keyout /etc/apache2/ssl/autocertssl.key
      chmod 600 /etc/apache2/ssl/*
      cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak
      sed -i -e 's|${APACHE_LOG_DIR}|/var/www/html/logs|g' /etc/apache2/sites-available/default-ssl.conf
      sed -i -e 's|ssl/certs/ssl-cert-snakeoil.pem|apache2/ssl/autocertssl.pem|g' /etc/apache2/sites-available/default-ssl.conf
      sed -i -e 's|ssl/private/ssl-cert-snakeoil.key|apache2/ssl/autocertssl.key|g' /etc/apache2/sites-available/default-ssl.conf
      service apache2 restart
      
      echo ""
      echo -e "${ColorVerde}Instalando el servidor de bases de datos...${FinColor}"
      echo ""
      apt-get -y install mariadb-server
      echo ""
      echo -e "${ColorVerde}Asegurando el servidor de bases de datos...${FinColor}"
      echo ""
      mysql_secure_installation
      echo ""

      echo -e "${ColorVerde}Instalando MemCacheD...${FinColor}"
      echo ""
      apt-get -y install memcached php-memcached
      phpenmod memcached
      service apache2 restart
      echo ""

      echo -e "${ColorVerde}Instalando PHPMyAdmin para administrar bases de datos...${FinColor}"
      echo ""
      apt-get -y install phpmyadmin
      cp /etc/apache2/conf-available/phpmyadmin.conf /etc/apache2/conf-available/phpmyadmin.conf.bak
      sed -i "7 a AllowOverride All" /etc/apache2/conf-available/phpmyadmin.conf
      service apache2 restart
      echo ""
      echo "--------------------------------------------------------"
      echo " ASEGURANDO PHPMYADMIN CON BLOQUEO WEB"
      echo ""
      echo " Si quieres agregar un usuario adicional al bloqueo web"
      echo " de phpmyadmin ejecuta el comando sin -c. Por ej:"
      echo ""
      echo " htpasswd /etc/phpmyadmin/.htpasswd usuarioadicional"
      echo ""
      echo "--------------------------------------------------------"
      echo ""
      echo 'AuthType Basic' > /usr/share/phpmyadmin/.htaccess
      echo 'AuthName "Restricted Files"' >> /usr/share/phpmyadmin/.htaccess
      echo 'AuthUserFile /etc/phpmyadmin/.htpasswd' >> /usr/share/phpmyadmin/.htaccess
      echo 'Require valid-user' >> /usr/share/phpmyadmin/.htaccess
      htpasswd -c /etc/phpmyadmin/.htpasswd phpmyadmin
      service apache2 restart
      echo ""
      
      echo -e "${ColorVerde}El script ha terminado de ejecutarse.${FinColor}"
      echo ""
      echo -e "${ColorVerde}Reinicia el sistema ejecutando: shutdown -r now${FinColor}"
      echo ""
    ;;
    
    2)
      echo ""
      echo -e "${ColorVerde}Instalando el certificado SSL de letsencrypt y configurando Apache para que lo use...${FinColor}"
      echo ""
      apt-get update
      apt-get -y install certbot python3-certbot-apache
      iptables -A INPUT -p tcp --dport 443 -j ACCEPT
      service apache2 stop
      certbot --apache
      dominio_servidor=$(dialog --title "Actualizar la configuración de default-ssl.conf" --inputbox "Ingresa el nombre de dominio exactamente como se lo pusiste a LetsEncrypt:" 8 60 3>&1 1>&2 2>&3 3>&- )
      echo ""
      echo "SE ACTUALIZARÁ EL ARCHIVO default-ssl.conf con el dominio $dominio_servidor"
      echo ""
      sed -i -e 's|apache2/ssl/autocertssl.pem|letsencrypt/live/'"$dominio_servidor"'/fullchain.pem|g' /etc/apache2/sites-available/default-ssl.conf
      sed -i -e 's|apache2/ssl/autocertssl.key|letsencrypt/live/'"$dominio_servidor"'/privkey.pem|g' /etc/apache2/sites-available/default-ssl.conf
      chmod 600 /etc/letsencrypt/live/$dominio_servidor/*
      sed -i -e 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html\n        Redirect permanent / https://'"$dominio_servidor"'/|g' /etc/apache2/sites-available/000-default.conf
      service apache2 start
    ;;

    3)
      a2enmod remoteip
      a2enmod headers
      echo "RemoteIPHeader X-Forwarded-For" > /etc/apache2/conf-available/remoteip.conf
      echo "#RemoteIPInternalProxy 0.0.0.0" >> /etc/apache2/conf-available/remoteip.conf
      echo "#RemoteIPTrustedProxy 0.0.0.0" >> /etc/apache2/conf-available/remoteip.conf
      echo 'LogFormat "%a %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined' >> /etc/apache2/conf-available/remoteip.conf
      a2enconf remoteip
      service apache2 restart
      echo ""
      echo "El modulo remoteip está activado. Para configurarlo edita el archivo:"
      echo ""
      echo "/etc/apache2/conf-available/remoteip.conf"
      echo ""
      echo "descomenta la línea que te interese de las dos que están comentadas,"
      echo "reemplaza la ip que aparece como 0.0.0.0 con la ip del host del proxy inverso"
      echo "y reinicia apache 2 ejecutando:"
      echo ""
      echo "service apache2 restart"
      echo ""
      echo "Para más información sobre este punto, revisa:"
      echo ""
      echo "http://hacks4geeks.com/pasar-ips-reales-de-clientes-http-de-haproxy-a-backends-con-apache/"
      echo ""
    ;;

    esac

done


elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación del servidor web con Apache2 para Debian 10 (Buster)...${vFinColor}"
  echo ""

  apt-get -y update > /dev/null
  apt-get -y install dialog > /dev/null
  cmd=(dialog --checklist "Script de hacks4geeks.com para instalación de servidor Web:" 22 76 16)
  options=(
    1 "Instalar con certificado SSL autofirmado" on
    2 "Agregar certificado LetsEncrypt encima (Requiere DDNS)" off
    3 "Configurar y activar el módulo remoteip para estar detrás de un proxy inverso" off
  )
  choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
  clear
  for choice in $choices
  do
    case $choice in

      1)
        echo ""
        echo -e "${ColorVerde}----------------------------------------------------------${FinColor}"
        echo -e "${ColorVerde}Instalando servidor web con certificado SSL autofirmado...${FinColor}"
        echo -e "${ColorVerde}----------------------------------------------------------${FinColor}"
        echo ""
        echo -e "${ColorVerde}Actualizando el sistema...${FinColor}"
        echo ""
        apt-get -y update
        apt-get -y upgrade
        apt-get -y dist-upgrade
        apt-get -y autoremove
        echo ""
      
        echo -e "${ColorVerde}Instalando el servidor web con Apache y PHP 7.3...${FinColor}"
        echo ""
        apt-get -y install tasksel
        tasksel install ssh-server
        tasksel install web-server
        apt-get -y install apache2-utils
        apt-get -y install redis-server
        apt-get -y install imagemagick
        apt-get -y install php7.3-common
        apt-get -y install php7.3-gd
        apt-get -y install php7.3-curl
        apt-get -y install php7.3-cli
        apt-get -y install php7.3-dev
        apt-get -y install php7.3-json
        apt-get -y install php7.3-mysql
        apt-get -y install php7.3-mcrypt
        apt-get -y install php7.3-mbstring
        apt-get -y install php-intl
        apt-get -y install php-redis
        apt-get -y install php-imagick
        apt-get -y install php-pear
        apt-get -y install libapache2-mod-php7.3
        phpenmod gd
        phpenmod curl
        phpenmod json
        phpenmod mbstring
        phpenmod intl
        phpenmod redis
        phpenmod imagick
        a2enmod rewrite
        a2enmod ssl
        a2enmod headers
        a2enmod env
        a2enmod dir
        a2enmod mime
        a2ensite default-ssl
        phpenmod mcrypt
        phpenmod mbstring
        cp /etc/php/7.3/apache2/php.ini /etc/php/7.3/apache2/php.ini.bak
        sed -i -e 's|max_execution_time = 30|max_execution_time = 300|g'   /etc/php/7.3/apache2/php.ini
        sed -i -e 's|memory_limit = 128M|memory_limit = 300M|g'            /etc/php/7.3/apache2/php.ini
        sed -i -e 's|post_max_size = 8M|post_max_size = 64M|g'             /etc/php/7.3/apache2/php.ini
        sed -i -e 's|upload_max_filesize = 2M|upload_max_filesize = 64M|g' /etc/php/7.3/apache2/php.ini
        mkdir /var/www/html/logs
        cp /etc/apache2/sites-available/000-default.conf     /etc/apache2/sites-available/000-default.conf
        sed -i -e 's|${APACHE_LOG_DIR}|/var/www/html/logs|g' /etc/apache2/sites-available/000-default.conf
        echo "RewriteEngine On"                                   > /var/www/html/logs/.htaccess
        echo '  RewriteCond %{REQUEST_URI} !hotlink\.(log) [NC]' >> /var/www/html/logs/.htaccess
        echo "  RewriteRule .*\.(log)$ http://google.com [NC]"   >> /var/www/html/logs/.htaccess
    
        cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
        echo ""                             >> /etc/ssh/sshd_config
        echo "Match Group webmasters"       >> /etc/ssh/sshd_config
        echo "  ChrootDirectory /var/www"   >> /etc/ssh/sshd_config
        echo "  AllowTCPForwarding no"      >> /etc/ssh/sshd_config
        echo "  X11Forwarding no"           >> /etc/ssh/sshd_config
        echo "  ForceCommand internal-sftp" >> /etc/ssh/sshd_config
        echo ""
      
        echo -e "${ColorVerde}Ahora tendrás que ingresar veces en nuevo password para el usuario www-data.${FinColor}"
        echo -e "${ColorVerde}Acuérdate de apuntarlo en un lugar seguro porque tendrás que loguearte con él mediante sftp.${FinColor}"
        echo ""
        passwd www-data
        usermod -s /bin/bash www-data
        groupadd webmasters
        usermod -a -G webmasters www-data
        chown root:root /var/www
        service ssh restart
      
        echo ""                                                               > /etc/apache2/sites-available/nuevawebvar.conf
        echo "<VirtualHost *:80>"                                            >> /etc/apache2/sites-available/nuevawebvar.conf
        echo ""                                                              >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "  ServerName nuevawebvar.com"                                  >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "  ServerAlias www.nuevawebvar.com"                             >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "  DocumentRoot /var/www/nuevawebvar.com"                       >> /etc/apache2/sites-available/nuevawebvar.conf
        echo ""                                                              >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "  #Redirect permanent / https://nuevawebvar.com/"              >> /etc/apache2/sites-available/nuevawebvar.conf
        echo ""                                                              >> /etc/apache2/sites-available/nuevawebvar.conf
        echo '  <Directory "/var/www/nuevawebvar.com">'                      >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "    Require all granted"                                       >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "    Options FollowSymLinks"                                    >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "    AllowOverride All"                                         >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "  </Directory>"                                                >> /etc/apache2/sites-available/nuevawebvar.conf
        echo ""                                                              >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "  ServerAdmin webmaster@nuevawebvar.com"                       >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "  ErrorLog /var/www/nuevawebvar.com/logs/error.log"            >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "  CustomLog /var/www/nuevawebvar.com/logs/access.log combined" >> /etc/apache2/sites-available/nuevawebvar.conf
        echo ""                                                              >> /etc/apache2/sites-available/nuevawebvar.conf
        echo "</VirtualHost>"                                                >> /etc/apache2/sites-available/nuevawebvar.conf
        echo ""                                                              >> /etc/apache2/sites-available/nuevawebvar.conf
        echo ""
      
        echo -e "${ColorVerde}Instalando el certificado SSL autofirmado para https...${FinColor}"
        echo ""
        mkdir -p /etc/apache2/ssl/
        openssl req -x509 -nodes -days 365 -newkey rsa:8192 -out /etc/apache2/ssl/autocertssl.pem -keyout /etc/apache2/ssl/autocertssl.key
        chmod 600 /etc/apache2/ssl/*
        cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak
        sed -i -e 's|${APACHE_LOG_DIR}|/var/www/html/logs|g'                          /etc/apache2/sites-available/default-ssl.conf
        sed -i -e 's|ssl/certs/ssl-cert-snakeoil.pem|apache2/ssl/autocertssl.pem|g'   /etc/apache2/sites-available/default-ssl.conf
        sed -i -e 's|ssl/private/ssl-cert-snakeoil.key|apache2/ssl/autocertssl.key|g' /etc/apache2/sites-available/default-ssl.conf
        service apache2 restart
      
        echo ""
        echo -e "${ColorVerde}Instalando el servidor de bases de datos...${FinColor}"
        echo ""
        apt-get -y install mariadb-server
        echo ""
        echo -e "${ColorVerde}Asegurando el servidor de bases de datos...${FinColor}"
        echo ""
        mysql_secure_installation
        echo ""

        echo -e "${ColorVerde}Instalando MemCacheD...${FinColor}"
        echo ""
        apt-get -y install memcached php-memcached
        phpenmod memcached
        service apache2 restart
        echo ""

        echo -e "${ColorVerde}Instalando el cortafuegos NFTables...${FinColor}"
        echo ""
        apt-get -y install nftables
        systemctl enable nftables.service
        echo "# Reglas NFTables para servidor Web"                   >> /root/scripts/ComandosNFTables.sh
        echo "# nft chain inet filter input { policy drop \; }"      >> /root/scripts/ComandosNFTables.sh
        echo "# nft add rule inet filter input tcp dport 22 accept"  >> /root/scripts/ComandosNFTables.sh
        echo "# nft add rule inet filter input tcp dport 80 accept"  >> /root/scripts/ComandosNFTables.sh
        echo "# nft add rule inet filter input tcp dport 443 accept" >> /root/scripts/ComandosNFTables.sh

        echo -e "${ColorVerde}El script ha terminado de ejecutarse.${FinColor}"
        echo ""
        echo -e "${ColorVerde}Reinicia el sistema ejecutando: shutdown -r now${FinColor}"
        echo ""
      ;;

      2)
        echo ""
        echo -e "${ColorVerde}Instalando el certificado SSL de letsencrypt y configurando Apache para que lo use...${FinColor}"
        echo ""
        apt-get update
        apt-get -y install certbot python3-certbot-apache
        iptables -A INPUT -p tcp --dport 443 -j ACCEPT
        service apache2 stop
        certbot --apache
        dominio_servidor=$(dialog --title "Actualizar la configuración de default-ssl.conf" --inputbox "Ingresa el nombre de dominio exactamente como se lo pusiste a LetsEncrypt:" 8 60 3>&1 1>&2 2>&3 3>&- )
        echo ""
        echo "SE ACTUALIZARÁ EL ARCHIVO default-ssl.conf con el dominio $dominio_servidor"
        echo ""
        sed -i -e 's|apache2/ssl/autocertssl.pem|letsencrypt/live/'"$dominio_servidor"'/fullchain.pem|g' /etc/apache2/sites-available/default-ssl.conf
        sed -i -e 's|apache2/ssl/autocertssl.key|letsencrypt/live/'"$dominio_servidor"'/privkey.pem|g'   /etc/apache2/sites-available/default-ssl.conf
        chmod 600 /etc/letsencrypt/live/$dominio_servidor/*
        sed -i -e 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html\n        Redirect permanent / https://'"$dominio_servidor"'/|g' /etc/apache2/sites-available/000-default.conf
        service apache2 start
        mkdir -p /root/scripts/ 2> /dev/null
        echo '#!/bin/bash'                   >  /root/scripts/RenovarCertificadosSSL.sh
        echo ""                              >> /root/scripts/RenovarCertificadosSSL.sh
        echo "# Parar el servidor Apache"    >> /root/scripts/RenovarCertificadosSSL.sh
        echo "service apache2 stop"          >> /root/scripts/RenovarCertificadosSSL.sh
        echo ""                              >> /root/scripts/RenovarCertificadosSSL.sh
        echo "# Renovar certificados"        >> /root/scripts/RenovarCertificadosSSL.sh
        echo "certbot renew"                 >> /root/scripts/RenovarCertificadosSSL.sh
        echo ""                              >> /root/scripts/RenovarCertificadosSSL.sh
        echo "# Arrancar el servidor Apache" >> /root/scripts/RenovarCertificadosSSL.sh
        echo "service apache2 start"         >> /root/scripts/RenovarCertificadosSSL.sh
        chmod +x /root/scripts/RenovarCertificadosSSL.sh
        echo "/root/scripts/RenovarCertificadosSSL.sh" >> /root/scripts/TareasCronPorSemana.sh
      ;;

      3)
        a2enmod remoteip
        a2enmod headers
        echo "RemoteIPHeader X-Forwarded-For"                                                     > /etc/apache2/conf-available/remoteip.conf
        echo "#RemoteIPInternalProxy 0.0.0.0"                                                    >> /etc/apache2/conf-available/remoteip.conf
        echo "#RemoteIPTrustedProxy 0.0.0.0"                                                     >> /etc/apache2/conf-available/remoteip.conf
        echo 'LogFormat "%a %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined' >> /etc/apache2/conf-available/remoteip.conf
        a2enconf remoteip
        service apache2 restart
        echo ""
        echo -e "${ColorVerde}El módulo remoteip está activado. Para configurarlo edita el archivo:${FinColor}"
        echo ""
        echo -e "${ColorVerde}/etc/apache2/conf-available/remoteip.conf${FinColor}"
        echo ""
        echo -e "${ColorVerde}descomenta la línea que te interese de las dos que están comentadas,${FinColor}"
        echo -e "${ColorVerde}reemplaza la ip que aparece como 0.0.0.0 con la ip del host del proxy inverso${FinColor}"
        echo -e "${ColorVerde}y reinicia apache 2 ejecutando:${FinColor}"
        echo ""
        echo -e "${ColorVerde}service apache2 restart${FinColor}"
        echo ""
        echo -e "${ColorVerde}Para más información sobre este punto, revisa:${FinColor}"
        echo ""
        echo -e "${ColorVerde}http://hacks4geeks.com/pasar-ips-reales-de-clientes-http-de-haproxy-a-backends-con-apache${FinColor}"
        echo ""
      ;;

    esac

  done

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación del servidor web con Apache2 para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  # Comprobar si el paquete dialog esté instalado. SI no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install dialog
      echo ""
    fi
  # Crear el menú
    cmd=(dialog --checklist "Script de NiPeGun para instalar un servidor Web con Apache:" 10 94 10)
    options=(
      1 "Instalar con certificado SSL autofirmado." on
      2 "Agregar certificado LetsEncrypt encima (Requiere DDNS)." off
      3 "Configurar y activar el módulo remoteip para estar detrás de un proxy inverso." off
    )
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "    Instalando servidor web con certificado SSL autofirmado..."
            echo ""

            # Actualizar sistema
              echo ""
              echo "      Actualizando el sistema..."
              echo ""
              apt-get -y update
              apt-get -y upgrade
              apt-get -y dist-upgrade
              apt-get -y autoremove

            # Determinar la última versión de PHP
              vUltVersPHP=$(apt-cache search php | grep etapackage | grep php | cut -d' ' -f1 | sed 's|[^0-9.]*||g' )
        
            # Instalar paquetes
              echo ""
              echo "    Instalando el servidor web con Apache y PHP $vUltVersPHP..."
              echo ""
              apt-get -y install tasksel
              tasksel install ssh-server
              tasksel install web-server
              apt-get -y install apache2-utils
              apt-get -y install redis-server
              apt-get -y install imagemagick
              apt-get -y install php"$vUltVersPHP"-common
              apt-get -y install php"$vUltVersPHP"-gd
              apt-get -y install php"$vUltVersPHP"-curl
              apt-get -y install php"$vUltVersPHP"-cli
              apt-get -y install php"$vUltVersPHP"-dev
              apt-get -y install php"$vUltVersPHP"-json
              apt-get -y install php"$vUltVersPHP"-mysql
              #apt-get -y install php"$vUltVersPHP"-mcrypt
              apt-get -y install php"$vUltVersPHP"-mbstring
              apt-get -y install php-intl
              apt-get -y install php-redis
              apt-get -y install php-imagick
              apt-get -y install php-pear
              apt-get -y install libapache2-mod-php"$vUltVersPHP"
            # Activar módulos de PHP
              echo ""
              echo "    Activando módulos de PHP..."
              echo ""
              phpenmod gd
              phpenmod curl
              phpenmod json
              phpenmod mbstring
              phpenmod intl
              phpenmod redis
              phpenmod imagick
            # Activar módulos de Apache
              echo ""
              echo "    Activando módulos de Apache..."
              echo ""
              a2enmod rewrite
              a2enmod ssl
              a2enmod headers
              a2enmod env
              a2enmod dir
              a2enmod mime
            # Activar sitio SSL por defecto
              echo ""
              echo "    Activando sitio SSL por defecto en Apache..."
              echo ""
              a2ensite default-ssl
            # Volver a activar mbstring
              echo ""
              echo "    Volviendo a activar el módulo mbstring de PHP..."
              echo ""
              #phpenmod mcrypt
              phpenmod mbstring
            # Modificar php.ini
              echo ""
              echo "    Modificando php.ini..."
              echo ""
              cp /etc/php/"$vUltVersPHP"/apache2/php.ini /etc/php/"$vUltVersPHP"/apache2/php.ini.ori
              sed -i -e 's|max_execution_time = 30|max_execution_time = 300|g'   /etc/php/"$vUltVersPHP"/apache2/php.ini
              sed -i -e 's|memory_limit = 128M|memory_limit = 300M|g'            /etc/php/"$vUltVersPHP"/apache2/php.ini
              sed -i -e 's|post_max_size = 8M|post_max_size = 64M|g'             /etc/php/"$vUltVersPHP"/apache2/php.ini
              sed -i -e 's|upload_max_filesize = 2M|upload_max_filesize = 64M|g' /etc/php/"$vUltVersPHP"/apache2/php.ini
            # Configurar carpeta de logs del sitio por defecto
              echo ""
              echo "    Configurando carpeta de logs del sitio por defecto..."
              echo ""
              cp /etc/apache2/sites-available/000-default.conf     /etc/apache2/sites-available/000-default.conf.ori
              sed -i -e 's|${APACHE_LOG_DIR}|/var/www/html/_/logs|g' /etc/apache2/sites-available/000-default.conf
              mkdir -p /var/www/html/_/logs/
              echo "RewriteEngine On"                                   > /var/www/html/_/logs/.htaccess
              echo '  RewriteCond %{REQUEST_URI} !hotlink\.(log) [NC]' >> /var/www/html/_/logs/.htaccess
              echo "  RewriteRule .*\.(log)$ http://google.com [NC]"   >> /var/www/html/_/logs/.htaccess
            # Modificr el servidor SSH
              echo ""
              echo "    Modificando el servidor SSH..."
              echo ""
              cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
              echo ""                             >> /etc/ssh/sshd_config
              echo "Match Group webmasters"       >> /etc/ssh/sshd_config
              echo "  ChrootDirectory /var/www"   >> /etc/ssh/sshd_config
              echo "  AllowTCPForwarding no"      >> /etc/ssh/sshd_config
              echo "  X11Forwarding no"           >> /etc/ssh/sshd_config
              echo "  ForceCommand internal-sftp" >> /etc/ssh/sshd_config
            # Preparar el usuario www-data para conectarse mediante sftp
              echo ""
              echo "    Preparando el usuario www-data para conectarse mediante sftp..."
              echo ""
              echo ""
              echo "      Ahora tendrás que ingresar veces en nuevo password para el usuario www-data."
              echo "      Acuérdate de apuntarlo en un lugar seguro porque tendrás que loguearte con él mediante sftp."
              echo ""
              passwd www-data
              usermod -s /bin/bash www-data
              groupadd webmasters
              usermod -a -G webmasters www-data
              chown root:root /var/www
              service ssh restart
            # Crear el archivo intermedio nuevawebvar.conf
              echo ""
              echo "    Creando el archivo intermedio nuevawebvar.conf..."
              echo ""
              echo ""                                                                 > /etc/apache2/sites-available/nuevawebvar.conf
              echo "<VirtualHost *:80>"                                              >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  ServerName nuevawebvar.com"                                    >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  ServerAlias www.nuevawebvar.com"                               >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  DocumentRoot /var/www/nuevawebvar.com"                         >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  #Redirect permanent / https://nuevawebvar.com/"                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo '  <Directory "/var/www/nuevawebvar.com">'                        >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "    Require all granted"                                         >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "    Options FollowSymLinks"                                      >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "    AllowOverride All"                                           >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  </Directory>"                                                  >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  ServerAdmin webmaster@nuevawebvar.com"                         >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  ErrorLog /var/www/nuevawebvar.com/_/logs/error.log"            >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  CustomLog /var/www/nuevawebvar.com/_/logs/access.log combined" >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "</VirtualHost>"                                                  >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
            # Instalar el certificado SSL autofirmado para https...
              echo ""
              echo "    Instalando el certificado SSL autofirmado para https..."
              echo ""
              mkdir -p /etc/apache2/ssl/
              openssl req -x509 -nodes -days 365 -newkey rsa:8192 -out /etc/apache2/ssl/autocertssl.pem -keyout /etc/apache2/ssl/autocertssl.key
              chmod 600 /etc/apache2/ssl/*
              cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak
              sed -i -e 's|${APACHE_LOG_DIR}|/var/www/html/_/logs|g'                        /etc/apache2/sites-available/default-ssl.conf
              sed -i -e 's|ssl/certs/ssl-cert-snakeoil.pem|apache2/ssl/autocertssl.pem|g'   /etc/apache2/sites-available/default-ssl.conf
              sed -i -e 's|ssl/private/ssl-cert-snakeoil.key|apache2/ssl/autocertssl.key|g' /etc/apache2/sites-available/default-ssl.conf
              service apache2 restart
            # Instalar el servidor de bases de datos
              echo ""
              echo "    Instalando el servidor de bases de datos..."
              echo ""
              apt-get -y install mariadb-server
              # Asegurar el servidor de bases de datos
              echo ""
              echo "      Asegurando el servidor de bases de datos...${FinColor}"
              echo ""
              mysql_secure_installation
            # Instalar memcached
              echo ""
              echo "    Instalando MemCacheD...${FinColor}"
              echo ""
              apt-get -y install memcached
              apt-get -y install php-memcached
              phpenmod memcached
              service apache2 restart
            # Instalar el cortafuegos NFTables
              echo ""
              echo "    Instalando el cortafuegos NFTables..."
              echo ""
              apt-get -y install nftables
              systemctl enable nftables.service
              echo "# Reglas NFTables para servidor Web"                   >> /root/scripts/ComandosNFTables.sh
              echo "# nft chain inet filter input { policy drop \; }"      >> /root/scripts/ComandosNFTables.sh
              echo "# nft add rule inet filter input tcp dport 22 accept"  >> /root/scripts/ComandosNFTables.sh
              echo "# nft add rule inet filter input tcp dport 80 accept"  >> /root/scripts/ComandosNFTables.sh
              echo "# nft add rule inet filter input tcp dport 443 accept" >> /root/scripts/ComandosNFTables.sh
            # Notificar el fin de la ejecución de la parte 1 del script
              echo ""
              echo -e "${vColorVerde}    Fin de ejecución de la parte 1 del script.${vFinColor}"
              echo ""

          ;;

          2)

            # Instalar el cortafuegos NFTables
              echo ""
              echo "    Agregando el certificado SSL de letsencrypt y configurando Apache para que lo use..."
              echo ""
              apt-get update
              apt-get -y install certbot
              apt-get -y install python3-certbot-apache
              #iptables -A INPUT -p tcp --dport 443 -j ACCEPT
              #service apache2 stop
              certbot --apache
              dominio_servidor=$(dialog --title "Actualizar la configuración de default-ssl.conf" --inputbox "Ingresa el nombre de dominio exactamente como se lo pusiste a LetsEncrypt:" 8 60 3>&1 1>&2 2>&3 3>&- )
              echo ""
              echo "SE ACTUALIZARÁ EL ARCHIVO default-ssl.conf con el dominio $dominio_servidor"
              echo ""
              sed -i -e 's|apache2/ssl/autocertssl.pem|letsencrypt/live/'"$dominio_servidor"'/fullchain.pem|g' /etc/apache2/sites-available/default-ssl.conf
              sed -i -e 's|apache2/ssl/autocertssl.key|letsencrypt/live/'"$dominio_servidor"'/privkey.pem|g'   /etc/apache2/sites-available/default-ssl.conf
              chmod 600 /etc/letsencrypt/live/$dominio_servidor/*
              sed -i -e 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html\n        Redirect permanent / https://'"$dominio_servidor"'/|g' /etc/apache2/sites-available/000-default.conf
              service apache2 start
            # Creando el script para renovar el certificado
              echo ""
              echo "  Creando el script para renovar el certificado de LetsEncrypt de forma automática.,.."
              echo ""
              mkdir -p /root/scripts/EsteDebian/ 2> /dev/null
              echo '#!/bin/bash'                    > /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo ""                              >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo "# Parar el servidor Apache"    >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo "service apache2 stop"          >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo ""                              >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo "# Renovar certificados"        >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo "certbot renew"                 >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo ""                              >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo "# Arrancar el servidor Apache" >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo "service apache2 start"         >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              chmod +x                                /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo "/root/scripts/EsteDebian/RenovarCertificadosSSL.sh" >> /root/scripts/TareasCronPorSemana.sh

          ;;

          3)

            # Activar módulos para remoteip
              echo ""
              echo "    Activando módulos para RemoteIP..."
              echo ""
              a2enmod remoteip
              a2enmod headers
            # Modificar la configuración de apache
              echo ""
              echo "    Modificando el archivo remoteip.conf en Apache..."
              echo ""
              echo "RemoteIPHeader X-Forwarded-For"                                                     > /etc/apache2/conf-available/remoteip.conf
              echo "#RemoteIPInternalProxy 0.0.0.0"                                                    >> /etc/apache2/conf-available/remoteip.conf
              echo "#RemoteIPTrustedProxy 0.0.0.0"                                                     >> /etc/apache2/conf-available/remoteip.conf
              echo 'LogFormat "%a %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined' >> /etc/apache2/conf-available/remoteip.conf
            # Activar la configuración de remoteip
              echo ""
              echo "    Activando la configuración de apache de remoteip..."
              echo ""
              a2enconf remoteip
            # Reiniciar el servidor apache
              echo ""
              echo "    Reiniciando el servidor apache..."
              echo ""
              service apache2 restart
            # Notificar fin del script
              echo ""
              echo -e "${ColorVerde}      El módulo remoteip está activado. Para configurarlo edita el archivo:${FinColor}"
              echo ""
              echo -e "${ColorVerde}        /etc/apache2/conf-available/remoteip.conf${FinColor}"
              echo ""
              echo -e "${ColorVerde}      descomenta la línea que te interese de las dos que están comentadas,${FinColor}"
              echo -e "${ColorVerde}      reemplaza la ip que aparece como 0.0.0.0 con la ip del host del proxy inverso${FinColor}"
              echo -e "${ColorVerde}      y reinicia apache 2 ejecutando:${FinColor}"
              echo ""
              echo -e "${ColorVerde}      service apache2 restart${FinColor}"
              echo ""
              echo -e "${ColorVerde}      Para más información sobre este punto, revisa:${FinColor}"
              echo ""
              echo -e "${ColorVerde}        http://hacks4geeks.com/pasar-ips-reales-de-clientes-http-de-haproxy-a-backends-con-apache${FinColor}"
              echo ""

          ;;

        esac

      done

fi

