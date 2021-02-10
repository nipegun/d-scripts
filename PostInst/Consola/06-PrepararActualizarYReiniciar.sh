#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para crear la tarea cron de actualización y reinicio cada lunes a las 05:30 de la mañana
#--------------------------------------------------------------------------------------------------------------

# Exportar las tareas cron actuales al CronTemporal 
crontab -l > /root/CronTemporal

# Cargar la nueva tarea dentro del CronTemporal
echo "30 05 * * 1 /root/scripts/d-scripts/SistemaOperativo-ActualizarYReiniciar.sh" >> /root/CronTemporal

#      *  * * * * "Comando a ejecutar"
#      -  - - - -
#      |  | | | |
#      |  | | | ----- Día de la semana (0 - 7) (Doming=0, Lunes=1, etc...)
#      |  | | ------- Mes (1 - 12)
#      |  | --------- Día del mes (1 - 31)
#      |  ----------- Hora (0 - 23)
#      -------------- Minuto (0 - 59)

# Instalar los cambios
crontab /root/CronTemporal

# Borrar el archivo temporal
rm /root/CronTemporal

