#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para NOTIFICAR POR MAIL EL FALLO DE UN DISCO DURO
# ----------

echo ""
echo "--------------------"
echo "  ENVIANDO MAIL..."
echo "--------------------"
echo ""
echo "$SMARTD_MESSAGE" | mail -s "$SMARTD_FAILTYPE" "$SMARTD_ADDRESS"

echo ""
echo "-----------------------------"
echo "  NOTIFICANDO AL USUARIO..."
echo "-----------------------------"
echo ""
wall "$SMARTD_MESSAGE"

