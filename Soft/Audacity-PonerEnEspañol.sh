#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para poner Audacity en español
# ----------

# Asegúrate de que Audacity esté cerrado antes de ejecutar este script

sed -i -e 's|Language=|Language=es|g' ~/.audacity-data/audacity.cfg

echo "[Locale]" >> ~/.audacity-data/audacity.cfg
echo "Language=es" >> ~/.audacity-data/audacity.cfg

