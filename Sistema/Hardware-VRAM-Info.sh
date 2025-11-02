#!/bin/bash

# Script de NiPeGun para etectar todas las GPUs y mostrar su VRAM total (Compatible con AMD, NVIDIA e Intel)
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Hardware-VRAM-Info.sh | bash

# Requisitos opcionales: lspci, glxinfo, bc
# Instalación rápida: sudo apt install pciutils mesa-utils bc -y

echo "=== Detección de GPUs y VRAM ==="

# Verificar que lspci existe
if ! command -v lspci >/dev/null 2>&1; then
  echo "Error: no se encuentra el comando 'lspci'. Instalá el paquete 'pciutils'."
  exit 1
fi

# Enumerar GPUs detectadas
vGPUs=$(lspci | egrep -i "vga|3d|display")
if [ -z "$vGPUs" ]; then
  echo "No se detectaron tarjetas gráficas en el sistema."
  exit 0
fi

echo "$vGPUs" | while read -r vLinea; do
  vID=$(echo "$vLinea" | cut -d" " -f1)
  vModelo=$(echo "$vLinea" | cut -d":" -f3- | sed 's/^ //')
  echo
  echo "GPU detectada en $vID → $vModelo"

  # Determinar tipo de GPU
  if echo "$vModelo" | grep -iq "nvidia"; then
    echo "Tipo: NVIDIA"
    if command -v nvidia-smi >/dev/null 2>&1; then
      vVRAMMiB=$(nvidia-smi --id=$(nvidia-smi --query-gpu=index --format=csv,noheader | head -n1) \
                  --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null)
      if [ -n "$vVRAMMiB" ]; then
        vVRAMGiB=$(echo "scale=2; $vVRAMMiB / 1024" | bc)
        echo "VRAM total: ${vVRAMMiB} MiB (${vVRAMGiB} GiB)"
      else
        echo "No se pudo obtener VRAM (¿driver no cargado?)"
      fi
    else
      echo "nvidia-smi no disponible (instalá los drivers propietarios para más info)"
    fi

  elif echo "$vModelo" | grep -iq "amd\|radeon"; then
    echo "Tipo: AMD"
    for vCard in /sys/class/drm/card*/device/mem_info_vram_total; do
      if [ -f "$vCard" ]; then
        vBytes=$(cat "$vCard" 2>/dev/null)
        vMiB=$((vBytes / 1024 / 1024))
        vGiB=$(echo "scale=2; $vMiB / 1024" | bc)
        vCardName=$(echo "$vCard" | sed 's|/sys/class/drm/||; s|/device/mem_info_vram_total||')
        echo "→ $vCardName: $vMiB MiB (${vGiB} GiB)"
      fi
    done

  elif echo "$vModelo" | grep -iq "intel"; then
    echo "Tipo: Intel (iGPU compartida con RAM del sistema)"
    echo "No tiene VRAM dedicada fija."

  else
    echo "Tipo: desconocido o no soportado."
  fi
done

echo
echo "=== Fin del informe ==="


