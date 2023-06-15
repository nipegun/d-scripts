#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para preparar las tareas cron
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/TareasCron-Preparar.sh | bash
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

echo ""
echo "  Creando el archivo para las tareas de cada minuto..."
echo ""
mkdir -p /root/scripts/EsteDebian/ 2> /dev/null
echo '#!/bin/bash'                                                                                                 > /root/scripts/EsteDebian/TareasCronCadaMinuto.sh
echo ""                                                                                                           >> /root/scripts/EsteDebian/TareasCronCadaMinuto.sh
echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                         >> /root/scripts/EsteDebian/TareasCronCadaMinuto.sh
echo 'echo "Iniciada la ejecución del cron de cada minuto el $vFechaDeEjec" >> /var/log/TareasCronCadaMinuto.log' >> /root/scripts/EsteDebian/TareasCronCadaMinuto.sh
echo ""                                                                                                           >> /root/scripts/EsteDebian/TareasCronCadaMinuto.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA MINUTO"                                         >> /root/scripts/EsteDebian/TareasCronCadaMinuto.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                       >> /root/scripts/EsteDebian/TareasCronCadaMinuto.sh
echo ""                                                                                                           >> /root/scripts/EsteDebian/TareasCronCadaMinuto.sh
echo ""
echo "    Dando permiso de ejecución al archivo..."
echo ""
chmod +x /root/scripts/EsteDebian/TareasCronCadaMinuto.sh
echo ""
echo "    Instalando la tarea en crontab..."
echo ""
crontab -l > /tmp/CronTemporal
echo "* * * * * /root/scripts/EsteDebian/TareasCronCadaMinuto.sh" >> /tmp/CronTemporal
crontab /tmp/CronTemporal
rm /tmp/CronTemporal

echo ""
echo "  Creando el archivo para las tareas de cada hora..."
echo ""
mkdir -p /root/scripts/EsteDebian/ 2> /dev/null
echo '#!/bin/bash'                                                                                             > /root/scripts/EsteDebian/TareasCronCadaHora.sh
echo ""                                                                                                       >> /root/scripts/EsteDebian/TareasCronCadaHora.sh
echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                     >> /root/scripts/EsteDebian/TareasCronCadaHora.sh
echo 'echo "Iniciada la ejecución del cron de cada hora el $vFechaDeEjec" >> /var/log/TareasCronCadaHora.log' >> /root/scripts/EsteDebian/TareasCronCadaHora.sh
echo ""                                                                                                       >> /root/scripts/EsteDebian/TareasCronCadaHora.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA"                                       >> /root/scripts/EsteDebian/TareasCronCadaHora.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                     >> /root/scripts/EsteDebian/TareasCronCadaHora.sh
echo ""                                                                                                       >> /root/scripts/EsteDebian/TareasCronCadaHora.sh
echo ""
echo "    Dando permiso de ejecución al archivo..."
echo ""
chmod +x /root/scripts/EsteDebian/TareasCronCadaHora.sh
echo ""
echo "    Creando enlace hacia el archivo en /etc/cron.hourly/ ..."
echo ""
ln -s /root/scripts/EsteDebian/TareasCronCadaHora.sh /etc/cron.hourly/TareasCronCadaHora

echo ""
echo "  Creando el archivo para las tareas de cada hora impar..."
echo ""
mkdir -p /root/scripts/EsteDebian/ 2> /dev/null
echo '#!/bin/bash'                                                                                                        > /root/scripts/EsteDebian/TareasCronCadaHoraImpar.sh
echo ""                                                                                                                  >> /root/scripts/EsteDebian/TareasCronCadaHoraImpar.sh
echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                                >> /root/scripts/EsteDebian/TareasCronCadaHoraImpar.sh
echo 'echo "Iniciada la ejecución del cron de cada hora impar el $vFechaDeEjec" >> /var/log/TareasCronCadaHoraImpar.log' >> /root/scripts/EsteDebian/TareasCronCadaHoraImpar.sh
echo ""                                                                                                                  >> /root/scripts/EsteDebian/TareasCronCadaHoraImpar.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA IMPAR"                                            >> /root/scripts/EsteDebian/TareasCronCadaHoraImpar.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                          >> /root/scripts/EsteDebian/TareasCronCadaHoraImpar.sh
echo ""                                                                                                                  >> /root/scripts/EsteDebian/TareasCronCadaHoraImpar.sh
echo ""
echo "    Dando permiso de ejecución al archivo..."
echo ""
chmod +x /root/scripts/EsteDebian/TareasCronCadaHoraImpar.sh
echo ""
echo "    Instalando la tarea en crontab..."
echo ""
crontab -l > /tmp/CronTemporal
echo "0 1-23/2 * * * /root/scripts/EsteDebian/TareasCronCadaHoraImpar.sh" >> /tmp/CronTemporal
crontab /tmp/CronTemporal
rm /tmp/CronTemporal

echo ""
echo "  Creando el archivo para las tareas de cada hora par..."
echo ""
mkdir -p /root/scripts/EsteDebian/ 2> /dev/null
echo '#!/bin/bash'                                                                                                    > /root/scripts/EsteDebian/TareasCronCadaHoraPar.sh
echo ""                                                                                                              >> /root/scripts/EsteDebian/TareasCronCadaHoraPar.sh
echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                            >> /root/scripts/EsteDebian/TareasCronCadaHoraPar.sh
echo 'echo "Iniciada la ejecución del cron de cada hora par el $vFechaDeEjec" >> /var/log/TareasCronCadaHoraPar.log' >> /root/scripts/EsteDebian/TareasCronCadaHoraPar.sh
echo ""                                                                                                              >> /root/scripts/EsteDebian/TareasCronCadaHoraPar.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA PAR"                                          >> /root/scripts/EsteDebian/TareasCronCadaHoraPar.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                        >> /root/scripts/EsteDebian/TareasCronCadaHoraPar.sh
echo ""                                                                                                              >> /root/scripts/EsteDebian/TareasCronCadaHoraPar.sh
echo ""
echo "    Dando permiso de ejecución al archivo..."
echo ""
chmod +x /root/scripts/EsteDebian/TareasCronCadaHoraPar.sh
echo ""
echo "    Instalando la tarea en crontab..."
echo ""
crontab -l > /tmp/CronTemporal
echo "0 */2 * * * /root/scripts/EsteDebian/TareasCronCadaHoraPar.sh" >> /tmp/CronTemporal
crontab /tmp/CronTemporal
rm /tmp/CronTemporal


echo ""
echo "  Creando el archivo para las tareas de cada día..."
echo ""
echo '#!/bin/bash'                                                                                           > /root/scripts/EsteDebian/TareasCronCadaDía.sh
echo ""                                                                                                     >> /root/scripts/EsteDebian/TareasCronCadaDía.sh
echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                   >> /root/scripts/EsteDebian/TareasCronCadaDía.sh
echo 'echo "Iniciada la ejecución del cron de cada día el $vFechaDeEjec" >> /var/log/TareasCronCadaDía.log' >> /root/scripts/EsteDebian/TareasCronCadaDía.sh
echo ""                                                                                                     >> /root/scripts/EsteDebian/TareasCronCadaDía.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA DÍA"                                      >> /root/scripts/EsteDebian/TareasCronCadaDía.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                    >> /root/scripts/EsteDebian/TareasCronCadaDía.sh
echo ""                                                                                                     >> /root/scripts/EsteDebian/TareasCronCadaDía.sh
echo ""
echo "    Dando permiso de ejecución al archivo..."
echo ""
chmod +x /root/scripts/TareasCronCadaDía.sh
echo ""
echo "    Creando enlace hacia el archivo en /etc/cron.daily/ ..."
echo ""
ln -s /root/scripts/EsteDebian/TareasCronCadaDía.sh /etc/cron.daily/TareasCronCadaDía

echo ""
echo "  Creando el archivo para las tareas de cada semana..."
echo ""
echo '#!/bin/bash'                                                                                                 > /root/scripts/EsteDebian/TareasCronCadaSemana.sh
echo ""                                                                                                           >> /root/scripts/EsteDebian/TareasCronCadaSemana.sh
echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                         >> /root/scripts/EsteDebian/TareasCronCadaSemana.sh
echo 'echo "Iniciada la ejecución del cron de cada semana el $vFechaDeEjec" >> /var/log/TareasCronCadaSemana.log' >> /root/scripts/EsteDebian/TareasCronCadaSemana.sh
echo ""                                                                                                           >> /root/scripts/EsteDebian/TareasCronCadaSemana.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA SEMANA"                                         >> /root/scripts/EsteDebian/TareasCronCadaSemana.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                       >> /root/scripts/EsteDebian/TareasCronCadaSemana.sh
echo ""                                                                                                           >> /root/scripts/EsteDebian/TareasCronCadaSemana.sh
echo ""
echo "    Dando permiso de ejecución al archivo..."
echo ""
chmod +x /root/scripts/EsteDebian/TareasCronCadaSemana.sh
echo ""
echo "    Creando enlace hacia el archivo en /etc/cron.weekly/ ..."
echo ""
ln -s /root/scripts/EsteDebian/TareasCronCadaSemana.sh /etc/cron.weekly/TareasCronCadaSemana

echo ""
echo "  Creando el archivo para las tareas de cada mes..."
echo ""
echo '#!/bin/bash'                                                                                           > /root/scripts/EsteDebian/TareasCronCadaMes.sh
echo ""                                                                                                     >> /root/scripts/EsteDebian/TareasCronCadaMes.sh
echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                   >> /root/scripts/EsteDebian/TareasCronCadaMes.sh
echo 'echo "Iniciada la ejecución del cron de cada mes el $vFechaDeEjec" >> /var/log/TareasCronCadaMes.log' >> /root/scripts/EsteDebian/TareasCronCadaMes.sh
echo ""                                                                                                     >> /root/scripts/EsteDebian/TareasCronCadaMes.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA MES"                                      >> /root/scripts/EsteDebian/TareasCronCadaMes.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                    >> /root/scripts/EsteDebian/TareasCronCadaMes.sh
echo ""                                                                                                     >> /root/scripts/EsteDebian/TareasCronCadaMes.sh
echo ""
echo "    Dando permiso de ejecución al archivo..."
echo ""
chmod +x /root/scripts/EsteDebian/TareasCronCadaMes.sh
echo ""
echo "    Creando enlace hacia el archivo en /etc/cron.monthly/ ..."
echo ""
ln -s /root/scripts/EsteDebian/TareasCronCadaMes.sh /etc/cron.monthly/TareasCronCadaMes

echo ""
echo "  Dando permisos de lectura y ejecución solo al propietario de los scripts..."
echo ""
# Si esto no se hace las tareas no se ejecutarán.
chmod 700 /root/scripts/EsteDebian/TareasCronCadaMinuto.sh
chmod 700 /root/scripts/EsteDebian/TareasCronCadaHora.sh
chmod 700 /root/scripts/EsteDebian/TareasCronCadaHoraImpar.sh
chmod 700 /root/scripts/EsteDebian/TareasCronCadaHoraPar.sh
chmod 700 /root/scripts/EsteDebian/TareasCronCadaDía.sh
chmod 700 /root/scripts/EsteDebian/TareasCronCadaSemana.sh
chmod 700 /root/scripts/EsteDebian/TareasCronCadaMes.sh

