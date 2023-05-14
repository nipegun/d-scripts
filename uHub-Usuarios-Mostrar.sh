 #!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para agregar usuarios a uHub
# ----------

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Comprobar si el paquete sqlite3 está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s sqlite3 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}  El paquete sqlite3 no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install sqlite3
    echo ""
  fi

# Comprobar estado de la base de datos
  echo ""
  echo "  Comprobando estado de la base de datos..."
  echo ""
  vEstadoDeLaBaseDeDatosDeUHUB=$(sqlite3 /etc/uhub/users.db "PRAGMA integrity_check;")

# Mostrar usuarios
  if [ $vEstadoDeLaBaseDeDatosDeUHUB == "ok" ]; then
    echo ""
    echo -e "${vColorVerde}    El estado de la base de datos es consistente. Mostrando usuarios..."
    echo ""
    sqlite3 -column -header /etc/uhub/users.db "select * from users;"
  else
    echo ""
    echo -e "${vColorRojo}    El estado de la base de datos no es consistente. Intentando mostrar lo que se pueda...${vFinColor}"
    echo ""
    cat /etc/uhub/users.db
  fi

