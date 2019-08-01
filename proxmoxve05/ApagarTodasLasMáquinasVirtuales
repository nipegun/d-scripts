#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------
#  Script de NiPeGun para apagar todas las máquinas virtuales
#--------------------------------------------------------------

mvini=200
mvfin=255

for vmid in $(seq $mvini $mvfin);
  do
    echo ""
    echo "  Apagando la máquina $vmid..."
    qm shutdown $vmid
    echo "  Estado de la MV $vmid:"
    qm status $vmid
  done
  
  
