#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para re organizar la ubicación y resolución del triple monitor en X11
#
# Ejecución remota para resolución nativa de los monitores:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/X11-Monitores-Organizar-3.sh | bash
#
# Ejecución remota pasando resolución personalizada:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/X11-Monitores-Organizar-3.sh | bash -s 1920 1080
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/X11-Monitores-Organizar-3.sh | nano -
#
# NOTAS:
#   Funciona tanto con MST (daisy chain) como con salidas independientes.
#   Detecta DisplayPort, HDMI y eDP.
#   El primer monitor detectado se coloca al centro, el segundo a la izquierda y el tercero a la derecha.
#
# Uso:
#   ./OrganizarMonitores.sh [ANCHO] [ALTO]
#
#   Ejemplos:
#     ./OrganizarMonitores.sh 1280 720
#     ./OrganizarMonitores.sh   ← usa resolución nativa
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

# Detectar salidas conectadas
aSalidasConectadas=($(xrandr | grep " connected" | grep -E "^(DP|HDMI|eDP|DisplayPort)" | sed -E 's/.* ([0-9]+)x[0-9]+\+([0-9]+)\+.*/\2 \0/' | sort -n | awk '{print $3}' ))

if [ ${#aSalidasConectadas[@]} -eq 0 ]; then
  echo "  No se detectaron monitores conectados."
  exit 1
fi

echo "Detectados ${#aSalidasConectadas[@]} monitores conectados:"
printf '   %s\n' "${aSalidasConectadas[@]}"
echo ""

# Identificar posiciones
vCentral="${aSalidasConectadas[0]}"
vIzquierda="${aSalidasConectadas[1]}"
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
  xrandr --output "$vIzquierda" --left-of "$vCentral"
  echo "    $vIzquierda ← izquierda de $vCentral"
fi
if [ -n "$vDerecha" ]; then
  xrandr --output "$vDerecha" --right-of "$vCentral"
  echo "    $vDerecha → derecha de $vCentral"
fi

echo ""
echo "  Organización completada:"
echo "    Centro:    $vCentral"
[ -n "$vIzquierda" ] && echo "    Izquierda: $vIzquierda"
[ -n "$vDerecha" ] && echo "    Derecha:   $vDerecha"
echo ""
