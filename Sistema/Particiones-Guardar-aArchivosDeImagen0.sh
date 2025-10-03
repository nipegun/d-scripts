#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para guardar las particiones de un disco hacia archivos de imagen
#
# Ejecución remota con argumentos (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Particiones-Guardar-aArchivosDeImagen.sh | bash -s [RutaAlDeviceDeLaUnidad] [CantDeParticiones]
#
# Ejecución remota con argumentos como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Particiones-Guardar-aArchivosDeImagen.sh | sed 's-sudo--g' | bash -s [RutaAlDeviceDeLaUnidad] [CantDeParticiones]
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Particiones-Guardar-aArchivosDeImagen.sh | nano -
# ----------

# Definir la cantidad de argumentos esperados
  cCantArgsEsperados=2

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
      echo "    $vNombreDelScript [RutaAlDeviceDeLaUnidad] [CantDeParticiones]"
      echo ""
      echo "  Ejemplo:"
      echo ""
      echo "    $vNombreDelScript /dev/nvme0n1 2"
      echo ""
      exit
  fi

# Guardar los argumentos en variables
  vDisco="${1:-}"
  vCantidadDeParticiones="${2:-}"

# Directorio de salida
  cFecha="$(date +"y%Ym%md%dh%Hm%Ms%S")"
  vDir="backups-$(basename "$vDisco")-$cFecha"
  sudo mkdir -p "$vDir"
  vLog="$vDir/log.txt"

# Separador de partición
  vSep=""
  case "$vDisco" in
    *[0-9]) vSep="p" ;;
  esac

# Funciones

  fTipoFS() { blkid -o value -s TYPE "$1" 2>/dev/null || echo ""; }

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

  fCheckFS() {
    local vPart="$1"; local vFS="$2"
    case "$vFS" in
      ext2|ext3|ext4) e2fsck -p "$vPart" ;;
      xfs)            xfs_repair -L "$vPart" ;;
      btrfs)          btrfs check --repair "$vPart" ;;
      vfat|fat|fat32) fsck.vfat -a "$vPart" ;;
      ntfs)           ntfsfix "$vPart" ;;
      f2fs)           fsck.f2fs -a "$vPart" ;;
      reiserfs)       reiserfsck --fix-fixable "$vPart" ;;
      hfsplus|hfs+)   fsck.hfsplus -y "$vPart" ;;
      exfat)          fsck.exfat -a "$vPart" ;;
      *) echo "No hay comprobador para $vFS"; return 0 ;;
    esac
  }

  fRellenarCeros() {
    local vPart="$1"; local vNum="$2"; local vPunto="/mnt/tmp-clone-p${vNum}"
    mkdir -p "$vPunto"
    if mount "$vPart" "$vPunto"; then
      dd if=/dev/zero of="$vPunto/ceros.tmp" bs=1M status=progress || true
      sync; rm -f "$vPunto/ceros.tmp"; sync
      umount "$vPunto"; rmdir "$vPunto"
    fi
  }

  fEstaMontada() {
    local vPart="$1"
    findmnt -no TARGET "$vPart" 2>/dev/null || true
  }

# Crear el menú
  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install dialog
      echo ""
    fi
  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Guardar tabla de particiones"                                         on
      2 "Corregir posibles errores en las particiones a clonar"                on
      3 "Borrar espacio libre en las particiones a clonar (Relleno con ceros)" off
      4 "Clonar hacia archivos de imagen"                                      on
      5 "Comprimir xon xz los archivos resultantes"                            off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)


  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Guardando tabla de particiones..."
          echo ""
          # Comprobar si el paquete util-linux está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s util-linux 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${cColorRojo}  El paquete util-linux no está instalado. Iniciando su instalación...${cFinColor}"
              echo ""
              sudo apt-get -y update
              sudo apt-get -y install util-linux
              echo ""
            fi
          sudo sfdisk -d "$vDisco" | sudo tee "$vDir/TablaDeParticiones.txt"

        ;;

        2)

          echo ""
          echo "  Corrigiendo posibles errores en las particiones a clonar..."
          echo ""
          for ((vNum=1; vNum<=vCantidadDeParticiones; vNum++)); do
            vPart="${vDisco}${vSep}${vNum}"
            vFS="$(fTipoFS "$vPart")"
            sudo fCheckFS "$vPart" "$vFS" | sudo tee -a "$vLog" 2>&1
          done

        ;;

        3)

          echo ""
          echo "  Borrando espacio libre en las particiones a clonar..."
          echo ""
          for ((vNum=1; vNum<=vCantidadDeParticiones; vNum++)); do
            vPart="${vDisco}${vSep}${vNum}"
            fRellenarCeros "$vPart" "$vNum"
            echo "[LOG] Relleno con ceros en $vPart" >> "$vLog"
          done

        ;;

        4)

          echo ""
          echo "  Clonando hacia archivos de imagen..."
          echo ""
          for ((vNum=1; vNum<=vCantidadDeParticiones; vNum++)); do
            vPart="${vDisco}${vSep}${vNum}"
            vFS="$(fTipoFS "$vPart")"
            vBin="$(fBinPartclone "$vFS")"
            vArchivo="$vDir/part${vNum}-${vFS}.img"

            vMontadaEn="$(fEstaMontada "$vPart")"
            if [ -n "$vMontadaEn" ]; then
              echo "[!] $vPart está montada en $vMontadaEn. Aborto."
              echo "[ERROR] $vPart montada en $vMontadaEn" >> "$vLog"
              exit 1
            fi

            if [ -n "$vBin" ]; then
              echo "    $vPart -> $vArchivo"
              $vBin -c -s "$vPart" -o "$vArchivo" -N -q
              echo "[LOG] Clonado $vPart con $vBin a $vArchivo" >> "$vLog"
              vTam="$(du -h "$vArchivo" | awk '{print $1}')"
              echo "[LOG] Tamaño final de $vArchivo: $vTam" >> "$vLog"
            else
              echo "[!] No hay soporte partclone para FS $vFS en $vPart"
              echo "[ERROR] Sin soporte partclone para $vFS" >> "$vLog"
            fi
          done

        ;;

        5)

          echo ""
          echo "  Comprimiendo con xz los archivos resultantes..."
          echo ""
          for vArchivo in "$vDir"/*.img; do
            if [ -f "$vArchivo" ]; then
              echo "    Comprimiendo $vArchivo..."
              xz -T0 -9 "$vArchivo"
              vTam="$(du -h "${vArchivo}.xz" | awk '{print $1}')"
              echo "[LOG] Comprimido ${vArchivo}.xz, tamaño final: $vTam" >> "$vLog"
            fi
          done

        ;;

    esac

done

echo ""
echo "[✓]  Proceso completado. Archivos en $vDir"
echo ""

