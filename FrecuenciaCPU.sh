#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para mostrar en tiempo real la frecuencia de los diferentes núcleos del procesador
#--------------------------------------------------------------------------------------------------------

echo ""
echo "Mostrando la frecuencia a la que están trabajando los núcleos de la CPU..."
echo ""
echo "Toca CTRL + C para salir."
echo ""
watch grep \"cpu MHz\" /proc/cpuinfo

