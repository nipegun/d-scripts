#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para modificar URLs de items de Heimdall desde Bash
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Heimdall-Items-Modificar-URL.sh | bash
#
# Ejecución remota sin caché:
#  curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/Heimdall-Items-Modificar-URL.sh | bash
# ----------

vURLVieja="'http://192.168.1.205:9091/transmission/web/'"
vURLNueva="'http://192.168.1.202:9091/transmission/web/'"

# Comprobar que sqlite3 esté instalado
  if [[ $(dpkg-query -s sqlite3 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}sqlite3 no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update && apt-get -y install sqlite3
    echo ""
  fi

# Mostrar campo con URL vieja
  echo ""
  echo "Mostrando campos con URL vieja... ($vURLVieja)"
  echo ""
sqlite3 /var/www/heimdall/database/app.sqlite << EOF
select url from items where url like '%$vURLVieja%';
EOF

# Modificar URL
  echo ""
  echo "Modificando URL..." 
echo ""
  echo "  Cambiando $vURLVieja"
  echo ""
  echo "  por"
  echo ""
  echo "  Cambiando $vURLNueva"
  echo ""
sqlite3 /var/www/heimdall/database/app.sqlite << EOF
update items
set url = $vURLNueva
where url = $vURLVieja;
EOF


#select url from items where url like "%9091%";

# Mostrar campo con URL nueva
  echo ""
  echo "Mostrando campos con URL nueva... ($vURLNueva)"
  echo ""
sqlite3 /var/www/heimdall/database/app.sqlite << EOF
select url from items where url like '%$vURLNueva%';
EOF

