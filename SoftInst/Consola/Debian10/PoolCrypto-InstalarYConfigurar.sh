#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar un pool de minería de criptomonedas en Debian10
#------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

UsuarioDaemon="pooladmin"
CarpetaSoftLTC="Litecoin"
CarpetaSoftRVN="Ravencoin"
DominioPool="localhost"
VersPHP="7.3"

echo ""
echo -e "${ColorVerde}-----------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Iniciando el script de instalación de una pool de minería de criptomonedas...${FinColor}"
echo -e "${ColorVerde}-----------------------------------------------------------------------------${FinColor}"
echo ""

## Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "dialog no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install dialog
   fi

menu=(dialog --timeout 5 --checklist "Marca lo que quieras instalar:" 22 76 16)
  opciones=(1 "Crear usuario sin privilegios para ejecutar la pool (obligatorio)" on
            2 "Borrar todas las carteras y configuraciones ya existentes" off
            3 "Instalar nodo Litecoin" on
            4 "Instalar nodo Litecoin desde código fuente" off
            5 "Instalar nodo Ravencoin" on
            6 "Instalar nodo Ravencoin desde código fuente" off
            7 "Instalar MPOS" off
            8 "Reniciar el sistema" off)
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  clear

  for choice in $choices
    do
      case $choice in

        1)
          echo ""
          echo -e "${ColorVerde}  Creando el usuario para ejecutar y administrar la pool...${FinColor}"
          echo ""
          useradd -d /home/$UsuarioDaemon/ -s /bin/bash $UsuarioDaemon
        ;;

        2)
          echo ""
          echo -e "${ColorVerde}  Borrando carteras y configuraciones anteriores...${FinColor}"
          echo ""
          rm -rf /home/$UsuarioDaemon/.litecoin/
          rm -rf /home/$UsuarioDaemon/.raven/
          rm -rf /var/www/MPOS/
        ;;

        3)
          echo ""
          echo -e "${ColorVerde}  Instalando el nodo litecoin...${FinColor}"
          echo ""

          echo "Determinando la última versión de litecoin core..."
          echo ""
          ## Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo "curl no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update
              apt-get -y install curl
            fi
          UltVersLite=$(curl --silent https://litecoin.org | grep linux-gnu | grep x86_64 | grep -v in64 | cut -d '"' -f 2 | sed 2d | cut -d '-' -f 3)
          echo ""
          echo "La última versión de raven es la $UltVersLite"
          
          echo ""
          echo "Intentando descargar el archivo comprimido de la última versión..."
          echo ""
          mkdir -p /root/SoftInst/Litecoin/ 2> /dev/null
          rm -rf /root/SoftInst/Litecoin/*
          cd /root/SoftInst/Litecoin/
          ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo "wget no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update
              apt-get -y install wget
            fi
          echo "Pidiendo el archivo en formato tar.gz..."
          echo ""
          wget https://download.litecoin.org/litecoin-$UltVersLite/linux/litecoin-$UltVersLite-x86_64-linux-gnu.tar.gz
          
          echo ""
          echo "Descomprimiendo el archivo..."
          echo ""
          ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo "tar no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update
              apt-get -y install tar
            fi
          tar -xf /root/SoftInst/Litecoin/litecoin-$UltVersLite-x86_64-linux-gnu.tar.gz
          rm -rf /root/SoftInst/Litecoin/litecoin-$UltVersLite-x86_64-linux-gnu.tar.gz
          
          echo ""
          echo "Creando carpetas y archivos necesarios para ese usuario..."
          echo ""
          mkdir -p /home/$UsuarioDaemon/ 2> /dev/null
          mkdir -p /home/$UsuarioDaemon/.litecoin/
          touch /home/$UsuarioDaemon/.litecoin/raven.conf
          echo "rpcuser=user1"      > /home/$UsuarioDaemon/.litecoin/raven.conf
          echo "rpcpassword=pass1" >> /home/$UsuarioDaemon/.litecoin/raven.conf
          echo "prune=550"         >> /home/$UsuarioDaemon/.litecoin/raven.conf
          echo "daemon=1"          >> /home/$UsuarioDaemon/.litecoin/raven.conf
          rm -rf /home/$UsuarioDaemon/$CarpetaSoftLTC/
          mv /root/SoftInst/Litecoin/litecoin-$UltVersLite/ /home/$UsuarioDaemon/$CarpetaSoftLTC/
          chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ -R
          find /home/$UsuarioDaemon -type d -exec chmod 775 {} \;
          find /home/$UsuarioDaemon -type f -exec chmod 664 {} \;
          find /home/$UsuarioDaemon/$CarpetaSoftLTC/bin -type f -exec chmod +x {} \;
          ## Denegar el acceso a la carpeta a los otros usuarios del sistema
             #find /home/$UsuarioDaemon -type d -exec chmod 750 {} \;
             #find /home/$UsuarioDaemon -type f -exec chmod 664 {} \;
          echo ""
          echo "Arrancando litecoind..."
          echo ""
          su $UsuarioDaemon -c "/home/$UsuarioDaemon/$CarpetaSoftLTC/bin/litecoind -daemon"
          sleep 5
          su $UsuarioDaemon -c "/home/$UsuarioDaemon/$CarpetaSoftLTC/bin/litecoin-cli getnewaddress" > /home/$UsuarioDaemon/ltc-pooladdress.txt
          echo ""
          echo "La dirección para recibir litecoins es:"
          echo ""
          cat /home/$UsuarioDaemon/ltc-pooladdress.txt
          DirCart=$(cat /home/$UsuarioDaemon/ltc-pooladdress.txt)
          echo ""
          #echo "Información de la cartera:"
          #echo ""
          #su $UsuarioDaemon -c "/home/$UsuarioDaemon/$CarpetaSoftLTC/bin/litecoin-cli getwalletinfo"
          #echo ""
          #echo "Direcciones de recepción disponibles:"
          #echo ""
          #su $UsuarioDaemon -c "/home/$UsuarioDaemon/$CarpetaSoftLTC/bin/litecoin-cli getaddressesbylabel ''"
          #echo ""

          echo ""
          echo "Agregar litecoind a los ComandosPostArranque..."
          echo ""
          echo "su "$UsuarioDaemon" -c '/home/"$UsuarioDaemon"/"$CarpetaSoftLTC"/bin/litecoind -daemon'" >> /root/scripts/ComandosPostArranque.sh

          #echo ""
          #echo "Creando el servicio para systemd..."
          #echo ""
          #echo "[Unit]"                                                                > /etc/systemd/system/litecoind.service
          #echo "Description=Litecoin daemon"                                          >> /etc/systemd/system/litecoind.service
          #echo "After=network.target"                                                 >> /etc/systemd/system/litecoind.service
          #echo ""                                                                     >> /etc/systemd/system/litecoind.service
          #echo "[Service]"                                                            >> /etc/systemd/system/litecoind.service
          #echo "User=$UsuarioDaemon"                                                  >> /etc/systemd/system/litecoind.service
          #echo "Group=$UsuarioDaemon"                                                 >> /etc/systemd/system/litecoind.service
          #echo ""                                                                     >> /etc/systemd/system/litecoind.service
          #echo "Type=forking"                                                         >> /etc/systemd/system/litecoind.service
          #echo "PIDFile=/home/$UsuarioDaemon/litecoind-pid.txt"                       >> /etc/systemd/system/litecoind.service
          #echo "ExecStart=/home/$UsuarioDaemon/$CarpetaSoftLTC/bin/litecoind -daemon" >> /etc/systemd/system/litecoind.service
          #echo "Restart=always"                                                       >> /etc/systemd/system/litecoind.service
          #echo "PrivateTmp=true"                                                      >> /etc/systemd/system/litecoind.service
          #echo "TimeoutStopSec=60s"                                                   >> /etc/systemd/system/litecoind.service
          #echo "TimeoutStartSec=2s"                                                   >> /etc/systemd/system/litecoind.service
          #echo "StartLimitInterval=120s"                                              >> /etc/systemd/system/litecoind.service
          #echo "StartLimitBurst=5"                                                    >> /etc/systemd/system/litecoind.service
          #echo "[Install]"                                                            >> /etc/systemd/system/litecoind.service
          #echo "WantedBy=multi-user.target"                                           >> /etc/systemd/system/litecoind.service
          #touch /home/$UsuarioDaemon/litecoind-pid.txt
          #chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/litecoind-pid.txt
          #systemctl enable litecoind.service
        ;;

        4)
          echo ""
          echo -e "${ColorVerde}  Instalando el nodo litecoin desde código fuente...${FinColor}"
          echo ""
          ## Si se quiere instalar litecoin compilando
          #
          #mkdir -p ~/SoftInst/ 2> /dev/null
          #cd ~/SoftInst/
          #rm -rf ~/SoftInst/Litecoin
          #git clone git://github.com/litecoin-project/litecoin.git
          #mv ~/SoftInst/litecoin/ ~/SoftInst/Litecoin/
          #cd ~/SoftInst/Litecoin/
          #apt-get -y install autoconf
          #~/SoftInst/Litecoin/autogen.sh
          #apt-get -y install libevent-dev doxygen libzmq3-dev
          #~/SoftInst/Litecoin/configure --with-incompatible-bdb
          #make
          #make check
          #make install
        ;;

        5)
          echo ""
          echo -e "${ColorVerde}  Instalando el nodo ravencoin...${FinColor}"
          echo ""

          echo "Determinando la última versión de ravencoin core..."
          echo ""
          ## Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "curl no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install curl
             fi
          UltVersRaven=$(curl --silent https://github.com/RavenProject/Ravencoin/releases/latest | cut -d '/' -f 8 | cut -d '"' -f 1 | cut -c2-)
          echo ""
          echo "La última versión de raven es la $UltVersRaven"
          echo ""

          echo ""
          echo "Intentando descargar el archivo comprimido de la última versión..."
          echo ""
          mkdir -p /root/SoftInst/Ravencoin/ 2> /dev/null
          rm -rf /root/SoftInst/Ravencoin/*
          cd /root/SoftInst/Ravencoin/
          ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "wget no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install wget
             fi
          echo ""
          echo "  Pidiendo el archivo en formato zip..."
          echo ""
          wget https://github.com/RavenProject/Ravencoin/releases/download/v$UltVersRaven/raven-$UltVersRaven-x86_64-linux-gnu.zip
          echo ""
          echo "  Pidiendo el archivo en formato tar.gz..."
          echo ""
          wget https://github.com/RavenProject/Ravencoin/releases/download/v$UltVersRaven/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz

          echo ""
          echo "Descomprimiendo el archivo..."
          echo ""
          ## Comprobar si el paquete zip está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s zip 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "zip no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install zip
             fi
          unzip /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.zip
          mv /root/SoftInst/Ravencoin/linux/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz /root/SoftInst/Ravencoin/
          rm -rf /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.zip
          rm -rf /root/SoftInst/Ravencoin/linux/
          rm -rf /root/SoftInst/Ravencoin/__MACOSX/
          ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "tar no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install tar
             fi
          tar -xf /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz
          rm -rf /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz

          echo ""
          echo "Creando carpetas y archivos necesarios para ese usuario..."
          echo ""
          mkdir -p /home/$UsuarioDaemon/ 2> /dev/null
          mkdir -p /home/$UsuarioDaemon/.raven/
          touch /home/$UsuarioDaemon/.raven/raven.conf
          echo "rpcuser=user1"      > /home/$UsuarioDaemon/.raven/raven.conf
          echo "rpcpassword=pass1" >> /home/$UsuarioDaemon/.raven/raven.conf
          echo "prune=550"         >> /home/$UsuarioDaemon/.raven/raven.conf
          echo "daemon=1"          >> /home/$UsuarioDaemon/.raven/raven.conf
          rm -rf /home/$UsuarioDaemon/$CarpetaSoftRVN/
          mv /root/SoftInst/Ravencoin/raven-$UltVersRaven/ /home/$UsuarioDaemon/$CarpetaSoftRVN/
          chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ -R
          find /home/$UsuarioDaemon -type d -exec chmod 775 {} \;
          find /home/$UsuarioDaemon -type f -exec chmod 664 {} \;
          find /home/$UsuarioDaemon/$CarpetaSoftRVN/bin -type f -exec chmod +x {} \;
          ## Denegar el acceso a la carpeta a los otros usuarios del sistema
             #find /home/$UsuarioDaemon -type d -exec chmod 750 {} \;
             #find /home/$UsuarioDaemon -type f -exec chmod 664 {} \;

          echo ""
          echo "Arrancando ravencoind..."
          echo ""
          su $UsuarioDaemon -c /home/$UsuarioDaemon/$CarpetaSoftRVN/bin/ravend
          sleep 5
          su $UsuarioDaemon -c "/home/$UsuarioDaemon/$CarpetaSoftRVN/bin/raven-cli getnewaddress" > /home/$UsuarioDaemon/rvn-pooladdress.txt
          echo ""
          echo "La dirección para recibir ravencoins es:"
          echo ""
          cat /home/$UsuarioDaemon/rvn-pooladdress.txt
          DirCart=$(cat /home/$UsuarioDaemon/rvn-pooladdress.txt)
          echo ""
          #echo "Información de la cartera:"
          #echo ""
          #su $UsuarioDaemon -c "/home/$UsuarioDaemon/$CarpetaSoftRVN/bin/raven-cli getwalletinfo"
          #echo ""
          #echo "Direcciones de recepción disponibles:"
          #echo ""
          #su $UsuarioDaemon -c "/home/$UsuarioDaemon/$CarpetaSoftRVN/bin/raven-cli getaddressesbyaccount ''"
          #echo ""

          echo ""
          echo "Agregar litecoind a los ComandosPostArranque..."
          echo ""
          echo "su $UsuarioDaemon -c '/home/"$UsuarioDaemon"/"$CarpetaSoftRVN"/bin/ravend'" >> /root/scripts/ComandosPostArranque.sh

          #echo ""
          #echo "Creando el servicio para systemd..."
          #echo ""
          #echo "[Unit]"                                                             > /etc/systemd/system/ravend.service
          #echo "Description=Ravencoin daemon"                                      >> /etc/systemd/system/ravend.service
          #echo "After=network.target"                                              >> /etc/systemd/system/ravend.service
          #echo ""                                                                  >> /etc/systemd/system/ravend.service
          #echo "[Service]"                                                         >> /etc/systemd/system/ravend.service
          #echo "User=$UsuarioDaemon"                                               >> /etc/systemd/system/ravend.service
          #echo "Group=$UsuarioDaemon"                                              >> /etc/systemd/system/ravend.service
          #echo ""                                                                  >> /etc/systemd/system/ravend.service
          #echo "Type=forking"                                                      >> /etc/systemd/system/ravend.service
          #echo "PIDFile=/home/$UsuarioDaemon/ravend-pid.txt"                       >> /etc/systemd/system/ravend.service
          #echo "ExecStart=/home/$UsuarioDaemon/$CarpetaSoftRVN/bin/ravend -daemon -pid=/home/$UsuarioDaemon/ravend.pid.txt -conf=/home/$UsuarioDaemon/.raven/raven.conf -datadir=/var/lib/ravend -disablewallet"
          #echo "ExecStart=/home/$UsuarioDaemon/$CarpetaSoftRVN/bin/ravend -daemon" >> /etc/systemd/system/ravend.service
          #echo "Restart=always"                                                    >> /etc/systemd/system/ravend.service
          #echo "PrivateTmp=true"                                                   >> /etc/systemd/system/ravend.service
          #echo "TimeoutStopSec=60s"                                                >> /etc/systemd/system/ravend.service
          #echo "TimeoutStartSec=2s"                                                >> /etc/systemd/system/ravend.service
          #echo "StartLimitInterval=120s"                                           >> /etc/systemd/system/ravend.service
          #echo "StartLimitBurst=5"                                                 >> /etc/systemd/system/ravend.service
          #echo "[Install]"                                                         >> /etc/systemd/system/ravend.service
          #echo "WantedBy=multi-user.target"                                        >> /etc/systemd/system/ravend.service
          #touch /home/$UsuarioDaemon/ravend-pid.txt
          #chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ravend-pid.txt
          #systemctl enable ravend.service
        ;;

        6)
          echo ""
          echo -e "${ColorVerde}  Instalando el nodo ravencoin desde código fuente...${FinColor}"
          echo ""
        ;;

        7)
          echo ""
          echo -e "${ColorVerde}  Instalando la pool MPOS...${FinColor}"
          echo ""

          ## Comprobar si el paquete tasksel está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s tasksel 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "tasksel no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install tasksel
             fi

          ## Instalar servidor Web
             tasksel install web-server

          ## Instalar paquetes necesarios
             apt-get -y update
             apt-get -y install build-essential libcurl4-openssl-dev libdb5.3-dev libdb5.3++-dev mariadb-server
             apt-get -y install memcached zip
             apt-get -y install php-dom php-mbstring php-memcached php-zip
             apt-get -y install libapache2-mod-php$VersPHP
             apt-get -y install php$VersPHP-curl php$VersPHP-mysqlnd php$VersPHP-json php$VersPHP-xml 

          apache2ctl -k stop
          cd /var/www/

          ## Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "git no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install git
             fi
          git clone git://github.com/MPOS/php-mpos.git MPOS
          cd MPOS
          git checkout master
          php composer.phar install
          ## Crear el sitio web en Apache
             echo "<VirtualHost *:80>"                                  > /etc/apache2/sites-available/pool.conf
             echo ""                                                   >> /etc/apache2/sites-available/pool.conf
             echo "  #Redirect permanent / https://$DominioPool/"      >> /etc/apache2/sites-available/pool.conf
             echo ""                                                   >> /etc/apache2/sites-available/pool.conf
             echo "  ServerName $DominioPool"                          >> /etc/apache2/sites-available/pool.conf
             echo "  DocumentRoot /var/www/MPOS/public"                >> /etc/apache2/sites-available/pool.conf
             echo ""                                                   >> /etc/apache2/sites-available/pool.conf
             echo '  <Directory "/var/www/MPOS/public">'               >> /etc/apache2/sites-available/pool.conf
             echo "    Require all granted"                            >> /etc/apache2/sites-available/pool.conf
             echo "    Options FollowSymLinks"                         >> /etc/apache2/sites-available/pool.conf
             echo "    AllowOverride All"                              >> /etc/apache2/sites-available/pool.conf
             echo "  </Directory>"                                     >> /etc/apache2/sites-available/pool.conf
             echo ""                                                   >> /etc/apache2/sites-available/pool.conf
             echo "  ServerAdmin mail@gmail.com"                       >> /etc/apache2/sites-available/pool.conf
             echo ""                                                   >> /etc/apache2/sites-available/pool.conf
             echo "  ErrorLog  /var/www/MPOS/logs/error.log"           >> /etc/apache2/sites-available/pool.conf
             echo "  CustomLog /var/www/MPOS/logs/access.log combined" >> /etc/apache2/sites-available/pool.conf
             echo ""                                                   >> /etc/apache2/sites-available/pool.conf
             echo "</VirtualHost>"                                     >> /etc/apache2/sites-available/pool.conf
             touch /var/www/MPOS/logs/error.log
             touch /var/www/MPOS/logs/access.log
             a2ensite pool
             a2dissite 000-default
             a2dissite default-ssl
             service apache2 reload
             sleep 3
             service apache2 restart

          ## Permisos
             chown -Rv www-data /var/www/MPOS/templates/compile
             chown -Rv www-data /var/www/MPOS/templates/cache
             chown -Rv www-data /var/www/MPOS/logs

          ## Archivo de configuración
             cp /var/www/MPOS/include/config/global.inc.dist.php /var/www/MPOS/include/config/global.inc.php
             sed -i -e 's|$config['db']['host'] = 'localhost';|$config['db']['host'] = 'localhost';|g'                                     /var/www/MPOS/include/config/global.inc.php
             sed -i -e 's|$config['db']['user'] = 'root';|$config['db']['user'] = 'root';|g'                                               /var/www/MPOS/include/config/global.inc.php
             sed -i -e 's|$config['db']['pass'] = 'root';|$config['db']['pass'] = 'root';|g'                                               /var/www/MPOS/include/config/global.inc.php
             sed -i -e 's|$config['db']['port'] = 3306;|$config['db']['port'] = 3306;|g'                                                   /var/www/MPOS/include/config/global.inc.php
             sed -i -e 's|$config['db']['name'] = 'mpos';|$config['db']['name'] = 'mpos';|g'                                               /var/www/MPOS/include/config/global.inc.php
             sed -i -e 's|$config['wallet']['type'] = 'http';|$config['wallet']['type'] = 'http';|g'                                       /var/www/MPOS/include/config/global.inc.php
             sed -i -e 's|$config['wallet']['host'] = 'localhost:19334';|$config['wallet']['host'] = 'localhost:19334';|g'                 /var/www/MPOS/include/config/global.inc.php
             sed -i -e 's|$config['wallet']['username'] = 'testnet';|$config['wallet']['username'] = 'testnet';|g'                         /var/www/MPOS/include/config/global.inc.php
             sed -i -e 's|$config['wallet']['password'] = 'testnet';|$config['wallet']['password'] = 'testnet';|g'                         /var/www/MPOS/include/config/global.inc.php
             sed -i -e 's|$config['gettingstarted']['stratumurl'] = '';|$config['gettingstarted']['stratumurl'] = 'localhost';|g'          /var/www/MPOS/include/config/global.inc.php
             sed -i -e 's|$config['check_valid_coinaddress'] = true;|$config['check_valid_coinaddress'] = false;|g'                        /var/www/MPOS/include/config/global.inc.php
             #sed -i -e 's|$config['SALT']||g'                                        /var/www/MPOS/include/config/global.inc.php
             #sed -i -e 's|$config['SALTY']||g'                                       /var/www/MPOS/include/config/global.inc.php
             #SALT and SALTY must be a minimum of 24 characters or you will get an error message:
             #'SALT or SALTY is too short, they should be more than 24 characters and changing them will require registering a
   
             ## Servidor Stratum
   
             ## Web socket
                sed -i -e 's|from autobahn.websocket import WebSocketServerProtocol, WebSocketServerFactory|from autobahn.twisted.websocket import WebSocketServerProtocol, WebSocketServerFactory|g' /usr/local/lib/python2.7/dist-packages/stratum-0.2.13-py2.7.egg/stratum/websocket_transport.py
                apache2ctl -k start

             ## Base de datos

                ## Borrar la base de datos anterior de mpos, si es que existe
                   mysql -e "drop database if exists mpos"

                ## Borrar el usuario mpos, si es que existe
                   mysql -e "drop user if exists mpos@localhost"

                echo ""
                echo "Las bases de datos MySQL disponibles actualmente en el sistema son:"
                echo ""
                mysql -e "show databases"
                echo ""
                echo "Los usuarios MySQL disponibles actualmente en el sistema son:"
                echo ""
                mysql -e "select user,host from mysql.user"

                echo ""
                echo "Creando la base de datos mpos..."
                echo ""
                mysql -e "create database mpos"
                echo ""
                echo "Creando el usuario mpos@localhost..."
                echo ""
                mysql -e "create user mpos@localhost"
                echo ""
                echo "Dando permisos al usuario mpos para que administre la base de datos mpos..."
                echo ""
                mysql -e "grant all privileges on mpos.* to mpos@localhost identified by '$ContraBD'"
                
                echo ""
                echo "Las bases de datos MySQL disponibles actualmente en el sistema son:"
                echo ""
                mysql -e "show databases"
                echo ""
                echo "Los usuarios MySQL disponibles actualmente en el sistema son:"
                echo ""
                mysql -e "select user,host from mysql.user"

                echo ""
                echo "Importando la estructura de la base de datos..."
                echo ""
                mysql -p mpos < /var/www/MPOS/sql/000_base_structure.sql
        ;;

        8)
          echo ""
          echo -e "${ColorVerde}  Reiniciando el sistema...${FinColor}"
          echo ""
          shutdown -r now
        ;;
      esac

done

echo ""
echo -e "${ColorVerde}--------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Script de instalación de una pool de minería de criptomonedas, finalzaado.${FinColor}"
echo -e "${ColorVerde}--------------------------------------------------------------------------${FinColor}"
echo ""

