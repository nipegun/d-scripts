#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun montar todas las particiones de los discos IDE
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Particiones-IDE-Montar.sh | bash
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
  echo -e "${cColorAzulClaro}  Iniciando el script para montar todas las particiones de los discos IDE...${cFinColor}"
  echo ""

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}    Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

# Disco hda
  # Crear carpetas para montar las particiones
    mkdir -p /Particiones/IDE/hda1/ 2> /dev/null
    mkdir -p /Particiones/IDE/hda2/ 2> /dev/null
    mkdir -p /Particiones/IDE/hda3/ 2> /dev/null
    mkdir -p /Particiones/IDE/hda4/ 2> /dev/null
  # Montar las particiones
    mount -t auto /dev/hda1 /Particiones/IDE/hda1/
    mount -t auto /dev/hda2 /Particiones/IDE/hda2/
    mount -t auto /dev/hda3 /Particiones/IDE/hda3/
    mount -t auto /dev/hda4 /Particiones/IDE/hda4/

# Disco hdb
  # Crear carpetas para montar las particiones
    mkdir -p /Particiones/IDE/hdb1/ 2> /dev/null
    mkdir -p /Particiones/IDE/hdb2/ 2> /dev/null
    mkdir -p /Particiones/IDE/hdb3/ 2> /dev/null
    mkdir -p /Particiones/IDE/hdb4/ 2> /dev/null
  # Montar las particiones
    mount -t auto /dev/hdb1 /Particiones/IDE/hdb1/
    mount -t auto /dev/hdb2 /Particiones/IDE/hdb2/
    mount -t auto /dev/hdb3 /Particiones/IDE/hdb3/
    mount -t auto /dev/hdb4 /Particiones/IDE/hdb4/

# Disco hdc
  # Crear carpetas para montar las particiones
    mkdir -p /Particiones/IDE/hdc1/ 2> /dev/null
    mkdir -p /Particiones/IDE/hdc2/ 2> /dev/null
    mkdir -p /Particiones/IDE/hdc3/ 2> /dev/null
    mkdir -p /Particiones/IDE/hdc4/ 2> /dev/null
  # Montar las particiones
    mount -t auto /dev/hdc1 /Particiones/IDE/hdc1/
    mount -t auto /dev/hdc2 /Particiones/IDE/hdc2/
    mount -t auto /dev/hdc3 /Particiones/IDE/hdc3/
    mount -t auto /dev/hdc4 /Particiones/IDE/hdc4/

# Disco hdd
  # Crear carpetas para montar las particiones
    mkdir -p /Particiones/IDE/hdd1/ 2> /dev/null
    mkdir -p /Particiones/IDE/hdd2/ 2> /dev/null
    mkdir -p /Particiones/IDE/hdd3/ 2> /dev/null
    mkdir -p /Particiones/IDE/hdd4/ 2> /dev/null
  # Montar las particiones
    mount -t auto /dev/hdd1 /Particiones/IDE/hdd1/
    mount -t auto /dev/hdd2 /Particiones/IDE/hdd2/
    mount -t auto /dev/hdd3 /Particiones/IDE/hdd3/
    mount -t auto /dev/hdd4 /Particiones/IDE/hdd4/

# Disco hde
  # Crear carpetas para montar las particiones
    mkdir -p /Particiones/IDE/hde1/ 2> /dev/null
    mkdir -p /Particiones/IDE/hde2/ 2> /dev/null
    mkdir -p /Particiones/IDE/hde3/ 2> /dev/null
    mkdir -p /Particiones/IDE/hde4/ 2> /dev/null
  # Montar las particiones
    mount -t auto /dev/hde1 /Particiones/IDE/hde1/
    mount -t auto /dev/hde2 /Particiones/IDE/hde2/
    mount -t auto /dev/hde3 /Particiones/IDE/hde3/
    mount -t auto /dev/hde4 /Particiones/IDE/hde4/

# Disco hdf
  # Crear carpetas para montar las particiones
    mkdir -p /Particiones/IDE/hdf1/ 2> /dev/null
    mkdir -p /Particiones/IDE/hdf2/ 2> /dev/null
    mkdir -p /Particiones/IDE/hdf3/ 2> /dev/null
    mkdir -p /Particiones/IDE/hdf4/ 2> /dev/null
  # Montar las particiones
    mount -t auto /dev/hdf1 /Particiones/IDE/hdf1/
    mount -t auto /dev/hdf2 /Particiones/IDE/hdf2/
    mount -t auto /dev/hdf3 /Particiones/IDE/hdf3/
    mount -t auto /dev/hdf4 /Particiones/IDE/hdf4/

