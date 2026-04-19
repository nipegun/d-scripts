#!/bin/bash
set -euo pipefail

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para limpiar Codex en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/Codex-Limpiar.sh | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/Codex-Limpiar.sh | nano -
# ----------

# Definir la constante con la carpeta base
  cBaseDir="$HOME/.codex"

# Borrado de carpetas

  # Definir el array con el nombre de las carpetas a borrar
    aCarpetasABorrar=(
      "cache"
      "log"
      "memories"
      "plugins"
      "rules"
      "sessions"
      "shell_snapshots"
      "tmp"
      ".tmp"
    )

  # Ejecutar el bucle de borrado
    for vCarpeta in "${aCarpetasABorrar[@]}"; do
      vRutaALaCarpeta="$cBaseDir/$vCarpeta"
      if [ -d "$vRutaALaCarpeta" ]; then
        rm -rfv "$vRutaALaCarpeta"
      fi
    done

# Borrado de archivos

  aArchivosABorrar=(
    "history.jsonl"
    "installation_id"
    "logs_2.sqlite"
    "logs_2.sqlite-shm"
    "logs_2.sqlite-wal"
    "models_cache.json"
    "state_5.sqlite"
    "version.json"
    ".personality_migration"
  )

  for vArchivo in "${aArchivosABorrar[@]}"; do
    vRutaAlArchivo="$cBaseDir/$vArchivo"
    if [ -f "$vRutaAlArchivo" ]; then
      rm -fv "$vRutaAlArchivo"
    fi
  done
