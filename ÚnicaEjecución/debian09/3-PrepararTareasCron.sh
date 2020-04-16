#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------
#  SCRIPT DE NIPEGUN PARA PREPARAR LAS TAREAS CRON
#---------------------------------------------------

echo ""
echo "-----------------------------------------------"
echo "  CREANDO EL ARCHIVO PARA LAS TAREAS HORARIAS"
echo "-----------------------------------------------"
echo ""
echo '#!/bin/bash' > /root/scripts/TareasCronPorHora.sh
echo "" >> /root/scripts/TareasCronPorHora.sh
echo 'FechaDeEjecucion=$(date +A%YM%mD%d@%T)' >> /root/scripts/TareasCronPorHora.sh
echo 'echo "Cron horario ejecutado el $FechaDeEjecucion" >> /var/log/TareasCronPorHora.log' >> /root/scripts/TareasCronPorHora.sh
echo "" >> /root/scripts/TareasCronPorHora.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA"  >> /root/scripts/TareasCronPorHora.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/scripts/TareasCronPorHora.sh
echo "" >> /root/scripts/TareasCronPorHora.sh

echo ""
echo "-----------------------------------------"
echo "  DANDO PERMISO DE EJECUCIÓN AL ARCHIVO"
echo "-----------------------------------------"
echo ""
chmod +x /root/scripts/TareasCronPorHora.sh

echo ""
echo "--------------------------------------------------------"
echo "  CREANDO ENLACE HACIA EL ARCHIVO EN /etc/cron.hourly/"
echo "--------------------------------------------------------"
echo ""
ln -s /root/scripts/TareasCronPorHora.sh /etc/cron.hourly/TareasCronPorHora.sh

echo ""
echo "-------------------------------------------------------------"
echo ""

echo ""
echo "----------------------------------------------"
echo "  CREANDO EL ARCHIVO PARA LAS TAREAS DIARIAS"
echo "----------------------------------------------"
echo ""
echo '#!/bin/bash' > /root/scripts/TareasCronPorDía.sh
echo "" >> /root/scripts/TareasCronPorDía.sh
echo 'FechaDeEjecucion=$(date +A%YM%mD%d@%T)' >> /root/scripts/TareasCronPorDía.sh
echo 'echo "Cron diario ejecutado el $FechaDeEjecucion" >> /var/log/TareasCronPorDía.log' >> /root/scripts/TareasCronPorDía.sh
echo "" >> /root/scripts/TareasCronPorDía.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA DÍA"  >> /root/scripts/TareasCronPorDía.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/scripts/TareasCronPorDía.sh
echo "" >> /root/scripts/TareasCronPorDía.sh

echo ""
echo "-----------------------------------------"
echo "  DANDO PERMISO DE EJECUCIÓN AL ARCHIVO"
echo "-----------------------------------------"
echo ""
chmod +x /root/scripts/TareasCronPorDía.sh

echo ""
echo "-------------------------------------------------------"
echo "  CREANDO ENLACE HACIA EL ARCHIVO EN /etc/cron.daily/"
echo "-------------------------------------------------------"
echo ""
ln -s /root/scripts/TareasCronPorDía.sh /etc/cron.daily/TareasCronPorDía.sh

echo ""
echo "-------------------------------------------------------------"
echo ""

echo ""
echo "------------------------------------------------"
echo "  CREANDO EL ARCHIVO PARA LAS TAREAS SEMANALES"
echo "------------------------------------------------"
echo ""
echo '#!/bin/bash' > /root/scripts/TareasCronPorSemana.sh
echo "" >> /root/scripts/TareasCronPorSemana.sh
echo 'FechaDeEjecucion=$(date +A%YM%mD%d@%T)' >> /root/scripts/TareasCronPorSemana.sh
echo 'echo "Cron semanal ejecutado el $FechaDeEjecucion" >> /var/log/TareasCronPorSemana.log' >> /root/scripts/TareasCronPorSemana.sh
echo "" >> /root/scripts/TareasCronPorSemana.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA SEMANA"  >> /root/scripts/TareasCronPorSemana.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/scripts/TareasCronPorSemana.sh
echo "" >> /root/scripts/TareasCronPorSemana.sh

echo ""
echo "-----------------------------------------"
echo "  DANDO PERMISO DE EJECUCIÓN AL ARCHIVO"
echo "-----------------------------------------"
echo ""
chmod +x /root/scripts/TareasCronPorSemana.sh

echo ""
echo "--------------------------------------------------------"
echo "  CREANDO ENLACE HACIA EL ARCHIVO EN /etc/cron.weekly/"
echo "--------------------------------------------------------"
echo ""
ln -s /root/scripts/TareasCronPorSemana.sh /etc/cron.weekly/TareasCronPorSemana.sh

echo ""
echo "-------------------------------------------------------------"
echo ""

echo ""
echo "------------------------------------------------"
echo "  CREANDO EL ARCHIVO PARA LAS TAREAS MENSUALES"
echo "------------------------------------------------"
echo ""
echo '#!/bin/bash' > /root/scripts/TareasCronPorMes.sh
echo "" >> /root/scripts/TareasCronPorMes.sh
echo 'FechaDeEjecucion=$(date +A%YM%mD%d@%T)' >> /root/scripts/TareasCronPorMes.sh
echo 'echo "Cron mensual ejecutado el $FechaDeEjecucion" >> /var/log/TareasCronPorMes.log' >> /root/scripts/TareasCronPorMes.sh
echo "" >> /root/scripts/TareasCronPorMes.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA MES"  >> /root/scripts/TareasCronPorMes.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/scripts/TareasCronPorMes.sh
echo "" >> /root/scripts/TareasCronPorMes.sh

echo ""
echo "-----------------------------------------"
echo "  DANDO PERMISO DE EJECUCIÓN AL ARCHIVO"
echo "-----------------------------------------"
echo ""
chmod +x /root/scripts/TareasCronPorMes.sh

echo ""
echo "---------------------------------------------------------"
echo "  CREANDO ENLACE HACIA EL ARCHIVO EN /etc/cron.monthly/"
echo "---------------------------------------------------------"
echo ""
ln -s /root/scripts/TareasCronPorMes.sh /etc/cron.monthly/TareasCronPorMes.sh

echo ""
echo "-------------------------------------------------------------------------------"
echo "  Dando permisos de lectura y ejecución solo al propietario de los scripts..."
echo "-------------------------------------------------------------------------------"
echo ""
# Si esto no se hace las tareas no se ejecutarán.
chmod 700 /root/scripts/TareasCronPorHora.sh
chmod 700 /root/scripts/TareasCronPorDía.sh
chmod 700 /root/scripts/TareasCronPorSemana.sh
chmod 700 /root/scripts/TareasCronPorMes.sh

