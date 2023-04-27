#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para cambiar el año de todos los archivos dentro de una carpeta dada
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Archivos-CambiarA%C3%B1o.sh | bash
# ----------

vCarpeta="$1"
vYear="$2"

vEsNumero='^[0-9]+$'

vCantArgsCorrectos=2
vArgsInsuficientes=65

if [ $# -ne $vCantArgsCorrectos ]
  then
    echo ""
    echo "------------------------------------------------------------------------------"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 [Carpeta] [Año]"
    echo ""
    echo "Ejemplo:"
    echo ' $0 "/home/nico/fotos/2022" 2023'
    echo "------------------------------------------------------------------------------"
    echo ""
    exit $vArgsInsuficientes
  elif ! [[ $vYear =~ $vEsNumero ]] && [[ ]]; then # Comprobar si la variable es un número y si tiene 4 caracteres
    echo "Error: No has introducido un número de 4 dígitos como año" >&2; exit
  else
    # Guardar lista de archivos en un fichero txt
      for vArchivos in "$(find "$vCarpeta" -type f)"
        do
          #date -r "$vArchivo" "+%Y%m%d%H%M.%S"
          echo "$vArchivos" > /tmp/Archivos.txt
        done

    # Mostrar la fecha de cada no de los archivos en el fichero
      while read vArchivo
        do
          # Obtener mes del archivo
            vMes=$(date -r "$vArchivo" "+%m")
            #echo "  El mes es: $vMes"
          # Obtener día del archivo
            vDia=$(date -r "$vArchivo" "+%d")
            #echo "  El día es: $vDia"
          # Obtener hora del archivo
            vHora=$(date -r "$vArchivo" "+%H")
            #echo "  La hora es: $vHora"
          # Obtener minuto del archivo
            vMin=$(date -r "$vArchivo" "+%M")
            #echo "  El minuto es: $vMin"
          # Obtener segundo del archivo
            vSeg=$(date -r "$vArchivo" "+%S")
            #echo "  El segundo es: $vSeg"
          # Aplicar cambio de año
            echo $vYear$vMes$vDia$vHora$vMin.$vSeg "$vArchivo"
           #touch -t $vMes$vDia$vHora$vMin.$vSeg "$vArchivo"
        done </tmp/Archivos.txt
fi

#touch --date=2015-09-01
#find $vCarpeta -type f -print -exec touch -t $vFechaDeseada {} \;
#find $vCarpeta -type d -print -exec touch -t $vFechaDeseada {} \;

