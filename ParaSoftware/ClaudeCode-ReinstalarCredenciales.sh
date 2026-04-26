#!/bin/bash
set -euo pipefail

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para restaurar credenciales de Claude Code en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/ClaudeCode-RestaurarCredenciales.sh | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/ClaudeCode-RestaurarCredenciales.sh | nano -
# ----------

# Directorio donde buscar los backups
cBackupDir="/Git"

# Directorio destino
cDestDir="$HOME/.claude"

# Archivo a restaurar
cArchivo=".credentials.json"

fCleanup() {
  # limpieza
  :
}

trap fCleanup EXIT

fMain() {
  # Verificar que el directorio de backups existe
  if [ ! -d "$cBackupDir" ]; then
    echo "Error: El directorio $cBackupDir no existe."
    exit 1
  fi

  # Buscar carpetas que coincidan con el patrón y guardarlas en un array
  mapfile -t aCarpetas < <(find "$cBackupDir" -maxdepth 1 -type d -name '.claude-backup-*' | sort)

  # Verificar si se encontraron carpetas
  if [ ${#aCarpetas[@]} -eq 0 ]; then
    echo "No se encontraron carpetas .claude-backup-* en $cBackupDir"
    exit 1
  fi

  # Mostrar menú
  echo "========================================"
  echo "  Menú de restauración de credentials"
  echo "========================================"
  echo ""

  # Array para almacenar los nombres mostrados al usuario
  declare -a aNombres

  for vI in "${!aCarpetas[@]}"; do
    vCarpeta="${aCarpetas[$vI]}"
    # Extraer el nombre después de .claude-backup-
    vNombre=$(basename "$vCarpeta" | sed 's/\.claude-backup-//')
    aNombres[$vI]="$vNombre"
    echo "  $((vI+1)). $vNombre"
  done

  echo ""
  echo "  0. Salir"
  echo ""
  echo "========================================"

  # Pedir opción al usuario
  read -rp "Elige una opción: " vOpcion

  # Validar que sea un número
  if ! [[ "$vOpcion" =~ ^[0-9]+$ ]]; then
    echo "Error: Debes introducir un número."
    exit 1
  fi

  # Opción de salir
  if [ "$vOpcion" -eq 0 ]; then
    echo "Saliendo sin hacer cambios."
    exit 0
  fi

  # Validar rango
  if [ "$vOpcion" -lt 1 ] || [ "$vOpcion" -gt "${#aCarpetas[@]}" ]; then
    echo "Error: Opción fuera de rango."
    exit 1
  fi

  # Obtener la carpeta seleccionada (índice base 0)
  vIndice=$((vOpcion - 1))
  vCarpetaSel="${aCarpetas[$vIndice]}"
  vNombreSel="${aNombres[$vIndice]}"
  vArchivoOrigen="$vCarpetaSel/$cArchivo"

  # Verificar que el archivo .credentials.json existe en la carpeta seleccionada
  if [ ! -f "$vArchivoOrigen" ]; then
    echo "Error: No se encontró el archivo $cArchivo en $vCarpetaSel"
    exit 1
  fi

  # Crear el directorio destino si no existe
  mkdir -p "$cDestDir"

  # Copiar el archivo (sobrescribiendo si es necesario)
  set +e
  cp -f "$vArchivoOrigen" "$cDestDir/$cArchivo"
  vResultadoCp=$?
  set -e

  # Verificar que la copia fue exitosa
  if [ "$vResultadoCp" -eq 0 ]; then
    echo ""
    echo "✅ Restauración completada con éxito."
    echo "   Origen:  $vArchivoOrigen"
    echo "   Destino: $cDestDir/$cArchivo"
  else
    echo ""
    echo "❌ Error: No se pudo copiar el archivo."
    exit 1
  fi
}

if ! fMain; then
  echo "error"
fi
