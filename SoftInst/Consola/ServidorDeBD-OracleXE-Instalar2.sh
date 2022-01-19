#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar el servidor de bases de datos de Oracle en Debian
#
# Ejecución remota
# curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/Consola/ServidorDeBD-OracleXE-Instalar.sh | bash
#-----------------------------------------------------------------------------------------------------------------------------

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
  echo -e "${ColorVerde}-------------------------------------------------------------------------------${FinColor}"
  echo -e "${ColorVerde}  Iniciando el script de instalación de OracleDB XE para Debian 7 (Wheezy)...${FinColor}"
  echo -e "${ColorVerde}-------------------------------------------------------------------------------${FinColor}"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${ColorVerde}-------------------------------------------------------------------------------${FinColor}"
  echo -e "${ColorVerde}  Iniciando el script de instalación de OracleDB XE para Debian 8 (Jessie)...${FinColor}"
  echo -e "${ColorVerde}-------------------------------------------------------------------------------${FinColor}"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${ColorVerde}--------------------------------------------------------------------------------${FinColor}"
  echo -e "${ColorVerde}  Iniciando el script de instalación de OracleDB XE para Debian 9 (Stretch)...${FinColor}"
  echo -e "${ColorVerde}--------------------------------------------------------------------------------${FinColor}"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${ColorVerde}--------------------------------------------------------------------------------${FinColor}"
  echo -e "${ColorVerde}  Iniciando el script de instalación de OracleDB XE para Debian 10 (Buster)...${FinColor}"
  echo -e "${ColorVerde}--------------------------------------------------------------------------------${FinColor}"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${ColorVerde}----------------------------------------------------------------------------------${FinColor}"
  echo -e "${ColorVerde}  Iniciando el script de instalación de OracleDB XE para Debian 11 (Bullseye)...${FinColor}"
  echo -e "${ColorVerde}----------------------------------------------------------------------------------${FinColor}"
  echo ""

  ## Determinar URL del paquete
     URLDelPaquete=$(curl -s https://www.oracle.com/database/technologies/xe-downloads.html | sed 's/>/>\n/g' | sed 's-//-\n-g' | grep .rpm | grep -v preinst | head -n1 | cut -d"'" -f1)
 
  ## Guardar archivo con número de versión
     echo $URLDelPaquete >  /tmp/versoraclexe.txt
     sed -i -e 's|xe-|\n|g' /tmp/versoraclexe.txt
     sed -i -e 's|.rpm||g'  /tmp/versoraclexe.txt
     mkdir -p /root/SoftInst/OracleDBXE/ 2> /dev/null
     touch /root/SoftInst/OracleDBXE/version.txt
     cat /tmp/versoraclexe.txt | grep x86 > /root/SoftInst/OracleDBXE/version.txt
     echo ""
     echo "  La versión que se va a descargar es la $(cat /root/SoftInst/OracleDBXE/version.txt)"
     echo ""

  ## Descargar el paquete
     echo ""
     echo "  Descargando el paquete..."
     echo ""
     cd /root/SoftInst/OracleDBXE/
     ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  wget no está instalado. Iniciando su instalación..."
          echo ""
          apt-get -y update > /dev/null
          apt-get -y install wget
          echo ""
        fi
     wget $URLDelPaquete -O oracledb-xe.rpm

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
     alien --scripts --verbose -d /root/SoftInst/OracleDBXE/oracledb-xe.rpm

  ## Agregar el grupo dba
     echo ""
     echo "  Agregando el grupo dba..."
     echo ""
     groupadd dba

  ## Agregar el usuario oracle
     echo ""
     echo "  Agregando el usuario oracle y metiéndolo en el grupo dba.."
     echo ""
     useradd -m -s /bin/bash -g dba oracle

  ## Poner contraseña al usuario oracle
     echo ""
     echo "  Estableciendo la contraseña del usuario oracle..."
     echo ""
     passwd oracle

  ## Instalar dependencias
     echo ""
     echo "  Instalando dependencias y paquetes necesarios...."
     echo ""
     apt-get -y update
     apt-get -y install libaio1
     apt-get -y install bc
     apt-get -y install net-tools
     #apt-get -y install ksh
     #apt-get -y install gawk

  ## Instalar paquete
     echo ""
     echo "  Instalando paquete .deb..."
     echo ""
     find /root/SoftInst/OracleDBXE/ -type f -name *.deb -exec dpkg -i {} \;

  ## Creando variables de entorno
      cat $ArchivoInit | grep "export ORACLE_HOME" >> /home/oracle/.bashrc
      cat $ArchivoInit | grep "export ORACLE_SID"  >> /home/oracle/.bashrc
      echo 'export PATH=$ORACLE_HOME/bin:$PATH'    >> /home/oracle/.bashrc

  ## Configurar instancia
     echo ""
     echo "  Configurando instancia..."
     echo ""
     ArchivoInit=$(find /etc/init.d/ -type f -name oracle-xe*)
     $ArchivoInit configure

  ## Informar de instalación finalizada
     echo ""
     echo "  Instalación finalizada..."
     echo ""

  ## maximum stack size limitation
     #ulimit -s 1024

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

fi

