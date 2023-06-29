#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para poner a cero todos los logs de /var/log
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Logs-Todos-PonerACero.sh | bash
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
  echo -e "${vColorAzulClaro}  Poniendo a cero todos los achivos de logs de todo el sistema... ...${vFinColor}"
  echo ""

# Borrar archivos comprimidos de logs viejos
  echo ""
  echo "    Borrando archivos comprimidos de logs viejos..."
  echo ""
  find /bin/        -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;
  find /boot/       -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;
  find /dev/        -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;
  find /etc/        -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;
  find /home/       -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;
  find /lib/        -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;
  find /lib64/      -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;
  find /lost+found/ -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;
  find /media/      -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;
  find /mnt/        -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;
  find /opt/        -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;
  find /root/       -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;
  find /run/        -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;
  find /sbin/       -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;
  find /srv/        -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;
  find /tmp/        -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;
  find /usr/        -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;
  find /var/        -type f -name "*.log.gz" -print -exec truncate -s 0 {} \;

# Truncar logs activos
  echo ""
  echo "    Truncando archivos de logs activos..."
  echo ""
  find /bin/        -type f -name "*.log" -print -exec truncate -s 0 {} \;
  find /boot/       -type f -name "*.log" -print -exec truncate -s 0 {} \;
  find /dev/        -type f -name "*.log" -print -exec truncate -s 0 {} \;
  find /etc/        -type f -name "*.log" -print -exec truncate -s 0 {} \;
  find /home/       -type f -name "*.log" -print -exec truncate -s 0 {} \;
  find /lib/        -type f -name "*.log" -print -exec truncate -s 0 {} \;
  find /lib64/      -type f -name "*.log" -print -exec truncate -s 0 {} \;
  find /lost+found/ -type f -name "*.log" -print -exec truncate -s 0 {} \;
  find /media/      -type f -name "*.log" -print -exec truncate -s 0 {} \;
  find /mnt/        -type f -name "*.log" -print -exec truncate -s 0 {} \;
  find /opt/        -type f -name "*.log" -print -exec truncate -s 0 {} \;
  find /root/       -type f -name "*.log" -print -exec truncate -s 0 {} \;
  find /run/        -type f -name "*.log" -print -exec truncate -s 0 {} \;
  find /sbin/       -type f -name "*.log" -print -exec truncate -s 0 {} \;
  find /srv/        -type f -name "*.log" -print -exec truncate -s 0 {} \;
  find /tmp/        -type f -name "*.log" -print -exec truncate -s 0 {} \;
  find /usr/        -type f -name "*.log" -print -exec truncate -s 0 {} \;
  find /var/        -type f -name "*.log" -print -exec truncate -s 0 {} \;

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${vColorVerde}    Ejecución del script, finalizada.${vFinColor}"
  echo ""

