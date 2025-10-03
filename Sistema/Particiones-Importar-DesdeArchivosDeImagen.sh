#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para restaurar a disco, particiones guardadas en archivos de imagen
#
# Ejecución remota con argumentos (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Particiones-Importar-DesdeArchivosDeImagen.sh | bash -s  [ArchivoDeImagenDeDisco] [RutaAlDeviceDeLaUnidadDeDestino] [ArchivoConTablaDePartic]
#
# Ejecución remota con argumentos como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Particiones-Importar-DesdeArchivosDeImagen.sh | sed 's-sudo--g' | bash -s  [ArchivoDeImagenDeDisco] [RutaAlDeviceDeLaUnidadDeDestino] [ArchivoConTablaDePartic]
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
      echo "    $vNombreDelScript [ArchivoDeImagenDeDisco] [RutaAlDeviceDeLaUnidadDeDestino] [ArchivoConTablaDePartic]"
      echo ""
      echo "  Ejemplo:"
      echo ""
      echo "    $vNombreDelScript /dev/nvme0n1 2"
      echo ""
      exit
  fi

# Parámetros
  vArchivoImagen="${1:-}"
  vDiscoDestino="${2:-}"
  vArchivoTabla="${3:-}"

# Preparar directorio de logs
  cFecha="$(date +"y%Ym%md%dh%Hm%Ms%S")"
  vDir="restore-$(basename "$vDiscoDestino")-$cFecha"
  mkdir -p "$vDir"
  vLog="$vDir/log.txt"

# Funciones auxiliares
  fBinPartclone() {
    case "$1" in
      ext2|ext3|ext4) echo "partclone.extfs" ;;
      vfat|fat|fat32) echo "partclone.vfat" ;;
      ntfs) echo "partclone.ntfs" ;;
      xfs) echo "partclone.xfs" ;;
      btrfs) echo "partclone.btrfs" ;;
     f2fs) echo "partclone.f2fs" ;;
      reiserfs) echo "partclone.reiserfs" ;;
      hfsplus|hfs+) echo "partclone.hfsp" ;;
      exfat) echo "partclone.exfat" ;;
      *) echo "" ;;
    esac
  }

# 1. Restaurar tabla de particiones
  echo "  Restaurando tabla de particiones en $vDiscoDestino..."
  sfdisk "$vDiscoDestino" < "$vArchivoTabla"
  echo "[LOG] Tabla de particiones restaurada en $vDiscoDestino desde $vArchivoTabla" >> "$vLog"

# 2. Preparar imagen
  vArchivoTmp="$vArchivoImagen"
  if [[ "$vArchivoImagen" == *.xz ]]; then
    echo "  Descomprimiendo $vArchivoImagen..."
    vArchivoTmp="$vDir/$(basename "${vArchivoImagen%.xz}")"
    xz -dkc "$vArchivoImagen" > "$vArchivoTmp"
    echo "[LOG] Imagen $vArchivoImagen descomprimida a $vArchivoTmp" >> "$vLog"
  fi

# 3. Determinar número de partición
  vNum=$(echo "$vArchivoTmp" | sed -E 's/[^0-9]*([0-9]+).*/\1/')
  vPart="${vDiscoDestino}${vNum}"

# 4. Detectar FS en el nombre del archivo
  vFS=$(echo "$vArchivoTmp" | sed -nE 's/.*-([a-z0-9]+)\.img/\1/p')
  vBin="$(fBinPartclone "$vFS")"

  if [ -z "$vBin" ]; then
    echo "[!] No se pudo determinar binario de partclone para FS '$vFS'"
    echo "[ERROR] No hay binario partclone para FS '$vFS'" >> "$vLog"
    exit 1
  fi

# 5. Restaurar con partclone
  echo "  Restaurando $vArchivoTmp en $vPart con $vBin..."
  $vBin -r -s "$vArchivoTmp" -o "$vPart" -N -q
  if [ $? -eq 0 ]; then
    echo "[LOG] Restaurada $vArchivoTmp en $vPart con $vBin" >> "$vLog"
  else
    echo "[!] Error restaurando $vArchivoTmp en $vPart"
    echo "[ERROR] Fallo en restauración de $vArchivoTmp con $vBin" >> "$vLog"
    exit 1
  fi

echo ""
echo "[✓] Proceso de restauración completado. Log en $vLog"
