#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------
#  Script de NiPeGun para sincronizar los nipe-scripts
#-------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

# Comprobar si hay conexión a Internet antes de sincronizar los nipe-scripts
wget -q --tries=10 --timeout=20 --spider https://github.com
  if [[ $? -eq 0 ]]; then
    echo ""
    echo "------------------------------------------------------------"
    echo -e "  ${ColorVerde}Sincronizando los nipe-scripts con las últimas versiones${FinColor}"
    echo -e "  ${ColorVerde} y descargando nuevos nipe-scripts si es que existen...${FinColor}"
    echo "------------------------------------------------------------"
    echo ""
    rm /root/scripts/nipe-scripts -R
    cd /root/scripts/
    git clone --depth=1 https://github.com/nipegun/nipe-scripts
    rm /root/scripts/nipe-scripts/.git -R
    rm /root/scripts/nipe-scripts/*
    chmod +x /root/scripts/nipe-scripts/* -R
    /root/scripts/nipe-scripts/debian09/CrearAlias
    echo ""
    echo "--------------------------------------------"
    echo -e "  ${ColorVerde}nipe-scripts sincronizados correctamente${FinColor}"
    echo "--------------------------------------------"
    echo ""
  else
    echo ""
    echo "---------------------------------------------------------------------------------------------------"
    echo -e "${ColorRojo}No se pudo iniciar la sincronización de los nipe-scripts porque no se detectó conexión a Internet.${FinColor}"
    echo "---------------------------------------------------------------------------------------------------"
    echo ""
  fi

