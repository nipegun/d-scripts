#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar Nagios Core en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Nagios-InstalarYConfigurar.sh | bash
#----------------------------------------------------------------------------------------------------------------------------

NagiosAdmin="nagiosadmin"

ColorAzul="\033[0;34m"
ColorVerde='\033[1;32m'
ColorRojo='\033[1;31m'
FinColor='\033[0m'

# Determinar la versión de Debian

  if [ -f /etc/os-release ]; then
    # Para systemd y freedesktop.org
      . /etc/os-release
      OS_NAME=$NAME
      OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
      OS_NAME=$(lsb_release -si)
      OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then
    # Para algunas versiones de Debian sin el comando lsb_release
      . /etc/lsb-release
      OS_NAME=$DISTRIB_ID
      OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then
    # Para versiones viejas de Debian.
      OS_NAME=Debian
      OS_VERS=$(cat /etc/debian_version)
  else
    # Para el viejo uname (También funciona para BSD)
      OS_NAME=$(uname -s)
      OS_VERS=$(uname -r)
  fi


if [ $OS_VERS == "7" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Nagios Core para Debian 7 (Wheezy)..."
  echo "-------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Nagios Core para Debian 8 (Jessie)..."
  echo "-------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Nagios Core para Debian 9 (Stretch)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Nagios Core para Debian 10 (Buster)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Nagios Core para Debian 11 (Bullseye)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${ColorRojo}  dialog no está instalado. Iniciando su instalación...${FinColor}"
      echo ""
      apt-get -y update > /dev/null
      apt-get -y install dialog
      echo ""
    fi
  menu=(dialog --timeout 5 --checklist "Instalación de Nagios" 22 76 16)
    opciones=(
      1 "Instalar Nagios4 desde los repos de Debian" off
      2 "Instalar NagiosXI desde el script oficial" on
      3 "Instalar la última versión de Nagios Core desde la web Oficial (no terminado)" off
      4 "Instalar la última versión de Nagios Core desde GitHub (no terminado)" off
      5 "Instalar plugins (no terminado)" off
      6 "x" off
    )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
    clear

    for choice in $choices
      do
        case $choice in

          1)
            echo ""
            echo -e "${ColorAzul}  Instalando Nagios desde los repos de Debian...${FinColor}"
            echo ""

            echo -e "${ColorAzul}    Determinando la versión disponible en los repos...${FinColor}"
            echo ""
            PaqueteEnRepos=$(apt-cache search nagios | grep ^nagios | grep core | cut -d'-' -f1)
            UltVersiRepos=$(apt-cache show $PaqueteEnRepos | grep ersion | cut -d':' -f2 | sed 's- --g')
            echo -e "${ColorAzul}      La última versión disponible en los repos de debian es la $UltVersiRepos...${FinColor}"

            echo ""
            echo -e "${ColorAzul}    Instalando el paquete $PaqueteEnRepos...${FinColor}"
            echo ""
            apt-get -y install $PaqueteEnRepos

            echo ""
            echo -e "${ColorAzul}    Activando el servicio $PaqueteEnRepos...${FinColor}"
            echo ""
            systemctl enable $PaqueteEnRepos --now

            echo ""
            echo -e "${ColorAzul}    Activando módulos de apache...${FinColor}"
            echo ""
            a2enmod rewrite
            a2enmod cgi

            echo ""
            echo -e "${ColorAzul}    Activando autenticación...${FinColor}"
            echo ""
            a2enmod auth_digest
            a2enmod authz_groupfile
            htdigest -c /etc/nagios4/htdigest.users "Restricted Nagios4 Access" $NagiosAdmin

            echo ""
            echo -e "${ColorAzul}    Cambiando los permisos del binario de ping para que no de errores...${FinColor}"
            echo ""
            chmod u+s /bin/ping

            echo ""
            echo -e "${ColorAzul}    Reiniciando apache...${FinColor}"
            echo ""
            systemctl restart apache2

            echo ""
            echo -e "${ColorAzul}    Reiniciando el servicio $PaqueteEnRepos...${FinColor}"
            echo ""
            systemctl restart $PaqueteEnRepos

            echo ""
            echo -e "${ColorVerde}  $PaqueteEnRepos instalado desde los repos de Debian.${FinColor}"
            echo -e "${ColorVerde}  Accede $(hostname -I | sed 's- --g')/$PaqueteEnRepos para conectarte.${FinColor}"
            echo ""

            echo ""
            
            # Impresoras
              sed -i -e 's|#cfg_dir=/etc/nagios4/printers|cfg_dir=/etc/nagios4/printers|g' /etc/nagios4/nagios.cfg
              mkdir -p            /etc/nagios4/printers/
              chmod 775           /etc/nagios4/printers/
              chown nagios:nagios /etc/nagios4/printers/
            # Routers
              sed -i -e 's|#cfg_dir=/etc/nagios4/routers|cfg_dir=/etc/nagios4/routers|g' /etc/nagios4/nagios.cfg
              mkdir -p            /etc/nagios4/routers/
              chmod 775           /etc/nagios4/routers/
              chown nagios:nagios /etc/nagios4/routers/
            # Servidores
              sed -i -e 's|#cfg_dir=/etc/nagios4/servers|cfg_dir=/etc/nagios4/servers|g' /etc/nagios4/nagios.cfg
              mkdir -p            /etc/nagios4/servers/
              chmod 775           /etc/nagios4/servers/
              chown nagios:nagios /etc/nagios4/servers/
            # Switches
              sed -i -e 's|#cfg_dir=/etc/nagios4/switches|cfg_dir=/etc/nagios4/switches|g' /etc/nagios4/nagios.cfg
              mkdir -p            /etc/nagios4/switches/
              chmod 775           /etc/nagios4/switches/
              chown nagios:nagios /etc/nagios4/switches/
            # Computers
              sed -i -e 's|cfg_dir=/etc/nagios4/routers|cfg_dir=/etc/nagios4/routers\ncfg_dir=/etc/nagios4/computers|g' /etc/nagios4/nagios.cfg
              mkdir -p            /etc/nagios4/computers/
              chmod 775           /etc/nagios4/computers/
              chown nagios:nagios /etc/nagios4/computers/

            # Crear el archivo para abrir midnight commander
              mkdir -p /root/scripts 2> /dev/null
              echo '#!/bin/bash'                                > /root/scripts/MidnightCommander.sh
              echo "mc /etc/nagios4/ /usr/lib/nagios/plugins/" >> /root/scripts/MidnightCommander.sh
              chmod +x                                            /root/scripts/MidnightCommander.sh

            echo ""
            echo "  Agregando nrpe..."
            echo ""
            apt-get -y install nagios-nrpe-plugin
            #echo ""                                                             >> /etc/nagios4/objects/commands.cfg
            #echo "define command {"                                             >> /etc/nagios4/objects/commands.cfg
            #echo "  command_name check_nrpe"                                    >> /etc/nagios4/objects/commands.cfg
            #echo '  command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$' >> /etc/nagios4/objects/commands.cfg
            #echo "}"                                                            >> /etc/nagios4/objects/commands.cfg

            echo ""
            echo "  Nagios instalado."
            echo ""
            echo "  Para ver los plugins que tienes instalados, ejecuta:"
            echo "  ls -1 /usr/lib/nagios/plugins/*"
            echo ""
            echo "  Para ver si la configuración funciona, ejecuta:"
            echo ""
            echo "/usr/sbin/nagios4 -v /etc/nagios4/nagios.cfg"
            echo ""

          ;;

          2)
            echo ""
            echo -e "${ColorAzul}  Iniciando la instalación de Nagios XI desde el script oficial...${FinColor}"
            echo ""

            # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${ColorRojo}      curl no está instalado. Iniciando su instalación...${FinColor}"
                echo ""
                apt-get -y update
                apt-get -y install curl
                echo ""
              fi

            curl -s https://assets.nagios.com/downloads/nagiosxi/install.sh | sh
          ;;

          3)
            echo ""
            echo -e "${ColorAzul}  Iniciando la instalación de Nagios Core desde la web oficial...${FinColor}"
            echo ""

            echo ""
            echo -e "${ColorAzul}    Determinando la última versión disponible en la web oficial...${FinColor}"
            echo ""
            # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${ColorRojo}      curl no está instalado. Iniciando su instalación...${FinColor}"
                echo ""
                apt-get -y update
                apt-get -y install curl
                echo ""
              fi
            UltVersNagiosCoreWeb=$(curl -s https://www.nagios.org/downloads/nagios-core/thanks/?product_download=nagioscore | sed 's->->\n-g' | grep releases | grep "tar.gz" | head -n1 | cut -d'"' -f2 | sed 's-.tar.gz--g' | cut -d'-' -f2)
            echo -e "${ColorAzul}      La última versión según la web oficial es la $UltVersNagiosCoreWeb.${FinColor}"

            echo ""
            echo -e "${ColorAzul}    Descargando archivo de la última versión...${FinColor}"
            echo ""
            ArchUltVersNagiosCoreWeb=$(curl -s https://www.nagios.org/downloads/nagios-core/thanks/?product_download=nagioscore | sed 's->->\n-g' | grep releases | grep "tar.gz" | head -n1 | cut -d'"' -f2)
            mkdir -p /root/SoftInst/NagiosCore/
            rm -rf /root/SoftInst/NagiosCore/*
            curl --silent $ArchUltVersNagiosCoreWeb --output /root/SoftInst/NagiosCore/nagiosweb.tar.gz

            echo ""
            echo -e "${ColorAzul}    Descomprimiendo archivo descargado...${FinColor}"
            echo ""
            # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${ColorRojo}    tar no está instalado. Iniciando su instalación...${FinColor}"
                echo ""
                apt-get -y update
                apt-get -y install tar
                echo ""
              fi
            tar -x -f /root/SoftInst/NagiosCore/nagiosweb.tar.gz -C /root/SoftInst/NagiosCore/

            echo ""
            echo -e "${ColorAzul}    Instalando paquetes necesarios...${FinColor}"
            echo ""
            apt-get -y update
            apt-get -y install autoconf
            apt-get -y install gcc
            apt-get -y install libc6
            apt-get -y install make
            apt-get -y install apache2
            apt-get -y install apache2-utils
            apt-get -y install php
            apt-get -y install libgd-dev
            apt-get -y install openssl
            apt-get -y install libssl-dev
            apt-get -y install unzip

            echo ""
            echo -e "${ColorAzul}    Compilando...${FinColor}"
            echo ""
            cd /root/SoftInst/NagiosCore/nagios-$UltVersNagiosCoreWeb/
            ./configure --with-httpd-conf=/etc/apache2/sites-enabled
            make all
            make install-groups-users
            usermod -a -G nagios www-data
            make install
            make install-daemoninit
            make install-commandmode
            make install-config
            make install-webconf
            a2enmod rewrite
            a2enmod cgi

            echo ""
            echo -e "${ColorAzul}    Creando la cuenta en apache para poder loguearse en nagios...${FinColor}"
            echo ""
            htpasswd -c             /usr/local/nagios/etc/htpasswd.users $NagiosAdmin
            chown www-data:www-data /usr/local/nagios/etc/htpasswd.users
            chmod 640               /usr/local/nagios/etc/htpasswd.users

            echo ""
            echo -e "${ColorAzul}    Re-arrancando el servicio de Apache...${FinColor}"
            echo ""
            systemctl restart apache2.service

            echo ""
            echo -e "${ColorAzul}  Activando el servicio de Nagios...${FinColor}"
            echo ""
            systemctl enable nagios.service --now

            # Crear el archivo para abrir midnight commander
              mkdir -p /root/scripts 2> /dev/null
              echo '#!/bin/bash'                                     > /root/scripts/MidnightCommander.sh
              echo "mc /usr/local/nagios/ /usr/lib/nagios/plugins/" >> /root/scripts/MidnightCommander.sh
              chmod +x                                                 /root/scripts/MidnightCommander.sh

            echo ""
            echo -e "${ColorAzul}  Arrancando el servicio de Nagios...${FinColor}"
            echo ""
            systemctl start nagios.service
            systemctl stop nagios.service
            systemctl restart nagios.service
            # systemctl status nagios.service

          ;;

          4)
            echo ""
            echo -e "${ColorAzul}  Iniciando la instalación de Nagios Core desde la web de GitHub...${FinColor}"
            echo ""

            echo ""
            echo -e "${ColorAzul}  Determinando la última versión según la web de GitHub...${FinColor}"
            echo ""
            # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${ColorRojo}  curl no está instalado. Iniciando su instalación...${FinColor}"
                echo ""
                apt-get -y update
                apt-get -y install curl
                echo ""
              fi
            UltVersNagiosCoreGitHub=$(curl -s https://github.com/NagiosEnterprises/nagioscore/releases/ | grep href | grep "tar.gz" | head -n1 | cut -d'"' -f2 | sed 's-.tar.gz--g' | cut -d'-' -f3)
            echo -e "${ColorAzul}    La última versión según la web de GitHub es la $UltVersNagiosCoreGitHub.${FinColor}"

            echo ""
            echo -e "${ColorAzul}  Descargando archivo de la última versión...${FinColor}"
            echo ""
            ArchUltVersNagiosCoreGitHub=$(curl -s https://github.com/NagiosEnterprises/nagioscore/releases/ | grep href | grep "tar.gz" | head -n1 | cut -d'"' -f2)
            mkdir -p /root/SoftInst/NagiosCore/
            rm -rf /root/SoftInst/NagiosCore/*
            # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${ColorRojo}  wget no está instalado. Iniciando su instalación...${FinColor}"
                echo ""
                apt-get -y update
                apt-get -y install wget
                echo ""
              fi
            wget https://github.com$ArchUltVersNagiosCoreGitHub -O /root/SoftInst/NagiosCore/nagiosgithub.tar.gz

            echo ""
            echo -e "${ColorAzul}  Descomprimiendo archivo descargado...${FinColor}"
            echo ""
            # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${ColorRojo}  tar no está instalado. Iniciando su instalación...${FinColor}"
                echo ""
                apt-get -y update
                apt-get -y install tar
                echo ""
              fi
            tar -x -f /root/SoftInst/NagiosCore/nagiosgithub.tar.gz -C /root/SoftInst/NagiosCore/

            echo ""
            echo -e "${ColorAzul}  Instalando paquetes necesarios...${FinColor}"
            echo ""
            apt-get -y update
            apt-get -y install autoconf
            apt-get -y install gcc
            apt-get -y install libc6
            apt-get -y install make
            apt-get -y install apache2
            apt-get -y install apache2-utils
            apt-get -y install php
            apt-get -y install libgd-dev
            apt-get -y install openssl
            apt-get -y install libssl-dev
            apt-get -y install unzip

            echo ""
            echo -e "${ColorAzul}  Compilando...${FinColor}"
            echo ""
            cd /root/SoftInst/NagiosCore/nagios-$UltVersNagiosCoreGitHub/
            ./configure --with-httpd-conf=/etc/apache2/sites-enabled
            make all
            make install-groups-users
            usermod -a -G nagios www-data
            make install
            make install-daemoninit
            make install-commandmode
            make install-config
            make install-webconf
            a2enmod rewrite
            a2enmod cgi

            echo ""
            echo -e "${ColorAzul}  Creando la cuenta en apache para poder loguearse en nagios...${FinColor}"
            echo ""
            htpasswd -c             /usr/local/nagios/etc/htpasswd.users $NagiosAdmin
            chown www-data:www-data /usr/local/nagios/etc/htpasswd.users
            chmod 640               /usr/local/nagios/etc/htpasswd.users

            echo ""
            echo -e "${ColorAzul}  Re-arrancando el servicio de Apache...${FinColor}"
            echo ""
            systemctl restart apache2.service

            echo ""
            echo -e "${ColorAzul}  Activando el servicio de Nagios...${FinColor}"
            echo ""
            systemctl enable nagios.service --now

            # Crear el archivo para abrir midnight commander
              mkdir -p /root/scripts 2> /dev/null
              echo '#!/bin/bash'                                     > /root/scripts/MidnightCommander.sh
              echo "mc /usr/local/nagios/ /usr/lib/nagios/plugins/" >> /root/scripts/MidnightCommander.sh
              chmod +x                                                 /root/scripts/MidnightCommander.sh

            echo ""
            echo -e "${ColorAzul}  Arrancando el servicio de nagios...${FinColor}"
            echo ""
            systemctl start nagios.service
            systemctl stop nagios.service
            systemctl restart nagios.service
            # systemctl status nagios.service
          ;;

          5)
            echo ""
            echo -e "${ColorAzul}  Instalando plugins de Nagios...${FinColor}"
            echo ""

            echo ""
            echo -e "${ColorAzul}    Instalando paquetes necesarios para que funcionen los plugins...${FinColor}"
            echo ""
            apt-get -y install libmcrypt-dev
            apt-get -y install bc
            apt-get -y install gawk
            apt-get -y install dc
            apt-get -y install build-essential
            apt-get -y install snmp
            apt-get -y install libnet-snmp-perl
            apt-get -y install gettext
            apt-get -y install libpqxx3-dev
            apt-get -y install libdbi-dev
            apt-get -y install libfreeradius-dev
            apt-get -y install libldap2-dev
            apt-get -y install libmariadb-dev-compat
            apt-get -y install libmariadb-dev
            apt-get -y install dnsutils
            apt-get -y install smbclient
            apt-get -y install qstat
            apt-get -y install fping
            apt-get -y install qmail-tools

            echo ""
            echo -e "${ColorAzul}    Determinando la última versión de los plugins...${FinColor}"
            echo ""
            UltVersPlugIns=$(curl -s https://github.com/nagios-plugins/nagios-plugins/releases/ | grep href | grep ".tar.gz" | head -n1 | cut -d'"' -f2)

            echo ""
            echo -e "${ColorAzul}    Descargando la última versión de los plugins...${FinColor}"
            echo ""
            ArchUltVersPlugIns=$(curl -s https://github.com/nagios-plugins/nagios-plugins/releases/ | grep href | grep ".tar.gz" | head -n1 | cut -d'"' -f2)
            # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${ColorRojo}    wget no está instalado. Iniciando su instalación...${FinColor}"
                echo ""
                apt-get -y update
                apt-get -y install wget
                echo ""
              fi
            wget https://github.com$ArchUltVersPlugIns -O /root/SoftInst/NagiosCore/nagiosplugins.tar.gz
            tar -xv -f /root/SoftInst/NagiosCore/nagiosplugins.tar.gz -C /root/SoftInst/NagiosCore/

            echo ""
            echo -e "${ColorAzul}    Compilando e instalando plugins...${FinColor}"
            echo ""
            cd /root/SoftInst/NagiosCore/nagios-plugins$UltVersPlugIns/
            ./configure --with-nagios-user=nagios --with-nagios-group=nagios
            make
            make install
            echo -e "${ColorAzul}    Plugins instalaos en /usr/local/nagios/libexec/${FinColor}"
            echo ""

            # state_retention_file=/usr/local/nagios/var/retention.dat /usr/local/nagios/etc/nagios.cfg
            # status_file=/usr/local/nagios/var/status.dat             /usr/local/nagios/etc/nagios.cfg
            # touch /usr/local/nagios/var/retention.da
            # touch /usr/local/nagios/var/status.dat

            echo ""
            echo -e "${ColorAzul}  Re-arrancando el servicio de nagios...${FinColor}"
            echo ""
            systemctl start nagios.service
            systemctl stop nagios.service
            systemctl restart nagios.service
            # systemctl status nagios.service
          ;;

          6)
            # HTML URL:  http://localhost/nagios/
            # CGI URL:  http://localhost/nagios/cgi-bin/
            # Traceroute (used by WAP):  /usr/sbin/traceroute
            # /usr/local/nagios/bin/nagios -d /usr/local/nagios/etc/nagios.cfg
            # Para comprobar que la configuración funciona
              #/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
          ;;
        
        esac
      done
fi

