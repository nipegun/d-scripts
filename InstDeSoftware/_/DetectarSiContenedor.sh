#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para detectar si el Debian es un contenedor
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL x | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL x | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL x | nano -
# ----------

# Detectar si el script se está ejecutando dentro de un contendor LXC
  if [ "$(systemd-detect-virt)" = "lxc" ]; then
    echo "Contenedor lxc detectado"
  elif [ "$(systemd-detect-virt)" = "systemd-nspawn" ]; then
    echo "Contenedor systemd-nspawn detectado"
  fi

