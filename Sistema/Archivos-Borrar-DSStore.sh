#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para BORRAR LOS ARCHIVOS ._.DS_Store y .DS_Store
#  DEL DISCO DE SISTEMA DEBIAN Y DE TODOS LOS VOLÚMENES MONTADOS
# ----------

echo ""
echo "  Borrando de todo el sistema y volúmenes montados todos los archivos ._.DS_Store..."
echo ""
find / -type f -name "._.DS_Store" -print -exec rm -f {} \;

echo ""
echo "  Borrando de todo el sistema y volúmenes montados todos los archivos .DS_Store..."
echo ""
find / -type f -name ".DS_Store" -print -exec rm -f {} \;

