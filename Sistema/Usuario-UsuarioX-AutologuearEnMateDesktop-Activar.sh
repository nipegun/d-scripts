#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para activar el logueo automático del usuariox en mate-desktop
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Usuario-UsuarioX-AutologuearEnMateDesktop-Activar.sh | bash
# ----------

sed -i -e 's|#autologin-user=|autologin-user=usuariox|g'           /etc/lightdm/lightdm.conf
sed -i -e 's|#autologin-user-timeout=0|autologin-user-timeout=2|g' /etc/lightdm/lightdm.conf

