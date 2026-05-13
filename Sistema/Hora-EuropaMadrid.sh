#!/bin/bash

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

