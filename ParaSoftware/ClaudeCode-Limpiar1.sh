#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para limpiar Claude Code en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/ClaudeCode-Limpiar.sh | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/ClaudeCode-Limpiar.sh | nano -
# ----------

# Definir la constante con la carpeta base
  cBaseDir="$HOME/.claude"

# Borrado de carpetas

  # Definir el array con el nombre de las carpetas a borrar
    aCarpetasABorrar=(
      "backups"
      "cache"
      "file-history"
      "ide"
      "paste-cache"
      "projects"
      "session-env"
      "sessions"
      "shell-snapshots"
      "tasks"
      "telemetry"
    )

  # Ejecutar el bucle de borrado
    for vCarpeta in "${aCarpetasABorrar[@]}"; do
      vRutaALaCarpeta="$cBaseDir/$vCarpeta"
      if [ -d "$vRutaALaCarpeta" ]; then
        rm -rfv "$vRutaALaCarpeta"
      fi
    done

# Borrado de archivos

  # Definir el array con el nombre de los archivos a borrar
    aArchivosABorrar=(
      "history.jsonl"
      "mcp-needs-auth-cache.json"
      "stats-cache.json"
    )

  # Ejecutar el bucle de borrado
    for vArchivo in "${aArchivosABorrar[@]}"; do
      vRutaAlArchivo="$cBaseDir/$vArchivo"
      if [ -d "$vRutaAlArchivo" ]; then
        rm -fv "$vRutaAlArchivo"
      fi
    done

