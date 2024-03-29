#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar lighthttpd en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Web-lighttpd-InstalaryConfigurar.sh | bash
#
# Ejecución remota sin caché:
#  curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Web-lighttpd-InstalaryConfigurar.sh | bash
#
# Ejecución remota con parámetros:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Web-lighttpd-InstalaryConfigurar.sh | bash -s Parámetro1 Parámetro2
# ----------

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

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

if [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de lighthttpd para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de lighthttpd para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de lighthttpd para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de lighthttpd para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de lighthttpd para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  vFecha=$(date +A%YM%mD%d@%T)

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi

  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Instalar el paquete lighttpd." on
      2 "Instalar y activar PHP." off
      3 "Instalar servidor de bases de datos MariaDB." off
      4 "Activar HTTPS." off
      5 "Activar certificado de LetsEncrypt." off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  #clear

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Instalando el paquete lighttpd..."          echo ""
          apt-get -y update && apt-get -y install lighttpd 
          systemctl enable lighttpd --now

        ;;

        2)

          echo ""
          echo "  Instalando y activando PHP..."          echo ""
          #apt-get -y install php
          apt-get -y install php-cgi
          apt-get -y install php-fpm
          # Determinar la última versión de PHP disponible en Debian
            vUltVerPHP=$(apt-cache search php | grep etapack | grep ^php | cut -d ' ' -f1 | cut -d'p' -f3)
          sed -i -e 's|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=1|g' /etc/php/$vUltVerPHP/fpm/php.ini
          sed -i -e 's|listen = /run/php/php'"$vUltVerPHP"'-fpm.sock|listen = 127.0.0.1:9000|g' /etc/php/$vUltVerPHP/fpm/pool.d/www.conf
          
          sed -i -e 's|"bin-path" => "/usr/bin/php-cgi",|"host" => "127.0.0.1",|g'       /etc/lighttpd/conf-available/15-fastcgi-php.conf
          #sed -i -e 's|"socket" => "/var/run/lighttpd/php.socket",|"port" => "9000",|g' /etc/lighttpd/conf-available/15-fastcgi-php.conf
          # Modificación individual (Por si la línea anterior no funciona)
            sed -i -e 's|"socket"|"port"|g'                   /etc/lighttpd/conf-available/15-fastcgi-php.conf
            sed -i -e 's|/var/run/lighttpd/php.socket|9000|g' /etc/lighttpd/conf-available/15-fastcgi-php.conf
            sed -i -e 's|/run/lighttpd/php.socket|9000|g'     /etc/lighttpd/conf-available/15-fastcgi-php.conf
          # Crear página web básica con PHP
            cat /var/www/html/index.lighttpd.html  > /var/www/html/index.php
            echo "<?php"                          >> /var/www/html/index.php
            echo "  phpinfo();"                   >> /var/www/html/index.php
            echo "?>"                             >> /var/www/html/index.php
          # Borrar html
            rm -f /var/www/html/index.lighttpd.html
          # Reparar permisos
            chown -R www-data:www-data /var/www/html/
            chmod -R 755 /var/www/html
          # Desinstalar apache
            apt-get -y purge apache2-data
            apt-get -y purge apache2-bin
            apt-get -y autoremove
          # Reiniciar servidor web
            echo ""
            echo "    Reiniciando php$vUltVerPHP-fpm..."
            echo ""
            systemctl restart php$vUltVerPHP-fpm
            echo ""
            echo "    Activando módulo fastcgi..."
            echo ""
            lighty-enable-mod fastcgi
            echo ""
            echo "    Activando módulo fastcgi-php..."
            echo ""
            lighty-enable-mod fastcgi-php
            echo ""
            echo "    Reiniciando servidor Web..."
            echo ""
            systemctl restart lighttpd

        ;;

        3)

          echo ""
          echo "  Instalando servidor de bases de datos MariaDB..."          echo ""
          apt-get -y install php-mysql
          # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
            echo ""
            echo -e "${cColorRojo}    curl no está instalado. Iniciando su instalación...${cFinColor}"
            echo ""
            apt-get -y update && apt-get -y install curl
            echo ""
          fi
          curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-MariaDB-InstalarYConfigurar.sh | bash

        ;;

        4)

          echo ""
          echo "  Activando HTTPS con certificado autofirmado..."          echo ""
          # Crear el certificado y la clave del certificado
            openssl req -x509 -nodes -days 365 -newkey rsa:2048 -out /etc/ssl/certs/lighttpd-default.crt -keyout /etc/ssl/private/lighttpd-default.key
          # Unir certificado y llave privada
            mkdir  /etc/lighttpd/ssl/
            cat /etc/ssl/private/lighttpd-default.key /etc/ssl/certs/lighttpd-default.crt > /etc/lighttpd/ssl/lighttpd-default.pem
          # Añadir el certificado al archivo de configuración del sitio web por defecto de lighttpd
            sed -i -e 's|server.modules += (|server.modules += (\n"mod_openssl",|g' /etc/lighttpd/lighttpd.conf
            echo ''                                                              >> /etc/lighttpd/lighttpd.conf
            echo '$SERVER["socket"] == ":443" {'                                 >> /etc/lighttpd/lighttpd.conf
            echo '  ssl.engine = "enable"'                                       >> /etc/lighttpd/lighttpd.conf
            echo '  ssl.pemfile = "/etc/lighttpd/ssl/lighttpd-default.pem"'      >> /etc/lighttpd/lighttpd.conf
            echo '}'                                                             >> /etc/lighttpd/lighttpd.conf
          # Verificar configuración
            lighttpd -t -f /etc/lighttpd/lighttpd.conf
          # Reiniciar el servicio
            systemctl restart lighttpd

        ;;

        5)

          echo ""
          echo "  Activando certificado de LetsEncrypt..."          echo ""
          apt-get -y install certbot
          echo ""
          echo "  Introduce el nombre de dominio para el que quieras crear el certificado y presiona Enter:"
          echo ""
          read vNombreDeDominio < /dev/tty
          certbot certonly --webroot -w /var/www/html -d $vNombreDeDominio
          # Agregar cetificado en un único archivo combinado
            # Combinar certificado y llave privada en el mismo archivo
              #cat /etc/letsencrypt/live/$vNombreDeDominio/cert.pem /etc/letsencrypt/live/$vNombreDeDominio/privkey.pem > /etc/letsencrypt/live/$vNombreDeDominio/web.pem
            # Agregar el certificado al archivo de configuración del sitio
          # Agregar certificado en archivos separados
            sed -i -e 's|ssl.pemfile = "/etc/lighttpd/ssl/lighttpd-default.pem"|ssl.pemfile =|g' /etc/lighttpd/lighttpd.conf
            sed -i -e "s|ssl.pemfile =|\n  ssl.pemfile = /etc/letsencrypt/live/$vNombreDeDominio/fullchain.pem\n  ssl.privkey = /etc/letsencrypt/live/$vNombreDeDominio/privkey.pem|g" /etc/lighttpd/lighttpd.conf
          # Reiniciar lighttpd
            systemctl restart lighttpd

        ;;


    esac

  done

fi

