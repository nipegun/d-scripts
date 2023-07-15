#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para comprobar el estado de salud de los discos duros SSD SATA
# ----------

cColorVerde="\033[1;32m"
cFinColor="\033[0m"

echo ""
echo -e "${cColorVerde}  Mostrando información de salud de discos SSD SATA...${cFinColor}"
echo ""

echo ""
echo "  Identificando que discos SATA son SSD..."echo ""

# Obtener la cantidad de discos SSD SATA que hay instalados en el sistema
   for LetraDiscoSATA in {a..x}
     do
       if [[ $(cat /sys/block/sd$LetraDiscoSATA/queue/rotational 2> /dev/null) == "0" ]]; then
         echo "    El disco /dev/sd$LetraDiscoSATA es un SSD"
         ArrayDiscosSSDSATA[$LetraDiscoSATA]=$(echo "sd$LetraDiscoSATA")
       fi
     done

echo ""
echo "  Mostrando estado de salud de todos los discos SSD SATA instalados en el sistema (Total: ${#ArrayDiscosSSDSATA[@]})..."
# Comprobar si el paquete hdparm está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s hdparm 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "hdparm no está instalado. Iniciando su instalación..."     echo ""
     apt-get -y update
     apt-get -y install hdparm
     echo ""
   fi


for DiscoSSD in "${ArrayDiscosSSDSATA[@]}"
  do
    echo ""
    echo "    Disco /dev/$DiscoSSD"
    echo ""
    hdparm -I /dev/$DiscoSSD | grep odel
    smartctl /dev/$DiscoSSD --all | grep "ector" | grep -v "eall"
    # Mostrar el último campo de 241
    echo "GiB escritos: " && smartctl /dev/$DiscoSSD --all | grep 241 | awk '{print $(NF)}'
    echo ""
  done
  
