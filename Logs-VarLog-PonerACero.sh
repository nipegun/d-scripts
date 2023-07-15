#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para poner a cero todos los logs de /var/log
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Logs-VarLog-PonerACero.sh | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}" >&2
    exit 1
  fi

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para poner a cero todos los logs de /var/log/ ...${cFinColor}"
  echo ""

# Borrar archivos comprimidos de logs viejos y otros archivos ya innecesarios
  echo ""
  echo "    Borrando archivos comprimidos de logs viejos y otros archivos ya innecesarios..." 
echo ""
  find /var/log/ -type f -name "*.gz" -print -exec rm {} \;
  for vExt in {0..100}
    do
      find /var/log/ -type f -name "*.$vExt" -print -exec rm {} \;
      find /var/log/ -type f -name "*.$vExt.log" -print -exec rm {} \;
      find /var/log/ -type f -name "*.old" -print -exec rm {} \;
    done

# Truncar todos los logs activos
  echo ""
  echo "    Truncando a cero todos los logs activos..." 
echo ""
  find /var/log/ -type f -print -exec truncate -s 0 {} \;

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorVerde}    Ejecución del script, finalizada.${cFinColor}"
  echo ""

# Listar el contenido de la carpeta /var/log
  echo ""
  echo "    Estado en el que quedaron los logs de /var/log/:"
  echo ""
  ls -n /var/log/
  echo ""

