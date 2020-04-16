#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA PREPARAR UN ORDENADOR O SERVIDOR CON DEBIAN 9
#  RECIÉN INSTALADO Y DEJARLO A GUSTO DE NIPEGUN
#------------------------------------------------------------------------

/root/scripts/d-scripts/ÚnicaEjecución/debian09/1-ViejaNomencaturaDeEthernet.sh

/root/scripts/d-scripts/ÚnicaEjecución/debian09/2-PonerNombresViejosAInterfacesDeRed.sh

/root/scripts/d-scripts/ÚnicaEjecución/debian09/3-PrepararTareasCron.sh

/root/scripts/d-scripts/ÚnicaEjecución/debian09/4-PrepararComandosPostArranque.sh

/root/scripts/d-scripts/ÚnicaEjecución/debian09/5-PonerRepositoriosCompletos.sh

echo "mc /root /root" > /root/scripts/MidnightCommander.sh
chmod +x /root/scripts/MidnightCommander.sh

/root/scripts/d-scripts/ActualizarSistemaOperativo.sh

apt-get -y install mc

shutdown -r now
