#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear nuevos usuarios en jitsi-meet
# ----------

vCantParamCorr=3
cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $vCantParamCorr ]; then

  echo ""
  echo -e "${cColorRojo}Mal uso del script. Se le deben pasar tres parámetros obligatorios:${cFinColor}"
  echo ""
  echo -e "${cColorVerde}[NombreDeUsuario] [Dominio] [ContarseñaDeUsuario]${cFinColor}"
  echo ""
  echo "Ejemplo:"
  echo ""
  echo -e "$0 ${cColorVerde}Nico video.dominio.com 12345678${cFinColor}"
  echo ""
  exit

else

  prosodyctl register $1 $2 $3
  service prosody            restart
  service jicofo             restart
  service jitsi-videobridge2 restart

fi

