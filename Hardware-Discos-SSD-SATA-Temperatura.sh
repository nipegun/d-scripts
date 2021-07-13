#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------
#  Script de NiPeGun para mostrar la temperatura de los discos duros SATA
#--------------------------------------------------------------------------

ColorVerde="\033[1;32m"
FinColor="\033[0m"

echo ""
echo -e "${ColorVerde}  Mostrando temperatura de los discos duros SATA...${FinColor}"
echo ""


## Obtener la cantidad de discos SATA que hay instalados en el sistema
   for LetraDiscoSATA in {a..x}
     do
       if [[ -d "/sys/block/sd$LetraDiscoSATA/" ]]; then
         ArrayDiscosSATA[$LetraDiscoSATA]=$(echo "sd$LetraDiscoSATA")
       fi
     done

echo ""
echo "  Mostrando estado de salud de todos los discos SSD SATA instalados en el sistema (Total: ${#ArrayDiscosSATA[@]})..."

## Comprobar si el paquete hddtemp está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s hddtemp 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  hddtemp no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install hddtemp
     echo ""
   fi


for DiscoSATA in "${ArrayDiscosSATA[@]}"
  do
    echo ""
    echo "    Disco /dev/$DiscoSATA"
    echo ""
    hddtemp /dev/$DiscoSATA
  done

