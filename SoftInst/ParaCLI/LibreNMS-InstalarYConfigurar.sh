#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar LibreNMS en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/LibreNMS-InstalarYConfigurar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/LibreNMS-InstalarYConfigurar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/LibreNMS-InstalarYConfigurar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/LibreNMS-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/LibreNMS-InstalarYConfigurar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de LibreNMS para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de LibreNMS para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Instalar paquetes necesarios
      sudo apt-get -y update
      sudo apt-get -y install acl
      sudo apt-get -y install curl
      sudo apt-get -y install fping
      sudo apt-get -y install git
      sudo apt-get -y install graphviz
      sudo apt-get -y install imagemagick
      sudo apt-get -y install mariadb-client
      sudo apt-get -y install mariadb-server
      sudo apt-get -y install mtr-tiny nginx-full
      sudo apt-get -y install nmap php-cli
      sudo apt-get -y install php-curl
      sudo apt-get -y install php-fpm
      sudo apt-get -y install php-gd
      sudo apt-get -y install php-gmp
      sudo apt-get -y install php-json
      sudo apt-get -y install php-mbstring
      sudo apt-get -y install php-mysql
      sudo apt-get -y install php-snmp
      sudo apt-get -y install php-xml
      sudo apt-get -y install php-zip
      sudo apt-get -y install rrdtool
      sudo apt-get -y install snmp
      sudo apt-get -y install snmpd unzip
      sudo apt-get -y install python3-pymysql
      sudo apt-get -y install python3-dotenv
      sudo apt-get -y install python3-redis
      sudo apt-get -y install python3-setuptools
      sudo apt-get -y install python3-psutil
      sudo apt-get -y install python3-systemd
      sudo apt-get -y install python3-pip
      sudo apt-get -y install whois
      sudo apt-get -y install traceroute

    # Crear el usuario
      sudo useradd librenms -d /opt/librenms -M -r -s "$(which bash)"

    # Clonar el repo
      cd /opt
      sudo git clone https://github.com/librenms/librenms.git

    # Configurar permisos
      sudo chown -R librenms:librenms /opt/librenms
      sudo chmod 771 /opt/librenms
      sudo setfacl -d -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/
      sudo setfacl -R -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/

    # Instalar dependencias de PHP
      #su - librenms
      #  ./scripts/composer_wrapper.php install --no-dev
      #exit

    # Instalar composer Wrapper
      sudo wget https://getcomposer.org/composer-stable.phar
      sudo mv composer-stable.phar /usr/bin/composer
      sudo chmod +x /usr/bin/composer

    # Configurar la zona horaria en php
      sudo sed -i -e 's|;date.timezone =|date.timezone = Europe/Madrid|g' /etc/php/8.2/fpm/php.ini
      sudo sed -i -e 's|;date.timezone =|date.timezone = Europe/Madrid|g' /etc/php/8.2/cli/php.ini

    # Configurar la zona horaria en el sistema
      sudo timedatectl set-timezone Europe/Madrid

    # Modificar la configuración de servidor mariadb
      sudo cp /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf.bak.ori
      sudo sed -i '/^\[mysqld\]/a\innodb_file_per_table=1\nlower_case_table_names=0' /etc/mysql/mariadb.conf.d/50-server.cnf
      sudo systemctl enable mariadb
      sudo systemctl restart mariadb

    # Cambiar el password del root
      echo ""
      echo "  Se procederá a cambiar el password del root de MariaDB."
      echo "  Si nunca has cambiado el password antes, simplemente presiona Enter."
      echo ""
      sudo mariadb -u root -p -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'rootMySQL'; FLUSH PRIVILEGES;"

    # Efectuar cambios en el servidor MariaDB
      sudo mariadb -u root -prootMySQL -e "CREATE DATABASE librenms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; CREATE USER 'librenms'@'localhost' IDENTIFIED BY 'password'; GRANT ALL PRIVILEGES ON librenms.* TO 'librenms'@'localhost'; FLUSH PRIVILEGES;"

    # Configurar PHP-FPM
      sudo cp /etc/php/8.2/fpm/pool.d/www.conf /etc/php/8.2/fpm/pool.d/librenms.conf
      sudo sed -i -e 's|user = www-data|user = librenms|g'   /etc/php/8.2/fpm/pool.d/librenms.conf
      sudo sed -i -e 's|group = www-data|group = librenms|g' /etc/php/8.2/fpm/pool.d/librenms.conf

    #Change listen to a unique path that must match your webserver's config (fastcgi_pass for NGINX and SetHandler for Apache) :
    # listen = /run/php-fpm-librenms.sock

    # Al ser LibreNMS la única app PHP borramos la www por defecto
      sudo mv /etc/php/8.2/fpm/pool.d/www.conf /etc/php/8.2/fpm/pool.d/www.conf.bak

    # Crear la web en nginx
      echo 'server {'                                       | sudo tee    /etc/nginx/conf.d/librenms.conf
      echo 'listen      80;'                                | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo 'server_name librenms.example.com;'              | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo 'root        /opt/librenms/html;'                | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo 'index       index.php;'                         | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo 'charset utf-8;'                                 | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo 'gzip on;'                                       | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo 'gzip_types text/css application/javascript text/javascript application/x-javascript image/svg+xml text/plain text/xsd text/xsl text/xml image/x-icon;' | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo 'location / {'                                   | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo 'try_files $uri $uri/ /index.php?$query_string;' | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo '}'                                              | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo 'location ~ [^/]\.php(/|$) {'                    | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo 'fastcgi_pass unix:/run/php-fpm-librenms.sock;'  | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo 'fastcgi_split_path_info ^(.+\.php)(/.+)$;'      | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo 'include fastcgi.conf;'                          | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo '}'                                              | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo 'location ~ /\.(?!well-known).* {'               | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo 'deny all;'                                      | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo '}'                                              | sudo tee -a /etc/nginx/conf.d/librenms.conf
      echo '}'                                              | sudo tee -a /etc/nginx/conf.d/librenms.conf
    sudo rm /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default
    sudo systemctl restart nginx
    sudo systemctl restart php8.2-fpm

    # Activar el completado de comandos usando tab
      sudo ln -s /opt/librenms/lnms /usr/bin/lnms
      sudo cp /opt/librenms/misc/lnms-completion.bash /etc/bash_completion.d/

    # Configurar snmpd
      sudo cp /opt/librenms/snmpd.conf.example /etc/snmp/snmpd.conf
      sudo sed -i -e 's|RANDOMSTRINGGOESHERE|PonerLaComunidadSNMPAqui|g' /etc/snmp/snmpd.conf
      # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install curl
          echo ""
        fi
      sudo curl -L https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/distro -o /usr/bin/distro
      sudo chmod +x /usr/bin/distro
      sudo systemctl enable snmpd
      sudo systemctl restart snmpd

    # Tareas Cron
      sudo cp /opt/librenms/dist/librenms.cron /etc/cron.d/librenms

    # Activar el programador
      sudo cp /opt/librenms/dist/librenms-scheduler.service /opt/librenms/dist/librenms-scheduler.timer /etc/systemd/system/
      sudo systemctl enable librenms-scheduler.timer
      sudo systemctl start librenms-scheduler.timer

    # Copiar la configuración de logrotate
      sudo cp /opt/librenms/misc/librenms.logrotate /etc/logrotate.d/librenms

    # Notificar fin de ejecución del script
      echo ""
      echo "  El script de instalación de LibreNMS para Debian ha finalizado."
      echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de LibreNMS para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de LibreNMS para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de LibreNMS para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de LibreNMS para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de LibreNMS para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi

