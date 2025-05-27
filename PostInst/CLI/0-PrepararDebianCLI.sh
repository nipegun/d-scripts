#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para preparar Debian sin entorno gráfico a gusto de NiPeGun
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/0-PrepararDebianCLI.sh | bash
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
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/ComandosPostArranque-Preparar.sh | bash

# Preparar tareas Cron
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/TareasCron-Preparar.sh | bash

# Preparar cortafuegos
  #curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/Cortafuegos-Preparar.sh | bash

# Poner idioma sólo en español
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/Idioma-CambiarTodoAes-es.sh | bash

# Poner todos los repositorios
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/Repositorios-Todos-Poner.sh | sed 's-sudo--g' | bash

# Instalar d-scripts
  apt-get -y update
  apt-get -y install curl
  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/DScripts-Sincronizar.sh | bash
  sh -c "echo 'export PATH=$PATH:~/scripts/d-scripts/Alias/' >> ~/.bashrc"

# Modificar .bashrc a nivel de sistema
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInst/CLI/.bashrc >> /etc/bash.bashrc

