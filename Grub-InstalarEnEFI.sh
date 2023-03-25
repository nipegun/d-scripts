#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar Grub en una partición EFI
#
#  Ejecución remota:
#  curl -s x | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' x | bash
#
#  Ejecución remota con parámetros:
#  curl -s x | bash -s Parámetro1 Parámetro2
# ----------

vDispPart="$1"
vCarpetaEFI="/Particiones/EFIParaGrub"

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Comprobar si el paquete grub-efi-amd64 está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s grub-efi-amd64 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}  grub-efi-amd64 no está instalado. Iniciando su instalación...${vFinColor}"
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
