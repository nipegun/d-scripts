#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para poner a cero todos los logs de /var/log
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Logs-Todos-PonerACero.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Logs-Todos-PonerACero.sh | sed 's-sudo--g' | bash
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
  echo -e "${cColorAzulClaro}  Poniendo a cero todos los archivos de logs de todo el sistema... ...${cFinColor}"
  echo ""

# Borrar archivos comprimidos de logs viejos
  echo ""
  echo "    Borrando archivos comprimidos de logs viejos..." 
  echo ""
  find /bin/        -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \;
  find /boot/       -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \;
  find /dev/        -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \; 2> /dev/null
  find /etc/        -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \;
  find /home/       -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \;
  find /lib/        -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \;
  find /lib64/      -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \;
  find /lost+found/ -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \; 2> /dev/null
  find /media/      -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \;
  find /mnt/        -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \;
  find /opt/        -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \;
  find /root/       -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \;
  find /run/        -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \;
  find /sbin/       -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \;
  find /srv/        -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \;
  find /tmp/        -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \;
  find /usr/        -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \;
  find /var/        -type f -name "*.log.gz" -print -exec sudo truncate -s 0 {} \;

# Truncar logs activos
  echo ""
  echo "    Truncando archivos de logs activos..." 
  echo ""
  find /bin/        -type f -name "*.log" -print -exec sudo truncate -s 0 {} \;
  find /boot/       -type f -name "*.log" -print -exec sudo truncate -s 0 {} \;
  find /dev/        -type f -name "*.log" -print -exec sudo truncate -s 0 {} \; 2> /dev/null
  find /etc/        -type f -name "*.log" -print -exec sudo truncate -s 0 {} \;
  find /home/       -type f -name "*.log" -print -exec sudo truncate -s 0 {} \;
  find /lib/        -type f -name "*.log" -print -exec sudo truncate -s 0 {} \;
  find /lib64/      -type f -name "*.log" -print -exec sudo truncate -s 0 {} \;
  find /lost+found/ -type f -name "*.log" -print -exec sudo truncate -s 0 {} \; 2> /dev/null
  find /media/      -type f -name "*.log" -print -exec sudo truncate -s 0 {} \;
  find /mnt/        -type f -name "*.log" -print -exec sudo truncate -s 0 {} \;
  find /opt/        -type f -name "*.log" -print -exec sudo truncate -s 0 {} \;
  find /root/       -type f -name "*.log" -print -exec sudo truncate -s 0 {} \;
  find /run/        -type f -name "*.log" -print -exec sudo truncate -s 0 {} \;
  find /sbin/       -type f -name "*.log" -print -exec sudo truncate -s 0 {} \;
  find /srv/        -type f -name "*.log" -print -exec sudo truncate -s 0 {} \;
  find /tmp/        -type f -name "*.log" -print -exec sudo truncate -s 0 {} \;
  find /usr/        -type f -name "*.log" -print -exec sudo truncate -s 0 {} \;
  find /var/        -type f -name "*.log" -print -exec sudo truncate -s 0 {} \;

# Vaciar journal
  echo ""
  echo ""
  echo ""
  find /var/        -type f -name "*.journal" -print -exec sudo truncate -s 0 {} \;

# Notificar fin de ejecución del script
  echo ""
  echo -e "${cColorVerde}    Ejecución del script, finalizada.${cFinColor}"
  echo ""

