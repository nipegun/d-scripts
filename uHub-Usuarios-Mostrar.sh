#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para mostrar los usuarios de la base de datos del servidor uHub
# ----------

# Definir variables de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Comprobar si el paquete sqlite3 está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s sqlite3 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete sqlite3 no está instalado. Iniciando su instalación...${cFinColor}"
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
    echo -e "${cColorVerde}    El estado de la base de datos es consistente. Mostrando usuarios...${cFinColor}"
    echo ""
    sqlite3 -column -header /etc/uhub/users.db "select * from users;"
    echo ""
  else
    echo ""
    echo -e "${cColorRojo}    El estado de la base de datos no es consistente. Intentando mostrar lo que se pueda...${cFinColor}"
    echo ""
    cat /etc/uhub/users.db
    echo ""
  fi

