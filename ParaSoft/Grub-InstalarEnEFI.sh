#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar Grub en una partición EFI
#
# Ejecución remota:
#  curl -sL x | bash
#
# Ejecución remota sin caché:
#  curl -sL -H 'Cache-Control: no-cache, no-store' x | bash
#
# Ejecución remota con parámetros:
#  curl -sL x | bash -s Parámetro1 Parámetro2
# ----------

vDispPart="$1"
vCarpetaEFI="/Particiones/EFIParaGrub"

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

# Comprobar si el paquete grub-efi-amd64 está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s grub-efi-amd64 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  grub-efi-amd64 no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install grub-efi-amd64
    echo ""
  fi

# Comprobar si existe la carpeta a montar, y si no, crearla
  if [ ! -d "$vCarpetaEFI" ]; then
    mkdir -p "$vCarpetaEFI"
  fi

# Instalar grub
  grub-install --target=x86_64-efi --efi-directory="$vCarpetaEFI" --bootloader-id=GRUB

# Configurar grub
  echo "configfile (hd0,gpt2)/boot/grub.cfg" > "$vCarpetaEFI"/GRUB/grub.cfg
