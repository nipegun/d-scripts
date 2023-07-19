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
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando script para crear el script de copia de seguridad interna...${cFinColor}"
  echo ""

# Crear carpeta
  mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null

# Crear el archivo de log
  touch /var/log/CopSegInt.log 2> /dev/null

# Crear archivo
  echo '#!/bin/bash'                                                  > /root/scripts/ParaEsteDebian/CopSegInt.sh
  echo ""                                                            >> /root/scripts/ParaEsteDebian/CopSegInt.sh
  echo "# Guardar la fecha de ejecución del script en una constante" >> /root/scripts/ParaEsteDebian/CopSegInt.sh
  echo '  cFechaEjecScript=$(date +a%Ym%md%d@%T)'                    >> /root/scripts/ParaEsteDebian/CopSegInt.sh
  echo "" >> /root/scripts/ParaEsteDebian/CopSegInt.sh
  echo "" >> /root/scripts/ParaEsteDebian/CopSegInt.sh
  echo "" >> /root/scripts/ParaEsteDebian/CopSegInt.sh
  echo "" >> /root/scripts/ParaEsteDebian/CopSegInt.sh
  echo "" >> /root/scripts/ParaEsteDebian/CopSegInt.sh
  echo "" >> /root/scripts/ParaEsteDebian/CopSegInt.sh
  echo "# Loguear la ejecución del script el /var/log/CopSegInt.log" >> /root/scripts/ParaEsteDebian/CopSegInt.sh
  echo '  echo $cFechaEjecScript >> /var/log/CopSegInt.log'          >> /root/scripts/ParaEsteDebian/CopSegInt.sh
                
# Dar permisos de ejecución al script
  chmod +x /root/scripts/ParaEsteDebian/CopSegInt.sh
  
