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

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script para poner a cero todos los logs de /var/log/ ...${vFinColor}"
  echo ""

# Borrar archivos sobrantes
  echo ""
  echo "    Borrando archivos sobrantes..."
  echo ""
  find /var/log/ -type f -name "*.gz" -print -exec rm {} \;
  for ContExt in {0..100}
    do
      find /var/log/ -type f -name "*.$ContExt" -print -exec rm {} \;
      find /var/log/ -type f -name "*.$ContExt.log" -print -exec rm {} \;
      find /var/log/ -type f -name "*.old" -print -exec rm {} \;
    done

# Truncar todos los logs activos
  echo ""
  echo "    Truncando a cero todos los logs activos..."
  echo ""
  find /var/log/ -type f -print -exec truncate -s 0 {} \;

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${vColorVerde}    Ejecución del script, finalizada.${vFinColor}"
  echo ""

# Listar el contenido de la carpeta /var/log
  echo ""
  echo "    Estado en el que quedaron los logs de /var/log/:"
  echo ""
  ls -n /var/log/
  echo ""

