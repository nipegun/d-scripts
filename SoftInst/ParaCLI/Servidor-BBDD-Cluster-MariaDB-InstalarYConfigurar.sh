#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar un cluster de bases de datos MariaDB en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-Cluster-MariaDB-InstalarYConfigurar.sh | bash
#
# Ejecución remota sin caché:
#  curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-Cluster-MariaDB-InstalarYConfigurar.sh | bash
#
# Ejecución remota con parámetros:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-Cluster-MariaDB-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
# ----------

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

vIP1=$1
vIP2=$2
vIP3=$3
vIPHAProxy=$4

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}" >&2
    exit 1
  fi

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}curl no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update && apt-get -y install curl
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
  echo -e "${cColorAzulClaro}Iniciando el script de instalación del cluster MariaDB con Galera para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}Iniciando el script de instalación del cluster MariaDB con Galera para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}Iniciando el script de instalación del cluster MariaDB con Galera para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}Iniciando el script de instalación del cluster MariaDB con Galera para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del cluster MariaDB con Galera para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  vFecha=$(date +A%YM%mD%d@%T)

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi

  #menu=(dialog --timeout 5 --checklist "Marca las opciones que quieras instalar:" 22 96 16)
  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Activar el cluster en el nodo 1 (Ejecutar sólo en el servidor 1)." off
      2 "Activar el cluster en el nodo 2 (Ejecutar sólo en el servidor 2)." off
      3 "Activar el cluster en el nodo 3 (Ejecutar sólo en el servidor 3)." off
      4 "Instalar y configurar el nodo HAProxy (Ejecutar sólo en el nodo HAproxy)." off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  #clear

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Activando en cluster en el servidor 1..."            echo ""

            # Comprobar si el paquete mariadb-server está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s mariadb-server 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}    El paquete mariadb-server no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update
                apt-get -y install mariadb-server
                echo ""
              fi

            # Obtener la IP local del servidor
              vIPLocal=$(hostname -I)
            # Parar el servicio antes de hacer modificaciones
              echo ""
              echo "    Parando el servicio mariadb..."              echo ""
              systemctl stop mariadb
            # Securizando la instalación de MariaDB del nodo
              echo ""
              echo "    Securizando la instalación de MariaDB del nodo..."              echo ""
              mysql_secure_installation
            # Realizar modificaciones en archivos de configuración
              echo ""
              echo "    Realizando modificaciones en archivos de configuración..."              echo ""
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
                echo "wsrep_node_address=$vIPLocal"                             >> /etc/mysql/mariadb.conf.d/60-galera.cnf
                echo 'wsrep_node_name=mariadb1'                                 >> /etc/mysql/mariadb.conf.d/60-galera.cnf
                echo 'wsrep_sst_method=rsync'                                   >> /etc/mysql/mariadb.conf.d/60-galera.cnf
            # Creando el cluster
              echo ""
              echo "    Inicializando el cluster..."              echo ""
              galera_new_cluster
            # Agregar las IPs de todos los servidores que van a conformar el cluster
              sed -i -e "s|gcomm://|gcomm://$vIP1,$vIP2,$vIP3|g" /etc/mysql/mariadb.conf.d/60-galera.cnf
            # Volver a iniciar el servicio mariadb
              echo ""
              echo "    Volviendo a iniciar el servicio mariadb..."              echo ""
              systemctl start mariadb
            # Consultar el estado del cluster
              echo ""
              echo "    Consultando el estado del cluster..."              echo ""
              mysql -e "show status like 'wsrep_%';"
            # Agregar comandos a ejecutarse al inicio del servidor
              echo ""
              echo "    Agregando comandos a ejecutarse en cada inicio de Debian..."              echo ""
              echo "# Re-inicializar el cluster" >> /root/scripts/ComandosPostArranque.sh
              echo "  galera_new_cluster"        >> /root/scripts/ComandosPostArranque.sh
            # Crear usuario en la bases de datos para monitorizar con haproxy
              echo ""
              echo "    Creando el usuario para monitorizar con HAProxy..."              echo ""
              mysql -e "create user 'haproxy'@'"$vIPHAProxy"'";

          ;;

          2)

            echo ""
            echo "  Activando en cluster en el servidor 2..."            echo ""

            # Comprobar si el paquete mariadb-server está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s mariadb-server 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}    El paquete mariadb-server no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update && apt-get -y install mariadb-server
                echo ""
              fi

            # Obtener la IP local del servidor
              vIPLocal=$(hostname -I)
            # Parar el servicio antes de hacer modificaciones
              echo ""
              echo "    Parando el servicio mariadb..."              echo ""
              systemctl stop mariadb
            # Securizando la instalación de MariaDB del nodo
              #echo ""
              #echo "    Securizando la instalación de MariaDB del nodo..."              #echo ""
              #mysql_secure_installation
              # Nota: En los nodos posteriores no hace falta configurar ni usuario root ni la bases de datos.
              #       La primera vez que el nuevo nodo se conecta al cluster, copia todo del primer nodo configurado,
              #       incluido el usuario root (con su contraseña) y todas las bases de datos.
            # Realizar modificaciones en archivos de configuración
              echo ""
              echo "    Realizando modificaciones en archivos de configuración..."              echo ""
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
                echo "wsrep_node_address=$vIPLocal"                             >> /etc/mysql/mariadb.conf.d/60-galera.cnf
                echo 'wsrep_node_name=mariadb2'                                 >> /etc/mysql/mariadb.conf.d/60-galera.cnf
                echo 'wsrep_sst_method=rsync'                                   >> /etc/mysql/mariadb.conf.d/60-galera.cnf
            # Agregar las IPs de todos los servidores que van a conformar el cluster
              sed -i -e "s|gcomm://|gcomm://$vIP1,$vIP2,$vIP3|g" /etc/mysql/mariadb.conf.d/60-galera.cnf
            # Volver a iniciar el servicio mariadb
              echo ""
              echo "    Volviendo a iniciar el servicio mariadb..."              echo ""
              systemctl start mariadb
            # Consultar el estado del cluster
              echo ""
              echo "    Consultar el estado del cluster..."              echo ""
              mysql -e "show status like 'wsrep_%';"
            # Agregar el script para reiniciar el cluster en nodos secundarios.
              echo ""
              echo "    Agregar el script para reiniciar el cluster en nodos secundarios..."              echo ""
              echo "/root/scripts/d-scripts/MariaDB-Servidor-ComprobarYLevantar.sh" >> /root/scripts/ComandosPostArranque.sh
              echo "/root/scripts/d-scripts/MariaDB-Servidor-ComprobarYLevantar.sh" >> /root/scripts/TareasCronCadaMinuto.sh

          ;;

          3)

            echo ""
            echo " Activando en cluster en el servidor 3..."            echo ""

            # Comprobar si el paquete mariadb-server está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s mariadb-server 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}    El paquete mariadb-server no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update && apt-get -y install mariadb-server
                echo ""
              fi

            # Obtener la IP local del servidor
              vIPLocal=$(hostname -I)
            # Parar el servicio antes de hacer modificaciones
              echo ""
              echo "    Parando el servicio mariadb..."              echo ""
              systemctl stop mariadb
            # Securizando la instalación de MariaDB del nodo
              #echo ""
              #echo "    Securizando la instalación de MariaDB del nodo..."              #echo ""
              #mysql_secure_installation
              # Nota: En los nodos posteriores no hace falta configurar ni usuario root ni la bases de datos.
              #       La primera vez que el nuevo nodo se conecta al cluster, copia todo del primer nodo configurado,
              #       incluido el usuario root (con su contraseña) y todas las bases de datos.
            # Realizar modificaciones en archivos de configuración
              echo ""
              echo "    Realizando modificaciones en archivos de configuración..."              echo ""
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
                echo "wsrep_node_address=$vIPLocal"                             >> /etc/mysql/mariadb.conf.d/60-galera.cnf
                echo 'wsrep_node_name=mariadb3'                                 >> /etc/mysql/mariadb.conf.d/60-galera.cnf
                echo 'wsrep_sst_method=rsync'                                   >> /etc/mysql/mariadb.conf.d/60-galera.cnf
            # Agregar las IPs de todos los servidores que van a conformar el cluster
              sed -i -e "s|gcomm://|gcomm://$vIP1,$vIP2,$vIP3|g" /etc/mysql/mariadb.conf.d/60-galera.cnf
            # Volver a iniciar el servicio mariadb
              echo ""
              echo "    Volviendo a iniciar el servicio mariadb..."              echo ""
              systemctl start mariadb
            # Consultar el estado del cluster
              echo ""
              echo "  Consultar el estado del cluster..."              echo ""
              mysql -e "show status like 'wsrep_%';"
            # Agregar el script para reiniciar el cluster en nodos secundarios.
              echo ""
              echo "    Agregar el script para reiniciar el cluster en nodos secundarios..."              echo ""
              echo "/root/scripts/d-scripts/MariaDB-Servidor-ComprobarYLevantar.sh" >> /root/scripts/ComandosPostArranque.sh
              echo "/root/scripts/d-scripts/MariaDB-Servidor-ComprobarYLevantar.sh" >> /root/scripts/TareasCronCadaMinuto.sh

          ;;

          4)

            echo ""
            echo "  Instalando y configurando el nodo HAProxy..."            echo ""

            apt-get -y install haproxy
            cp  /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak
            echo ""                                       >> /etc/haproxy/haproxy.cfg
            echo "listen galera-cluster"                  >> /etc/haproxy/haproxy.cfg
            echo "bind *:3306"                            >> /etc/haproxy/haproxy.cfg
            echo "mode tcp"                               >> /etc/haproxy/haproxy.cfg
            echo "option mysql-check user haproxy"        >> /etc/haproxy/haproxy.cfg
            echo "option tcpka"                           >> /etc/haproxy/haproxy.cfg
            echo "# balance first"                        >> /etc/haproxy/haproxy.cfg
            echo "# balance roundrobin"                   >> /etc/haproxy/haproxy.cfg
            echo "balance source"                         >> /etc/haproxy/haproxy.cfg
            echo "server node1 $vIP1:3306 check weight 1" >> /etc/haproxy/haproxy.cfg
            echo "server node2 $vIP2:3306 check weight 1" >> /etc/haproxy/haproxy.cfg
            echo "server node3 $vIP3:3306 check weight 1" >> /etc/haproxy/haproxy.cfg
            systemctl reload haproxy.service
            #service haproxy reload

            # Para WordPress, en el nodo principal
              # create user 'wordpress'@'IPDeHAProxy' identified by 'P@ssw0rd';
              # grant all privileges on wordpress.* to 'wordpress'@'IPDeHaProxy';
              # create user 'otrousuario'@'IPDeHAProxy' identified by 'P@ssw0rd';
              # grant all privileges on otratabla.* to 'otrousuario'@'IPDeHaProxy';
              #
              # Todos los usuarios deben ser creados para la IP de HAProxy

          ;;

      esac

  done

fi

echo ""
echo "  Script finalizado."
echo ""
echo "  Si todo resulto correcto, recuerda permitir en cada nodo el tráfico mediante los siguientes puertos:"
echo "  3306, 4567,4568 y 4444"
echo ""

