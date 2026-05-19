#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para hacer copia de seguridad interna de Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/CopSegInt.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/CopSegInt.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/CopSegInt.sh | nano -
# ----------

# Definir ubicaciones
  cCarpetaRaizDeCopias='/CopSegInt'
  cArchivoConDatosACopiar='/root/DataToBackup.txt'

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Definir el momento de ejecución del script
  cFechaDeEjec=$(date +a%Ym%md%dh%Hm%Ms%S)

# Definir carpeta de destino
  cCarpetaDestino="$cCarpetaRaizDeCopias"/"$cFechaDeEjec"

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando la copia de seguridad interna el $cFechaDeEjec...${cFinColor}"
  echo ""

# Comprobar si existe el archivo con datos a copiar
  if ! sudo test -f "$cArchivoConDatosACopiar"; then
    echo -e "${cColorRojo}    El archivo $cArchivoConDatosACopiar no existe.${cFinColor}"
    echo ''
    exit 1
  fi

# Crear la carpeta de copia de seguridad
  if ! sudo mkdir -p "$cCarpetaDestino"; then
    echo -e "${cColorRojo}  No se pudo crear la carpeta de destino: $cCarpetaDestino${cFinColor}"
    echo ''
    exit 1
  fi

# Leer el archivo línea por línea
  sudo cat "$cArchivoConDatosACopiar" | while IFS= read -r vLinea || [ -n "$vLinea" ]; do

  # Eliminar retorno de carro si el archivo viene de Windows
    vLinea="${vLinea%$'\r'}"

  # Ignorar líneas vacías
    if [ -z "$vLinea" ]; then
      continue
    fi

  # Ignorar líneas que empiezan por #
    if [[ "$vLinea" == \#* ]]; then
      continue
    fi

  # Comprobar que sea una ruta absoluta
    if [[ "$vLinea" != /* ]]; then
      echo -e "${cColorRojo}      Ruta ignorada porque no es absoluta: $vLinea${cFinColor}"
      continue
    fi

  # Si termina en /, debe ser una carpeta existente
    if [[ "$vLinea" == */ ]]; then
      if ! sudo test -d "$vLinea"; then
        echo -e "${cColorRojo}      Carpeta inexistente, ignorada: $vLinea${cFinColor}"
        continue
      fi

      echo "    Copiando carpeta: $vLinea$"
      if ! sudo cp -a --parents "$vLinea" "$cCarpetaDestino/"; then
        echo -e "${cColorRojo}      Error copiando: $vLinea${cFinColor}"
        continue
      fi

  # Si no termina en /, debe ser un archivo existente
    else
      if ! sudo test -f "$vLinea"; then
        echo -e "${cColorRojo}      Archivo inexistente, ignorado: $vLinea${cFinColor}"
        continue
      fi

      echo "    Copiando archivo: $vLinea$"
      if ! sudo cp -a --parents "$vLinea" "$cCarpetaDestino/"; then
        echo -e "${cColorRojo}      Error copiando: $vLinea${cFinColor}"
        continue
      fi
    fi

  done

# Loguear tarea
  echo "$cFechaDeEjec - Terminada la copia de seguridad interna." | sudo tee -a /var/log/CopiasDeSeguridad.log > /dev/null

# Notificar fin de ejecución del script
  echo ""
  echo -e "${cColorVerde}  Ejecución del script finalizada.${cFinColor}"
  echo ""
