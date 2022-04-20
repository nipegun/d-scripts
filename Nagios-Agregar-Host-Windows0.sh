#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para agregar un host de Windows a Nagios
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios-Agregar-Host-Windows.sh | bash -s URL Servicio
#
#  Ejemplo:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios-Agregar-Host-Windows.sh | bash -s miwindows "Mi máquina de Windows" "192.168.0.122"
#----------------------------------------------------------------------------------------------------------------------

NombreDelHost=$1
AliasDelHost=$2
IPDelHost=$3

# cp /etc/nagios4/objects/windows.cfg /etc/nagios4/servers/$NombreDelHost.cfg

echo "define host {"                                                                                        > /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use        windows-server ; Valor heredado de la plantilla"                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name  $NombreDelHost ; Nombre del host"                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  alias      $AliasDelHost  ; Nombre largo para identificar el Windows"                              >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  address    $IPDelHost     ; Dirección IP del Windows"                                              >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "# Todos los hosts que usen la plantilla windows-server formarán parte de este grupo"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "define hostgroup {"                                                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  hostgroup_name  windows-servers ; Nombre del grupo"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  alias           Windows Servers ; Nombre largo para el grupo"                                      >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "# El servicio para monitorear NSClient++ del Windows. Debe tener el mismo nombre de host que arriba" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "define service {"                                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                                               >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description NSClient++ Version"                                                            >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       check_nt!CLIENTVERSION"                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "define service {"                                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                                               >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Uptime"                                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       check_nt!UPTIME"                                                               >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "define service {"                                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                                               >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description CPU Load"                                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       check_nt!CPULOAD!-l 5,80,90"                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "define service {"                                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                                               >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Memory Usage"                                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       check_nt!MEMUSE!-w 80 -c 90"                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "define service {"                                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                                               >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description C:\ Drive Space"                                                               >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       check_nt!USEDDISKSPACE!-l c -w 80 -c 90"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "define service {"                                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                                               >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description W3SVC"                                                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       check_nt!SERVICESTATE!-d SHOWALL -l W3SVC"                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "define service {"                                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                                               >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Explorer"                                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       check_nt!PROCSTATE!-d SHOWALL -l Explorer.exe"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg

chown nagios:nagios /etc/nagios4/servers/$NombreDelHost.cfg

systemctl restart nagios4

