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
  echo "------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Oracle DB Server para Debian 7 (Wheezy)..."
  echo "------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Oracle DB Server para Debian 8 (Jessie)..."
  echo "------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Oracle DB Server para Debian 9 (Stretch)..."
  echo "-------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Oracle DB Server para Debian 10 (Buster)..."
  echo "-------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Oracle DB Server para Debian 11 (Bullseye)..."
  echo "---------------------------------------------------------------------------------------"
  echo ""

  ## Instalar dependencias
     echo ""
     echo "  Instalando dependencias...."
     echo ""
     apt-get -y update
     apt-get -y install libaio1
     apt-get -y install bc
     apt-get -y install alien
     #apt-get -y install ksh
     #apt-get -y install gawk

  ## Determinar URL del paquete
     URLDelPaquete=$(curl -s https://www.oracle.com/database/technologies/xe-downloads.html | sed 's/>/>\n/g' | sed 's-//-\n-g' | grep .rpm | grep -v preinst | head -n1 | cut -d"'" -f1)
 
  ## Guardar archivo con número de versión
     echo $URLDelPaquete > /tmp/versoraclexe.txt
     sed -i -e 's|xe-|\n|g' /tmp/versoraclexe.txt
     sed -i -e 's|.rpm||g' /tmp/versoraclexe.txt
     touch /root/SoftInst/OracleXE/version.txt
     mkdir -p /root/SoftInst/OracleXE/ 2> /dev/null
     cat /tmp/versoraclexe.txt | grep x86 > /root/SoftInst/OracleXE/version.txt
     echo ""
     echo "  La versión que se va a descargar es la $(cat /root/SoftInst/OracleXE/version.txt)"
     echo ""

  ## Descargar el paquete
     echo ""
     echo "  Descargando el paquete..."
     echo ""
     cd /root/SoftInst/OracleXE/
     wget $URLDelPaquete -O oracle-xe.rpm

  ## Convertir el .rpm a un .deb
     echo ""
     echo "  Convirtiendo el paquete .rpm a .deb..."
     echo ""
     alien --scripts --verbose -d /root/SoftInst/OracleXE/oracle-xe.rpm

  ## Instalar el paquete
     echo ""
     echo "  Instalando el paquete RPM..."
     echo ""
     #alien --scripts --verbose -i /root/SoftInst/OracleXE/oracle-xe.rpm

  ## Agregar el grupo dba
     #groupadd dba

  ## Agregar el usuario
     #useradd -b -s /bin/bash -g dba oracle

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

