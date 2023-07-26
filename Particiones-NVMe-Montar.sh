#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun montar todas las particiones de los discos NVMe
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Particiones-NVMe-Montar.sh | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Notificar inicio de ekecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para montar todas las particiones de los discos NVMe...${cFinColor}"
  echo ""

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}    Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

# Disco nvme0n1
  # Crear las carpetas para montar las particiones
    mkdir -p /Particiones/NVMe/nvme0n1p1/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme0n1p2/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme0n1p3/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme0n1p4/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme0n1p5/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme0n1p6/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme0n1p7/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme0n1p8/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme0n1p9/ 2> /dev/null
  # Montar las particiones
    mount -t auto /dev/nvme0n1p1 /Particiones/NVMe/nvme0n1p1/
    mount -t auto /dev/nvme0n1p2 /Particiones/NVMe/nvme0n1p2/
    mount -t auto /dev/nvme0n1p3 /Particiones/NVMe/nvme0n1p3/
    mount -t auto /dev/nvme0n1p4 /Particiones/NVMe/nvme0n1p4/
    mount -t auto /dev/nvme0n1p5 /Particiones/NVMe/nvme0n1p5/
    mount -t auto /dev/nvme0n1p6 /Particiones/NVMe/nvme0n1p6/
    mount -t auto /dev/nvme0n1p7 /Particiones/NVMe/nvme0n1p7/
    mount -t auto /dev/nvme0n1p8 /Particiones/NVMe/nvme0n1p8/
    mount -t auto /dev/nvme0n1p9 /Particiones/NVMe/nvme0n1p9/

# Disco nvme1n1
  # Crear las carpetas para montar las particiones
    mkdir -p /Particiones/NVMe/nvme1n1p1/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme1n1p2/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme1n1p3/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme1n1p4/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme1n1p5/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme1n1p6/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme1n1p7/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme1n1p8/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme1n1p9/ 2> /dev/null
  # Montar las particiones
    mount -t auto /dev/nvme1n1p1 /Particiones/NVMe/nvme1n1p1/
    mount -t auto /dev/nvme1n1p2 /Particiones/NVMe/nvme1n1p2/
    mount -t auto /dev/nvme1n1p3 /Particiones/NVMe/nvme1n1p3/
    mount -t auto /dev/nvme1n1p4 /Particiones/NVMe/nvme1n1p4/
    mount -t auto /dev/nvme1n1p5 /Particiones/NVMe/nvme1n1p5/
    mount -t auto /dev/nvme1n1p6 /Particiones/NVMe/nvme1n1p6/
    mount -t auto /dev/nvme1n1p7 /Particiones/NVMe/nvme1n1p7/
    mount -t auto /dev/nvme1n1p8 /Particiones/NVMe/nvme1n1p8/
    mount -t auto /dev/nvme1n1p9 /Particiones/NVMe/nvme1n1p9/

# Disco nvme2n1
  # Crear las carpetas para montar las particiones
    mkdir -p /Particiones/NVMe/nvme2n1p1/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme2n1p2/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme2n1p3/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme2n1p4/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme2n1p5/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme2n1p6/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme2n1p7/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme2n1p8/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme2n1p9/ 2> /dev/null
  # Montar las particiones
    mount -t auto /dev/nvme2n1p1 /Particiones/NVMe/nvme2n1p1/
    mount -t auto /dev/nvme2n1p2 /Particiones/NVMe/nvme2n1p2/
    mount -t auto /dev/nvme2n1p3 /Particiones/NVMe/nvme2n1p3/
    mount -t auto /dev/nvme2n1p4 /Particiones/NVMe/nvme2n1p4/
    mount -t auto /dev/nvme2n1p5 /Particiones/NVMe/nvme2n1p5/
    mount -t auto /dev/nvme2n1p6 /Particiones/NVMe/nvme2n1p6/
    mount -t auto /dev/nvme2n1p7 /Particiones/NVMe/nvme2n1p7/
    mount -t auto /dev/nvme2n1p8 /Particiones/NVMe/nvme2n1p8/
    mount -t auto /dev/nvme2n1p9 /Particiones/NVMe/nvme2n1p9/

# Disco nvme3n1
  # Crear las carpetas para montar las particiones
    mkdir -p /Particiones/NVMe/nvme3n1p1/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme3n1p2/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme3n1p3/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme3n1p4/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme3n1p5/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme3n1p6/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme3n1p7/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme3n1p8/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme3n1p9/ 2> /dev/null
  # Montar las particiones
    mount -t auto /dev/nvme3n1p1 /Particiones/NVMe/nvme3n1p1/
    mount -t auto /dev/nvme3n1p2 /Particiones/NVMe/nvme3n1p2/
    mount -t auto /dev/nvme3n1p3 /Particiones/NVMe/nvme3n1p3/
    mount -t auto /dev/nvme3n1p4 /Particiones/NVMe/nvme3n1p4/
    mount -t auto /dev/nvme3n1p5 /Particiones/NVMe/nvme3n1p5/
    mount -t auto /dev/nvme3n1p6 /Particiones/NVMe/nvme3n1p6/
    mount -t auto /dev/nvme3n1p7 /Particiones/NVMe/nvme3n1p7/
    mount -t auto /dev/nvme3n1p8 /Particiones/NVMe/nvme3n1p8/
    mount -t auto /dev/nvme3n1p9 /Particiones/NVMe/nvme3n1p9/

# Disco nvme4n1
  # Crear las carpetas para montar las particiones
    mkdir -p /Particiones/NVMe/nvme4n1p1/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme4n1p2/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme4n1p3/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme4n1p4/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme4n1p5/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme4n1p6/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme4n1p7/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme4n1p8/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme4n1p9/ 2> /dev/null
  # Montar las particiones
    mount -t auto /dev/nvme4n1p1 /Particiones/NVMe/nvme4n1p1/
    mount -t auto /dev/nvme4n1p2 /Particiones/NVMe/nvme4n1p2/
    mount -t auto /dev/nvme4n1p3 /Particiones/NVMe/nvme4n1p3/
    mount -t auto /dev/nvme4n1p4 /Particiones/NVMe/nvme4n1p4/
    mount -t auto /dev/nvme4n1p5 /Particiones/NVMe/nvme4n1p5/
    mount -t auto /dev/nvme4n1p6 /Particiones/NVMe/nvme4n1p6/
    mount -t auto /dev/nvme4n1p7 /Particiones/NVMe/nvme4n1p7/
    mount -t auto /dev/nvme4n1p8 /Particiones/NVMe/nvme4n1p8/
    mount -t auto /dev/nvme4n1p9 /Particiones/NVMe/nvme4n1p9/

# Disco nvme5n1
  # Crear las carpetas para montar las particiones
    mkdir -p /Particiones/NVMe/nvme5n1p1/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme5n1p2/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme5n1p3/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme5n1p4/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme5n1p5/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme5n1p6/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme5n1p7/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme5n1p8/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme5n1p9/ 2> /dev/null
  # Montar las particiones
    mount -t auto /dev/nvme5n1p1 /Particiones/NVMe/nvme5n1p1/
    mount -t auto /dev/nvme5n1p2 /Particiones/NVMe/nvme5n1p2/
    mount -t auto /dev/nvme5n1p3 /Particiones/NVMe/nvme5n1p3/
    mount -t auto /dev/nvme5n1p4 /Particiones/NVMe/nvme5n1p4/
    mount -t auto /dev/nvme5n1p5 /Particiones/NVMe/nvme5n1p5/
    mount -t auto /dev/nvme5n1p6 /Particiones/NVMe/nvme5n1p6/
    mount -t auto /dev/nvme5n1p7 /Particiones/NVMe/nvme5n1p7/
    mount -t auto /dev/nvme5n1p8 /Particiones/NVMe/nvme5n1p8/
    mount -t auto /dev/nvme5n1p9 /Particiones/NVMe/nvme5n1p9/

# Disco nvme6n1
  # Crear las carpetas para montar las particiones
    mkdir -p /Particiones/NVMe/nvme6n1p1/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme6n1p2/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme6n1p3/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme6n1p4/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme6n1p5/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme6n1p6/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme6n1p7/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme6n1p8/ 2> /dev/null
    mkdir -p /Particiones/NVMe/nvme6n1p9/ 2> /dev/null
  # Montar las particiones
    mount -t auto /dev/nvme6n1p1 /Particiones/NVMe/nvme6n1p1/
    mount -t auto /dev/nvme6n1p2 /Particiones/NVMe/nvme6n1p2/
    mount -t auto /dev/nvme6n1p3 /Particiones/NVMe/nvme6n1p3/
    mount -t auto /dev/nvme6n1p4 /Particiones/NVMe/nvme6n1p4/
    mount -t auto /dev/nvme6n1p5 /Particiones/NVMe/nvme6n1p5/
    mount -t auto /dev/nvme6n1p6 /Particiones/NVMe/nvme6n1p6/
    mount -t auto /dev/nvme6n1p7 /Particiones/NVMe/nvme6n1p7/
    mount -t auto /dev/nvme6n1p8 /Particiones/NVMe/nvme6n1p8/
    mount -t auto /dev/nvme6n1p9 /Particiones/NVMe/nvme6n1p9/

