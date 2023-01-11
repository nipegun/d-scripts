#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar un cluster de bases de datos MariaDB en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-Cluster-MariaDB-InstalarYConfigurar.sh | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-Cluster-MariaDB-InstalarYConfigurar.sh | bash
#
#  Ejecución remota con parámetros:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-Cluster-MariaDB-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

vIP1=$1
vIP2=$2
vIP3=$3

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}curl no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update && apt-get -y install curl
    echo ""
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
  echo -e "${vColorAzulClaro}Iniciando el script de instalación del cluster MariaDB con Galera para Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación del cluster MariaDB con Galera para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación del cluster MariaDB con Galera para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación del cluster MariaDB con Galera para Debian 10 (Buster)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación del cluster MariaDB con Galera para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  vFecha=$(date +A%YM%mD%d@%T)

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}El paquete dialog no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi

  #menu=(dialog --timeout 5 --checklist "Marca las opciones que quieras instalar:" 22 96 16)
  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Instalar el servidor MariaDB." on
      2 "Activar el cluster en el servidor 1." off
      3 "Activar el cluster en el servidor 2." off
      4 "Activar el cluster en el servidor 3" off
      5 "Activar el cluster en el servidor 2" off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  #clear

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando el servidor MariaDB..."
            echo ""
            apt-get -y update && apt-get -y install mariadb-server

          ;;

          2)

            echo ""
            echo "  Activando en cluster en el servidor 1..."
            echo ""
            # Obtener la IP local del servidor
              vIPLocal=$(hostname -I)
            # Parar el servicio antes de hacer modificaciones
              echo ""
              echo "    Parando el servicio mariadb..."
              echo ""
              systemctl stop mariadb
            # Realizar modificaciones en archivos de configuración
              echo ""
              echo "    Realizando modificaciones en archivos de configuración..."
              echo ""
              # Responder consultas en todas las IPs
                sed -i -e 's|bind-address|#bind-address|g' /etc/mysql/mariadb.conf.d/50-server.cnf
              # Modificar la configuración del cluster
                sed -i -e 's|#wsrep_on|wsrep_on|g'                                 /etc/mysql/mariadb.conf.d/60-galera.cnf
                sed -i -e 's|#wsrep_cluster_name|wsrep_cluster_name|g'             /etc/mysql/mariadb.conf.d/60-galera.cnf
                sed -i -e 's|#wsrep_cluster_address|wsrep_cluster_address|g'       /etc/mysql/mariadb.conf.d/60-galera.cnf
                sed -i -e 's|#binlog_format|binlog_format|g'                       /etc/mysql/mariadb.conf.d/60-galera.cnf
                sed -i -e 's|#default_storage_engine|default_storage_engine|g'     /etc/mysql/mariadb.conf.d/60-galera.cnf
                sed -i -e 's|#innodb_autoinc_lock_mode|innodb_autoinc_lock_mode|g' /etc/mysql/mariadb.conf.d/60-galera.cnf
                sed -i -e 's|#bind-address|bind-address|g'                         /etc/mysql/mariadb.conf.d/60-galera.cnf
                echo 'wsrep_provider = /usr/lib/galera/libgalera_smm.so'        >> /etc/mysql/mariadb.conf.d/60-galera.cnf
                echo 'wsrep_node_address="$vIPLocal"'                           >> /etc/mysql/mariadb.conf.d/60-galera.cnf
                echo 'wsrep_node_name=mariadb1'                                 >> /etc/mysql/mariadb.conf.d/60-galera.cnf
                echo 'wsrep_sst_method=rsync'                                   >> /etc/mysql/mariadb.conf.d/60-galera.cnf
            # Creando el cluster
              echo ""
              echo "    Inicializando el cluster..."
              echo ""
              galera_new_cluster
            # Consultar el estado del cluster
              echo ""
              echo "  Consultar el estado del cluster..."
              echo ""
              
            # Volver a iniciar el servicio mariadb
              echo ""
              echo "    Volviendo a iniciar el servicio mariadb..."
              echo ""
              systemctl start mariadb

          ;;

          3)

            echo ""
            echo "  Activando en cluster en el servidor 2..."
            echo ""
            systemctl stop mariadb
            sed -i -e 's|bind-address|#bind-address|g' /etc/mysql/mariadb.conf.d/50-server.cnf

          ;;

          4)

            echo ""
            echo " Activando en cluster en el servidor 3..."
            echo ""
            systemctl stop mariadb
            sed -i -e 's|bind-address|#bind-address|g' /etc/mysql/mariadb.conf.d/50-server.cnf

          ;;

          5)

            echo ""
            echo "  Opción 5..."
            echo ""

          ;;


      esac

  done

fi

