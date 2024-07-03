#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para obtener información de los puertos PCIe de una placa base
#
# Ejecución remota:
#   curl -sL x | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' x | bash
# ----------

# Definir el array asociativo
  declare -A vPuertosPCIe

# Definir la variable para guardar la información sobre los puertos PCIe proporcionada por dmidecode
  # Comprobar si el paquete dmidecode está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dmidecode 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete dmidecode no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dmidecode
      echo ""
    fi
  vSalidaDMI=$(dmidecode -t 9 | grep -E "Designation|Type|ID" | sed 's/\t//g' | sed 's-PCIE-Nom_PCIE-g' | sed 's/x/Elec_x/g' | cut -d' ' -f2)

# Inicializar contadores y variables
  vContador=0
  vPuerto=0
  key=""

# Leer la salida del comando desde la variable
  while IFS= read -r line; do
    if (( vContador % 3 == 0 )); then # Comprueba si el contador es múltiplo de 3 para crear una nueva clave en el array asociativo.
      key="Puerto$vPuerto"
      vPuertosPCIe["$key"]=""
      vPuerto=$(( vPuerto + 1 ))
    fi
    vPuertosPCIe["$key"]+="$line "
    vContador=$(( vContador + 1 ))
  done <<< "$vSalidaDMI"

# Mostrar todas las claves del array, ordenadas de la primera a la última
  for key in $(printf "%s\n" "${!vPuertosPCIe[@]}" | sort); do
    echo "$key: ${vPuertosPCIe[$key]}"
  done

## Mostrar los dos primeros valores de cada clave del array, ordenada por el orden de clave
#  for key in $(printf "%s\n" "${!vPuertosPCIe[@]}" | sort); do
#    # Obtener los valores asociados a la clave
#      values=(${vPuertosPCIe[$key]})
#    # Mostrar solo los primeros dos valores
#      echo "$key: ${values[0]} ${values[1]}"
#  done

