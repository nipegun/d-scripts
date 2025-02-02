#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Nagios Core en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/MonRed-Nagios-InstalarYConfigurar.sh | bash
# ----------

NagiosAdmin="nagiosadmin"

ColorAzul="\033[0;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

# Determinar la versión de Debian

  if [ -f /etc/os-release ]; then
    # Para systemd y freedesktop.org
      . /etc/os-release
      cNomSO=$NAME
      cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
      cNomSO=$(lsb_release -si)
      cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then
    # Para algunas versiones de Debian sin el comando lsb_release
      . /etc/lsb-release
      cNomSO=$DISTRIB_ID
      cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then
    # Para versiones viejas de Debian.
      cNomSO=Debian
      cVerSO=$(cat /etc/debian_version)
  else
    # Para el viejo uname (También funciona para BSD)
      cNomSO=$(uname -s)
      cVerSO=$(uname -r)
  fi


if [ $cVerSO == "7" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de Nagios Core para Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de Nagios Core para Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Nagios Core para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Nagios Core para Debian 10 (Buster)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Nagios Core para Debian 11 (Bullseye)..."  
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  dialog no está instalado. Iniciando su instalación...${cFinColor}"
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
            echo -e "${ColorAzul}  Instalando Nagios4 desde los repos de Debian...${cFinColor}"
            echo ""

            echo -e "${ColorAzul}    Determinando la versión disponible en los repos...${cFinColor}"
            echo ""
            PaqueteEnRepos=$(apt-cache search nagios | grep ^nagios | grep core | cut -d'-' -f1)
            UltVersiRepos=$(apt-cache show $PaqueteEnRepos | grep ersion | cut -d':' -f2 | sed 's- --g')
            echo -e "${ColorAzul}      La última versión disponible en los repos de debian es la $UltVersiRepos...${cFinColor}"

            echo ""
            echo -e "${ColorAzul}    Instalando el paquete $PaqueteEnRepos...${cFinColor}"
            echo ""
            apt-get -y install $PaqueteEnRepos
            apt-get -y install nagios-images

            echo ""
            echo "  Instalando nagvis..."
            echo ""
            apt-get -y install nagvis
            apt-get -y install nagvis-demos

            echo ""
            echo "  Agregando el archivo de comandos personalizados..."
            echo ""
            touch /etc/nagios4/objects/comandospers.cfg
            sed -i -e 's|cfg_file=/etc/nagios4/objects/templates.cfg|cfg_file=/etc/nagios4/objects/templates.cfg\n\ncfg_file=/etc/nagios4/objects/comandospers.cfg|g' /etc/nagios4/nagios.cfg
            echo 'define command {'                                                                      > /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_dhcp'                                                       >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_dhcp -s $HOSTADDRESS$'                                   >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_disk'                                                       >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_disk -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$ -p $ARG3$'     >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_ftp'                                                        >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_ftp -H $HOSTADDRESS$ $ARG1$'                             >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check-host-alive'                                                 >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_ping -H $HOSTADDRESS$ -w 3000.0,80% -c 5000.0,100% -p 5' >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_http'                                                       >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_http -I $HOSTADDRESS$ $ARG1$'                            >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_imap'                                                       >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_imap -H $HOSTADDRESS$ $ARG1$'                            >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_load'                                                       >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_load -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$'               >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_nrpe'                                                       >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -t 30 -c $ARG1$ $ARG2$'            >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_nrpe_version'                                               >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_nrpe -H $HOSTADDRESS$'                                   >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_nt'                                                         >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_nt -H $HOSTADDRESS$ -p 12489 -v $ARG1$ $ARG2$'           >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_ping'                                                       >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_ping -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$ -p 5'          >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_pop'                                                        >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_pop -H $HOSTADDRESS$ $ARG1$'                             >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_procs'                                                      >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_procs -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$ -s $ARG3$'    >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_smtp'                                                       >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_smtp -H $HOSTADDRESS$ $ARG1$'                            >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_snmp'                                                       >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_snmp -H $HOSTADDRESS$ $ARG1$'                            >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_ssh'                                                        >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_ssh -H $HOSTADDRESS$ $ARG1$'                             >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_swap'                                                       >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_swap -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$'               >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_tcp'                                                        >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_tcp -H $HOSTADDRESS$ -p $ARG1$ $ARG2$'                   >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_udp'                                                        >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_udp -H $HOSTADDRESS$ -p $ARG1$ $ARG2$'                   >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg
            echo ''                                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo 'define command {'                                                                     >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_name pers_check_users'                                                      >> /etc/nagios4/objects/comandospers.cfg
            echo '  command_line $USER1$/check_users -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$'              >> /etc/nagios4/objects/comandospers.cfg
            echo '}'                                                                                    >> /etc/nagios4/objects/comandospers.cfg

            echo ""
            echo -e "${ColorAzul}    Instalando plugins...${cFinColor}"
            echo ""
            apt-get -y install nagios-nrpe-plugin
            apt-get -y install monitoring-plugins
            apt-get -y install monitoring-plugins-contrib
            apt-get -y install nagios-check-xmppng
            apt-get -y install nagios-snmp-plugins
            apt-get -y install nagios-plugins-rabbitmq
            apt-get -y install tang-nagios
            apt-get -y install nordugrid-arc-nagios-plugins
            apt-get -y install monitoring-plugins-btrfs

            echo ""
            echo -e "${ColorAzul}    Activando el servicio $PaqueteEnRepos...${cFinColor}"
            echo ""
            systemctl enable $PaqueteEnRepos --now

            echo ""
            echo -e "${ColorAzul}    Activando módulos de apache...${cFinColor}"
            echo ""
            a2enmod rewrite
            a2enmod cgi

            echo ""
            echo -e "${ColorAzul}    Activando autenticación...${cFinColor}"
            echo ""
            a2enmod auth_digest
            a2enmod authz_groupfile
            htdigest -c /etc/nagios4/htdigest.users "Restricted Nagios4 Access" $NagiosAdmin

            echo ""
            echo -e "${ColorAzul}    Cambiando los permisos del binario de ping para que no de errores...${cFinColor}"
            echo ""
            chmod u+s /bin/ping

            echo ""
            echo -e "${ColorAzul}    Reiniciando apache...${cFinColor}"
            echo ""
            systemctl restart apache2

            echo ""
            echo -e "${ColorAzul}    Reiniciando el servicio $PaqueteEnRepos...${cFinColor}"
            echo ""
            systemctl restart $PaqueteEnRepos

            echo ""
            echo -e "${cColorVerde}  $PaqueteEnRepos instalado desde los repos de Debian.${cFinColor}"
            echo -e "${cColorVerde}  Accede $(hostname -I | sed 's- --g')/$PaqueteEnRepos para conectarte.${cFinColor}"
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
            echo -e "${ColorAzul}  Iniciando la instalación de Nagios XI desde el script oficial...${cFinColor}"
            echo ""

            # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}    curl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update
                apt-get -y install curl
                echo ""
              fi

            curl -sL https://assets.nagios.com/downloads/nagiosxi/install.sh | sh
          ;;

          3)
            echo ""
            echo -e "${ColorAzul}  Iniciando la instalación de Nagios Core desde la web oficial...${cFinColor}"
            echo ""

            echo ""
            echo -e "${ColorAzul}    Determinando la última versión disponible en la web oficial...${cFinColor}"
            echo ""
            # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}      curl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update
                apt-get -y install curl
                echo ""
              fi
            UltVersNagiosCoreWeb=$(curl -sL https://www.nagios.org/downloads/nagios-core/thanks/?product_download=nagioscore | sed 's->->\n-g' | grep releases | grep "tar.gz" | head -n1 | cut -d'"' -f2 | sed 's-.tar.gz--g' | cut -d'-' -f2)
            echo -e "${ColorAzul}      La última versión según la web oficial es la $UltVersNagiosCoreWeb.${cFinColor}"

            echo ""
            echo -e "${ColorAzul}    Descargando archivo de la última versión...${cFinColor}"
            echo ""
            ArchUltVersNagiosCoreWeb=$(curl -sL https://www.nagios.org/downloads/nagios-core/thanks/?product_download=nagioscore | sed 's->->\n-g' | grep releases | grep "tar.gz" | head -n1 | cut -d'"' -f2)
            mkdir -p /root/SoftInst/NagiosCore/
            rm -rf /root/SoftInst/NagiosCore/*
            curl --silent $ArchUltVersNagiosCoreWeb --output /root/SoftInst/NagiosCore/nagiosweb.tar.gz

            echo ""
            echo -e "${ColorAzul}    Descomprimiendo archivo descargado...${cFinColor}"
            echo ""
            # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}    tar no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update
                apt-get -y install tar
                echo ""
              fi
            tar -x -f /root/SoftInst/NagiosCore/nagiosweb.tar.gz -C /root/SoftInst/NagiosCore/

            echo ""
            echo -e "${ColorAzul}    Instalando paquetes necesarios...${cFinColor}"
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
            echo -e "${ColorAzul}    Compilando...${cFinColor}"
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
            echo -e "${ColorAzul}    Creando la cuenta en apache para poder loguearse en nagios...${cFinColor}"
            echo ""
            htpasswd -c             /usr/local/nagios/etc/htpasswd.users $NagiosAdmin
            chown www-data:www-data /usr/local/nagios/etc/htpasswd.users
            chmod 640               /usr/local/nagios/etc/htpasswd.users

            echo ""
            echo -e "${ColorAzul}    Re-arrancando el servicio de Apache...${cFinColor}"
            echo ""
            systemctl restart apache2.service

            echo ""
            echo -e "${ColorAzul}  Activando el servicio de Nagios...${cFinColor}"
            echo ""
            systemctl enable nagios.service --now

            # Crear el archivo para abrir midnight commander
              mkdir -p /root/scripts 2> /dev/null
              echo '#!/bin/bash'                                     > /root/scripts/MidnightCommander.sh
              echo "mc /usr/local/nagios/ /usr/lib/nagios/plugins/" >> /root/scripts/MidnightCommander.sh
              chmod +x                                                 /root/scripts/MidnightCommander.sh

            echo ""
            echo -e "${ColorAzul}  Arrancando el servicio de Nagios...${cFinColor}"
            echo ""
            systemctl start nagios.service
            systemctl stop nagios.service
            systemctl restart nagios.service
            # systemctl status nagios.service

          ;;

          4)
            echo ""
            echo -e "${ColorAzul}  Iniciando la instalación de Nagios Core desde la web de GitHub...${cFinColor}"
            echo ""

            echo ""
            echo -e "${ColorAzul}  Determinando la última versión según la web de GitHub...${cFinColor}"
            echo ""
            # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}  curl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update
                apt-get -y install curl
                echo ""
              fi
            UltVersNagiosCoreGitHub=$(curl -sL https://github.com/NagiosEnterprises/nagioscore/releases/ | grep href | grep "tar.gz" | head -n1 | cut -d'"' -f2 | sed 's-.tar.gz--g' | cut -d'-' -f3)
            echo -e "${ColorAzul}    La última versión según la web de GitHub es la $UltVersNagiosCoreGitHub.${cFinColor}"

            echo ""
            echo -e "${ColorAzul}  Descargando archivo de la última versión...${cFinColor}"
            echo ""
            ArchUltVersNagiosCoreGitHub=$(curl -sL https://github.com/NagiosEnterprises/nagioscore/releases/ | grep href | grep "tar.gz" | head -n1 | cut -d'"' -f2)
            mkdir -p /root/SoftInst/NagiosCore/
            rm -rf /root/SoftInst/NagiosCore/*
            # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}  wget no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update
                apt-get -y install wget
                echo ""
              fi
            wget https://github.com$ArchUltVersNagiosCoreGitHub -O /root/SoftInst/NagiosCore/nagiosgithub.tar.gz

            echo ""
            echo -e "${ColorAzul}  Descomprimiendo archivo descargado...${cFinColor}"
            echo ""
            # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}  tar no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update
                apt-get -y install tar
                echo ""
              fi
            tar -x -f /root/SoftInst/NagiosCore/nagiosgithub.tar.gz -C /root/SoftInst/NagiosCore/

            echo ""
            echo -e "${ColorAzul}  Instalando paquetes necesarios...${cFinColor}"
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
            echo -e "${ColorAzul}  Compilando...${cFinColor}"
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
            echo -e "${ColorAzul}  Creando la cuenta en apache para poder loguearse en nagios...${cFinColor}"
            echo ""
            htpasswd -c             /usr/local/nagios/etc/htpasswd.users $NagiosAdmin
            chown www-data:www-data /usr/local/nagios/etc/htpasswd.users
            chmod 640               /usr/local/nagios/etc/htpasswd.users

            echo ""
            echo -e "${ColorAzul}  Re-arrancando el servicio de Apache...${cFinColor}"
            echo ""
            systemctl restart apache2.service

            echo ""
            echo -e "${ColorAzul}  Activando el servicio de Nagios...${cFinColor}"
            echo ""
            systemctl enable nagios.service --now

            # Crear el archivo para abrir midnight commander
              mkdir -p /root/scripts 2> /dev/null
              echo '#!/bin/bash'                                     > /root/scripts/MidnightCommander.sh
              echo "mc /usr/local/nagios/ /usr/lib/nagios/plugins/" >> /root/scripts/MidnightCommander.sh
              chmod +x                                                 /root/scripts/MidnightCommander.sh

            echo ""
            echo -e "${ColorAzul}  Arrancando el servicio de nagios...${cFinColor}"
            echo ""
            systemctl start nagios.service
            systemctl stop nagios.service
            systemctl restart nagios.service
            # systemctl status nagios.service
          ;;

          5)
            echo ""
            echo -e "${ColorAzul}  Instalando plugins de Nagios...${cFinColor}"
            echo ""

            echo ""
            echo -e "${ColorAzul}    Instalando paquetes necesarios para que funcionen los plugins...${cFinColor}"
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
            echo -e "${ColorAzul}    Determinando la última versión de los plugins...${cFinColor}"
            echo ""
            UltVersPlugIns=$(curl -sL https://github.com/nagios-plugins/nagios-plugins/releases/ | grep href | grep ".tar.gz" | head -n1 | cut -d'"' -f2)

            echo ""
            echo -e "${ColorAzul}    Descargando la última versión de los plugins...${cFinColor}"
            echo ""
            ArchUltVersPlugIns=$(curl -sL https://github.com/nagios-plugins/nagios-plugins/releases/ | grep href | grep ".tar.gz" | head -n1 | cut -d'"' -f2)
            # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}    wget no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update
                apt-get -y install wget
                echo ""
              fi
            wget https://github.com$ArchUltVersPlugIns -O /root/SoftInst/NagiosCore/nagiosplugins.tar.gz
            tar -xv -f /root/SoftInst/NagiosCore/nagiosplugins.tar.gz -C /root/SoftInst/NagiosCore/

            echo ""
            echo -e "${ColorAzul}    Compilando e instalando plugins...${cFinColor}"
            echo ""
            cd /root/SoftInst/NagiosCore/nagios-plugins$UltVersPlugIns/
            ./configure --with-nagios-user=nagios --with-nagios-group=nagios
            make
            make install
            echo -e "${ColorAzul}    Plugins instalaos en /usr/local/nagios/libexec/${cFinColor}"
            echo ""

            # state_retention_file=/usr/local/nagios/var/retention.dat /usr/local/nagios/etc/nagios.cfg
            # status_file=/usr/local/nagios/var/status.dat             /usr/local/nagios/etc/nagios.cfg
            # touch /usr/local/nagios/var/retention.da
            # touch /usr/local/nagios/var/status.dat

            echo ""
            echo -e "${ColorAzul}  Re-arrancando el servicio de nagios...${cFinColor}"
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

