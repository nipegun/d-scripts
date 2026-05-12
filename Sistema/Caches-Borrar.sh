#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para borrar todos los caches de Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Caches-Borrar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Caches-Borrar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Caches-Borrar.sh | nano -
# ----------

# /apt
  sudo apt clean
  sudo apt autoclean

# /var/cache
  sudo rm -rf /var/cache/apt/archives/*
  sudo rm -rf /var/cache/apt/archives/partial/*
  sudo rm -rf /var/cache/man/*
  sudo rm -rf /var/cache/fontconfig/*
  sudo rm -rf /var/cache/ldconfig/*
  sudo rm -rf /var/cache/app-info/*
  sudo rm -rf /var/cache/swcatalog/*
  sudo rm -rf /var/cache/PackageKit/*
  sudo rm -rf /var/cache/fwupd/*

# /home/
  sudo find /home -path '*/.cache/*' -mindepth 1 -delete

# /root
  sudo find /root/.cache -mindepth 1 -delete 2>/dev/null

