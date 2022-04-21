#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para agregar un host de Windows a Nagios
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios-Agregar-Host-Debian.sh | bash -s URL Servicio
#
#  Ejemplo:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios-Agregar-Host-Debian.sh | bash -s milinux "Mi servidor Linux" "192.168.0.123"
# ----------

NombreDelHost=$1
AliasDelHost=$2
IPDelHost=$3

mkdir -p /etc/nagios4/servers/ 2> /dev/null

echo "define host {"                                                                      > /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use        linux-server"                                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name  $NombreDelHost"                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  alias      $AliasDelHost"                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  address    $IPDelHost"                                                           >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "# Todos los hosts que usen la plantilla linux-server formarán parte de este grupo" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "define hostgroup {"                                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  hostgroup_name  linux-servers"                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  alias           Linux Servers"                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "define service {"                                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                             >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                              >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description NSClient++ Version"                                          >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       check_nt!CLIENTVERSION"                                      >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "define service {"                                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                             >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                              >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Uptime"                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       check_nt!UPTIME"                                             >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

chown nagios:nagios /etc/nagios4/servers/$NombreDelHost.cfg
chmod 664 /etc/nagios4/servers/$NombreDelHost.cfg

systemctl restart nagios4

echo ""
echo "  Host agregado."
echo "  Si la monitorización no funciona comprueba que en el host esté instalado los paquetes:"
echo ""
echo "  nagios-plugins"
echo "  nagios-nrpe-server"
echo ""

