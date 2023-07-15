#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# -------------
#  Script de NiPeGun para agregar un host de Windows a Nagios para monitorear con NSClient++
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios4-Agregar-Host-Windows-nscp.sh | bash -s URL Servicio
#
#  Ejemplo:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios4-Agregar-Host-Windows-nscp.sh | bash -s miwindows "Mi máquina de Windows" "192.168.0.122"
# -------------

NombreDelHost=$1
AliasDelHost=$2
IPDelHost=$3

# cp /etc/nagios4/objects/windows.cfg /etc/nagios4/computers/$NombreDelHost.cfg

mkdir -p /etc/nagios4/computers/ 2> /dev/null

echo "define host {"                                                                         > /etc/nagios4/computers/$NombreDelHost.cfg
echo "  use             windows-server"                                                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  host_name       $NombreDelHost"                                                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  alias           $AliasDelHost"                                                      >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  address         $IPDelHost"                                                         >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  icon_image      windows.png"                                                        >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  icon_image_alt  Windows"                                                            >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  vrml_image      windows40.png"                                                      >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  statusmap_image windows40.gd2"                                                      >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "}"                                                                                    >> /etc/nagios4/computers/$NombreDelHost.cfg
echo ""                                                                                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "# Todos los hosts que usen la plantilla windows-server formarán parte de este grupo." >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "define hostgroup {"                                                                   >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  hostgroup_name  windows-servers"                                                    >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  alias           Windows Servers"                                                    >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "}"                                                                                    >> /etc/nagios4/computers/$NombreDelHost.cfg
echo ""                                                                                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "define service {"                                                                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  use                 generic-service"                                                >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                                 >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  service_description NSClient++ Version"                                             >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  check_command       check_nt!CLIENTVERSION"                                         >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "}"                                                                                    >> /etc/nagios4/computers/$NombreDelHost.cfg
echo ""                                                                                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "define service {"                                                                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  use                 generic-service"                                                >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                                 >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  service_description Uptime"                                                         >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  check_command       check_nt!UPTIME"                                                >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "}"                                                                                    >> /etc/nagios4/computers/$NombreDelHost.cfg
echo ""                                                                                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "define service {"                                                                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  use                 generic-service"                                                >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                                 >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  service_description CPU Load"                                                       >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  check_command       check_nt!CPULOAD!-l 5,80,90"                                    >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "}"                                                                                    >> /etc/nagios4/computers/$NombreDelHost.cfg
echo ""                                                                                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "define service {"                                                                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  use                 generic-service"                                                >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                                 >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  service_description Memory Usage"                                                   >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  check_command       check_nt!MEMUSE!-w 80 -c 90"                                    >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "}"                                                                                    >> /etc/nagios4/computers/$NombreDelHost.cfg
echo ""                                                                                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "define service {"                                                                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  use                 generic-service"                                                >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                                 >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  service_description C:\ Drive Space"                                                >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  check_command       check_nt!USEDDISKSPACE!-l c -w 80 -c 90"                        >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "}"                                                                                    >> /etc/nagios4/computers/$NombreDelHost.cfg
echo ""                                                                                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "define service {"                                                                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  use                 generic-service"                                                >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                                 >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  service_description W3SVC"                                                          >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  check_command       check_nt!SERVICESTATE!-d SHOWALL -l W3SVC"                      >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "}"                                                                                    >> /etc/nagios4/computers/$NombreDelHost.cfg
echo ""                                                                                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "define service {"                                                                     >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  use                 generic-service"                                                >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                                 >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  service_description Explorer"                                                       >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "  check_command       check_nt!PROCSTATE!-d SHOWALL -l Explorer.exe"                  >> /etc/nagios4/computers/$NombreDelHost.cfg
echo "}"                                                                                    >> /etc/nagios4/computers/$NombreDelHost.cfg

chown nagios:nagios /etc/nagios4/computers/$NombreDelHost.cfg
chmod 664 /etc/nagios4/computers/$NombreDelHost.cfg

systemctl restart nagios4

echo ""
echo "  Ordenador Windows agregado."
echo "  Si la monitorización no funciona comprueba en el host que existan y estén en enabled"
echo "  las siguientes líneas dal archivo c:\Archivos de programa\NSClient++\nsclient.ini"
echo ""

