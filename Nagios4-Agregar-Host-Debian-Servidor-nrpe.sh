#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para agregar un servidor Debian a Nagios
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios4-Agregar-Host-Debian-Servidor-nrpe.sh | bash -s URL Servicio
#
#  Ejemplo:
#  https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios4-Agregar-Host-Debian-Servidor-nrpe.sh | bash -s midebianserver "Mi servidor Debian" "192.168.0.123"
# ----------

NombreDelHost=$1
AliasDelHost=$2
IPDelHost=$3

mkdir -p /etc/nagios4/servers/ 2> /dev/null

echo "define host {"                     > /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use             linux-server"   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name       $NombreDelHost" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  alias           $AliasDelHost"  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  address         $IPDelHost"     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  icon_image      debian.jpg"     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  icon_image_alt  Linux"          >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  vrml_image      debian.png"     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  statusmap_image debian.gd2"     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

#echo "define service {"                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
#echo "  use                 generic-service"                >> /etc/nagios4/servers/$NombreDelHost.cfg
#echo "  host_name           $NombreDelHost"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
#echo "  service_description PING"                           >> /etc/nagios4/servers/$NombreDelHost.cfg
#echo "  check_command       check_ping!100.0,20%!500.0,60%" >> /etc/nagios4/servers/$NombreDelHost.cfg
#echo "}"                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
#echo ""                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg

#echo "define service {"                      >> /etc/nagios4/servers/$NombreDelHost.cfg
#echo "  use                 generic-service" >> /etc/nagios4/servers/$NombreDelHost.cfg
#echo "  host_name           $NombreDelHost"  >> /etc/nagios4/servers/$NombreDelHost.cfg
#echo "  service_description SSH"             >> /etc/nagios4/servers/$NombreDelHost.cfg
#echo "  check_command       check_ssh"       >> /etc/nagios4/servers/$NombreDelHost.cfg
#echo "}"                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
#echo ""                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Procesador"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_load" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Disco"                      >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_disk" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                               >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Swap"                                          >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_swap!-a '-w 95% -c 90%'" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Procesos"                          >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_total_procs" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"             >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"              >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Usuarios"                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_users" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                                          >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Uso de disco /"                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_disk!-a '-w 20% -c 10% -p /'" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                         >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Actualizaciones"                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_apt!-a '-U'" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description CPU"                                              >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_cpu_stats!-a '-w 85 -c 95'" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                                              >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Carga de trabajo"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_load!-a '-w 15,10,5 -c 30,20,10'" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                            >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                             >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                            >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                             >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Uso de memoria"                             >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_mem!-a '-w 20 -c 10'" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Archivos abiertos"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_open_files!-a '-w 30 -c 50'" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Cantidad de procesos"                           >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_procs!-a '-w 150 -c 250'" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                             >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                              >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Usuarios"                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_users!-a '-w 5 -c 10'" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                              >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                               >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Demonio cron"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_init_service!-a 'cron'" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Servidor Apache"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_init_service!-a 'apache2'" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Servidor Dovecot"                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_init_service!-a 'dovecot'" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""

echo "define service{"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                               >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Servicio MySQL"                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_init_service!-a 'mysql'" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                             >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                              >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Servicio SSH"                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_init_service!-a 'ssh'" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Servicio Sendmail"                                >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_init_service!-a 'sendmail'" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg

echo "define service{"                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  use                 generic-service"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  host_name           $NombreDelHost"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  service_description Daemon de log"                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "  check_command       pers_check_nrpe!check_init_service!-a 'rsyslog'" >> /etc/nagios4/servers/$NombreDelHost.cfg
echo "}"                                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
echo ""                                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

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
echo "  Para comprobar manualmente nrpe desde el servidor Nagios4, ejecuta:"
echo "  /usr/lib/nagios/plugins/check_nrpe -H IPDelHostAComprobar -c Comando"
echo ""
echo "  Si al haber agregado este host, Nagios4 no incia, comprueba que error de da la configuración, ejecutando:"
echo "  /usr/sbin/nagios4 -v /etc/nagios4/nagios.cfg"
echo ""

