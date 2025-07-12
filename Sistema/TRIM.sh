#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para EJECUTAR TRIM SOBRE LA PARTICIÓN DONDE ESTÁ MONTADA /
#
#  PARA SABER SI TRIM ESTÁ SOPORTADO PUEDES EJECUTAR hdparm SOBRE EL DISCO
#  EJEMPLO:
#  hdparm -I /dev/disk/by-label/Debian | grep "TRIM supported"
#  O
#  hdparm -I /dev/sda | grep "TRIM supported"
# ----------

LOG=/var/log/TRIM.log
echo "*** $(date -R) ***" >> $LOG

echo ""
echo "Ejecutando trim sobre el directorio raíz..."echo ""
fstrim -v / >> $LOG
tail -n 2 /var/log/TRIM.log
echo ""

