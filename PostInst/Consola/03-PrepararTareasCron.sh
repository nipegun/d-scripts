#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------
#  Script de NiPeGun para preparar las tareas cron
#---------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Creando el archivo para las tareas horarias...${FinColor}"
echo ""
mkdir -p /root/scripts/ 2> /dev/null
echo '#!/bin/bash' > /root/scripts/TareasCronPorHora.sh
echo "" >> /root/scripts/TareasCronPorHora.sh
echo 'FechaDeEjec=$(date +A%YM%mD%d@%T)' >> /root/scripts/TareasCronPorHora.sh
echo 'echo "Iniciada la ejecución del cron horario el $FechaDeEjec" >> /var/log/TareasCronPorHora.log' >> /root/scripts/TareasCronPorHora.sh
echo "" >> /root/scripts/TareasCronPorHora.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA"  >> /root/scripts/TareasCronPorHora.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/scripts/TareasCronPorHora.sh
echo "" >> /root/scripts/TareasCronPorHora.sh

echo ""
echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
echo ""
chmod +x /root/scripts/TareasCronPorHora.sh

echo ""
echo -e "${ColorVerde}Creando enlace hacia el archivo en /etc/cron.hourly/ ...${FinColor}"
echo ""
ln -s /root/scripts/TareasCronPorHora.sh /etc/cron.hourly/TareasCronPorHora

echo ""
echo "-------------------------------------------------------------"
echo ""

echo ""
echo -e "${ColorVerde}Creando el archivo para las tareas diarias...${FinColor}"
echo ""
echo '#!/bin/bash' > /root/scripts/TareasCronPorDía.sh
echo "" >> /root/scripts/TareasCronPorDía.sh
echo 'FechaDeEjec=$(date +A%YM%mD%d@%T)' >> /root/scripts/TareasCronPorDía.sh
echo 'echo "Iniciada la ejecución del cron diario el $FechaDeEjec" >> /var/log/TareasCronPorDía.log' >> /root/scripts/TareasCronPorDía.sh
echo "" >> /root/scripts/TareasCronPorDía.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA DÍA"  >> /root/scripts/TareasCronPorDía.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/scripts/TareasCronPorDía.sh
echo "" >> /root/scripts/TareasCronPorDía.sh

echo ""
echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
echo ""
chmod +x /root/scripts/TareasCronPorDía.sh

echo ""
echo -e "${ColorVerde}Creando enlace hacia el archivo en /etc/cron.daily/ ...${FinColor}"
echo ""
ln -s /root/scripts/TareasCronPorDía.sh /etc/cron.daily/TareasCronPorDía

echo ""
echo "-------------------------------------------------------------"
echo ""

echo ""
echo -e "${ColorVerde}Creando el archivo para las tareas semanales...${FinColor}"
echo ""
echo '#!/bin/bash' > /root/scripts/TareasCronPorSemana.sh
echo "" >> /root/scripts/TareasCronPorSemana.sh
echo 'FechaDeEjec=$(date +A%YM%mD%d@%T)' >> /root/scripts/TareasCronPorSemana.sh
echo 'echo "Iniciada la ejecución del cron semanal el $FechaDeEjec" >> /var/log/TareasCronPorSemana.log' >> /root/scripts/TareasCronPorSemana.sh
echo "" >> /root/scripts/TareasCronPorSemana.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA SEMANA"  >> /root/scripts/TareasCronPorSemana.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/scripts/TareasCronPorSemana.sh
echo "" >> /root/scripts/TareasCronPorSemana.sh

echo ""
echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
echo ""
chmod +x /root/scripts/TareasCronPorSemana.sh

echo ""
echo -e "${ColorVerde}Creando enlace hacia el archivo en /etc/cron.weekly/ ...${FinColor}"
echo ""
ln -s /root/scripts/TareasCronPorSemana.sh /etc/cron.weekly/TareasCronPorSemana

echo ""
echo "-------------------------------------------------------------"
echo ""

echo ""
echo -e "${ColorVerde}Creando el archivo para las tareas mensuales...${FinColor}"
echo ""
echo '#!/bin/bash' > /root/scripts/TareasCronPorMes.sh
echo "" >> /root/scripts/TareasCronPorMes.sh
echo 'FechaDeEjec=$(date +A%YM%mD%d@%T)' >> /root/scripts/TareasCronPorMes.sh
echo 'echo "Iniciada la ejecución del cron mensual el $FechaDeEjec" >> /var/log/TareasCronPorMes.log' >> /root/scripts/TareasCronPorMes.sh
echo "" >> /root/scripts/TareasCronPorMes.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA MES"  >> /root/scripts/TareasCronPorMes.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/scripts/TareasCronPorMes.sh
echo "" >> /root/scripts/TareasCronPorMes.sh

echo ""
echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
echo ""
chmod +x /root/scripts/TareasCronPorMes.sh

echo ""
echo -e "${ColorVerde}Creando enlace hacia el archivo en /etc/cron.monthly/ ...${FinColor}"
echo ""
ln -s /root/scripts/TareasCronPorMes.sh /etc/cron.monthly/TareasCronPorMes

echo ""
echo -e "${ColorVerde}Dando permisos de lectura y ejecución solo al propietario de los scripts...${FinColor}"
echo ""
# Si esto no se hace las tareas no se ejecutarán.
chmod 700 /root/scripts/TareasCronPorHora.sh
chmod 700 /root/scripts/TareasCronPorDía.sh
chmod 700 /root/scripts/TareasCronPorSemana.sh
chmod 700 /root/scripts/TareasCronPorMes.sh

