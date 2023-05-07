#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar sacar al usuario que ejecute el comando, de la sesión de mate-desktop en la que está logueado
#
# Ejecución remota:
#   curl -s x | bash
# ----------

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Definir quién es el usuario que está ejecutando el comando
  vUsuario="$USER"

# Sacar al usuario de la sesión abierta de mate-desktop
  echo ""
  echo -e "${vColorAzulClaro}  Cerrando la sesión de mate-desktop del usuario $vUsuario...${vFinColor}"
  echo ""
  mate-session-save --logout

