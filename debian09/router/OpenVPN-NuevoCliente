#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------
#  Script de NiPeGun para crear un nuevo cliente OpenVPN en el servidor
#------------------------------------------------------------------------

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
    echo "  Creando un nuevo cliente para OpenVPN..."
    echo ""
    cd /root/EasyRSA/
    /root/EasyRSA/easyrsa gen-req client$1 nopass
    cp /root/EasyRSA/pki/private/client$1.key /root/VPN/client-configs/keys/
    /root/EasyRSA/easyrsa sign-req client client$1
    cp /root/EasyRSA/pki/issued/client$1.crt /root/VPN/client-configs/keys/
    cp /root/EasyRSA/ta.key /root/VPN/client-configs/keys/
    cp /etc/openvpn/ca.crt /root/VPN/client-configs/keys/
    /root/VPN/client-configs/make_config.sh client$1
    echo ""
    echo -e "${ColorVerde}El archivo de configuración para client$1 se guardó en: /root/VPN/client-configs/files/client$1.ovpn${FinColor}"
    echo ""
    ls -n /root/VPN/client-configs/files/
fi

