#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para restaurar a disco, particiones guardadas en archivos de imagen
#
# Ejecución remota con argumentos (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Particiones-Importar-DesdeArchivosDeImagen.sh | bash -s [ArchivoDeImagenDeDisco] [RutaAlDeviceDeLaUnidadDeDestino] [ArchivoConTablaDeParticiones]
#
# Ejecución remota con argumentos como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Particiones-Importar-DesdeArchivosDeImagen.sh | sed 's-sudo--g' | bash -s [ArchivoDeImagenDeDisco] [RutaAlDeviceDeLaUnidadDeDestino] [ArchivoConTablaDeParticiones]
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Particiones-Importar-DesdeArchivosDeImagen.sh | nano -
# ----------

# Definir la cantidad de argumentos esperados
  cCantArgsEsperados=3

# Comprobar que se hayan pasado la cantidad de argumentos esperados. Abortar el script si no.
  if [ $# -ne $cCantArgsEsperados ]
    then
      echo ""
      echo -e "${cColorRojo}  Mal uso del script. El uso correcto sería: ${cFinColor}"
      echo ""
      if [[ "$0" == "bash" ]]; then
        vNombreDelScript="script.sh"
      else
        vNombreDelScript="$0"
      fi
      echo "    $vNombreDelScript [ArchivoDeImagenDeDisco] [RutaAlDeviceDeLaUnidadDeDestino] [ArchivoConTablaDeParticiones]"
      echo ""
      echo "  Ejemplo:"
      echo ""
      echo "    $vNombreDelScript part1-vfat.img /dev/nvme0n1 TablaDeParticiones.txt"
      echo ""
      exit
  fi

# Argumentos
  vArchivoImagen="${1:-}"
  vDiscoDestino="${2:-}"
  vArchivoTabla="${3:-}"

# Funciones auxiliares
  fBinPartclone() {
    case "$1" in
      ext2|ext3|ext4) echo "partclone.extfs"    ;;
      vfat|fat|fat32) echo "partclone.vfat"     ;;
      ntfs)           echo "partclone.ntfs"     ;;
      xfs)            echo "partclone.xfs"      ;;
      btrfs)          echo "partclone.btrfs"    ;;
      f2fs)           echo "partclone.f2fs"     ;;
      reiserfs)       echo "partclone.reiserfs" ;;
      hfsplus|hfs+)   echo "partclone.hfsp"     ;;
      exfat)          echo "partclone.exfat"    ;;
      *)              echo ""                   ;;
    esac
  }

# 1. Restaurar tabla de particiones
  echo ""
  echo "  Borrando todas las firmas de particiones existentes en el disco de destino ($vDiscoDestino)..."
  echo ""
  #sudo wipefs -a "$vDiscoDestino"
  #sudo dd if=/dev/zero of="$vDiscoDestino" bs=1M count=8
  echo ""
  echo "  Restaurando tabla de particiones en $vDiscoDestino..."
  echo ""
  sudo sfdisk --force "$vDiscoDestino" < "$vArchivoTabla"
  # Ajustar la GPT al tamaño real del disco (evita el aviso de GParted)
    # Comprobar si el paquete gdisk está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s gdisk 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}  El paquete gdisk no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        sudo apt-get -y update
        sudo apt-get -y install gdisk
        echo ""
      fi
    sudo sgdisk -e "$vDiscoDestino"

# 2. Determinar número de partición
  vNum=$(echo "$vArchivoImagen" | sed -E 's/[^0-9]*([0-9]+).*/\1/')

  # Detectar tipo de dispositivo
  if [[ "$vDiscoDestino" =~ nvme ]] || [[ "$vDiscoDestino" =~ vd[a-z] ]] || [[ "$vDiscoDestino" =~ mmcblk ]]; then
    vPart="${vDiscoDestino}p${vNum}"
  else
    vPart="${vDiscoDestino}${vNum}"
  fi

# 3. Detectar FS en el nombre del archivo
  vFS=$(echo "$vArchivoImagen" | sed -nE 's/.*-([a-z0-9]+)\.img/\1/p')
  vBin="$(fBinPartclone "$vFS")"

  if [ -z "$vBin" ]; then
    echo "[!] No se pudo determinar binario de partclone para FS '$vFS'"
    exit 1
  fi

# 4. Restaurar con partclone
  echo ""
  echo "  Restaurando $vArchivoImagen en $vPart con $vBin..."
  echo ""
  sudo $vBin -r -s "$vArchivoImagen" -O "$vPart" -N
  if [ $? -eq 0 ]; then
    echo "[LOG] Restaurada $vArchivoImagen en $vPart con $vBin"
  else
    echo "[!] Error restaurando $vArchivoImagen en $vPart"
    exit 1
  fi

echo ""
echo "[✓] Proceso de restauración completado."
echo ""
echo "  Ya puedes proceder con el archivo de imagen de la partición inmediatamente posterior."
echo "    Simplemente vuelve a ejecutar el mismo comando pero indicando el nombre del siguiente archivo de imagen."
echo ""
