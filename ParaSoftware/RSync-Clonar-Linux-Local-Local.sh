#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para clonar un linux con RSync en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/RSync-Clonar-Linux-Local-Local.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/RSync-Clonar-Linux-Local-Local.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/RSync-Clonar-Linux-Local-Local.sh | nano -
# ----------

vCarpetaLinuxOrigen='/mnt/ibpve1PartLocal/'     # La / final es mandatoria
vCarpetaLinuxDestino='/mnt/ibpve1PartLocalExt/' # La / final es mandatoria

echo ""
echo "  Intentando clonación con RSync..."
echo "    Origen: $vCarpetaLinuxOrigen"
echo "    Destino: $vCarpetaLinuxDestino"
echo ""

#sudo nice -n 19 ionice -c3 rsync -aAXHv --numeric-ids --info=progress2 --bwlimit=10M \
#sudo rsync -aAXHv --numeric-ids --info=progress2 --bwlimit=40M \
sudo rsync -aAXHv --numeric-ids --info=progress2 \
  --exclude='/dev/*'                             \
  --exclude='/proc/*'                            \
  --exclude='/sys/*'                             \
  --exclude='/run/*'                             \
  --exclude='/tmp/*'                             \
  --exclude='/mnt/*'                             \
  --exclude='/media/*'                           \
  --exclude='/lost+found'                        \
  "$vCarpetaLinuxOrigen" "$vCarpetaLinuxDestino"
