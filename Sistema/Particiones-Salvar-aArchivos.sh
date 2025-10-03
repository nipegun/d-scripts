#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para salvar las particiones de un disco hacia archivos de imagen
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL x | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL x | sed 's-sudo--g' | bash
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
      1 "Guardar tabla de particoines"                                         on
      2 "Corregir posibles errores en las particiones a clonar"                on
      3 "Borrar espacio libre en las particiones a clonar (Relleno con ceros)" off
      4 "Clonar hacia archivos"                                                on
      5 "Opción 5" off
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
          sfdisk -d "$vDisco" > "$vDir/tabla.txt"
          echo "[LOG] Tabla de particiones guardada en tabla.txt" >> "$vLog"

        ;;

        2)

          echo ""
          echo "  Corrigiendo posibles errores en las particiones a clonar..."
          echo ""
          for ((vNum=1; vNum<=vCantidadDeParticiones; vNum++)); do
            vPart="${vDisco}${vSep}${vNum}"
            vFS="$(fTipoFS "$vPart")"
            fCheckFS "$vPart" "$vFS" >> "$vLog" 2>&1
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
            if [ -n "$vBin" ]; then
              echo "    $vPart -> $vArchivo"
              $vBin -c -s "$vPart" -o "$vArchivo" -N -q
              echo "[LOG] Clonado $vPart con $vBin a $vArchivo" >> "$vLog"
            else
              echo "[!] No hay soporte partclone para FS $vFS en $vPart"
            echo "[ERROR] Sin soporte partclone para $vFS" >> "$vLog"
            fi
          done


        ;;

        5)

          echo ""
          echo "  Opción 5 (futuras funciones)..."
          echo ""

        ;;

    esac

done

echo ""
echo "[✓] Proceso completado. Archivos en $vDir"
