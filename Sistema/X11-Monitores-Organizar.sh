#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para reorganizar la ubicación y resolución del triple monitor en X11
#
# Ejecución remota para resolución nativa de los monitores:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/X11-Monitores-Organizar-3.sh | bash
#
# Ejecución remota pasando resolución personalizada:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/X11-Monitores-Organizar-3.sh | bash -s 1920 1080
#
# NOTAS:
#   - Funciona tanto con MST (daisy chain) como con salidas independientes.
#   - Detecta DisplayPort, HDMI y eDP.
#   - En AMD usa el orden físico MST.
#   - En NVIDIA usa las coordenadas absolutas para determinar el orden.
# ----------

vAncho=$1
vAlto=$2

echo ""
echo "=== Organización automática de monitores conectados ==="
echo ""

# --- Reset global previo ---
echo "Restableciendo panning y escala previos..."
for salida in $(xrandr | grep " connected" | awk '{print $1}'); do
  vModoActual=$(xrandr | grep -A1 "^$salida connected" | tail -n1 | awk '{print $1}')
  xrandr --output "$salida" --scale 1x1 --mode "$vModoActual" --panning 0x0 2>/dev/null
done
xrandr --fb 0x0
echo "Hecho."
echo ""

# Detectar driver de GPU
vDriver=$(lspci -k | grep -A2 VGA | grep "Kernel driver in use" | awk '{print $5}')
echo "Driver gráfico detectado: $vDriver"
echo ""

# Detectar salidas conectadas según tipo de driver
if [[ "$vDriver" == *"amdgpu"* ]]; then
  echo "Usando lógica MST nativa (AMD/AMDGPU)..."
  aSalidasConectadas=($(xrandr | grep " connected" | grep -E "^(DisplayPort|HDMI|eDP)" | awk '{print $1}' | sort -V))
elif [[ "$vDriver" == *"nvidia"* ]]; then
  echo "Usando lógica propietaria NVIDIA (orden manual preferido)..."
  # Detectar salidas conectadas
  aDetectadas=($(xrandr | grep " connected" | grep -E "^(DP|HDMI|eDP|DisplayPort)" | awk '{print $1}'))
  # Orden deseado manualmente
  aPreferido=("DP-0.1.8" "DP-0.8" "DP-0.1.1.8")
  # Filtrar solo las que están realmente conectadas y mantener orden preferido
  aSalidasConectadas=()
  for salida in "${aPreferido[@]}"; do
    if [[ " ${aDetectadas[*]} " =~ " ${salida} " ]]; then
      aSalidasConectadas+=("$salida")
    fi
  done
else
  echo "Driver no reconocido. Usando detección genérica."
  aSalidasConectadas=($(xrandr | grep " connected" | awk '{print $1}' | sort -V))
fi

if [ ${#aSalidasConectadas[@]} -eq 0 ]; then
  echo "No se detectaron monitores conectados."
  exit 1
fi




echo "Detectados ${#aSalidasConectadas[@]} monitores conectados:"
printf '   %s\n' "${aSalidasConectadas[@]}"
echo ""

# Asignar posiciones: izquierda, centro, derecha
vIzquierda="${aSalidasConectadas[0]}"
vCentral="${aSalidasConectadas[1]}"
vDerecha="${aSalidasConectadas[2]}"

# Función para aplicar resolución
fAplicarModo() {
  local salida="$1"
  local vAncho="$2"
  local vAlto="$3"
  if [ -n "$vAncho" ] && [ -n "$vAlto" ]; then
    if xrandr | grep -A1 "^$salida connected" | grep -q "${vAncho}x${vAlto}"; then
      echo "    $salida → ${vAncho}x${vAlto}"
      xrandr --output "$salida" --mode "${vAncho}x${vAlto}"
    else
      echo "    Generando modo ${vAncho}x${vAlto} para $salida"
      vModeline=$(cvt -r $vAncho $vAlto 60 | grep Modeline | sed 's/^Modeline //')
      vModo=$(echo $vModeline | awk '{print $1}')
      xrandr --rmmode "$vModo" 2>/dev/null
      xrandr --newmode $vModeline
      xrandr --addmode "$salida" "$vModo"
      xrandr --output "$salida" --mode "$vModo"
    fi
  else
    vModoNativo=$(xrandr | grep -A1 "^$salida connected" | tail -n1 | awk '{print $1}')
    echo "    $salida → modo nativo: $vModoNativo"
    xrandr --output "$salida" --mode "$vModoNativo"
  fi
}

echo "Aplicando resoluciones..."
fAplicarModo "$vCentral" "$vAncho" "$vAlto"
[ -n "$vIzquierda" ] && fAplicarModo "$vIzquierda" "$vAncho" "$vAlto"
[ -n "$vDerecha" ] && fAplicarModo "$vDerecha" "$vAncho" "$vAlto"
echo ""

# Posicionar monitores
echo "Organizando posiciones..."
if [ -n "$vIzquierda" ]; then
  xrandr --output "$vIzquierda" --pos 0x0
  echo "    $vIzquierda ← posición 0x0"
fi

if [ -n "$vCentral" ]; then
  xrandr --output "$vCentral" --pos 2560x0
  echo "    $vCentral ← posición 2560x0"
fi

if [ -n "$vDerecha" ]; then
  xrandr --output "$vDerecha" --pos 5120x0
  echo "    $vDerecha ← posición 5120x0"
fi

# Marcar la pantalla central como principal
xrandr --output "$vCentral" --primary

echo ""
echo "  Organización completada:"
echo "    Centro:    $vCentral"
[ -n "$vIzquierda" ] && echo "    Izquierda: $vIzquierda"
[ -n "$vDerecha" ] && echo "    Derecha:   $vDerecha"
echo ""
