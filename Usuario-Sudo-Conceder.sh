#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para agregar un usuario al grupo sudo
#
# Ejecución remota con sudo:
#   curl -sL x | sudo bash
#
# Ejecución remota como root:
#   curl -sL x | sudo bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' x | bash
#
# Ejecución remota con parámetros:
#   curl -sL x | bash -s Parámetro1 Parámetro2
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

# Comprobar si el paquete sudo está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s sudo 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete sudo no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update && apt-get -y install sudo
    echo ""
  fi

# Comprobar si el usuario existe. Si no existe, crearlo y agregarlo al grupo sudo
  if grep -q "^$1:" /etc/passwd; then
    echo ""
    echo "  Asignando permisos sudo al usuario $1..."
    echo ""
    usermod -aG sudo "$1"
    newgrp sudo
  else
    echo ""
    echo "  El usuario $1 no existe. Se procederá a crearlo."
    echo ""
    useradd -m -s /bin/bash "$1" && echo "$1:$1" | chpasswd && echo "    Se ha creado el usuario $1 con contraseña $1"
    echo ""
    echo "  Asignando permisos sudo al usuario recién creado..."
    echo ""
    usermod -aG sudo "$1"
    newgrp sudo
    echo ""
  fi
