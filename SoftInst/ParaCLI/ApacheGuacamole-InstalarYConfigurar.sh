#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Apache Guacamole en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/ApacheGuacamole-InstalarYConfigurar.sh | bash
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
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Apache Guacamole para Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Apache Guacamole para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Apache Guacamole para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Apache Guacamole para Debian 10 (Buster)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Apache Guacamole para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install curl
      echo ""
    fi

  vUltVersApGuac=$(curl -sL https://dlcdn.apache.org/guacamole/ | sed 's|</a>|</a>\n|g' | sed 's|<a|\n<a|g' | grep href | grep -v ame | grep -v ize | grep -v escription | grep -v irectory | grep -v EYS | grep -v odifie | tail -n 1 | cut -d'/' -f1 | cut -d'"' -f2)

  # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}    El paquete wget no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install wget
      echo ""
    fi

  # Descargar
    mkdir -p /root/SoftInst/Guacamole/
    cd /root/SoftInst/Guacamole/
    if [[ $vUltVersApGuac == "" ]]; then
      echo "No se ha encontrado la versión"
    else
      wget https://dlcdn.apache.org/guacamole/$vUltVersApGuac/source/guacamole-server-$vUltVersApGuac.tar.gz
    fi
  # Descomprimir
    # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${vColorRojo}    El paquete tar no está instalado. Iniciando su instalación...${vFinColor}"
        echo ""
        apt-get -y update
        apt-get -y install tar
        echo ""
      fi
    tar zxf /root/SoftInst/Guacamole/guacamole-server-$vUltVersApGuac.tar.gz
  # Borrar archivo comprimido
    rm -rf /root/SoftInst/Guacamole/guacamole-server-$vUltVersApGuac.tar.gz
  # Compilar
    # Instalar paquetes necesarios
      apt-get -y install build-essential
      apt-get -y install libcairo2-dev
      #apt-get -y install libjpeg-turbo8-dev
      apt-get -y install libpng-dev
      apt-get -y install libtool-bin
      apt-get -y install libossp-uuid-dev
      apt-get -y install libvncserver-dev
      apt-get -y install freerdp2-dev
      apt-get -y install libssh2-1-dev
      apt-get -y install libtelnet-dev
      apt-get -y install libwebsockets-dev
      apt-get -y install libpulse-dev
      apt-get -y install libvorbis-dev
      apt-get -y install libwebp-dev
      apt-get -y install libssl-dev
      apt-get -y install libpango1.0-dev
      apt-get -y install libswscale-dev
      apt-get -y install libavcodec-dev
      apt-get -y install libavutil-dev
      apt-get -y install libavformat-dev
    #
      cd guacamole-server-$vUltVersApGuac
      ./configure --with-init-dir=/etc/init.d --enable-allow-freerdp-snapshots
      make
      make install
      ldconfig
      systemctl daemon-reload
      systemctl start guacd
      systemctl enable guacd
      mkdir -p /etc/guacamole/{extensions,lib}
    # Apache Tomcat
      apt install tomcat9 tomcat9-admin tomcat9-common tomcat9-user
      wget https://downloads.apache.org/guacamole/1.3.0/binary/guacamole-1.3.0.war
      mv guacamole-1.3.0.war /var/lib/tomcat9/webapps/guacamole.war
      systemctl restart tomcat9 guacd
    # Auntnticación de bases de datos
      apt install mariadb-server
      mysql_secure_installation
      wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.26.tar.gz
      tar -xf mysql-connector-java-8.0.26.tar.gz
      cp mysql-connector-java-8.0.26/mysql-connector-java-8.0.26.jar /etc/guacamole/lib/
      wget https://downloads.apache.org/guacamole/1.3.0/binary/guacamole-auth-jdbc-1.3.0.tar.gz
      tar -xf guacamole-auth-jdbc-1.3.0.tar.gz
      mv guacamole-auth-jdbc-1.3.0/mysql/guacamole-auth-jdbc-mysql-1.3.0.jar /etc/guacamole/extensions/
      mysql -u root -p
        ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';
        CREATE DATABASE guacamole_db;
        CREATE USER 'guacamole_user'@'localhost' IDENTIFIED BY 'password';
        GRANT SELECT,INSERT,UPDATE,DELETE ON guacamole_db.* TO 'guacamole_user'@'localhost';
        FLUSH PRIVILEGES;
        cd guacamole-auth-jdbc-1.3.0/mysql/schema
        cat *.sql | mysql -u root -p guacamole_db
        nano /etc/guacamole/guacamole.properties
        #Paste in the following configuration settings, replacing [password] with the password of the new guacamole_user that you created for the database.
        # MySQL properties
        #mysql-hostname: 127.0.0.1
        #mysql-port: 3306
        #mysql-database: guacamole_db
        #mysql-username: guacamole_user
        #mysql-password: [password]
        systemctl restart tomcat9 guacd mysql
        #Navigate to the URL: [ip]:8080/guacamole
        Enter guacadmin as the username and guacadmin as the password. Then click Login.
        Create a New Admin User
        Before continuing with configuring Guacamole, it’s recommended that you create a new admin account and delete the original.
        Click the guacadmin user dropdown menu on the top right and select Settings.
        Navigate to the Users tab and click the New User button.
        Under the Edit User section, enter your preferred username and a secure password.
        Under the Permissions section, check all the permissions.
        Click Save to create the new user.
        Log out of the current user and log in as the newly created user.
        Click your username on the top left and select Settings from the dropdown menu.
        Navigate to the Users tab and click the guacadmin user.
        At the bottom of the Edit User screen, click Delete to remove the default user.
        Create an SSH Connection
        To test Guacamole, let’s create an new connection in Guacamole that opens up an SSH connection to the server.
        After logging in to Guacamole, click your username on the top left and select Settings from the dropdown menu.
        Navigate to the Connections tab and click New Connection.
        Under Edit Connection, enter a name for your new connection (such as “Guacamole SSH”) and select SSH as the Protocol.

        Under Parameters, enter your IP address as the Hostname, 22 as the Port, your username as the Username and your user’s password as the Password. Other parameters as available if you wish to edit the connection further.
        Click Save to create the new connection.
        Navigate back to your user’s home screen by clicking your username on the top left and select Home from the dropdown menu.
        Click on the new connection under the All Connections list.

        Más info: https://www.linode.com/docs/guides/installing-apache-guacamole-on-ubuntu-and-debian/
        
elif [ $OS_VERS == "12" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Apache Guacamole para Debian 12 (Bookworm)...${vFinColor}"
  echo ""


  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install curl
      echo ""
    fi

  vUltVersApGuac=$(curl -sL https://dlcdn.apache.org/guacamole/ | sed 's|</a>|</a>\n|g' | sed 's|<a|\n<a|g' | grep href | grep -v ame | grep -v ize | grep -v escription | grep -v irectory | grep -v EYS | grep -v odifie | tail -n 1 | cut -d'/' -f1 | cut -d'"' -f2)

  # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}    El paquete wget no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install wget
      echo ""
    fi

  # Descargar
    mkdir -p /root/SoftInst/Guacamole/
    cd /root/SoftInst/Guacamole/
    if [[ $vUltVersApGuac == "" ]]; then
      echo "No se ha encontrado la versión"
    else
      wget https://dlcdn.apache.org/guacamole/$vUltVersApGuac/source/guacamole-server-$vUltVersApGuac.tar.gz
    fi
  # Descomprimir
    # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${vColorRojo}    El paquete tar no está instalado. Iniciando su instalación...${vFinColor}"
        echo ""
        apt-get -y update
        apt-get -y install tar
        echo ""
      fi
    tar zxf /root/SoftInst/Guacamole/guacamole-server-$vUltVersApGuac.tar.gz
  # Borrar archivo comprimido
    rm -rf /root/SoftInst/Guacamole/guacamole-server-$vUltVersApGuac.tar.gz
  # Instalar paquetes necesarios
    apt-get -y install build-essential
    apt-get -y install libcairo2-dev
    #apt-get -y install libjpeg-turbo8-dev
    apt-get -y install libpng-dev
    apt-get -y install libtool-bin
    apt-get -y install libossp-uuid-dev
    apt-get -y install libvncserver-dev
    apt-get -y install freerdp2-dev
    apt-get -y install libssh2-1-dev
    apt-get -y install libtelnet-dev
    apt-get -y install libwebsockets-dev
    apt-get -y install libpulse-dev
    apt-get -y install libvorbis-dev
    apt-get -y install libwebp-dev
    apt-get -y install libssl-dev
    apt-get -y install libpango1.0-dev
    apt-get -y install libswscale-dev
    apt-get -y install libavcodec-dev
    apt-get -y install libavutil-dev
    apt-get -y install libavformat-dev
  # Compilar
    cd guacamole-server-$vUltVersApGuac
    ./configure --with-init-dir=/etc/init.d --enable-allow-freerdp-snapshots
    make
    make install

fi
