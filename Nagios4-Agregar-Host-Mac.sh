#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para agregar un Mac a Nagios
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios4-Agregar-Host-Mac.sh | bash -s URL Servicio
#
#  Ejemplo:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios4-Agregar-Host-Mac.sh | bash -s mimac "Mi Mac" "192.168.0.123"
# ----------

NombreDelHost=$1
AliasDelHost=$2
IPDelHost=$3

mkdir -p /etc/nagios4/computers/ 2> /dev/null

echo "define host {"                                             > /etc/nagios4/computers/$NombreDelHost.cfg
echo "  use             linux-server"                           >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  host_name       $NombreDelHost"                         >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  alias           $AliasDelHost"                          >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  address         $IPDelHost"                             >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  icon_image      mac40.jpg"                              >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  icon_image_alt  Mac"                                    >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  vrml_image      mac40.png"                              >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  statusmap_image mac40.gd2"                              >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/computers/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "define service {"                                         >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  use                 generic-service"                    >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  service_description PING"                               >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  check_command       check_ping!100.0,20%!500.0,60%"     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/computers/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "define service {"                                         >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  use                 generic-service"                    >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  service_description SSH"                                >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  check_command       check_ssh"                          >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "}"                                                        >> /etc/nagios4/computers/$NombreDelHost.cfg
echo ""                                                         >> /etc/nagios4/computers/$NombreDelHost.cfg

chown nagios:nagios /etc/nagios4/computers/$NombreDelHost.cfg
chmod 664 /etc/nagios4/computers/$NombreDelHost.cfg

sed -i -e "s-$NombreDelHost-$IPDelHost-g" /etc/nagios4/computers/$NombreDelHost.cfg

systemctl restart nagios4

echo ""
echo "  Mac agregado."
echo "  Si la monitorización no funciona comprueba que xxx:"
echo ""
echo ""
