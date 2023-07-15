#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Zabbix en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Zabbix-InstalarYConfigurar.sh | bash
# ----------

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install curl
    echo ""
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
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Zabbix para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Zabbix para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Zabbix para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Zabbix para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Zabbix para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  # Obtener el númer de la última versión LTS de Zabbix
    echo ""
    echo "    Obteniendo el número de la última versión LTS de Zabbix..."    echo ""
    # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        apt-get -y update
        apt-get -y install curl
        echo ""
      fi
    vUltVerLTS=""
  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install dialog
      echo ""
    fi

  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Zabbix LTS con base de datos MariaDB y servidor web apache2." off
      2 "Zabbix LTS con base de datos MariaDB y servidor web nginx." off
      3 "Zabbix (última versión) con base de datos MariaDB y servidor web apache2." off
      4 "Zabbix (última versión) con base de datos MariaDB y servidor web nginx." off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando Zabbix LTS con base de datos MariaDB y servidor web apache2..."
            echo ""

            # Agregar el repositorio
              echo ""
              echo "    Agregando el repositorio..."
              echo ""
              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}    El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  apt-get -y update
                  apt-get -y install wget
                  echo ""
                fi
              mkdir -p /root/SoftInst/Zabbix/
              wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-4%2Bdebian11_all.deb -O /root/SoftInst/Zabbix/ZabbixRepo.deb
              apt -y install /root/SoftInst/Zabbix/ZabbixRepo.deb
              apt-get -y update

            # Instalar el frontend y el agente
              echo ""
              echo "    Instalando el frontend y el repositorio..."
              echo ""
              apt-get -y install zabbix-server-mysql
              apt-get -y install zabbix-frontend-php
              apt-get -y install zabbix-apache-conf
              apt-get -y install zabbix-sql-scripts
              apt-get -y install zabbix-agent
              apt-get -y install mariadb-server

            # Crear la base de datos
              echo ""
              echo "    Creando la base de datos..."
              echo ""
              mysql -e "create database zabbix character set utf8mb4 collate utf8mb4_bin"
              mysql -e "create user zabbix@localhost identified by 'Pass123'"
              mysql -e "grant all privileges on zabbix.* to zabbix@localhost"
              mysql -e "set global log_bin_trust_function_creators = 1"

            # Importando el esquema y los datos iniciales
              # Comprobar si el paquete gzip está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s gzip 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}    El paquete gzip no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  apt-get -y update
                  apt-get -y install gzip
                  echo ""
                fi
              zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -pPass123 zabbix
              # Deshabilitar log_bin_trust_function_creators
                mysql -e "set global log_bin_trust_function_creators = 0"
 
            # Indicar el password de la base de datos en el archivo de configuración
              sed -i -e 's|DBPassword=.*|\nDBPassword=Pass123|g' /etc/zabbix/zabbix_server.conf

            # Asegurarse que la configuración locale del Debian sea la correcta
              echo "es_ES.UTF-8 UTF-8"  > /etc/locale.gen
              echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
              apt-get -y update && apt-get -y install locales
              locale-gen --purge es_ES.UTF-8 en_US.UTF-8
              # Cambiar de false a true la línea que tenga como idioma es_ES
                sed -i -e '/es_ES/s/false/true/g' /usr/share/zabbix/include/locales.inc.php

            # Iniciar el servidor y el agente
              systemctl restart zabbix-server
              systemctl restart zabbix-agent
              systemctl restart apache2
              systemctl enable zabbix-server --now
              systemctl enable zabbix-agent  --now
              systemctl enable apache2       --now

            # Mostrar mensaje de fin
              vIPHostZabbix=$(hostname -I)
              echo ""
              echo "  Instalación de Zabbix LTS con servidor Web apache2 y base de datos MySQL, finalizada."
              echo ""
              echo "    Para conectarte a la web del servidor accede a la siguiente URL:"
              echo "      http://$vIPHostZabbix/zabbix"
              echo ""
              echo "      El usuario por defecto es Admin y la contraseña zabbix."
              echo ""

          ;;

          2)

            echo ""
            echo "  Instalando Zabbix LTS con base de datos MariaDB y servidor web nginx..."
            echo ""

            # Agregar el repositorio
              echo ""
              echo "    Agregando el repositorio..."
              echo ""
              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}    El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  apt-get -y update
                  apt-get -y install wget
                  echo ""
                fi
              mkdir -p /root/SoftInst/Zabbix/
              wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-4%2Bdebian11_all.deb -O /root/SoftInst/Zabbix/ZabbixRepo.deb
              apt -y install /root/SoftInst/Zabbix/ZabbixRepo.deb
              apt-get -y update

            # Instalar el frontend y el agente
              echo ""
              echo "    Instalando el frontend y el repositorio..."
              echo ""
              apt-get -y install zabbix-server-mysql
              apt-get -y install zabbix-frontend-php
              apt-get -y install zabbix-nginx-conf
              apt-get -y install zabbix-sql-scripts
              apt-get -y install zabbix-agent
              apt-get -y install mariadb-server

            # Crear la base de datos
              echo ""
              echo "    Creando la base de datos..."
              echo ""
              mysql -e "create database zabbix character set utf8mb4 collate utf8mb4_bin"
              mysql -e "create user zabbix@localhost identified by 'Pass123'"
              mysql -e "grant all privileges on zabbix.* to zabbix@localhost"
              mysql -e "set global log_bin_trust_function_creators = 1"

            # Importando el esquema y los datos iniciales
              # Comprobar si el paquete gzip está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s gzip 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}    El paquete gzip no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  apt-get -y update
                  apt-get -y install gzip
                  echo ""
                fi
              zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -pPass123 zabbix
              # Deshabilitar log_bin_trust_function_creators
                mysql -e "set global log_bin_trust_function_creators = 0"
 
            # Indicar el password de la base de datos en el archivo de configuración
              sed -i -e 's|DBPassword=.*|\nDBPassword=Pass123|g' /etc/zabbix/zabbix_server.conf

            # Modificar conf de nginx
              sed -i -e 's|8080;|\n  listen 8080;|g'                     /etc/zabbix/nginx.conf
              sed -i -e 's|example.com;|\n  server_name example.com; |g' /etc/zabbix/nginx.conf
              sed -i -e 's|^#.*||g'                                      /etc/zabbix/nginx.conf

            # Asegurarse que la configuración locale del Debian sea la correcta
              echo "es_ES.UTF-8 UTF-8"  > /etc/locale.gen
              echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
              apt-get -y update && apt-get -y install locales
              locale-gen --purge es_ES.UTF-8 en_US.UTF-8
              # Cambiar de false a true la línea que tenga como idioma es_ES
                sed -i -e '/es_ES/s/false/true/g' /usr/share/zabbix/include/locales.inc.php

            # Desinstalar apache2, por si está instalado
              apt-get -y autoremove apache2
              apt-get -y purge apache2

            # Quitar el sitio por defecto de nginx
              unlink /etc/nginx/sites-enabled/default

            # Iniciar el servidor y el agente
              systemctl restart zabbix-server
              systemctl restart zabbix-agent
              systemctl restart nginx
              systemctl restart php7.4-fpm
              systemctl enable zabbix-server --now
              systemctl enable zabbix-agent  --now
              systemctl enable nginx         --now
              systemctl enable php7.4-fpm    --now

            # Mostrar mensaje de fin
              vIPHostZabbix=$(hostname -I | sed 's- --g')
              echo ""
              echo "  Instalación de Zabbix LTS con servidor Web apache2 y base de datos MySQL, finalizada."
              echo ""
              echo "    Para conectarte a la web del servidor accede a la siguiente URL:"
              echo "      http://$vIPHostZabbix:8080"
              echo ""
              echo "      El usuario por defecto es Admin y la contraseña zabbix."
              echo ""

          ;;

          3)

            echo ""
            echo "  Instalando Zabbix (última versión) con base de datos MariaDB y servidor web apache2..."
            echo ""

            echo ""
            echo -e "${cColorRojo}    Comandos todavía no preparados...${cFinColor}"
            echo ""

          ;;

          4)

            echo ""
            echo "  Instalando Zabbix (última versión) con base de datos MariaDB y servidor web nginx..."
            echo ""

            echo ""
            echo -e "${cColorRojo}    Comandos todavía no preparados...${cFinColor}"
            echo ""

          ;;

      esac

  done

fi

