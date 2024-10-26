#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para borrar el rastro de acceso a un sistema
# ----------

# ----------
# Ejecución remota:
#
#  curl --silent https://raw.githubusercontent.com/nipegun/d-scripts/master/BorrarRastro.sh | bash
# ----------

cColorVerde="\033[1;32m"
ColorAzul="\033[0;34m" 
cFinColor="\033[0m"

echo ""
echo -e "${cColorVerde}  Iniciando el script de borrado de rastro...${cFinColor}"
echo ""

echo ""
echo -e "${cColorVerde}  Borrando todos los logs de /var/log...${cFinColor}"
echo ""

   # Borrar archivos sobrantes
      find /var/log/ -type f -name "*.gz" -print -exec rm {} \;
      for ContExt in {0..100}
        do
          find /var/log/ -type f -name "*.$ContExt"     -print -exec rm {} \;
          find /var/log/ -type f -name "*.$ContExt.log" -print -exec rm {} \;
          find /var/log/ -type f -name "*.old"          -print -exec rm {} \;
        done

   # Poner a cero todos los logs de /var/log
      find /var/log/ -type f -print -exec truncate -s 0 {} \;

echo ""
echo -e "${cColorVerde}  Borrando todos los historiales de comandos...${cFinColor}"
echo ""

  # Comandos ejecutados en bash por el root
     find /root/ -type f -name ".bash_history" -print -exec truncate -s 0 {} \;
     find /root/ -type f -name ".zsh_history"  -print -exec truncate -s 0 {} \;

  # Comandos ejecutados en bash por otros usuarios
     find /home/ -type f -name ".bash_history" -print -exec truncate -s 0 {} \;
     find /home/ -type f -name ".zsh_history"  -print -exec truncate -s 0 {} \;

  # Comandos ejecutados en Midnight Commander por el root
     find /root/.local/share/mc/ -type f -name "history" -print -exec truncate -s 0 {} \;

  # Este propio script
     history -c

echo ""
echo -e "${cColorVerde}  Poniendo a cero todos los achivos de logs que se encuentren en las carpetas de todo el sistema...${cFinColor}"
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
echo -e "${cColorVerde}  Borrando todos los achivos comprimidos de logs que se encuentren en las carpetas de todo el sistema...${cFinColor}"
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

echo ""
echo -e "${cColorVerde}  Script finalizado. Vuelve a ejecutar:${cFinColor}"
echo ""
echo -e "${cColorVerde}    history -c${cFinColor}"
echo ""
echo -e "${cColorVerde}    manualmente para borrar la ejecución de este script.${cFinColor}"
echo ""

