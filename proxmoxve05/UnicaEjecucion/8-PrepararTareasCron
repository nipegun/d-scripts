#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------
#  Script de NiPeGun para preparar las tareas cron en el host de ProxmoxVE
#---------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Creando el archivo para las tareas horarias...${FinColor}"
echo ""
echo '#!/bin/bash' > /root/TareasCronPorHora
echo "" >> /root/TareasCronPorHora
echo 'FechaDeEjecucion=$(date +A%YM%mD%d@%T)' >> /root/TareasCronPorHora
echo 'echo "Cron horario ejecutado el $FechaDeEjecucion" >> /var/log/TareasCronPorHora.log' >> /root/TareasCronPorHora
echo "" >> /root/TareasCronPorHora
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA"  >> /root/TareasCronPorHora
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/TareasCronPorHora
echo "" >> /root/TareasCronPorHora

echo ""
echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
echo ""
chmod +x /root/TareasCronPorHora

echo ""
echo -e "${ColorVerde}Creando enlace hacia el archivo en /etc/cron.hourly/ ...${FinColor}"
echo ""
ln -s /root/TareasCronPorHora /etc/cron.hourly/TareasCronPorHora

echo ""
echo "-------------------------------------------------------------"
echo ""

echo ""
echo -e "${ColorVerde}Creando el archivo para las tareas diarias...${FinColor}"
echo ""
echo '#!/bin/bash' > /root/TareasCronPorDía
echo "" >> /root/TareasCronPorDía
echo 'FechaDeEjecucion=$(date +A%YM%mD%d@%T)' >> /root/TareasCronPorDía
echo 'echo "Cron diario ejecutado el $FechaDeEjecucion" >> /var/log/TareasCronPorDía.log' >> /root/TareasCronPorDía
echo "" >> /root/TareasCronPorDía
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA DÍA"  >> /root/TareasCronPorDía
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/TareasCronPorDía
echo "" >> /root/TareasCronPorDía

echo ""
echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
echo ""
chmod +x /root/TareasCronPorDía

echo ""
echo -e "${ColorVerde}Creando enlace hacia el archivo en /etc/cron.daily/ ...${FinColor}"
echo ""
ln -s /root/TareasCronPorDía /etc/cron.daily/TareasCronPorDía

echo ""
echo "-------------------------------------------------------------"
echo ""

echo ""
echo -e "${ColorVerde}Creando el archivo para las tareas semanales...${FinColor}"
echo ""
echo '#!/bin/bash' > /root/TareasCronPorSemana
echo "" >> /root/TareasCronPorSemana
echo 'FechaDeEjecucion=$(date +A%YM%mD%d@%T)' >> /root/TareasCronPorSemana
echo 'echo "Cron semanal ejecutado el $FechaDeEjecucion" >> /var/log/TareasCronPorSemana.log' >> /root/TareasCronPorSemana
echo "" >> /root/TareasCronPorSemana
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA SEMANA"  >> /root/TareasCronPorSemana
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/TareasCronPorSemana
echo "" >> /root/TareasCronPorSemana

echo ""
echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
echo ""
chmod +x /root/TareasCronPorSemana

echo ""
echo -e "${ColorVerde}Creando enlace hacia el archivo en /etc/cron.weekly/ ...${FinColor}"
echo ""
ln -s /root/TareasCronPorSemana /etc/cron.weekly/TareasCronPorSemana

echo ""
echo "-------------------------------------------------------------"
echo ""

echo ""
echo -e "${ColorVerde}Creando el archivo para las tareas mensuales...${FinColor}"
echo ""
echo '#!/bin/bash' > /root/TareasCronPorMes
echo "" >> /root/TareasCronPorMes
echo 'FechaDeEjecucion=$(date +A%YM%mD%d@%T)' >> /root/TareasCronPorMes
echo 'echo "Cron mensual ejecutado el $FechaDeEjecucion" >> /var/log/TareasCronPorMes.log' >> /root/TareasCronPorMes
echo "" >> /root/TareasCronPorMes
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA MES"  >> /root/TareasCronPorMes
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/TareasCronPorMes
echo "" >> /root/TareasCronPorMes

echo ""
echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
echo ""
chmod +x /root/TareasCronPorMes

echo ""
echo -e "${ColorVerde}Creando enlace hacia el archivo en /etc/cron.monthly/ ...${FinColor}"
echo ""
ln -s /root/TareasCronPorMes /etc/cron.monthly/TareasCronPorMes

echo ""
echo -e "${ColorVerde}Dando permisos de lectura y ejecución solo al propietario de los scripts...${FinColor}"
echo ""
# Si esto no se hace las tareas no se ejecutarán.
chmod 700 /root/TareasCronPorHora
chmod 700 /root/TareasCronPorDía
chmod 700 /root/TareasCronPorSemana
chmod 700 /root/TareasCronPorMes

