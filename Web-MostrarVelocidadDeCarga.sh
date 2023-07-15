#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para MEDIR LA VELOCIDAD DE CARGA DE UNA WEB (via eduardocollado.com)
# ----------

cCantArgumEsperados=1


if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""

    echo "Se le debe pasar un (único) parámetro al script."
    echo ""
    echo "El uso correcto sería: MostrarVelocidadDeCargaDeWeb [URLDeLaWeb]"
    echo ""
    echo "Ejemplo:"
    echo ' MostrarVelocidadDeCargaDeWeb http://nipegun.com'

    echo ""
    exit
  else
    curl -sL -w '\nMostrando velocidad de carga de la web %{url_effective}\n\nTiempo consulta DNS:\t\t\t%{time_namelookup}s\nTiempo hasta conectar:\t\t\t%{time_connect}s\nAppCon Time:\t\t\t\t%{time_appconnect}s\nTiempo de redirección:\t\t\t%{time_redirect}s\nPre-transfer Time:\t\t\t%{time_pretransfer}s\nStart-transfer Time:\t\t\t%{time_starttransfer}\nVelocidad de descarga (bytes/sec):\t%{speed_download}\nTamaño descargado (bytes):\t\t%{size_download}\n\nTiempo total:\t\t\t\t%{time_total}\n' -o /dev/null $1
fi

