#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar diferentes carteras de criptomonedas en Debian10
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

DirWallet="451K8ZpJTWdLBKb5uCR1EWM5YfCUxdgxWFjYrvKSTaWpH1zdz22JDQBQeZCw7wZjRm3wqKTjnp9NKZpfyUzncXCJ24H4Xtr"
Hilos=$(dmidecode -t processor | grep ore | grep ount | cut -d ":" -f 2 | cut -d " " -f 2)

echo ""
echo -e "${cColorVerde}----------------------------------------------${cFinColor}"
echo -e "${cColorVerde}  Iniciando scripts de ejecución de XMRig...${cFinColor}"
echo -e "${cColorVerde}----------------------------------------------${cFinColor}"
echo ""

echo ""
echo "  Creando ID para el minero..."echo ""

# A partir de la MAC WiFi
   # Obtener MAC de la WiFi
      #DirMACwlan0=$(ip addr show wlan0 | grep link/ether | cut -d" " -f6 | sed 's/://g')
   # Generar un identificador del minero a partir de la MAC de la WiFi...
      #IdMinero=$(echo -n $DirMACwlan0 | md5sum | cut -d" " -f1)

# A partir del ID del procesador
   # Obtener ID del procesador
      IdProc=$(dmidecode -t 4 | grep ID | cut -d":" -f2 | sed 's/ //g')
   # Generar un identificador del minero a partir del ID del procesador...
      IdMinero=$(echo -n $IdProc | md5sum | cut -d" " -f1)

echo ""
echo "  Ejecutando minero con identificador $IdMinero..."echo ""

# Con TLS
   ~/Cryptos/XMR/minero/xmrig -o pool.minexmr.com:443 --threads=$Hilos --rig-id=$IdMinero -u $DirWallet --tls --background

# Sin TLS
   #~/Cryptos/XMR/minero/xmrig  -o pool.minexmr.com:4444 --threads=$Hilos --rig-id=$IdMinero -u $DirWallet --background
