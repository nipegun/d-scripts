#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para poner la hora de Europe/Madrid en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Hora-EuropeMadrid.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Hora-EuropeMadrid.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Hora-EuropeMadrid.sh | nano -
# ----------

set -e

vZonaHoraria="Europe/Madrid"

if [ "$(id -u)" -ne 0 ]; then
  echo "Este script debe ejecutarse como root."
  exit 1
fi

echo "Configurando zona horaria: ${vZonaHoraria}"
timedatectl set-timezone "${vZonaHoraria}"

echo "Activando sincronización NTP"
timedatectl set-ntp true

if systemctl list-unit-files systemd-timesyncd.service >/dev/null 2>&1; then
  echo "Reiniciando systemd-timesyncd"
  systemctl restart systemd-timesyncd.service || true
fi

if command -v chronyc >/dev/null 2>&1; then
  echo "Forzando sincronización con chrony"
  chronyc -a makestep || true
fi

if command -v ntpdig >/dev/null 2>&1; then
  echo "Forzando sincronización con ntpdig"
  ntpdig -S 0.debian.pool.ntp.org || true
fi

echo
timedatectl
echo
date

