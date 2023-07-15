#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#   Script de NiPeGun para volver a inicializar el cluster de Galera cuando no se levanta al no encontrar los otros nodos
#
#   Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/MariaDB-Cluster-Galera-ReInicializar.sh | bash
# ----------

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

echo ""
echo "  Iniciando el script para re-inicializar el clúster Galera..."
echo ""
# Obtener las direcciones IP que forman parte del cluster
  vIPsDelCluster=$(cat /etc/mysql/mariadb.conf.d/60-galera.cnf | grep gcomm | cut -d ':' -f2)
  echo ""
  echo "    Actualmente el clúster está configurado con estos nodos:"
  echo "    $vIPsDelCluster"
# Parar el servicio MariaDB
  echo ""
  echo "    Parando el servicio mariadb..."
  echo ""
  systemctl stop mariadb
# Quitar las IPs del cluster
  echo ""
  echo "    Quitando los nodos..."
  echo ""
  sed -i -e 's|^wsrep_cluster_address.*|wsrep_cluster_address = gcomm://|g' /etc/mysql/mariadb.conf.d/60-galera.cnf
# Inicializar el cluster
  echo ""
  echo "    Intentando reinicializar el clúster..."
  echo ""
  vEsSeguroInicializarlo=$(cat /var/lib/mysql/grastate.dat | grep trap | cut -d':' -f2 | sed 's- --g')
  if [[ $vEsSeguroInicializarlo == "0" ]]; then
    echo ""
    echo -e "${cColorRojo}      ATENCIÓN: Este nodo del clúster no fue el último en apagarse.${cFinColor}"
    echo -e "${cColorRojo}      Si se inicializa el clúster desde este nodo puede que se pierdan las últimas actualizaciones de la BD.${cFinColor}"
    echo ""
    sed -i -e 's|safe_to_bootstrap: 0|safe_to_bootstrap: 1|g' /var/lib/mysql/grastate.dat
    galera_new_cluster
  else
    galera_new_cluster
  fi
  
# Volver a iniciar el servicio MariaDB
  echo ""
  echo "    Volviendo a iniciar el servicio mariadb..."
  echo ""
  systemctl start mariadb
# Volver a agregar las IPs del cluster
  sed -i -e "s|^wsrep_cluster_address.*|wsrep_cluster_address = gcomm:$vIPsDelCluster|g" /etc/mysql/mariadb.conf.d/60-galera.cnf

