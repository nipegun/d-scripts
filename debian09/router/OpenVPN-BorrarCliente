#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------
#  Script de NiPeGun para borrar un cliente OpenVPN en el servidor
#-------------------------------------------------------------------

CantArgsCorrectos=1
ArgsInsuficientes=65

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

if [ $# -ne $CantArgsCorrectos ]
  then
    echo ""
    echo "--------------------------------------------------------------------------"
    echo -e "${ColorRojo}Mal uso del script.${FinColor} El uso correcto sería:"
    echo ""
    echo -e "  $0 ${ColorVerde}[NúmeroDeCliente]${FinColor}"
    echo ""
    echo "Ejemplo:"
    echo ""
    echo "  $0 2"
    echo "--------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    echo ""
    echo "  Borrando client$1..."
    echo ""
    rm /root/EasyRSA/pki/private/client$1.key
    rm /root/VPN/client-configs/keys/client$1.key
    rm /root/EasyRSA/pki/issued/client$1.crt
    rm /root/VPN/client-configs/keys/client$1.crt
    rm /root/VPN/client-configs/files/client$1.ovpn
    echo ""
    echo -e "${ColorVerde}Todos los archivos de client$1 se borraron con éxito...${FinColor}"
    echo ""
    ls -n /root/VPN/client-configs/files/
fi

