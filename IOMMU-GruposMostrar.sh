#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para mostrar el aislamiento/agrupamiento IOMMU en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/IOMMU-GruposMostrar.sh | bash
# ----------

echo ""
echo "-------------------------------------------"
echo " Grupos IOMMU disponibles en el sistema:"
echo "-------------------------------------------"
echo ""

for iommu_group in $(find /sys/kernel/iommu_groups/ -maxdepth 1 -mindepth 1 -type d);
  do echo "" && echo "Grupo IOMMU $(basename "$iommu_group")";

for device in $(ls -1 "$iommu_group"/devices/);
  do echo -n $t; lspci -nns "$device"; done; done

echo ""

