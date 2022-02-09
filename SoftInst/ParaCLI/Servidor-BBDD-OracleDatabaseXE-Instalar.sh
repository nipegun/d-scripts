#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar el servidor de bases de datos de Oracle Database XE en Debian
#
#  Ejecución remota
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-OracleDatabaseXE-Instalar.sh | bash
#--------------------------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

## Determinar la versión de Debian
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
  echo -e "${ColorVerde}--------------------------------------------------------------------------------------${FinColor}"
  echo -e "${ColorVerde}  Iniciando el script de instalación de Oracle Database XE para Debian 7 (Wheezy)...${FinColor}"
  echo -e "${ColorVerde}--------------------------------------------------------------------------------------${FinColor}"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${ColorVerde}--------------------------------------------------------------------------------------${FinColor}"
  echo -e "${ColorVerde}  Iniciando el script de instalación de Oracle Database XE para Debian 8 (Jessie)...${FinColor}"
  echo -e "${ColorVerde}--------------------------------------------------------------------------------------${FinColor}"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${ColorVerde}---------------------------------------------------------------------------------------${FinColor}"
  echo -e "${ColorVerde}  Iniciando el script de instalación de Oracle Database XE para Debian 9 (Stretch)...${FinColor}"
  echo -e "${ColorVerde}---------------------------------------------------------------------------------------${FinColor}"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${ColorVerde}---------------------------------------------------------------------------------------${FinColor}"
  echo -e "${ColorVerde}  Iniciando el script de instalación de Oracle Database XE para Debian 10 (Buster)...${FinColor}"
  echo -e "${ColorVerde}---------------------------------------------------------------------------------------${FinColor}"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${ColorVerde}-----------------------------------------------------------------------------------------${FinColor}"
  echo -e "${ColorVerde}  Iniciando el script de instalación de Oracle Database XE para Debian 11 (Bullseye)...${FinColor}"
  echo -e "${ColorVerde}-----------------------------------------------------------------------------------------${FinColor}"
  echo ""

  ## Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  dialog no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update > /dev/null
       apt-get -y install dialog
       echo ""
     fi
  menu=(dialog --timeout 5 --checklist "Instalación del servidor Oracle Database XE:" 22 76 16)
    opciones=(1 "Descargar paquete" on
              2 "Convertir .rpm a .deb" on
              3 "Crear el grupo dba" on
              4 "Crear el usuario oracle y agregarlo al grupo dba" on
              5 "Instalar dependencias y paquetes necesarios" on
              6 "Instalar paquete" on
              7 "  Crear variables de entorno" on
              8 "  Crear el servicio en systemd" on
              9 "  Añadir contraseña al usuario oracle" on
             10 "  Configurar instancia" on
             11 "  Activar e iniciar el servicio" on
             12 "  Realizar cambios en el sistema -- no terminados --" on)
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      clear

      for choice in $choices
        do
          case $choice in

            1)

              ## Determinar URL del paquete
                 URLDelPaquete=$(curl -s https://www.oracle.com/database/technologies/xe-downloads.html | sed 's/>/>\n/g' | sed 's-//-\n-g' | grep .rpm | grep -v preinst | head -n1 | cut -d"'" -f1)
 
              ## Guardar archivo con número de versión
                 touch /tmp/VersOracleDatabaseXE.txt
                 echo $URLDelPaquete >  /tmp/VersOracleDatabaseXE.txt
                 sed -i -e 's|xe-|\n|g' /tmp/VersOracleDatabaseXE.txt
                 sed -i -e 's|.rpm||g'  /tmp/VersOracleDatabaseXE.txt
                 mkdir -p /root/SoftInst/Oracle/DatabaseXE/ 2> /dev/null
                 touch /root/SoftInst/Oracle/DatabaseXE/VersOracleDatabaseXE.txt
                 cat /tmp/VersOracleDatabaseXE.txt | grep x86 > /root/SoftInst/Oracle/DatabaseXE/VersOracleDatabaseXE.txt
                 echo ""
                 echo "  La versión que se va a descargar es la $(cat /root/SoftInst/Oracle/DatabaseXE/VersOracleDatabaseXE.txt)"
                 echo ""

              ## Descargar el paquete
                 echo ""
                 echo "  Descargando el paquete..."
                 echo ""
                 mkdir -p /root/SoftInst/Oracle/DatabaseXE/ 2> /dev/null
                 cd /root/SoftInst/Oracle/DatabaseXE/
                 ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo "  wget no está instalado. Iniciando su instalación..."
                      echo ""
                      apt-get -y update > /dev/null
                      apt-get -y install wget
                      echo ""
                    fi
                 wget $URLDelPaquete -O OracleDatabaseXE.rpm

            ;;

            2)

              ## Convertir el .rpm a un .deb
                 echo ""
                 echo "  Convirtiendo el paquete .rpm a .deb..."
                 echo "  El proceso puede tardar hasta una hora. Déjalo terminar."ç
                 echo ""
                 ## Comprobar si el paquete alien está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s alien 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo "  alien no está instalado. Iniciando su instalación..."
                      echo ""
                      apt-get -y update > /dev/null
                      apt-get -y install alien
                      echo ""
                    fi
                 mkdir -p /root/SoftInst/Oracle/DatabaseXE/ 2> /dev/null
                 alien --scripts --verbose -d /root/SoftInst/Oracle/DatabaseXE/OracleDatabaseXE.rpm

            ;;

            3)

              ## Crear el grupo dba
                 echo ""
                 echo "  Creando el grupo dba..."
                 echo ""
                 groupadd dba

            ;;

            4)

              ## Crear el usuario oracle y agregarlo al grupo dba
                 echo ""
                 echo "  Agregando el usuario oracle y metiéndolo en el grupo dba.."
                 echo ""
                 useradd -m -s /bin/bash -g dba oracle

            ;;

            5)

              ## Instalar dependencias y paquetes necesarios
                 echo ""
                 echo "  Instalando dependencias y paquetes necesarios...."
                 echo ""
                 apt-get -y update
                 apt-get -y install libaio1
                 apt-get -y install bc
                 apt-get -y install net-tools

            ;;

            6)

              ## Instalar paquete
                 echo ""
                 echo "  Instalando paquete .deb..."
                 echo ""
                 mkdir -p /root/SoftInst/Oracle/DatabaseXE/ 2> /dev/null
                 find /root/ -type f -name oracle*.deb -exec mv {} /root/SoftInst/Oracle/DatabaseXE/ \; 2> /dev/null
                 find /root/SoftInst/Oracle/DatabaseXE/ -type f -name *.deb -exec dpkg -i {} \;
                 touch /root/SoftInst/Oracle/DatabaseXE/UbScriptDeArranque.txt
                 find /etc/init.d/ -type f -name oracle-xe* > /root/SoftInst/Oracle/DatabaseXE/UbScriptDeArranque.txt
                 # nano /etc/sysconfig/oracle-xe-21c.conf

            ;;

            7)

              ## Crear variables de entorno
                 echo ""
                 echo "  Creando variables de entorno..."
                 echo ""
                 ArchivoInitD=$(cat /root/SoftInst/Oracle/DatabaseXE/UbScriptDeArranque.txt)
                 cat $ArchivoInitD | grep "export ORACLE_HOME" >> /home/oracle/.bashrc
                 cat $ArchivoInitD | grep "export ORACLE_SID"  >> /home/oracle/.bashrc
                 echo 'export PATH=$ORACLE_HOME/bin:$PATH'     >> /home/oracle/.bashrc

            ;;

            8)

              ## Crear el servicio en systemd
                 echo ""
                 echo "  Creando el servicio en systemd..."
                 echo ""
                 ArchivoInitD=$(cat /root/SoftInst/Oracle/DatabaseXE/UbScriptDeArranque.txt)
                 echo "[Unit]"                            > /etc/systemd/system/OracleDatabaseXE.service
                 echo "  Description=Oracle Database XE" >> /etc/systemd/system/OracleDatabaseXE.service
                 echo "[Service]"                        >> /etc/systemd/system/OracleDatabaseXE.service
                 echo "  ExecStart=$ArchivoInitD start"  >> /etc/systemd/system/OracleDatabaseXE.service
                 echo "[Install]"                        >> /etc/systemd/system/OracleDatabaseXE.service
                 echo "  WantedBy=default.target"        >> /etc/systemd/system/OracleDatabaseXE.service

            ;;

            9)

              ## Poner contraseña al usuario oracle
                 echo ""
                 echo "  Estableciendo la contraseña del usuario oracle..."
                 echo ""
                 echo -e "Oracle0\nOracle0" | passwd oracle
                 echo ""
                 echo "  Se le ha puesto la contraseña Oracle0 al usuario oracle."
                 echo ""

            ;;

            10)

              ## Configurar instancia
                 ArchivoInitD=$(cat /root/SoftInst/Oracle/DatabaseXE/UbScriptDeArranque.txt)
                 #$ArchivoInitD delete
                 echo ""
                 echo "  Configurando instancia ejecutando:"
                 echo ""
                 sed -i -e 's|127.0.1.1|127.0.0.1|g' /etc/hosts
                 sed -i -e 's|LISTENER_PORT=|LISTENER_PORT=1521|g' /etc/sysconfig/oracle-xe-21c.conf
                 echo "  $ArchivoInitD configure"
                 echo ""
                 echo -e "Oracle0\nOracle0" | $ArchivoInitD configure
                 echo ""
                 echo "  Fin de configuración de instancia."
                 echo ""
                 echo "  Recuerda que para administrar la base de datos puedes conectarte con:"
                 echo ""
                 echo "  Nombre de usuario: system"
                 echo "  Contraseña: Oracle0"
                 echo ""

            ;;

            11)

              ## Activar e iniciar el servicio
                 echo ""
                 echo "  Activando e iniciando el servicio..."
                 echo ""
                 systemctl enable OracleDatabaseXE.service --now

            ;;

            12)

              echo ""
              echo "  Servidor instalado. Para conectarte desde Oracle SQL Developer:"
              echo ""
              echo "  Nueva conexión:"
              echo "    Usuario: sys"
              echo "    Contraseña: Oracle0"
              echo "    Rol: SYSDBA"
              echo "    Nombre del servicio: XEPDB1"
              echo ""
              echo "  Y ahí ya podrás crear los usuarios que te hagan falta."
              echo ""

              ## Hacer cambios necesarios en el sistema

                ## maximum stack size limitation
                   #ulimit -s 10240

                ## values for database user deployment
                   # echo "deployment soft nofile  1024"       > /etc/security/limits.conf
                   # echo "deployment hard nofile  65536"     >> /etc/security/limits.conf
                   # echo "deployment soft nproc   16384"     >> /etc/security/limits.conf
                   # echo "deployment hard nproc   16384"     >> /etc/security/limits.conf
                   # echo "deployment soft stack   10240"     >> /etc/security/limits.conf
                   # echo "deployment hard stack   32768"     >> /etc/security/limits.conf
                   # echo "deployment hard memlock 134217728" >> /etc/security/limits.conf
                   # echo "deployment soft memlock 134217728" >> /etc/security/limits.conf

                ## .
                   #echo "session include system-auth" >> /etc/pam.d/login

                ## .
                   #echo "session required pam_limits.so" >> /etc/pam.d/system-auth    

            ;;

          esac

        done

fi

