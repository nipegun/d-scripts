#!/bin/bash

# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/ClaudeCode-Chat-Importar.sh | bash -s IDHexadecimalDelChat

# Validar parámetro
if [ -z "$1" ]; then
  echo "Uso: bash ClaudeCode-Chat-Importar.sh <ID_DEL_CHAT>"
  exit 1
fi

# Definir el Id del chat a importar
  vIdDelChat="$1" # Por ejemplo c1ae9e4a-f4b1-abca-b132-a1b2c3d4e5f6
# Definir la ruta a la carpeta de descargas del usuario
  cRutaAlaCarpetaDeDescargasDelUsuario=$(xdg-user-dir DOWNLOAD)
# Crear la carpeta de Claude Code donde importar el chat
  mkdir -p $HOME/.claude/projects/$vIdDelChat/
# Buscar el jsonl en la carpeta de descargas e importarlo
  find "$cRutaAlaCarpetaDeDescargasDelUsuario" -name "$vIdDelChat".jsonl -exec cp {} $HOME/.claude/projects/$vIdDelChat/ \;
# Verificar que se importó correctamente
  if [ ! -f "$HOME/.claude/projects/$vIdDelChat/$vIdDelChat.jsonl" ]; then
    echo "  ERROR: no se ha importado correctamenteel chat $vIdDelChat"
    exit 1
  fi
# Cargar el chat
  claude --resume $vIdDelChat

# Extraer directamente de otro ordenador
#  mkdir -p $HOME/.claude/projects/nuevo/ && scp root@192.168.1.20:/root/.claude/projects/pruebas/c1ae9e4a-f4b1-abca-b132-a1b2c3d4e5f6.jsonl  $HOME/.claude/projects/nuevo/

