#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para interceptar la salida de terminal de un comando dado
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Terminal-Salida-Interceptar.sh | bash -s NombreDelSoftware
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}" >&2
    exit 1
  fi

cCantArgumEsperados=1
v

if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    echo -e "${cColorRojo}  Mal uso del script. El uso correcto sería: ${cFinColor}"
    echo "    $0 [NombreDelSoftware]"
    echo ""
    echo "  Ejemplo:"
    echo "    $0 xmrig"
    echo ""
    exit
  else
    # Comprobar si el paquete strace está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s strace 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}  strace no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        apt-get -y update
        apt-get -y install strace
        echo ""
      fi
    # Guardar el argumentao pasado en $1 como una variable nueva
      vSoftware="$1"
    # Interceptar salida de terminal
      while read -r vLinea;
        do
          printf "%b\n" "$vLinea";
        done < <(strace -e recvfrom,write -s 4096 -fp $(pgrep -n $vSoftware) 2>/dev/stdout)
    # Ejemplo para interceptar xmrig y parsear la salida
      #while read -r vLinea;
      #  do
      #    printf "%b\n" "$vLinea" | strings;
      # done < <(strace -e recvfrom,write -s 4096 -fp $(pgrep -n xmrig) 2>/dev/stdout)
  fi

