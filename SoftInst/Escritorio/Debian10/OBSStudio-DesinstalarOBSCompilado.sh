#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------
#  Script de NiPeGun para instalar y configurar OBS Studio
#-----------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}--------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Iniciando el script de desinstalación de OBS Studio desde código fuente...${FinColor}"
echo -e "${ColorVerde}--------------------------------------------------------------------------${FinColor}"
echo ""


rm -rf /bin/obs
rm -rf /bin/obs-ffmpeg-mux
rm -rf /lib/obs-plugins
rm -rf /usr/include/obs
rm -rf /usr/lib/cmake/LibObs
rm -rf /usr/lib/obs-scripting
rm -rf /usr/share/obs

