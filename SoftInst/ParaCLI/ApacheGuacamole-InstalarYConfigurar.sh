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

  # Instalar dependencias
    apt-get -y install build-essential
    apt-get -y install freerdp2-dev
    apt-get -y install libavcodec-dev
    apt-get -y install libavformat-dev
    apt-get -y install libavutil-dev
    apt-get -y install libcairo2-dev
    apt-get -y install libjpeg62-turbo-dev
    apt-get -y install libjpeg-dev
    apt-get -y install libossp-uuid-dev
    apt-get -y install libpango1.0-0
    apt-get -y install libpango1.0-dev
    apt-get -y install libpng-dev
    apt-get -y install libpulse-dev
    apt-get -y install libssh2-1
    apt-get -y install libssh2-1-dev
    apt-get -y install libssl-dev
    apt-get -y install libswscale-dev
    apt-get -y install libtelnet-dev
    apt-get -y install libtool-bin
    apt-get -y install libvncserver-dev
    apt-get -y install libvorbis-dev
    apt-get -y install libwebp-dev
    apt-get -y install libwebsocketpp-dev
    apt-get -y install libwebsockets16
    apt-get -y install libwebsockets-dev
    apt-get -y install openssl
  # Apache Tomcat
    apt-get -y install tomcat9
    apt-get -y install tomcat9-admin
    apt-get -y install tomcat9-common
    apt-get -y install tomcat9-user
    systemctl enable --now tomcat9
    systemctl status tomcat9 --no-pager
  # Guacamole server
    # Determinar cuál es la última versión
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
    # Descargar el código fuente
      # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${vColorRojo}    El paquete wget no está instalado. Iniciando su instalación...${vFinColor}"
          echo ""
          apt-get -y update
          apt-get -y install wget
          echo ""
        fi
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
    cd guacamole-server-$vUltVersApGuac
    ./configure --with-systemd-dir=/etc/systemd/system/
    make
  # Instalar
    make install
    ldconfig
    mkdir -p /etc/guacamole/{extensions,lib}
    echo 'GUACAMOLE_HOME=/etc/guacamole' >> /etc/default/tomcat9
  # Crear el archivo de propiedades
    echo "guacd-hostname: localhost"                      > /etc/guacamole/guacamole.properties
    echo "guacd-port: 4822"                              >> /etc/guacamole/guacamole.properties
    echo "user-mapping: /etc/guacamole/user-mapping.xml" >> /etc/guacamole/guacamole.properties
  # Crear el archivo de configuración de registro y depuración
    echo '<configuration>'                                                                    > /etc/guacamole/logback.xml
    echo ''                                                                                  >> /etc/guacamole/logback.xml
    echo '  <!-- Appender for debugging -->'                                                 >> /etc/guacamole/logback.xml
    echo '  <appender name="GUAC-DEBUG" class="ch.qos.logback.core.ConsoleAppender">'        >> /etc/guacamole/logback.xml
    echo '    <encoder>'                                                                     >> /etc/guacamole/logback.xml
    echo '      <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>' >> /etc/guacamole/logback.xml
    echo '    </encoder>'                                                                    >> /etc/guacamole/logback.xml
    echo '  </appender>'                                                                     >> /etc/guacamole/logback.xml
    echo ''                                                                                  >> /etc/guacamole/logback.xml
    echo '  <!-- Log at DEBUG level -->'                                                     >> /etc/guacamole/logback.xml
    echo '  <root level="debug">'                                                            >> /etc/guacamole/logback.xml
    echo '    <appender-ref ref="GUAC-DEBUG"/>'                                              >> /etc/guacamole/logback.xml
    echo '  </root>'                                                                         >> /etc/guacamole/logback.xml
    echo ''                                                                                  >> /etc/guacamole/logback.xml
    echo '</configuration>'                                                                  >> /etc/guacamole/logback.xml
  # Creando archivo de autenticación de usuarios
    echo '<user-mapping>'                                              > /etc/guacamole/user-mapping.xml
    echo ''                                                           >> /etc/guacamole/user-mapping.xml
    echo '  <authorize'                                               >> /etc/guacamole/user-mapping.xml
    echo ''                                                           >> /etc/guacamole/user-mapping.xml
    echo '    username="usuariox"'                                    >> /etc/guacamole/user-mapping.xml
    echo '    password="ContraHasheada"'                              >> /etc/guacamole/user-mapping.xml
    echo '    encoding="md5">'                                        >> /etc/guacamole/user-mapping.xml
    echo ''                                                           >> /etc/guacamole/user-mapping.xml
    echo '    <connection name="SSH localhost">'                      >> /etc/guacamole/user-mapping.xml
    echo '      <protocol>ssh</protocol>'                             >> /etc/guacamole/user-mapping.xml
    echo '      <param name="hostname">localhost</param>'             >> /etc/guacamole/user-mapping.xml
    echo '      <param name="port">22</param>'                        >> /etc/guacamole/user-mapping.xml
    echo '      <param name="username">usuariox</param>'              >> /etc/guacamole/user-mapping.xml
    echo '      <param name="password">UsuarioX</param>'              >> /etc/guacamole/user-mapping.xml
    echo '    </connection>'                                          >> /etc/guacamole/user-mapping.xml
    echo ''                                                           >> /etc/guacamole/user-mapping.xml
    echo '    <connection name="VNC localhost">'                      >> /etc/guacamole/user-mapping.xml
    echo '      <protocol>vnc</protocol>'                             >> /etc/guacamole/user-mapping.xml
    echo '      <param name="hostname">localhost</param>'             >> /etc/guacamole/user-mapping.xml
    echo '      <param name="port">5901</param>'                      >> /etc/guacamole/user-mapping.xml
    echo '      <param name="password">VNCPASS</param>'               >> /etc/guacamole/user-mapping.xml
    echo '    </connection>'                                          >> /etc/guacamole/user-mapping.xml
    echo ''                                                           >> /etc/guacamole/user-mapping.xml
    echo '    <connection name="VNC otherhost">'                      >> /etc/guacamole/user-mapping.xml
    echo '      <protocol>vnc</protocol>'                             >> /etc/guacamole/user-mapping.xml
    echo '      <param name="hostname">otherhost</param>'             >> /etc/guacamole/user-mapping.xml
    echo '      <param name="port">5900</param>'                      >> /etc/guacamole/user-mapping.xml
    echo '      <param name="password">VNCPASS</param>'               >> /etc/guacamole/user-mapping.xml
    echo '    </connection>'                                          >> /etc/guacamole/user-mapping.xml
    echo ''                                                           >> /etc/guacamole/user-mapping.xml
    echo '  </authorize>'                                             >> /etc/guacamole/user-mapping.xml
    echo ''                                                           >> /etc/guacamole/user-mapping.xml
    echo '</user-mapping>'                                            >> /etc/guacamole/user-mapping.xml
  # Generar el hash de la contraseña
    vHashContra=$(echo -n UsuarioX | openssl md5 | cut -d'=' -f2 | sed 's- --g')
  # Remplazar texto con hash de la contraseña
    sed -i -e "s|ContraHasheada|$vHashContra|g" /etc/guacamole/user-mapping.xml
  # Web cliente
    wget https://downloads.apache.org/guacamole/$vUltVersApGuac/binary/guacamole-$vUltVersApGuac.war
    mv guacamole-$vUltVersApGuac.war /var/lib/tomcat9/webapps/guacamole.war
    systemctl restart tomcat9
    systemctl status tomcat9 --no-pager
  # Servicio
    systemctl enable --now guacd
    systemctl status guacd --no-pager
  # Mensaje
    echo ""
    echo "    Ya deberías poder ver la web de Apache Guacamole en http://IPDeEsteServidor:8080/guacamole"
    echo ""
        
elif [ $OS_VERS == "12" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de Apache Guacamole para Debian 12 (Bookworm)...${vFinColor}"
  echo ""

  # Instalar dependencias
    apt-get -y install build-essential
    apt-get -y install freerdp2-dev
    apt-get -y install libavcodec-dev
    apt-get -y install libavformat-dev
    apt-get -y install libavutil-dev
    apt-get -y install libcairo2-dev
    apt-get -y install libjpeg62-turbo-dev
    apt-get -y install libjpeg-dev
    apt-get -y install libossp-uuid-dev
    apt-get -y install libpango1.0-0
    apt-get -y install libpango1.0-dev
    apt-get -y install libpng-dev
    apt-get -y install libpulse-dev
    apt-get -y install libssh2-1
    apt-get -y install libssh2-1-dev
    apt-get -y install libssl-dev
    apt-get -y install libswscale-dev
    apt-get -y install libtelnet-dev
    apt-get -y install libtool-bin
    apt-get -y install libvncserver-dev
    apt-get -y install libvorbis-dev
    apt-get -y install libwebp-dev
    apt-get -y install libwebsocketpp-dev
    apt-get -y install libwebsockets17
    apt-get -y install libwebsockets-dev
    apt-get -y install openssl
  # Apache Tomcat
    apt-get -y install tomcat10
    apt-get -y install tomcat10-admin
    apt-get -y install tomcat10-common
    apt-get -y install tomcat10-user
    systemctl enable --now tomcat10
    systemctl status tomcat10 --no-pager

fi
