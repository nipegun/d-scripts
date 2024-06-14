#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para agregar un host Router a Nagios
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios4-Agregar-Host-Router.sh | bash -s URL Servicio
#
#  Ejemplo:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Nagios4-Agregar-Host-Router.sh | bash -s mirouter "Mi router" "192.168.0.123"
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

      mkdir -p /etc/nagios4/routers/ 2> /dev/null

      echo "define host {"                                             > /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  use             linux-server"                           >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  host_name       $NombreDelHost"                         >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  alias           $AliasDelHost"                          >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  address         $IPDelHost"                             >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  icon_image      router40.jpg"                           >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  icon_image_alt  Router"                                 >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  vrml_image      router40.png"                           >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  statusmap_image router40.gd2"                           >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "}"                                                        >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo ""                                                         >> /etc/nagios4/routers/$NombreDelHost.cfg

      echo "define service {"                                         >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  use                 generic-service"                    >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  service_description PING"                               >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  check_command       check_ping!100.0,20%!500.0,60%"     >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "}"                                                        >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo ""                                                         >> /etc/nagios4/routers/$NombreDelHost.cfg

      echo "define service {"                                         >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  use                 generic-service"                    >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  service_description SSH"                                >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  check_command       check_ssh"                          >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "}"                                                        >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo ""                                                         >> /etc/nagios4/routers/$NombreDelHost.cfg

      echo "define service {"                                         >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  use                 generic-service"                    >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  service_description DHCP"                               >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  check_command       check_dhcp! -s $IPDelHost"          >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "}"                                                        >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo ""                                                         >> /etc/nagios4/routers/$NombreDelHost.cfg

      echo "define service {"                                         >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  use                 generic-service"                    >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  host_name           $NombreDelHost"                     >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  service_description HHTP"                               >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "  check_command       check_http"                         >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo "}"                                                        >> /etc/nagios4/routers/$NombreDelHost.cfg
      echo ""                                                         >> /etc/nagios4/routers/$NombreDelHost.cfg

      chown nagios:nagios /etc/nagios4/routers/$NombreDelHost.cfg
      chmod 664 /etc/nagios4/routers/$NombreDelHost.cfg

      sed -i -e "s-$NombreDelHost-$IPDelHost-g" /etc/nagios4/routers/$NombreDelHost.cfg

      systemctl restart nagios4

      echo ""
      echo "  Router Cisco agregado."
      echo "  Si la monitorización no funciona comprueba que:"
      echo "    - Hayas activado SNMP en el router."
      echo "    - Hayas permitido en el router la IP del servidor nagios:"
      echo ""

  fi

