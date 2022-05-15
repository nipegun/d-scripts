#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para poner a cero todos los logs de /var/log
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Logs-Todos-PonerACero.sh | bash
# ----------

echo ""
echo -e "${ColorVerde}  Poniendo a cero todos los achivos de logs que se encuentren en las carpetas de todo el sistema...${FinColor}"
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

echo ""
echo -e "${ColorVerde}  Borrando todos los achivos comprimidos de logs que se encuentren en las carpetas de todo el sistema...${FinColor}"
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

