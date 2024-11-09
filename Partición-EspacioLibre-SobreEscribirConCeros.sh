#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para sobreescribir con ceros todo el espacio libre de una partición en Debian
#
# Ejecución remota con parámetros:
#   curl -sL x | bash -s Parámetro1 
#
# Bajar y editar directamente el archivo en nano
#   curl -sL x | nano -
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

# Comprobar si se le pasó un parámetro al scrupt o no
  if [ -z "$1" ]; then
    dd if=/dev/zero of=/ArchivoTemporal bs=1M status=progress || rm /ArchivoTemporal
  else
    dd if=/dev/zero of="$PuntoDeMontaje"ArchivoTemporal bs=1M status=progress || rm "$PuntoDeMontaje"ArchivoTemporal
  fi

