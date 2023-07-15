#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# --------------
#  Script de NiPeGun para extender volúmenes lógicos LVM
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/LVM-VolumLogi-Reducir.sh | bash
#
#  Ejemplo:
#
#    df -h /testfs/
#
#    Filesystem            Size  Used Avail Use% Mounted on
#    /dev/mapper/vg01-lv01 492M   33M  435M   8% /testfs
#
#    lvreduce /dev/vg01/lv01 -L-235M -r
# --------------

lvreduce $1

