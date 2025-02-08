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

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de actualización de PortainerCE en el DockerCE de Debian...${cFinColor}"
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
