#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para borrar logs del SIEM Splunk
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Splunk-Logs-Borrar.sh | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Splunk-Logs-Borrar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi


# Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update && apt-get -y install dialog
    echo ""
  fi

# Crear el menú
  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Borrar todos los logs"                      off
      2 "Borrar sólo los logs del índice main"       off 
      3 "Borrar sólo los logs del índice web_logs"   off
      4 "Borrar sólo los logs del índice security"   off
      5 "Borrar sólo los logs del índice error_logs" off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)


  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Borrando todos los logs que hay en el SIEM Splunk..."
          echo ""
          /opt/splunk/bin/splunk stop
          /opt/splunk/bin/splunk clean eventdata
          /opt/splunk/bin/splunk start

        ;;

        2)

          echo ""
          echo "  Borrando sólo los logs del índice main..."
          echo ""
          /opt/splunk/bin/splunk stop
          /opt/splunk/bin/splunk clean eventdata -index main
          /opt/splunk/bin/splunk start

        ;;

        3)

          echo ""
          echo "  Borrando sólo los logs del índice web_logs..."
          echo ""
          /opt/splunk/bin/splunk stop
          /opt/splunk/bin/splunk clean eventdata -index web_logs
          /opt/splunk/bin/splunk start

        ;;

        4)

          echo ""
          echo "  Borrando sólo los logs del índice security..."
          echo ""
          /opt/splunk/bin/splunk stop
          /opt/splunk/bin/splunk clean eventdata -index security
          /opt/splunk/bin/splunk start

        ;;

        5)

          echo ""
          echo "  Borrando sólo los logs del índice error_logs..."
          echo ""
          /opt/splunk/bin/splunk stop
          /opt/splunk/bin/splunk clean eventdata -index error_logs
          /opt/splunk/bin/splunk start

        ;;

    esac

done
