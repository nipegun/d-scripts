#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para volver a activar el power saving
# ----------

# Sleep
systemctl unmask sleep.target

# Suspender
systemctl unmask suspend.target

# Hibernar
systemctl unmask hibernate.target

# Hybrid Sleep
systemctl unmask hybrid-sleep.target

