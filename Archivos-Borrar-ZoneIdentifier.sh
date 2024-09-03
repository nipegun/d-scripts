#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para BORRAR LOS ARCHIVOS QUE CONTENGAN EL TEXTO
#  Zone.Identifier
#  DEL DISCO DE SISTEMA DEBIAN Y DE TODOS LOS VOLÚMENES MONTADOS
#
#  DICHOS ARCHIVOS SON GENERADOS POR WINDOWS PARA IDENTIFICAR ARCHIVOS
#  DESCARGADOS DESDE INTERNET
# ----------

echo ""
echo "  Borrando de todo el sistema y volúmenes montados todos los archivos que contengan Zone.Identifier en el nombre ..."
echo ""
find / -type f -name "*Zone.Identifier*" -print -exec rm -f {} \;

