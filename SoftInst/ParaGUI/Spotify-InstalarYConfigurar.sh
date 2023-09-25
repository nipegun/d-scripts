#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar el cliente Spotify en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Spotify-InstalarYConfigurar.sh | bash
#
# Ejecución remota sin caché:
#  curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Spotify-InstalarYConfigurar.sh | bash
#
# Ejecución remota con parámetros:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Spotify-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Notificar el inicio de la ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Spotify en Debian...${cFinColor}"
  echo ""

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo ""
    echo -e "${cColorRojo}    Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    echo ""
    exit
  fi

# Agregar el repositorio
  echo ''
  echo '    Agregando el repositorio...'
  echo ''
  echo 'deb http://repository.spotify.com stable non-free' >> /etc/apt/sources.list.d/spotify.list

# Agregar la clave para firmar el repositorio
  echo ''
  echo '    Agregando la clave para firmar el repositorio...'
  echo ''
  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install curl
      echo ""
    fi
    curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg >> /tmp/Spotify.gpg

# Convertir la clave al formato apt
  echo ''
  echo '    Convirtiendo la clave al formato apt...'
  echo ''
  # Comprobar si el paquete gpg está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s gpg 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}      El paquete gpg no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install gpg
      echo ""
    fi
  gpg --yes -o /etc/apt/trusted.gpg.d/spotify.gpg --dearmor /tmp/Spotify.gpg

# Actualizar la lista de los paquetes disponibles en los repositorios instalados
  echo ''
  echo '    Actualizando la lista de los paquetes disponibles en los repositorios instalados...'
  echo ''
  apt-get -y update

# Instalar el paquete
  echo ''
  echo '    Instalando el paquete...'
  echo ''
  apt-get -y install spotify-client

