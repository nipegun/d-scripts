#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para enviar los commits locales a su repo correspondiente en Internet usando Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/Git-Empujar-CarpetaActual.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/Git-Empujar-CarpetaActual.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/Git-Empujar-CarpetaActual.sh | nano -
# ----------

# Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install git
    echo ""
  fi

 # Añadir todos los archivos nuevos o modificados del directorio actual al staging area (preparar para el commit).
  git add .

# Crear un commit con los cambios que estaban en el staging area, asignándole el mensaje "edición en local".
  git commit -m "Edición en local"

# Empujar los commits locales hacia repositorio remoto (subir los cambios al servidor).
  git push

