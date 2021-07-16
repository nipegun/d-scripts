#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar diferentes carteras de criptomonedas en Debian10
#-------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

DirWallet="451K8ZpJTWdLBKb5uCR1EWM5YfCUxdgxWFjYrvKSTaWpH1zdz22JDQBQeZCw7wZjRm3wqKTjnp9NKZpfyUzncXCJ24H4Xtr"
Hilos=$(dmidecode -t processor | grep ore | grep ount | cut -d ":" -f 2 | cut -d " " -f 2)

echo ""
echo -e "${ColorVerde}----------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Iniciando scripts de ejecución de XMRig...${FinColor}"
echo -e "${ColorVerde}----------------------------------------------${FinColor}"
echo ""
#echo ""
#echo "  Obteniendo dirección mac de la tarjeta inalámbrica..."
#echo ""
#DirMACWlan0=$(ip addr show wlan0 | grep link/ether | cut -d" " -f6)
#echo ""
#echo "  La dirección MAC de la tarjeta inalámbrica es: $DirMACWlan0"
#echo ""

#echo ""
#echo "  Generando un identificador de dispositivo a partir de la MAC $DirMACWlan0..."
#echo ""
#IdDispositivo=$(echo -n $DirMACWlan0 | md5sum | cut -d" " -f1)
#echo ""
#echo "  El identificador del dispositivo es: $IdDispositivo"
#echo ""

echo ""
echo "  Obteniendo identificador del procesador..."
echo ""
IdProc=$(dmidecode -t 4 | grep ID | cut -d":" -f2 | sed 's/ //g')
echo ""
echo "  El identificador del procesador es: $IdProc"
echo ""

echo ""
echo "  Generando un identificador de dispositivo a partir del identificador del procesador..."
echo ""
IdDispositivo=$(echo -n $IdProc | md5sum | cut -d" " -f1)
echo ""
echo "  El identificador del dispositivo es: $IdDispositivo"
echo ""

echo ""
echo "  Ejecutando minero con identificador $IdDispositivo..."
echo ""

## Con TLS
   ~/xmrig/build/xmrig -o pool.minexmr.com:443 --threads=$Hilos --rig-id=$Dispositivo -u $DirWallet --tls 

## Sin TLS
   #~/xmrig/build/xmrig  -o pool.minexmr.com:4444 --threads=$Hilos --rig-id=$Dispositivo -u $DirWallet

