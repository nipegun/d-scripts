#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------
#  Script de NiPeGun para borrar el rastro de acceso a un sistema
#------------------------------------------------------------------

ColorVerde="\033[1;32m"
ColorAzul="\033[0;34m" 
FinColor="\033[0m"

echo ""
echo -e "${ColorVerde}-----------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Iniciando el script de borrado de rastro...${FinColor}"
echo -e "${ColorVerde}-----------------------------------------------${FinColor}"
echo ""

echo ""
echo -e "${ColorVerde}  Borrando todos los logs de /var/log...${FinColor}"
echo ""

   ## Borrar archivos sobrantes
      find /var/log/ -type f -name "*.gz" -print -exec rm {} \;
      for ContExt in {0..100}
        do
          find /var/log/ -type f -name "*.$ContExt"     -print -exec rm {} \;
          find /var/log/ -type f -name "*.$ContExt.log" -print -exec rm {} \;
          find /var/log/ -type f -name "*.old"          -print -exec rm {} \;
        done

   ## Poner a cero todos los logs de /var/log
      find /var/log/ -type f -print -exec truncate -s 0 {} \;

echo ""
echo -e "${ColorVerde}  Borrando todos los historiales de comandos...${FinColor}"
echo ""

  ## Comandos ejecutados por el root
     find /root/ -type f -name ".bash_history" -print -exec truncate -s 0 {} \;

  ## Comandos ejecutados por otros usuarios
     find /home/ -type f -name ".bash_history" -print -exec truncate -s 0 {} \;

  ## Este propio script
     history -c

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

echo ""
echo -e "${ColorVerde}----------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Script finalizado. Vuelve a ejecutar:${FinColor}"
echo ""
echo -e "${ColorVerde}history -c${FinColor}"
echo ""
echo -e "${ColorVerde}manualmente para borrar la ejecución de este script.${FinColor}"
echo -e "${ColorVerde}----------------------------------------------------${FinColor}"
echo ""

