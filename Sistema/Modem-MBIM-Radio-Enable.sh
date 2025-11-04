#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para obtener información del modem 4G mediante el protocolo MBIM
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Modem-MBIM-Radio-Enable.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Modem-MBIM-Radio-Enable.sh | sed 's-sudo--g' | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Comprobar si el paquete libmbim-utils está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s libmbim-utils 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  libmbim-utils no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install libmbim-utils
    echo ""
  fi

# Determinar el dispositivo de modem
  vDevModem='/dev/cdc-wdm0'

#
  echo ""
  echo -e "${cColorAzulClaro}  Ejecutando --quectel-set-radio-state=on ...${cFinColor}"
  echo ""
  sudo mbimcli -p --device="$vDevModem" --quectel-set-radio-state=on
  sudo mmcli --modem 0 --enable
  sudo mmcli --modem 1 --enable
  sudo mmcli --modem 2 --enable
