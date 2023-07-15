#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para borrar usuarios en jitsi-meet
# ----------

vCantParamCorr=2
cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $vCantParamCorr ]; then

  echo ""
  echo -e "${cColorRojo}Mal uso del script. Se le deben pasar dos parámetros obligatorios:${cFinColor}"
  echo ""
  echo -e "${cColorVerde}[NombreDeUsuario] [Dominio]${cFinColor}"
  echo ""
  echo "Ejemplo:"
  echo ""
  echo -e "$0 ${cColorVerde}Nico video.dominio.com${cFinColor}"
  echo ""
  exit

else

  prosodyctl deluser $1@$2
  service prosody            restart
  service jicofo             restart
  service jitsi-videobridge2 restart

fi

