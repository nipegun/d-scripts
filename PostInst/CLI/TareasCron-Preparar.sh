#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para preparar las tareas cron
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/TareasCron-Preparar.sh | bash
# ----------

vColorRojo='\033[1;31m'
vColorVerde='\033[1;32m'
vFinColor='\033[0m'

echo ""
echo -e "${ColorVerde}--------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Creando el archivo para las tareas de cada minuto...${FinColor}"
echo -e "${ColorVerde}--------------------------------------------------------${FinColor}"
echo ""
mkdir -p /root/scripts/ 2> /dev/null
echo '#!/bin/bash'                                                                                                > /root/scripts/TareasCronCadaMinuto.sh
echo ""                                                                                                          >> /root/scripts/TareasCronCadaMinuto.sh
echo 'FechaDeEjec=$(date +A%Y-M%m-D%d@%T)'                                                                       >> /root/scripts/TareasCronCadaMinuto.sh
echo 'echo "Iniciada la ejecución del cron de cada minuto el $FechaDeEjec" >> /var/log/TareasCronCadaMinuto.log' >> /root/scripts/TareasCronCadaMinuto.sh
echo ""                                                                                                          >> /root/scripts/TareasCronCadaMinuto.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA MINUTO"                                        >> /root/scripts/TareasCronCadaMinuto.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                      >> /root/scripts/TareasCronCadaMinuto.sh
echo ""                                                                                                          >> /root/scripts/TareasCronCadaMinuto.sh

echo ""
echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
echo ""
chmod +x /root/scripts/TareasCronCadaMinuto.sh

echo ""
echo -e "${ColorVerde}Instalando la tarea en crontab...${FinColor}"
echo ""
crontab -l > /tmp/CronTemporal
echo "* * * * * /root/scripts/TareasCronCadaMinuto.sh" >> /tmp/CronTemporal
crontab /tmp/CronTemporal
rm /tmp/CronTemporal

echo ""
echo -e "${ColorVerde}------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Creando el archivo para las tareas de cada hora...${FinColor}"
echo -e "${ColorVerde}------------------------------------------------------${FinColor}"
echo ""
mkdir -p /root/scripts/ 2> /dev/null
echo '#!/bin/bash'                                                                                            > /root/scripts/TareasCronCadaHora.sh
echo ""                                                                                                      >> /root/scripts/TareasCronCadaHora.sh
echo 'FechaDeEjec=$(date +A%Y-M%m-D%d@%T)'                                                                   >> /root/scripts/TareasCronCadaHora.sh
echo 'echo "Iniciada la ejecución del cron de cada hora el $FechaDeEjec" >> /var/log/TareasCronCadaHora.log' >> /root/scripts/TareasCronCadaHora.sh
echo ""                                                                                                      >> /root/scripts/TareasCronCadaHora.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA"                                      >> /root/scripts/TareasCronCadaHora.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                    >> /root/scripts/TareasCronCadaHora.sh
echo ""                                                                                                      >> /root/scripts/TareasCronCadaHora.sh

echo ""
echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
echo ""
chmod +x /root/scripts/TareasCronCadaHora.sh

echo ""
echo -e "${ColorVerde}Creando enlace hacia el archivo en /etc/cron.hourly/ ...${FinColor}"
echo ""
ln -s /root/scripts/TareasCronCadaHora.sh /etc/cron.hourly/TareasCronCadaHora


echo ""
echo -e "${ColorVerde}------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Creando el archivo para las tareas de cada hora impar...${FinColor}"
echo -e "${ColorVerde}------------------------------------------------------------${FinColor}"
echo ""
mkdir -p /root/scripts/ 2> /dev/null
echo '#!/bin/bash'                                                                                                       > /root/scripts/TareasCronCadaHoraImpar.sh
echo ""                                                                                                                 >> /root/scripts/TareasCronCadaHoraImpar.sh
echo 'FechaDeEjec=$(date +A%Y-M%m-D%d@%T)'                                                                              >> /root/scripts/TareasCronCadaHoraImpar.sh
echo 'echo "Iniciada la ejecución del cron de cada hora impar el $FechaDeEjec" >> /var/log/TareasCronCadaHoraImpar.log' >> /root/scripts/TareasCronCadaHoraImpar.sh
echo ""                                                                                                                 >> /root/scripts/TareasCronCadaHoraImpar.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA IMPAR"                                           >> /root/scripts/TareasCronCadaHoraImpar.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                         >> /root/scripts/TareasCronCadaHoraImpar.sh
echo ""                                                                                                                 >> /root/scripts/TareasCronCadaHoraImpar.sh

echo ""
echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
echo ""
chmod +x /root/scripts/TareasCronCadaHoraImpar.sh

echo ""
echo -e "${ColorVerde}Instalando la tarea en crontab...${FinColor}"
echo ""
crontab -l > /tmp/CronTemporal
echo "0 1-23/2 * * * /root/scripts/TareasCronCadaHoraImpar.sh" >> /tmp/CronTemporal
crontab /tmp/CronTemporal
rm /tmp/CronTemporal


echo ""
echo -e "${ColorVerde}----------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Creando el archivo para las tareas de cada hora par...${FinColor}"
echo -e "${ColorVerde}----------------------------------------------------------${FinColor}"
echo ""
mkdir -p /root/scripts/ 2> /dev/null
echo '#!/bin/bash'                                                                                                   > /root/scripts/TareasCronCadaHoraPar.sh
echo ""                                                                                                             >> /root/scripts/TareasCronCadaHoraPar.sh
echo 'FechaDeEjec=$(date +A%Y-M%m-D%d@%T)'                                                                          >> /root/scripts/TareasCronCadaHoraPar.sh
echo 'echo "Iniciada la ejecución del cron de cada hora par el $FechaDeEjec" >> /var/log/TareasCronCadaHoraPar.log' >> /root/scripts/TareasCronCadaHoraPar.sh
echo ""                                                                                                             >> /root/scripts/TareasCronCadaHoraPar.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA PAR"                                         >> /root/scripts/TareasCronCadaHoraPar.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                       >> /root/scripts/TareasCronCadaHoraPar.sh
echo ""                                                                                                             >> /root/scripts/TareasCronCadaHoraPar.sh

echo ""
echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
echo ""
chmod +x /root/scripts/TareasCronCadaHoraPar.sh

echo ""
echo -e "${ColorVerde}Instalando la tarea en crontab...${FinColor}"
echo ""
crontab -l > /tmp/CronTemporal
echo "0 */2 * * * /root/scripts/TareasCronCadaHoraPar.sh" >> /tmp/CronTemporal
crontab /tmp/CronTemporal
rm /tmp/CronTemporal


echo ""
echo -e "${ColorVerde}-----------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Creando el archivo para las tareas de cada día...${FinColor}"
echo -e "${ColorVerde}-----------------------------------------------------${FinColor}"
echo ""
echo '#!/bin/bash'                                                                                          > /root/scripts/TareasCronCadaDía.sh
echo ""                                                                                                    >> /root/scripts/TareasCronCadaDía.sh
echo 'FechaDeEjec=$(date +A%Y-M%m-D%d@%T)'                                                                 >> /root/scripts/TareasCronCadaDía.sh
echo 'echo "Iniciada la ejecución del cron de cada día el $FechaDeEjec" >> /var/log/TareasCronCadaDía.log' >> /root/scripts/TareasCronCadaDía.sh
echo ""                                                                                                    >> /root/scripts/TareasCronCadaDía.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA DÍA"                                     >> /root/scripts/TareasCronCadaDía.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                   >> /root/scripts/TareasCronCadaDía.sh
echo ""                                                                                                    >> /root/scripts/TareasCronCadaDía.sh

echo ""
echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
echo ""
chmod +x /root/scripts/TareasCronCadaDía.sh

echo ""
echo -e "${ColorVerde}Creando enlace hacia el archivo en /etc/cron.daily/ ...${FinColor}"
echo ""
ln -s /root/scripts/TareasCronCadaDía.sh /etc/cron.daily/TareasCronCadaDía


echo ""
echo -e "${ColorVerde}--------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Creando el archivo para las tareas de cada semana...${FinColor}"
echo -e "${ColorVerde}--------------------------------------------------------${FinColor}"
echo ""
echo '#!/bin/bash'                                                                                                > /root/scripts/TareasCronCadaSemana.sh
echo ""                                                                                                          >> /root/scripts/TareasCronCadaSemana.sh
echo 'FechaDeEjec=$(date +A%Y-M%m-D%d@%T)'                                                                       >> /root/scripts/TareasCronCadaSemana.sh
echo 'echo "Iniciada la ejecución del cron de cada semana el $FechaDeEjec" >> /var/log/TareasCronCadaSemana.log' >> /root/scripts/TareasCronCadaSemana.sh
echo ""                                                                                                          >> /root/scripts/TareasCronCadaSemana.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA SEMANA"                                        >> /root/scripts/TareasCronCadaSemana.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                      >> /root/scripts/TareasCronCadaSemana.sh
echo ""                                                                                                          >> /root/scripts/TareasCronCadaSemana.sh

echo ""
echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
echo ""
chmod +x /root/scripts/TareasCronCadaSemana.sh

echo ""
echo -e "${ColorVerde}Creando enlace hacia el archivo en /etc/cron.weekly/ ...${FinColor}"
echo ""
ln -s /root/scripts/TareasCronCadaSemana.sh /etc/cron.weekly/TareasCronCadaSemana


echo ""
echo -e "${ColorVerde}-----------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Creando el archivo para las tareas de cada mes...${FinColor}"
echo -e "${ColorVerde}-----------------------------------------------------${FinColor}"
echo ""
echo '#!/bin/bash'                                                                                          > /root/scripts/TareasCronCadaMes.sh
echo ""                                                                                                    >> /root/scripts/TareasCronCadaMes.sh
echo 'FechaDeEjec=$(date +A%Y-M%m-D%d@%T)'                                                                 >> /root/scripts/TareasCronCadaMes.sh
echo 'echo "Iniciada la ejecución del cron de cada mes el $FechaDeEjec" >> /var/log/TareasCronCadaMes.log' >> /root/scripts/TareasCronCadaMes.sh
echo ""                                                                                                    >> /root/scripts/TareasCronCadaMes.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA MES"                                     >> /root/scripts/TareasCronCadaMes.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                   >> /root/scripts/TareasCronCadaMes.sh
echo ""                                                                                                    >> /root/scripts/TareasCronCadaMes.sh

echo ""
echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
echo ""
chmod +x /root/scripts/TareasCronCadaMes.sh

echo ""
echo -e "${ColorVerde}Creando enlace hacia el archivo en /etc/cron.monthly/ ...${FinColor}"
echo ""
ln -s /root/scripts/TareasCronCadaMes.sh /etc/cron.monthly/TareasCronCadaMes


echo ""
echo -e "${ColorVerde}-------------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Dando permisos de lectura y ejecución solo al propietario de los scripts...${FinColor}"
echo -e "${ColorVerde}-------------------------------------------------------------------------------${FinColor}"
echo ""
# Si esto no se hace las tareas no se ejecutarán.
chmod 700 /root/scripts/TareasCronCadaMinuto.sh
chmod 700 /root/scripts/TareasCronCadaHora.sh
chmod 700 /root/scripts/TareasCronCadaHoraImpar.sh
chmod 700 /root/scripts/TareasCronCadaHoraPar.sh
chmod 700 /root/scripts/TareasCronCadaDía.sh
chmod 700 /root/scripts/TareasCronCadaSemana.sh
chmod 700 /root/scripts/TareasCronCadaMes.sh

