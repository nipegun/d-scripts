#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA PREPARAR UN ORDENADOR O SERVIDOR CON DEBIAN 9
#  RECIÉN INSTALADO Y DEJARLO A GUSTO DE NIPEGUN
#------------------------------------------------------------------------

/root/nipe-scripts/debian09/UnicaEjecucion/1-ViejaNomencaturaDeEthernet

/root/nipe-scripts/debian09/UnicaEjecucion/2-PonerNombresViejosAInterfacesDeRed

/root/nipe-scripts/debian09/UnicaEjecucion/3-PrepararTareasCron

/root/nipe-scripts/debian09/UnicaEjecucion/4-PrepararComandosPostArranque

/root/nipe-scripts/debian09/UnicaEjecucion/5-PonerRepositoriosCompletos

echo "mc /root /root" > /root/MidnightCommander
chmod +x /root/MidnightCommander

/root/nipe-scripts/debian09/ActualizarSistemaOperativo

apt-get -y install mc

shutdown -r now
