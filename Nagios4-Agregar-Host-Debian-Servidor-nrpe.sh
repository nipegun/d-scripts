#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para agregar un servidor Debian a Nagios
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios4-Agregar-Host-Debian-Servidor-nrpe.sh | bash -s URL Servicio
#
#  Ejemplo:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios4-Agregar-Host-Debian-Servidor-nrpe.sh | bash -s midebianserver "Mi servidor Debian" "192.168.0.123"
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Definir la cantidad de argumentos esperados
  cCantArgumEsperados=2

# Controlar que la cantidad de argumentos ingresados sea la correcta
  if [ $# -ne $cCantArgumEsperados ]
    then
      echo ""
      echo -e "${cColorRojo}  Mal uso del script. El uso correcto sería: ${cFinColor}"
      echo "    $0 [NombreDelHost] [AliasDelHost] [IPDelHost]"
      echo ""
      echo "  Ejemplo:"
      echo "    $0 'servdebian' 'servdebian' '192.168.1.10'"
      echo ""
      exit
    else

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

      echo "define service{"                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"              >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"               >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Memoria"                      >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_memory" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"              >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"               >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Antivirus Act"                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_clamav" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"              >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Antivirus Daemon"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_clamd" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Impresoras"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_cups" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"              >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"               >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Tiempo encendido"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_uptime" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                      >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Kernel"                               >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_running_kernel" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                          >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                           >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Ping a sí mismo"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_localping" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"           >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description SSH"                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_ssh" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                               >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description IMAP"                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_imap" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"           >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description POP"                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_pop" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                               >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description SMTP"                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_smtp" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"               >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Sensores"                      >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sensors" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"              >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Usuarios"                    >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_users" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"           >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Actualizaciones"           >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_apt" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                               >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Carga"                      >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_load" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                   >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                    >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Procesos totales"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_total_procs" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                          >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                    >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Procesos zombies"                   >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_zombie_procs" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                         >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Intercambio"                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_swap" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"               >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Direct /"                      >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_mp_root" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"               >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Direct /home/"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_mp_home" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"              >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"               >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Direct /var/"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_mp_var" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco IDE 1 Part 1"         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_hda1" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco IDE 1 Part 2"         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_hda2" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco IDE 1 Part 3"         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_hda3" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco IDE 1 Part 4"         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_hda4" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco IDE 2 Part 1"         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_hdb1" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco IDE 2 Part 2"         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_hdb2" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco IDE 2 Part 3"         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_hdb3" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco IDE 2 Part 4"         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_hdb4" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco IDE 3 Part 1"         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_hdc1" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco IDE 3 Part 2"         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_hdc2" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco IDE 3 Part 3"         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_hdc3" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco IDE 3 Part 4"         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_hdc4" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco IDE 4 Part 1"         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_hdd1" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco IDE 4 Part 2"         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_hdd2" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco IDE 4 Part 3"         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_hdd3" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco IDE 4 Part 4"         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_hdd4" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 1 Part 1"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sda1" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 1 Part 2"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sda2" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 1 Part 3"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sda3" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 1 Part 4"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sda4" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 2 Part 1"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sdb1" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 2 Part 2"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sdb2" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 2 Part 3"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sdb3" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 2 Part 4"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sdb4" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 3 Part 1"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sdc1" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 3 Part 2"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sdc2" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 3 Part 3"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sdc3" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 3 Part 4"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sdc4" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 4 Part 1"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sdd1" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 4 Part 2"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sdd2" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 4 Part 3"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sdd3" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 4 Part 4"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sdd4" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 5 Part 1"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sde1" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 5 Part 2"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sde2" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 5 Part 3"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sde3" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco SATA 5 Part 4"        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_sde4" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco NVMe 0 Part 1"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_nvme0n1p1" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco NVMe 0 Part 2"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_nvme0n1p2" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco NVMe 0 Part 3"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_nvme0n1p3" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco NVMe 0 Part 4"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_nvme0n1p4" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco NVMe 1 Part 1"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_nvme1n1p1" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco NVMe 1 Part 2"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_nvme1n1p2" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco NVMe 1 Part 3"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_nvme1n1p3" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco NVMe 1 Part 4"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_nvme1n1p4" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "define service{"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco NVMe 2 Part 1"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_nvme2n1p1" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco NVMe 2 Part 2"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_nvme2n1p2" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco NVMe 2 Part 3"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_nvme2n1p3" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco NVMe 2 Part 4"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_nvme2n1p4" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "define service{"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco NVMe 3 Part 1"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_nvme3n1p1" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco NVMe 3 Part 2"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_nvme3n1p2" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco NVMe 3 Part 3"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_nvme3n1p3" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Disco NVMe 3 Part 4"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_nvme3n1p4" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"              >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"               >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description Oracle"                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_oracle" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"              >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description MySQL"                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_mysql" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                   >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                    >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description MySQL query"                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_mysql_query" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                   >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description DHCP local"                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_dhcp_local" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"           >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description DIG"                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_dig" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                               >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"           >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description DNS"                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_dns" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                               >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                >> /etc/nagios4/servers/$NombreDelHost.cfg

      echo "define service{"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  use                 generic-service"            >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"             >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  service_description HTTP"                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "  check_command       pers_check_nrpe!check_http" >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo "}"                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      echo ""                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      #echo "define service{"                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  use                 generic-service"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  host_name           $NombreDelHost"                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  service_description CPU"                                              >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  check_command       pers_check_nrpe!check_cpu_stats!-a '-w 85 -c 95'" >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "}"                                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo ""                                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg

      #echo "define service{"                                                              >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  use                 generic-service"                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  host_name           $NombreDelHost"                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  service_description Carga de trabajo"                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  check_command       pers_check_nrpe!check_load!-a '-w 15,10,5 -c 30,20,10'" >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "}"                                                                            >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo ""                                                                             >> /etc/nagios4/servers/$NombreDelHost.cfg

      #echo "define service{"                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  use                 generic-service"                            >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  host_name           $NombreDelHost"                             >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  service_description Uso de memoria"                             >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  check_command       pers_check_nrpe!check_mem!-a '-w 20 -c 10'" >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "}"                                                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo ""                                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg

      #echo "define service{"                                                         >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  use                 generic-service"                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  host_name           $NombreDelHost"                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  service_description Archivos abiertos"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  check_command       pers_check_nrpe!check_open_files!-a '-w 30 -c 50'" >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "}"                                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo ""                                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg

      #echo "define service{"                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  use                 generic-service"                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  host_name           $NombreDelHost"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  service_description Cantidad de procesos"                           >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  check_command       pers_check_nrpe!check_procs!-a '-w 150 -c 250'" >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "}"                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo ""                                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg

      #echo "define service{"                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  use                 generic-service"                             >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  host_name           $NombreDelHost"                              >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  service_description Usuarios"                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  check_command       pers_check_nrpe!check_users!-a '-w 5 -c 10'" >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "}"                                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo ""                                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg

      #echo "define service{"                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  use                 generic-service"                              >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  host_name           $NombreDelHost"                               >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  service_description Demonio cron"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  check_command       pers_check_nrpe!check_init_service!-a 'cron'" >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "}"                                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo ""                                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg

      #echo "define service{"                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  use                 generic-service"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  host_name           $NombreDelHost"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  service_description Servidor Apache"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  check_command       pers_check_nrpe!check_init_service!-a 'apache2'" >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "}"                                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo ""                                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

      #echo "define service{"                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  use                 generic-service"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  host_name           $NombreDelHost"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  service_description Servidor Dovecot"                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  check_command       pers_check_nrpe!check_init_service!-a 'dovecot'" >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "}"                                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo ""

      #echo "define service{"                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  use                 generic-service"                               >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  host_name           $NombreDelHost"                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  service_description Servicio MySQL"                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  check_command       pers_check_nrpe!check_init_service!-a 'mysql'" >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "}"                                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo ""                                                                    >> /etc/nagios4/servers/$NombreDelHost.cfg

      #echo "define service{"                                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  use                 generic-service"                             >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  host_name           $NombreDelHost"                              >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  service_description Servicio SSH"                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  check_command       pers_check_nrpe!check_init_service!-a 'ssh'" >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "}"                                                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo ""                                                                  >> /etc/nagios4/servers/$NombreDelHost.cfg

      #echo "define service{"                                                        >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  use                 generic-service"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  host_name           $NombreDelHost"                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  service_description Servicio Sendmail"                                >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  check_command       pers_check_nrpe!check_init_service!-a 'sendmail'" >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "}"                                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo ""                                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg

      #echo "define service{"                                                       >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  use                 generic-service"                                 >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  host_name           $NombreDelHost"                                  >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  service_description Daemon de log"                                   >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "  check_command       pers_check_nrpe!check_init_service!-a 'rsyslog'" >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo "}"                                                                     >> /etc/nagios4/servers/$NombreDelHost.cfg
      #echo ""                                                                      >> /etc/nagios4/servers/$NombreDelHost.cfg

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

  fi

