#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para BORRAR LOS ARCHIVOS que empiecen por ._
#  DEL DISCO DE SISTEMA DEBIAN Y DE TODOS LOS VOLÚMENES MONTADOS
# ----------

cd /

echo ""
echo "-----------------------------------------------------"
echo "  Borrando de todo el sistema y volúmenes montados"
echo "  todos los archivos cuyos nombres comienzan por ._"
echo "-----------------------------------------------------"
echo ""
find . -type f -name "._*" -print -exec rm -f {} \;
echo ""

echo "  Archivos borrados del sistema y volúmenes montados"

echo ""

