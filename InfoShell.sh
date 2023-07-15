#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ------------
#  Script de NiPeGun para mostrar si el shell que se está ejecutando es completo de login o no
# ------------

echo ""
shopt -q login_shell && echo 'Shell login. Variables de entorno del usuario cargadas' || echo "Shell no-login. variables de entorno del usuario NO cargadas."
echo ""
