#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para preparar Debian sin entorno gráfico a gusto de NiPeGun
#
# Ejecución remota:
#   curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/0-PrepararDebianCLI.sh | bash
# ----------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

# Preparar ComandosPostArranque (rc.local)
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/ComandosPostArranque-Preparar.sh | bash

# Preparar tareas Cron
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/TareasCron-Preparar.sh | bash

# Preparar cortafuegos
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/Cortafuegos-Preparar.sh | bash

# Poner idioma sólo en español
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/Idioma-CambiarTodoAes-es.sh | bash

# Poner todos los repositorios
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/Repositorios-PonerTodos.sh | bash

