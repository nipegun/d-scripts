#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para guardar las particiones de un disco hacia archivos de imagen (NO ES VÁLIDO PARA FORÉNSICA!!)
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

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de guardado de particiones hacia archivos de imagen...${cFinColor}"
  echo ""

# Definir la cantidad de argumentos esperados
  cCantArgsEsperados=2

# Comprobar que se hayan pasado la cantidad de argumentos esperados. Abortar el script si no.
  if [ $# -ne $cCantArgsEsperados ]
    then
      echo ""
      echo -e "${cColorRojo}    Mal uso del script. El uso correcto sería: ${cFinColor}"
      echo ""
      if [[ "$0" == "bash" ]]; then
        vNombreDelScript="script.sh"
      else
        vNombreDelScript="$0"
      fi
      echo "      $vNombreDelScript [RutaAlDeviceDeLaUnidad] [CantDeParticiones]"
      echo ""
      echo "    Ejemplo:"
      echo ""
      echo "      $vNombreDelScript /dev/nvme0n1 2"
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
      *)              echo "" ;;
    esac
  }

  fCheckFS() {
    local vPart="$1"; local vFS="$2"
    case "$vFS" in
      ext2|ext3|ext4) sudo e2fsck -p "$vPart" ;;
      xfs)            sudo xfs_repair -L "$vPart" ;;
      btrfs)          sudo btrfs check --repair "$vPart" ;;
      vfat|fat|fat32) sudo fsck.vfat -a "$vPart" ;;
      ntfs)           sudo ntfsfix "$vPart" ;;
      f2fs)           sudo fsck.f2fs -a "$vPart" ;;
      reiserfs)       sudo reiserfsck --fix-fixable "$vPart" ;;
      hfsplus|hfs+)   sudo fsck.hfsplus -y "$vPart" ;;
      exfat)          sudo fsck.exfat -a "$vPart" ;;
      *) echo "No hay comprobador para $vFS"; return 0 ;;
    esac
  }

  fRellenarCeros() {
    local vPart="$1"
    local vNum="$2"
    local vPunto="/mnt/tmp-clone-p${vNum}"
    sudo mkdir -p "$vPunto"
    if sudo mount "$vPart" "$vPunto"; then
      sudo dd if=/dev/zero of="$vPunto/ceros.tmp" bs=1M status=progress 2> /dev/null || true
      sudo sync
      sudo rm -f "$vPunto/ceros.tmp"
      sudo sync
      sudo umount "$vPunto"
      sudo rmdir "$vPunto"
    fi
  }

# Crear el menú
  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install dialog
      echo ""
    fi
  menu=(dialog --checklist "Marca las tareas a ejecutar:" 22 80 16)
    opciones=(
      1 "Guardar tabla de particiones"                                         on
      2 "Corregir posibles errores en las particiones a clonar"                on
      3 "Borrar espacio libre en las particiones a clonar (Relleno con ceros)" on
      4 "Clonar hacia archivos de imagen"                                      on
      5 "Comprimir los archivos resultantes con xz"                            off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)


  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "    Guardando tabla de particiones..."
          echo ""
          # Comprobar si el paquete util-linux está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s util-linux 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${cColorRojo}      El paquete util-linux no está instalado. Iniciando su instalación...${cFinColor}"
              echo ""
              sudo apt-get -y update
              sudo apt-get -y install util-linux
              echo ""
            fi
          sudo sfdisk -d "$vDisco" | sudo tee "$vDir/TablaDeParticiones.txt"

        ;;

        2)

          echo ""
          echo "    Corrigiendo posibles errores en las particiones a clonar..."
          echo ""
          for ((vNum=1; vNum<=vCantidadDeParticiones; vNum++)); do
            vPart="${vDisco}${vSep}${vNum}"
            vFS="$(sudo blkid -o value -s TYPE "$1" 2>/dev/null "$vPart")"
            fCheckFS "$vPart" "$vFS"
            echo ""
          done

        ;;

        3)

          echo ""
          echo "    Borrando espacio libre en las particiones a clonar..."
          echo ""
          for ((vNum=1; vNum<=vCantidadDeParticiones; vNum++)); do
            vPart="${vDisco}${vSep}${vNum}"
            fRellenarCeros "$vPart" "$vNum"
          done

        ;;

        4)

          echo ""
          echo "    Clonando hacia archivos de imagen..."
          echo ""
          # Comprobar si el paquete partclone está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s partclone 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${cColorRojo}      El paquete partclone no está instalado. Iniciando su instalación...${cFinColor}"
              echo ""
              sudo apt-get -y update
              sudo apt-get -y install partclone
              echo ""
            fi
          for ((vNum=1; vNum<=vCantidadDeParticiones; vNum++)); do
            vPart="${vDisco}${vSep}${vNum}"
            vFS="$(sudo blkid -o value -s TYPE "$1" 2>/dev/null "$vPart")"
            vBin="$(fBinPartclone "$vFS")"
            vArchivo="$vDir/part${vNum}-${vFS}.img"

            vMontadaEn="$(findmnt -no TARGET "$vPart" 2>/dev/null)"
            if [ -n "$vMontadaEn" ]; then
              echo "      [!] $vPart está montada en $vMontadaEn. Aborto."
              exit 1
            fi

            if [ -n "$vBin" ]; then
              echo ""
              sudo $vBin -c -s "$vPart" -o "$vArchivo" -N -q && echo -e "\n    $vPart -> $vArchivo"
            else
              echo "      [!] No hay soporte de partclone para FS $vFS en $vPart"
            fi
          done

        ;;

        5)

          echo ""
          echo "    Comprimiendo los archivos resultantes con xz usando $(nproc) hilos..."
          echo ""
          for vArchivo in "$vDir"/*.img; do
            if [ -f "$vArchivo" ]; then
              sudo xz -9 -e -T$(nproc) -v -k "$vArchivo"
            fi
          done

        ;;

    esac

done

# Reparar permisos de archivos
  sudo chown $USER:$USER "$vDir"/ -R

# Notificar fin de ejecución del script
  echo ""
  echo -e "${cColorVerde}    [✓] Proceso completado.${cFinColor}"
  echo ""
  echo -e "${cColorVerde}      Archivos creados en la carpeta: $vDir ${cFinColor}"
  echo ""

