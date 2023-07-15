#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para desactivar el logueo automático del usuariox en mate-desktop
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Usuario-UsuarioX-AutologuearEnMateDesktop-Desactivar.sh | bash
# ----------

sed -i -e 's|autologin-user=usuariox|#autologin-user=|g'           /etc/lightdm/lightdm.conf
sed -i -e 's|autologin-user-timeout=2|#autologin-user-timeout=0|g' /etc/lightdm/lightdm.conf

