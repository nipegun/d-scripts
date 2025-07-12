#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para cambiar la fecha a todas las carpetas y archivos dentro de una carpeta dada
# ----------

vFechaDeseada=201701011010.10
vCarpeta="/var/tmp/"

find $vCarpeta -type d -print -exec touch -t $vFechaDeseada {} \;
find $vCarpeta -type f -print -exec touch -t $vFechaDeseada {} \;

