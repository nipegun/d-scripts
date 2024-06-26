#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para actualizar PortainerCE en el DockerCE de Debian
#
# Ejecución remota
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/DockerCE-Contenedor-Actualizar-PortainerCE.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD)
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de actualización de PortainerCE en el DockerCE de Debian 7 (Wheezy)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de actualización de PortainerCE en el DockerCE de Debian 8 (Jessie)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de actualización de PortainerCE en el DockerCE de Debian 9 (Stretch)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de actualización de PortainerCE en el DockerCE de Debian 10 (Buster)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de actualización de PortainerCE en el DockerCE de Debian 11 (Bullseye)..."
  echo ""

  echo ""
  echo "    Obteniendo el nombre del contenedor de Portainer..."
  echo ""
  vNombreContenedorContainer=$(docker container ls | grep ortainer | rev | cut -d' ' -f1 | rev)
  echo "      El nombre es: $vNombreContenedorContainer."

  echo ""
  echo "    Deteniendo el contenedor con nombre $vNombreContenedorContainer..."
  echo ""
  docker stop $vNombreContenedorContainer

  echo ""
  echo "    Borrando el contenedor con nombre $vNombreContenedorContainer..."
  echo ""
  docker rm $vNombreContenedorContainer

  echo ""
  echo "    Descargando la última versión del contenedor de portainer..."
  echo ""
  docker pull cr.portainer.io/portainer/portainer-ce

  echo ""
  echo "    Volviendo a iniciar portainer..."
  echo ""
  /root/scripts/ParaEsteDebian/DockerCE-Cont-PortainerCE-Iniciar.sh

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de actualización de PortainerCE en el DockerCE de Debian 12 (Bookworm)..."
  echo ""

  echo ""
  echo "    Obteniendo el nombre del contenedor de Portainer..."
  echo ""
  vNombreContenedorContainer=$(docker container ls | grep ortainer | rev | cut -d' ' -f1 | rev)
  echo "      El nombre es: $vNombreContenedorContainer."

  echo ""
  echo "    Deteniendo el contenedor con nombre $vNombreContenedorContainer..."
  echo ""
  docker stop $vNombreContenedorContainer

  echo ""
  echo "    Borrando el contenedor con nombre $vNombreContenedorContainer..."
  echo ""
  docker rm $vNombreContenedorContainer

  echo ""
  echo "    Descargando la última versión del contenedor de portainer..."
  echo ""
  docker pull cr.portainer.io/portainer/portainer-ce

  echo ""
  echo "    Volviendo a iniciar portainer..."
  echo ""
  /root/scripts/ParaEsteDebian/DockerCE-Cont-PortainerCE-Iniciar.sh

fi
