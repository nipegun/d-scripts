#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para agregar una impresora a Nagios
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios-Agregar-Host-Impresora.sh | bash -s URL Servicio
#
#  Ejemplo:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios-Agregar-Host-Impresora.sh | bash -s midebianserver "Mi servidor Debian" "192.168.0.123"
# ----------

NombreDelHost=$1
AliasDelHost=$2
IPDelHost=$3

mkdir -p /etc/nagios4/printers/ 2> /dev/null

echo "define host {"                                             > /etc/nagios4/printers/$NombreDelHost.cfg
echo "  use             generic-printer"                        >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  host_name       $NombreDelHost"                         >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  alias           $AliasDelHost"                          >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  address         $IPDelHost"                             >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  icon_image      debian.jpg"                             >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  icon_image_alt  Linux"                                  >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  vrml_image      debian.png"                             >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  statusmap_image debian.gd2"                             >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/printers/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "define service {"                                         >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  use                 generic-service"                    >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  service_description PING"                               >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  check_command       check_ping!100.0,20%!500.0,60%"     >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/printers/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "define service {"                                         >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  use                 generic-service"                    >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  service_description SSH"                                >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  check_command       check_ssh"                          >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/printers/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "define service{"                                          >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  use                 generic-service"                    >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  service_description Procesador"                         >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  check_command       comprobar_nrpe!check_load"          >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/printers/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "define service{"                                          >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  use                 generic-service"                    >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  service_description Disco"                              >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  check_command       comprobar_nrpe!check_disk"          >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/printers/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "define service{"                                          >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  use                 generic-service"                    >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  service_description Procesos"                           >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  check_command       comprobar_nrpe!check_total_procs"   >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/printers/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "define service{"                                          >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  use                 generic-service"                    >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  service_description Usuarios"                           >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "  check_command       comprobar_nrpe!check_users"         >> /etc/nagios4/printers/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/printers/$NombreDelHost.cfg

chown nagios:nagios /etc/nagios4/printers/$NombreDelHost.cfg
chmod 664 /etc/nagios4/printers/$NombreDelHost.cfg

sed -i -e "s-$NombreDelHost-$IPDelHost-g" /etc/nagios4/printers/$NombreDelHost.cfg

systemctl restart nagios4

echo ""
echo "  Impresora agregada."
echo "  Si la monitorización no funciona comprueba que:"
echo ""

