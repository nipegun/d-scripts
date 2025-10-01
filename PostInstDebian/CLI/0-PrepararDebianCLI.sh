#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para preparar Debian sin entorno gráfico a gusto de NiPeGun
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/CLI/0-PrepararDebianCLI.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/CLI/0-PrepararDebianCLI.sh | sed 's-sudo--g' | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando script para preparar Debian sin entorno gráfico a gusto de NiPeGun...${cFinColor}"
  echo ""

# Preparar ComandosPostArranque (rc.local)
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/CLI/ComandosPostArranque-Preparar.sh | sed 's-sudo--g' | bash

# Preparar tareas Cron
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/CLI/TareasCron-Preparar.sh | sed 's-sudo--g' | bash

# Preparar cortafuegos
  #curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/CLI/Cortafuegos-Preparar.sh | sed 's-sudo--g' | bash

# Poner idioma sólo en español
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/CLI/Idioma-CambiarTodoAes-es.sh | sed 's-sudo--g' | bash

# Poner todos los repositorios
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/CLI/Repositorios-Todos-Poner.sh | sed 's-sudo--g' | bash

# Modificar .bashrc a nivel de sistema
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/CLI/ModificarElBashRCPorDefecto.sh | sed 's-sudo--g' | bash

# Instalar d-scripts
  apt-get -y update
  apt-get -y install curl
  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/DScripts-Sincronizar.sh | bash
  sh -c "echo 'export PATH=$PATH:~/scripts/d-scripts/Alias/' >> ~/.bashrc"

