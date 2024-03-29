#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# Fuente: https://learn.microsoft.com/es-es/sql/linux/quickstart-install-connect-ubuntu
# Instalación en docker: https://hub.docker.com/_/microsoft-mssql-server

# ----------
# Script de NiPeGun para instalar el servidor de bases de datos SQLServer en Debian
#
# Ejecución remota
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-SQLServer-Instalar.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD)
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor SQLServer para Debian 7 (Wheezy)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor SQLServer para Debian 8 (Jessie)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor SQLServer para Debian 9 (Stretch)..." 
echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor SQLServer para Debian 10 (Buster)..." 
echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor SQLServer para Debian 11 (Bullseye)..." 
echo ""

  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install curl
      echo ""
    fi
  # Agregar el repositorio
    curl -sL https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2022.list > /etc/apt/sources.list.d/mssql-server-2022.list
  # Agregar la llave
    # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}  El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        apt-get -y update
        apt-get -y install wget
        echo ""
      fi
    # Comprobar si el paquete gnupg2 está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s gnupg2 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}  El paquete gnupg2 no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        apt-get -y update
        apt-get -y install gnupg2
        echo ""
      fi
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
  # Instalar el paquete
    apt-get -y update
    apt-get -y install mssql-server
  # Instalar herramientas
    # Agregar repositorio
      curl -sL https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/msprod.list
    # Agregar llave
      curl -sL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
    # Actualizar
      apt-get -y update
    # Instalar paquetes
      apt-get -y install mssql-tools unixodbc-dev
    # Agregar la variable de entorno
      sh -c "echo 'export PATH=$PATH:/opt/mssql-tools/bin/' >> /root/.bash_profile"
      sh -c "echo 'export PATH=$PATH:/opt/mssql-tools/bin/' >> /root/.bashrc"
      source /root/.bashrc
  # Quitar permiso de ejecución al archivo del servicio
    chmod -x /usr/lib/systemd/system/mssql-server.service
  # Configurar
    /opt/mssql/bin/mssql-conf setup
  # Estado del servicio
    systemctl status mssql-server --no-pager
  # Notificar de fin de la instalación
    echo ""
    echo "  Instalación finalizada..."    echo ""
    echo "  Para conectarte a la CLI de SQLServer ejecuta:"
    echo ""
    echo "    sqlcmd -S localhost -U sa -P 'Contraseña'"
    echo "    o"
    echo "    sqlcmd -S localhost -U sa"
    echo ""
    echo "  ...para hacer que pida la contraseña."
    echo ""
    echo "  NOTA: sa (System Administrator) es el root."
    echo ""
    echo "  Para ver el estado del servicio, ejecuta: "
    echo "    systemctl status  mssql-server.service --no-pager"
    #sp_configure @configname = 'remote admin connections', @configvalue = 1;
    #go
    #reconfigure;
    #go

fi

