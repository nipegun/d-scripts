#!/bin/bash

# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/ClaudeCode-Chat-Exportar.sh | bash -s IDHexadecimalDelChat
# Validar parámetro
if [ -z "$1" ]; then
  echo "Uso: bash ClaudeCode-Chat-Exportar.sh <ID_DEL_CHAT>"
  exit 1
fi

# Definir el Id del chat a exportar
  vIdDelChat="$1" # Por ejemplo c1ae9e4a-f4b1-abca-b132-a1b2c3d4e5f6
# Definir la ruta a la carpeta del usuario
  cRutaAlEscritorioDelUsuario=$(xdg-user-dir DESKTOP)
# Buscar el jsonl del chat y copiarlo al escritorio
  find ~/.claude -name "$vIdDelChat".jsonl -exec cp {} "$cRutaAlEscritorioDelUsuario/$vIdDelChat".jsonl \;

# Verificar que se exportó correctamente
if [ ! -f "$cRutaAlEscritorioDelUsuario/$vIdDelChat.jsonl" ]; then
  echo "  ERROR: no se ha encontrado ningún chat con ID $vIdDelChat"
  exit 1
fi

# Notificar fin de ejecución del script
  echo ""
  echo "  Chat exportado "$cRutaAlEscritorioDelUsuario/$vIdDelChat".jsonl"
  echo ""
  echo "  Para importar ese chat en un nuevo ordenador, ejecutar en ese ordenador:"
  echo ""
  echo "    mkdir -p /home/NombreDeUsuario/.claude/projects/$vIdDelChat/"
  echo "    cp /home/NombreDeUsuario/Descargas/"$vIdDelChat".jsonl /home/NombreDeUsuario/.claude/projects/$vIdDelChat/"
  echo "    claude --resume $vIdDelChat"
  echo ""
