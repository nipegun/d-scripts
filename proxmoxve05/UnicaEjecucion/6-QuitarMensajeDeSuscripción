#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para quitar el mensaje de suscripción no válida al conectarse a la web de administración de ProxmoxVE
#---------------------------------------------------------------------------------------------------------------------------

sed -i.bak 's|status => "NotFound",|status => "Active",|g' /usr/share/perl5/PVE/API2/Subscription.pm
systemctl restart pveproxy.service

