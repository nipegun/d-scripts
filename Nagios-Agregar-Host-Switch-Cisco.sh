#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para agregar un host Switch de Cisco a Nagios
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios-Agregar-Host-Switch-Cisco.sh | bash -s URL Servicio
#
#  Ejemplo:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios-Agregar-Host-Switch-Cisco.sh | bash -s miswitch "Mi switch" "192.168.0.123"
# ----------

NombreDelHost=$1
AliasDelHost=$2
IPDelHost=$3

mkdir -p /etc/nagios4/switches/ 2> /dev/null

echo "define host {"                                             > /etc/nagios4/switches/$NombreDelHost.cfg
echo "  use             generic-switch"                         >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "  host_name       $NombreDelHost"                         >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "  alias           $AliasDelHost"                          >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "  address         $IPDelHost"                             >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "  icon_image      switch40.jpg"                           >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "  icon_image_alt  Switch"                                 >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "  vrml_image      switch40.png"                           >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "  statusmap_image switch40.gd2"                           >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/switches/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "define service {"                                         >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "  use                 generic-service"                    >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "  service_description PING"                               >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "  check_command       check_ping!100.0,20%!500.0,60%"     >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/switches/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "define service {"                                         >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "  use                 generic-service"                    >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "  service_description SSH"                                >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "  check_command       check_ssh"                          >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/switches/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#define service{"                                          >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#  use                 generic-service"                    >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#  host_name           $NombreDelHost"                     >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#  service_description Procesador"                         >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#  check_command       comprobar_nrpe!check_load"          >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#}"                                                        >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#"                                                         >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#define service{"                                          >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#  use                 generic-service"                    >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#  host_name           $NombreDelHost"                     >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#  service_description Disco"                              >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#  check_command       comprobar_nrpe!check_disk"          >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#}"                                                        >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#"                                                         >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#define service{"                                          >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#  use                 generic-service"                    >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#  host_name           $NombreDelHost"                     >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#  service_description Procesos"                           >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#  check_command       comprobar_nrpe!check_total_procs"   >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#}"                                                        >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#"                                                         >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#define service{"                                          >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#  use                 generic-service"                    >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#  host_name           $NombreDelHost"                     >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#  service_description Usuarios"                           >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#  check_command       comprobar_nrpe!check_users"         >> /etc/nagios4/switches/$NombreDelHost.cfg
echo "#}"                                                        >> /etc/nagios4/switches/$NombreDelHost.cfg

chown nagios:nagios /etc/nagios4/switches/$NombreDelHost.cfg
chmod 664 /etc/nagios4/switches/$NombreDelHost.cfg

sed -i -e "s-$NombreDelHost-$IPDelHost-g" /etc/nagios4/switches/$NombreDelHost.cfg

systemctl restart nagios4

echo ""
echo "  Switch Cisco agregado."
echo "  Si la monitorización no funciona comprueba que:"
echo "    - Hayas activado SNMP en el switch."
echo "    - Hayas permitido en el router la IP del servidor nagios:"
echo ""
