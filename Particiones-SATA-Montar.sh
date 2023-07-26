#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun montar todas las particiones de los discos SATA
#
# Ejecución remota:
#   curl -sL x | bash
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
  echo -e "${cColorAzulClaro}  Iniciando el script para montar todas las particiones de los discos SATA...${cFinColor}"
  echo ""

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}    Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

# Disco sda
  # Crear las carpetas para montar las particiones
    mkdir -p /Particiones/SATA/sda1/ 2> /dev/null
    mkdir -p /Particiones/SATA/sda2/ 2> /dev/null
    mkdir -p /Particiones/SATA/sda3/ 2> /dev/null
    mkdir -p /Particiones/SATA/sda4/ 2> /dev/null
    mkdir -p /Particiones/SATA/sda5/ 2> /dev/null
    mkdir -p /Particiones/SATA/sda6/ 2> /dev/null
    mkdir -p /Particiones/SATA/sda7/ 2> /dev/null
    mkdir -p /Particiones/SATA/sda8/ 2> /dev/null
    mkdir -p /Particiones/SATA/sda9/ 2> /dev/null
  # Montar las particiones del disco sda
    mount -t auto /dev/sda1 /Particiones/SATA/sda1/
    mount -t auto /dev/sda2 /Particiones/SATA/sda2/
    mount -t auto /dev/sda3 /Particiones/SATA/sda3/
    mount -t auto /dev/sda4 /Particiones/SATA/sda4/
    mount -t auto /dev/sda5 /Particiones/SATA/sda5/
    mount -t auto /dev/sda6 /Particiones/SATA/sda6/
    mount -t auto /dev/sda7 /Particiones/SATA/sda7/
    mount -t auto /dev/sda8 /Particiones/SATA/sda8/
    mount -t auto /dev/sda9 /Particiones/SATA/sda9/

# Disco sdb
  # Crear las carpetas para montar las particiones
    mkdir -p /Particiones/SATA/sdb1/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdb2/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdb3/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdb4/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdb5/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdb6/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdb7/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdb8/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdb9/ 2> /dev/null
  # Montar las particiones del disco sdb
    mount -t auto /dev/sdb1 /Particiones/SATA/sdb1/
    mount -t auto /dev/sdb2 /Particiones/SATA/sdb2/
    mount -t auto /dev/sdb3 /Particiones/SATA/sdb3/
    mount -t auto /dev/sdb4 /Particiones/SATA/sdb4/
    mount -t auto /dev/sdb5 /Particiones/SATA/sdb5/
    mount -t auto /dev/sdb6 /Particiones/SATA/sdb6/
    mount -t auto /dev/sdb7 /Particiones/SATA/sdb7/
    mount -t auto /dev/sdb8 /Particiones/SATA/sdb8/
    mount -t auto /dev/sdb9 /Particiones/SATA/sdb9/

# Disco sdc
  # Crear las carpetas para montar las particiones
    mkdir -p /Particiones/SATA/sdc1/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdc2/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdc3/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdc4/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdc5/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdc6/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdc7/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdc8/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdc9/ 2> /dev/null
  # Montar las particiones del disco sdc
    mount -t auto /dev/sdc1 /Particiones/SATA/sdc1/
    mount -t auto /dev/sdc2 /Particiones/SATA/sdc2/
    mount -t auto /dev/sdc3 /Particiones/SATA/sdc3/
    mount -t auto /dev/sdc4 /Particiones/SATA/sdc4/
    mount -t auto /dev/sdc5 /Particiones/SATA/sdc5/
    mount -t auto /dev/sdc6 /Particiones/SATA/sdc6/
    mount -t auto /dev/sdc7 /Particiones/SATA/sdc7/
    mount -t auto /dev/sdc8 /Particiones/SATA/sdc8/
    mount -t auto /dev/sdc9 /Particiones/SATA/sdc9/
    
# Disco sdd
  # Crear las carpetas para montar las particiones
    mkdir -p /Particiones/SATA/sdd1/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdd2/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdd3/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdd4/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdd5/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdd6/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdd7/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdd8/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdd9/ 2> /dev/null
  # Montar las particiones del disco sdd
    mount -t auto /dev/sdd1 /Particiones/SATA/sdd1/
    mount -t auto /dev/sdd2 /Particiones/SATA/sdd2/
    mount -t auto /dev/sdd3 /Particiones/SATA/sdd3/
    mount -t auto /dev/sdd4 /Particiones/SATA/sdd4/
    mount -t auto /dev/sdd5 /Particiones/SATA/sdd5/
    mount -t auto /dev/sdd6 /Particiones/SATA/sdd6/
    mount -t auto /dev/sdd7 /Particiones/SATA/sdd7/
    mount -t auto /dev/sdd8 /Particiones/SATA/sdd8/
    mount -t auto /dev/sdd8 /Particiones/SATA/sdd9/

# Disco sde
  # Crear las carpetas para montar las particiones
    mkdir -p /Particiones/SATA/sde1/ 2> /dev/null
    mkdir -p /Particiones/SATA/sde2/ 2> /dev/null
    mkdir -p /Particiones/SATA/sde3/ 2> /dev/null
    mkdir -p /Particiones/SATA/sde4/ 2> /dev/null
    mkdir -p /Particiones/SATA/sde5/ 2> /dev/null
    mkdir -p /Particiones/SATA/sde6/ 2> /dev/null
    mkdir -p /Particiones/SATA/sde7/ 2> /dev/null
    mkdir -p /Particiones/SATA/sde8/ 2> /dev/null
    mkdir -p /Particiones/SATA/sde9/ 2> /dev/null
  # Montar las particiones del disco sde
    mount -t auto /dev/sde1 /Particiones/SATA/sde1/
    mount -t auto /dev/sde2 /Particiones/SATA/sde2/
    mount -t auto /dev/sde3 /Particiones/SATA/sde3/
    mount -t auto /dev/sde4 /Particiones/SATA/sde4/
    mount -t auto /dev/sde5 /Particiones/SATA/sde5/
    mount -t auto /dev/sde6 /Particiones/SATA/sde6/
    mount -t auto /dev/sde7 /Particiones/SATA/sde7/
    mount -t auto /dev/sde8 /Particiones/SATA/sde8/
    mount -t auto /dev/sde9 /Particiones/SATA/sde9/

# Disco sdf
  # Crear las carpetas para montar las particiones
    mkdir -p /Particiones/SATA/sdf1/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdf2/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdf3/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdf4/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdf5/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdf6/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdf7/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdf8/ 2> /dev/null
    mkdir -p /Particiones/SATA/sdf9/ 2> /dev/null
  # Montar las particiones del disco sdf
    mount -t auto /dev/sdf1 /Particiones/SATA/sdf1/
    mount -t auto /dev/sdf2 /Particiones/SATA/sdf2/
    mount -t auto /dev/sdf3 /Particiones/SATA/sdf3/
    mount -t auto /dev/sdf4 /Particiones/SATA/sdf4/
    mount -t auto /dev/sdf5 /Particiones/SATA/sdf5/
    mount -t auto /dev/sdf6 /Particiones/SATA/sdf6/
    mount -t auto /dev/sdf7 /Particiones/SATA/sdf7/
    mount -t auto /dev/sdf8 /Particiones/SATA/sdf8/
    mount -t auto /dev/sdf9 /Particiones/SATA/sdf9/

