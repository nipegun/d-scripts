#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar un servidor de correo con en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Mail-InstalarYConfigurar.sh | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Mail-InstalarYConfigurar.sh | bash
#
#  Ejecución remota con parámetros:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Mail-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
# ----------

vDominio="nipegun.com"
vIPServMail="192.168.0.2"
vPrimerOcteto=$(echo $vIPServMail | cut -d '.' -f1)
vSegundoOcteto=$(echo $vIPServMail | cut -d '.' -f2)
vTercerOcteto=$(echo $vIPServMail | cut -d '.' -f3)
  
vIPDirecta="192.168.0.2"

Fecha=$(date +A%YM%mD%d@%T)

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

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}curl no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update && apt-get -y install curl
    echo ""
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
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de xxxxxxxxx para Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de xxxxxxxxx para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de xxxxxxxxx para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de xxxxxxxxx para Debian 10 (Buster)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación del servidor de correo para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi

  #menu=(dialog --timeout 5 --checklist "Marca las opciones que quieras instalar:" 22 96 16)
  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Instalar servidor DNS en el propio servidor de correo." on
      2 "Opción 2" off
      3 "Opción 3" off
      4 "Opción 4" off
      5 "Opción 5" off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  #clear

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando servidor DNS..."
            echo ""

            apt-get -y update && apt-get -y install bind9

            # Determinar si la IP directa es clase A, B o C para asignar la IP inversa
              if [ $(echo $vIPServMail | cut -d '.' -f1) == "10" ]; then # Clase A
                vIPInversa="$vPrimerOcteto"
              elif [ $(echo $vIPServMail | cut -d '.' -f1) == "172" ]; then # Clase B
                vIPInversa="$vSegundoOcteto.$vPrimerOcteto"
              elif [ $(echo $vIPServMail | cut -d '.' -f1) == "192" ]; then # Clase C
                vIPInversa="$vTercerOcteto.$vSegundoOcteto.$vPrimerOcteto"
              else
                echo ""
                echo -e "${vColorRojo}    La IP del servidor de mail no es de clase privada. Abortando...${vFinColor}"
                echo ""
                echo ""
              fi

            # Crear la zona directa
              echo ""
              echo "  Creando la zona directa..."
              echo ""
              cp /etc/bind/db.local /etc/bind/db.$vDominio.directa
              sed -i -e "s|localhost. root.localhost.|$vDominio. root.$vDominio.|g" /etc/bind/db.$vDominio.directa
              sed -i -e "s|localhost.|correo.$vDominio.|g"                          /etc/bind/db.$vDominio.directa
              sed -i -e '/127.0.0.1/d'                                              /etc/bind/db.$vDominio.directa
              sed -i -e '/::1/d'                                                    /etc/bind/db.$vDominio.directa
            # Anexar la zona directa
              echo ""
              echo "  Anexando la zona directa..."
              echo ""
              echo ''                                         >> /etc/bind/named.conf.local
              echo 'zone "lan.local" {'                       >> /etc/bind/named.conf.local
              echo '  type master;'                           >> /etc/bind/named.conf.local
              echo '  allow-transfer { none; };'              >> /etc/bind/named.conf.local
              echo '  file "/etc/bind/db.'$vDominio'.directa";' >> /etc/bind/named.conf.local
              echo '};'                                       >> /etc/bind/named.conf.local
              echo ''                                         >> /etc/bind/named.conf.local
            # Creando la zona inversa
              echo ""
              echo "  Creando la zona inversa..."
              echo ""
              cp /etc/bind/db.127   /etc/bind/db.$vDominio.inversa
            # Anexar la zona inversa
              echo ""
              echo "  Anexando la zona inversa..."
              echo ""
              echo ''                                         >> /etc/bind/named.conf.local
              echo 'zone "$vIPInversa.in-addr.arpa" {'        >> /etc/bind/named.conf.local
              echo '  type master; '                          >> /etc/bind/named.conf.local
              echo '  allow-transfer { none; };'              >> /etc/bind/named.conf.local
              echo '  file "/etc/bind/db.'$vDominio'.inversa";' >> /etc/bind/named.conf.local
              echo '};'                                       >> /etc/bind/named.conf.local
              echo ''                                         >> /etc/bind/named.conf.local

 
            # Configurar el servidor DNS, dado que las cuentas de correo no pueden funcionar con direcciones IP
            # Como las cuentas de correo no pueden funcionar con direcciones IP y deben funcionar con nombres dns,
            # hay que instalar el servidor de dns y apuntar el dominio a la IP del servidor de correo.
            # El servidor dns del servidor de correo debe ser el servidor DNS donde están configurados los registros:
            # Hay que crear una zona en el servidor DNS que sea el dominio y la extensión, por ejemplo: hacks4geeks.com
            # En bind 9 (zona directa, db.hacks4geeks.com):
       //     echo "correo     IN A     $vIPDirecta" >> /etc/bind/db.$vDominio
       //     echo "$vDominio. IN MX 10 correo"      >> /etc/bind/db.$vDominio # Las cuentas de correo que entren en @hacsk4geeks.com serán redirigidas a la entrada correos
            # Comprobamos que la zona esté bien escrita:
             echo ""
             echo "  Comprobando la sintaxis de las zonas..."
             echo ""
             named-checkzone $vDominio /etc/bind/db.$vDominio.directa
             named-checkzone $vDominio /etc/bind/db.$vDominio.inversa
            # En bind 9 (zona inversa, db.0.168.192): # es mejor declararla para que el correo no acabe en spam
         //   echo "2 IN PTR correo.hacks4geeks.com." >> db.$vIPInversa
    
          ;;

          2)

            echo ""
            echo "  Opción 2..."
            echo ""
   
            # Instalar el servidor de bases de datos
              apt-get -y install mariadb-server
            # Instalar roundcube (asume que la contraseña root de MySQL está vacía, si no, debería preguntar la contraseña root)
              apt-get -y install roundcube
              # dbconfig-common: si
              # Poner contraseña de aplicación.
            # Activar el alias para ingresar mediante /roundcube
              sed -i -e 's-#    Alias /roundcube /var/lib/roundcube/public_html-Alias /roundcube /var/lib/roundcube/public_html-g' /etc/roundcube/apache.conf
            # Hacer que se sirva en la carpeta raíz de apache
              # Modificar el sitio por defecto para HTTP
                sed -i -e 's|</VirtualHost>|\n  Include /etc/roundcube/apache.conf\n  Alias / /var/lib/roundcube/public_html/\n\n</VirtualHost>|g' /etc/apache2/sites-available/000-default.conf
                a2ensite 000-default
                # Modificar el sitio por defecto para HTTPS
                sed -i -e 's|</VirtualHost>|\n  Include /etc/roundcube/apache.conf\n  Alias / /var/lib/roundcube/public_html/\n\n</VirtualHost>|g' /etc/apache2/sites-available/default-ssl.conf
               a2ensite default-ssl.conf
               a2enmod ssl
              # Crear un certificado autofirmado
              openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/roundcube.key -out /etc/ssl/certs/roundcube.crt -subj "/C=ES/ST=Madrid/L=Arganda/O=MiEmpresa/CN=dominio.com/emailAddress=mail@gmail.com"
              # Reemplazar la ubicación del certificado en el archivo de configuración
              sed -i -e 's|/etc/ssl/certs/ssl-cert-snakeoil.pem|/etc/ssl/certs/roundcube.crt|g'     /etc/apache2/sites-available/default-ssl.conf
              sed -i -e 's|/etc/ssl/private/ssl-cert-snakeoil.key|/etc/ssl/private/roundcube.key|g' /etc/apache2/sites-available/default-ssl.conf
              # Desactivar la configuración por defecto de roundcube
              a2disconf roundcube
              # Comprobar sintaxis de apache
              echo ""
              echo "  Comprobando sintaxis de los archivos de apache..."
              echo ""
              apache2ctl configtest
              # Reiniciar el servidor apache
                echo ""
                echo "  Reiniciando el servidor apache..."
                echo ""
                systemctl restart apache2
                systemctl restart apache2

              # Reiniciar el servicio apache
                service apache2 restart
              # Instalar el demonio para IMAP
                apt-get -y install dovecot-imapd
              # Modificar la configuración
                #sed -i -e 's|$config['default_host'] = '';|$config['default_host'] = 'localhost';|g'                                            /etc/roundcube/config.inc.php
                sed -i -e 's|$config['default_host'] = '';|$config['default_host'] = 'correo.festivalehz.local';|g'                              /etc/roundcube/config.inc.php
                sed -i -e 's|$config['smtp_port'] = 587;|$config['smtp_port'] = 25;|g'                                                           /etc/roundcube/config.inc.php
                sed -i -e 's|$config['smtp_user'] = '%u';|$config['smtp_user'] = '';|g'                                                          /etc/roundcube/config.inc.php
                sed -i -e 's|$config['plugins'] = array(|$config['plugins'] = array(\n'archive',\n'zipdownload',\n'managesieve',\n'password',|g' /etc/roundcube/config.inc.php
                echo ""                                                                                                                       >> /etc/roundcube/config.inc.php
                echo ""'$config'"['session_lifetime'] = 60;"                                                                                  >> /etc/roundcube/config.inc.php
                echo ""'$config'"['skin_logo'] = './ispmail-logo.png';"                                                                       >> /etc/roundcube/config.inc.php
                echo ""
                echo "  Cambiando el logo por defecto..."
                echo ""
              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${vColorRojo}    wget no está instalado. Iniciando su instalación...${vFinColor}"
                  echo ""
                  apt-get -y update && apt-get -y install wget
                  echo ""
                fi
              wget --no-check-certificate http://hacks4geeks.com/_/cosas/LogoMailEHZ.png -O /var/lib/roundcube/public_html/logo.png

              apt-get -y install postfix
              apt-get -y install dovecot-imapd
              #apt-get -y install dovecot-pop3d
              #dpkg-reconfigure postfix
              # -> Sitio de intenet
              # -> festivalehz.ddns.net 
              # -> En blanco
              # -> Enter
              # -> Forzar actualizaciones síncronas, si
              # -> 127.0.0.0/24 192.168.0.0/24 192.168.1.0/24 192.168.2.0/24 192.168.3.0/24 192.168.4.0/24 192.168.255.0/24
              # -> Limite 0, ilimitado
              # -> Caracter de extension de direcciones locales +
              # -> Protocolos de internet a usar IPv4
              echo "home_mailbox = Maildir/" >> /etc/postfix/main.cf
              maildirmake.dovecot /etc/skel/Maildir
              sed -i -e 's|#   mail_location = maildir:~/Maildir|mail_location = maildir:~/Maildir|g' /etc/dovecot/conf.d/10-mail.conf
              service dovecot restart
              service postfix restart

              apt-get -y install mariadb-server
              apt-get -y install mariadb-client
              apt-get -y install phpmyadmin
              # Marcar apache2
              # Configurar la base para dbconfig-common: si
              # Poner contraseña de aplicacion
              mysql_secure_installation
              #mysql -uroot -prootMySQL -e "update mysql.user set plugin='' where user = 'root';"
              mysql -e "create user 'roundcube'@'localhost' identified by 'roundcube';"
              mysql -e "grant all privileges on mysql.* to 'roundcube'@'localhost';"
              mysql -e "create database roundcube;"
              mysql -e "grant all privileges on roundcube.* to 'roundcube'@'localhost'";
              apt-get -y install roundcube
                # dbconfig common, si, app
                # TCP/IP
                # Servidor de bases de datos para roundcube: localhost
                # Número de puerto del servicio mysql: 3306
                # Authentication: mysql_native_password
                # Nombre de la base de datos: roundcube
                # Usuario roundcube @ localhost
                # contraseña de aplicación: roundcube (Es la contraseña de :identified by 'roundcube')
              sed -i -e 's-#    Alias /roundcube /var/lib/roundcube/public_html-Alias /roundcube /var/lib/roundcube/public_html-g' /etc/roundcube/apache.conf
              service apache2 restart
              adduser nico
              adduser pablo
              adduser gorka

            # Instalar paquetes
              apt-get -y install roundcube
              apt-get -y install roundcube-mysql
              apt-get -y install roundcube-plugins
            # Poner la configuracion de la base de datos 
              sed -i -e 's---g' /etc/roundcube/config.inc.php
            # 
    
            echo "virtual_alias_maps = mysql:/etc/postfix/mysql-virtual-alias-maps.cf"     >> /etc/postfix/main.cf
            echo "virtual_mailbox_maps = mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf" >> /etc/postfix/main.cf
            echo "user = roundcube"                                                   > /etc/postfix/mysql-virtual-alias-maps.cf
            echo "password = raizraiz"                                               >> /etc/postfix/mysql-virtual-alias-maps.cf
            echo "hosts = localhost"                                                 >> /etc/postfix/mysql-virtual-alias-maps.cf
            echo "dbname = roundcube"                                                >> /etc/postfix/mysql-virtual-alias-maps.cf
            echo "query = SELECT destination FROM virtual_aliases WHERE source='%s'" >> /etc/postfix/mysql-virtual-alias-maps.cf
            echo "user = roundcube"                                                   > /etc/postfix/mysql-virtual-mailbox-maps.cf
            echo "password = raizraiz"                                               >> /etc/postfix/mysql-virtual-mailbox-maps.cf
            echo "hosts = localhost"                                                 >> /etc/postfix/mysql-virtual-mailbox-maps.cf
            echo "dbname = roundcube"                                                >> /etc/postfix/mysql-virtual-mailbox-maps.cf
            echo "query = SELECT maildir FROM virtual_users WHERE email='%s'"        >> /etc/postfix/mysql-virtual-mailbox-maps.cf
            systemctl restart postfix
  
            # Indicar el servidor IMAP y SMTP en el archivo de confioguración de roundcube
              sed -i -e 's|$config['default_host'] = '';|$config['default_host'] = 'tuservidor';|g'        /etc/roundcube/config.inc.php
              sed -i -e 's|$config['smtp_server'] = 'localhost';|$config['smtp_server'] = 'tuservidor';|g' /etc/roundcube/config.inc.php
            #apt-get install roundcube-plugins
              echo "home_mailbox = Maildir/" >> /etc/postfix/main.cf
              maildirmake.dovecot /etc/skel/Maildir
             apt-get -y install postfix

          ;;

          3)

            echo ""
            echo "  Opción 3..."
            echo ""

          ;;

          4)

            echo ""
            echo "  Opción 4..."
            echo ""

          ;;

          5)

            echo ""
            echo "  Opción 5..."
            echo ""

          ;;

      esac

  done

fi

