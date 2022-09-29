#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para modificar URLs de items de Heimdall desde Bash
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Heimdal-Items-Modificar-URL.sh | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/Heimdal-Items-Modificar-URL.sh | bash
# ----------

# Comprobar que sqlite3 esté instalado
  if [[ $(dpkg-query -s sqlite3 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}sqlite3 no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update && apt-get -y install sqlite3
    echo ""
  fi

# Modificar URL
sqlite3 /var/www/heimdall/database/app.sqlite << EOF
select url from items where url like "%9091%";
update items
set url = 'http://192.168.1.202:9091/transmission/web/'
where url = 'http://192.168.1.205:9091/transmission/web/';
select url from items where url like "%9091%";
EOF

