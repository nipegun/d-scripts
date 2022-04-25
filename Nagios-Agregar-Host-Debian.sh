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

echo "define host {"                                             > /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use             linux-server"                           >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name       $NombreDelHost"                         >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  alias           $AliasDelHost"                          >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  address         $IPDelHost"                             >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  icon_image      linux40.png"                            >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  icon_image_alt  Linux"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  vrml_image      linux40.png"                            >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  statusmap_image linux40.gd2"                            >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "define service {"                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description PING"                               >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       check_ping!100.0,20%!500.0,60%"     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "define service {"                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description SSH"                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       check_ssh"                          >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "define service{"                                          >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Carga del procesador"               >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       check_nrpe!check_load"              >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "define service{"                                          >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Uso de disco"                       >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       check_nrpe!check_disk"              >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "define service{"                                          >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Procesos totales"                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       check_nrpe!check_total_procs"       >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "define service{"                                          >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Usuarios actuales"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       check_nrpe!check_users"             >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}

chown nagios:nagios /etc/nagios4/servers/$NombreDelHost.cfg
chmod 664 /etc/nagios4/servers/$NombreDelHost.cfg

sed -i -e "s-$NombreDelHost-$IPDelHost-g" /etc/nagios4/servers/$NombreDelHost.cfg

systemctl restart nagios4

echo ""
echo "  Host agregado."
echo "  Si la monitorización no funciona comprueba que en el host esté instalado los paquetes:"
echo ""
echo "  monitoring-plugins"
echo "  nagios-nrpe-server"
echo ""
echo "  Y que has activado en ese host la IP del servidor nagios:"
echo "  sed -i -e 's/allowed_hosts=127.0.0.1,::1/allowed_hosts=127.0.0.1,::1,IpDelServidorNagios/g' /etc/nagios/nrpe.cfg"
echo "  service nagios-nrpe-server restart"
echo ""

