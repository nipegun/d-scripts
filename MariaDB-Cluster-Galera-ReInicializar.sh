#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#   Script de NiPeGun para volver a inicializar el cluster de Galera cuando no se levanta al no encontrar los otros nodos
#
#   Ejecución remota:
#   curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/MariaDB-Cluster-Galera-ReInicializar.sh | bash
# ----------

echo ""
echo "  Re-creando el cluster Galera..."
echo ""
# Obtener las direcciones IP que forman parte del cluster
  vIPsDelCluster=$(cat /etc/mysql/mariadb.conf.d/60-galera.cnf | grep gcomm | cut -d ':' -f2)
# Parar el servicio MariaDB
  systemctl stop mariadb
# Quitar las IPs del cluster
  sed -i -e 's|^wsrep_cluster_address.*|wsrep_cluster_address = gcomm://|g' /etc/mysql/mariadb.conf.d/60-galera.cnf
# Inicializar el cluster
  galera_new_cluster
# Volver a iniciar el servicio MariaDB
  systemctl start mariadb
# Volver a agregar las IPs del cluster
  sed -i -e 's|^wsrep_cluster_address.*|wsrep_cluster_address = gcomm:$vIPsDelCluster|g' /etc/mysql/mariadb.conf.d/60-galera.cnf

