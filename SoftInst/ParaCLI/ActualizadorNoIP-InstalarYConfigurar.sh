#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

---
# Script de NiPeGun para instalar y configurar el actualizador de NoIP en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/ActualizadorNoIP-InstalarYConfigurar.sh | bash
---

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
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

  echo "  Iniciando el script de instalación del actualizador NoIP para Debian 7 (Wheezy)..."

  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""

  echo "  Iniciando el script de instalación del actualizador NoIP para Debian 8 (Jessie)..."

  echo ""

  # Actualizar los paquetes de los repositorios
     apt-get -y update

  # Instalar los paquetes necesarios para compilar 
     apt-get -y install build-essential gcc make

  # Crear la carpeta para guardar el código
     mkdir /root/SoftInst/ 2> /dev/null

  # Posicionarse en esa carpeta y bajar allí el código fuente
     cd /root/SoftInst/
     # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  wget no está instalado. Iniciando su instalación..."
          echo ""
          apt-get -y update > /dev/null
          apt-get -y install wget
          echo ""
        fi
     wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz

  # Descomprimir el archivo con el código
     # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  tar no está instalado. Iniciando su instalación..."
          echo ""
          apt-get -y update > /dev/null
          apt-get -y install tar
          echo ""
        fi
     tar xf noip-duc-linux.tar.gz
     rm noip-duc-linux.tar.gz

  # Compilar e instalar
     Carpeta=$(ls /root/SoftInst/ | grep noip)
     cd $Carpeta
     make
     echo ""
     echo "------------------------------------------------------------------------"
     echo "  A CONTINUACIÓN SE TE PEDIRÁ EL MAIL, LA CONTRASEÑA DE SESIÓN DE NOIP"
     echo "  Y EL INTERVALO DE ACTUALIZACIÓN DE LA IP (POR DEFECTO 30 MINUTOS)"
     echo "------------------------------------------------------------------------"
     echo ""
     make install

  # Proteger los archivos de configuración
     chmod 600 /usr/local/etc/no-ip2.conf
     chown root:root /usr/local/etc/no-ip2.conf
     chmod 700 /usr/local/bin/noip2
     chown root:root /usr/local/bin/noip2

  # Lanzar la aplicación
     /usr/local/bin/noip2

  # Agregar la aplicación a los comandos post arranque
     echo "" >> /root/scripts/ComandosPostArranque.sh
     echo "# Actualizador NoIP"  >> /root/scripts/ComandosPostArranque.sh
     echo "/usr/local/bin/noip2" >> /root/scripts/ComandosPostArranque.sh

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del actualizador NoIP para Debian 9 (Stretch)..."
  echo "---------------------------------------------------------------------------------------"
  echo ""

  # Actualizar los paquetes de los repositorios
     apt-get -y update

  # Instalar los paquetes necesarios para compilar 
     apt-get -y install build-essential gcc make

  # Crear la carpeta para guardar el código
     mkdir /root/SoftInst/ 2> /dev/null

  # Posicionarse en esa carpeta y bajar allí el código fuente
     cd /root/SoftInst/
     # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  wget no está instalado. Iniciando su instalación..."
          echo ""
          apt-get -y update > /dev/null
          apt-get -y install wget
          echo ""
        fi
     wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz

  # Descomprimir el archivo con el código
     # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  tar no está instalado. Iniciando su instalación..."
          echo ""
          apt-get -y update > /dev/null
          apt-get -y install tar
          echo ""
        fi
     tar xf noip-duc-linux.tar.gz
     rm noip-duc-linux.tar.gz

  # Compilar e instalar
     Carpeta=$(ls /root/SoftInst/ | grep noip)
     cd $Carpeta
     make
     echo ""
     echo "------------------------------------------------------------------------"
     echo "  A CONTINUACIÓN SE TE PEDIRÁ EL MAIL, LA CONTRASEÑA DE SESIÓN DE NOIP"
     echo "  Y EL INTERVALO DE ACTUALIZACIÓN DE LA IP (POR DEFECTO 30 MINUTOS)"
     echo "------------------------------------------------------------------------"
     echo ""
     make install

  # Proteger los archivos de configuración
     chmod 600 /usr/local/etc/no-ip2.conf
     chown root:root /usr/local/etc/no-ip2.conf
     chmod 700 /usr/local/bin/noip2
     chown root:root /usr/local/bin/noip2

  # Lanzar la aplicación
     /usr/local/bin/noip2

  # Agregar la aplicación a los comandos post arranque
     echo "" >> /root/scripts/ComandosPostArranque.sh
     echo "# Actualizador NoIP"  >> /root/scripts/ComandosPostArranque.sh
     echo "/usr/local/bin/noip2" >> /root/scripts/ComandosPostArranque.sh

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del actualizador NoIP para Debian 10 (Buster)..."
  echo "---------------------------------------------------------------------------------------"
  echo ""

  # Actualizar los paquetes de los repositorios
     apt-get -y update

  # Instalar los paquetes necesarios para compilar 
     apt-get -y install build-essential gcc make

  # Crear la carpeta para guardar el código
     mkdir /root/SoftInst/ 2> /dev/null

  # Posicionarse en esa carpeta y bajar allí el código fuente
     cd /root/SoftInst/
     # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  wget no está instalado. Iniciando su instalación..."
          echo ""
          apt-get -y update > /dev/null
          apt-get -y install wget
          echo ""
        fi
     wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz

  # Descomprimir el archivo con el código
     # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  tar no está instalado. Iniciando su instalación..."
          echo ""
          apt-get -y update > /dev/null
          apt-get -y install tar
          echo ""
        fi
     tar xf noip-duc-linux.tar.gz
     rm noip-duc-linux.tar.gz

  # Compilar e instalar
     Carpeta=$(ls /root/SoftInst/ | grep noip)
     cd $Carpeta
     make
     echo ""
     echo "------------------------------------------------------------------------"
     echo "  A CONTINUACIÓN SE TE PEDIRÁ EL MAIL, LA CONTRASEÑA DE SESIÓN DE NOIP"
     echo "  Y EL INTERVALO DE ACTUALIZACIÓN DE LA IP (POR DEFECTO 30 MINUTOS)"
     echo "------------------------------------------------------------------------"
     echo ""
     make install

  # Proteger los archivos de configuración
     chmod 600 /usr/local/etc/no-ip2.conf
     chown root:root /usr/local/etc/no-ip2.conf
     chmod 700 /usr/local/bin/noip2
     chown root:root /usr/local/bin/noip2

  # Lanzar la aplicación
     /usr/local/bin/noip2

  # Agregar la aplicación a los comandos post arranque
     echo "" >> /root/scripts/ComandosPostArranque.sh
     echo "# Actualizador NoIP"  >> /root/scripts/ComandosPostArranque.sh
     echo "/usr/local/bin/noip2" >> /root/scripts/ComandosPostArranque.sh

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del actualizador NoIP para Debian 11 (Bullseye)..."
  echo "-----------------------------------------------------------------------------------------"
  echo ""

  # Actualizar los paquetes de los repositorios
    apt-get -y update

  # Instalar los paquetes necesarios para compilar 
    apt-get -y install build-essential gcc make

  # Crear la carpeta para guardar el código
    mkdir /root/SoftInst/ 2> /dev/null

  # Posicionarse en esa carpeta y bajar allí el código fuente
    cd /root/SoftInst/
    # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  wget no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update && apt-get -y install wget
        echo ""
      fi
    wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz

  # Descomprimir el archivo con el código
    # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  tar no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update > /dev/null
        apt-get -y install tar
        echo ""
      fi
    tar xf noip-duc-linux.tar.gz
    rm noip-duc-linux.tar.gz

  # Compilar e instalar
    Carpeta=$(ls /root/SoftInst/ | grep noip)
    cd $Carpeta
    make
    echo ""
    echo "------------------------------------------------------------------------"
    echo "  A CONTINUACIÓN SE TE PEDIRÁ EL MAIL, LA CONTRASEÑA DE SESIÓN DE NOIP"
    echo "  Y EL INTERVALO DE ACTUALIZACIÓN DE LA IP (POR DEFECTO 30 MINUTOS)"
    echo "------------------------------------------------------------------------"
    echo ""
    make install

  # Proteger los archivos de configuración
    chmod 600 /usr/local/etc/no-ip2.conf
    chown root:root /usr/local/etc/no-ip2.conf
    chmod 700 /usr/local/bin/noip2
    chown root:root /usr/local/bin/noip2

  # Lanzar la aplicación
    /usr/local/bin/noip2

  # Agregar la aplicación a los comandos post arranque
    echo "" >> /root/scripts/ComandosPostArranque.sh
    echo "# Actualizador NoIP"  >> /root/scripts/ComandosPostArranque.sh
    echo "/usr/local/bin/noip2" >> /root/scripts/ComandosPostArranque.sh

fi

