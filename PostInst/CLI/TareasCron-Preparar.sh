
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

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${vColorAzulClaro}  Iniciando script para preparar las tareas cron...${vFinColor}"
  echo ""

# Preparar el script de tareas cada minuto
  echo ""
  echo "    Creando el archivo para las tareas de cada minuto..."
  echo ""
  mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                                                 > /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  echo ""                                                                                                           >> /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                         >> /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  echo 'echo "Iniciada la ejecución del cron de cada minuto el $vFechaDeEjec" >> /var/log/TareasCronCadaMinuto.log' >> /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  echo ""                                                                                                           >> /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA MINUTO"                                         >> /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                       >> /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  echo ""                                                                                                           >> /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  echo ""
  echo "      Dando permiso de ejecución al archivo..."
  echo ""
  chmod +x /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  echo ""
  echo "      Instalando la tarea en crontab..."
  echo ""
  crontab -l > /tmp/CronTemporal
  echo "* * * * * /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh" >> /tmp/CronTemporal
  crontab /tmp/CronTemporal
  rm /tmp/CronTemporal

# Preparar el script de tareas cada hora
  echo ""
  echo "    Creando el archivo para las tareas de cada hora..."
  echo ""
  mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                                             > /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  echo ""                                                                                                       >> /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                     >> /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  echo 'echo "Iniciada la ejecución del cron de cada hora el $vFechaDeEjec" >> /var/log/TareasCronCadaHora.log' >> /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  echo ""                                                                                                       >> /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA"                                       >> /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                     >> /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  echo ""                                                                                                       >> /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  echo ""
  echo "      Dando permiso de ejecución al archivo..."
  echo ""
  chmod +x /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  echo ""
  echo "      Creando enlace hacia el archivo en /etc/cron.hourly/ ..."
  echo ""
  ln -s /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh /etc/cron.hourly/TareasCronCadaHora

# Preparar el script de tareas cada hora impar
  echo ""
  echo "    Creando el archivo para las tareas de cada hora impar..."
  echo ""
  mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                                                        > /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  echo ""                                                                                                                  >> /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                                >> /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  echo 'echo "Iniciada la ejecución del cron de cada hora impar el $vFechaDeEjec" >> /var/log/TareasCronCadaHoraImpar.log' >> /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  echo ""                                                                                                                  >> /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA IMPAR"                                            >> /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                          >> /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  echo ""                                                                                                                  >> /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  echo ""
  echo "      Dando permiso de ejecución al archivo..."
  echo ""
  chmod +x /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  echo ""
  echo "      Instalando la tarea en crontab..."
  echo ""
  crontab -l > /tmp/CronTemporal
  echo "0 1-23/2 * * * /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh" >> /tmp/CronTemporal
  crontab /tmp/CronTemporal
  rm /tmp/CronTemporal

# Preparar el script de tareas cada hora par
  echo ""
  echo "    Creando el archivo para las tareas de cada hora par..."
  echo ""
  mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                                                    > /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  echo ""                                                                                                              >> /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                            >> /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  echo 'echo "Iniciada la ejecución del cron de cada hora par el $vFechaDeEjec" >> /var/log/TareasCronCadaHoraPar.log' >> /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  echo ""                                                                                                              >> /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA PAR"                                          >> /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                        >> /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  echo ""                                                                                                              >> /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  echo ""
  echo "      Dando permiso de ejecución al archivo..."
  echo ""
  chmod +x /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  echo ""
  echo "      Instalando la tarea en crontab..."
  echo ""
  crontab -l > /tmp/CronTemporal
  echo "0 */2 * * * /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh" >> /tmp/CronTemporal
  crontab /tmp/CronTemporal
  rm /tmp/CronTemporal

# Preparar el script de tareas cada día
  echo ""
  echo "    Creando el archivo para las tareas de cada día..."
  echo ""
  echo '#!/bin/bash'                                                                                           > /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  echo ""                                                                                                     >> /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                   >> /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  echo 'echo "Iniciada la ejecución del cron de cada día el $vFechaDeEjec" >> /var/log/TareasCronCadaDía.log' >> /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  echo ""                                                                                                     >> /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA DÍA"                                      >> /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                    >> /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  echo ""                                                                                                     >> /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  echo ""
  echo "      Dando permiso de ejecución al archivo..."
  echo ""
  chmod +x /root/scripts/TareasCronCadaDía.sh
  echo ""
  echo "      Creando enlace hacia el archivo en /etc/cron.daily/ ..."
  echo ""
  ln -s /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh /etc/cron.daily/TareasCronCadaDía

# Preparar el script de tareas cada semana
  echo ""
  echo "    Creando el archivo para las tareas de cada semana..."
  echo ""
  echo '#!/bin/bash'                                                                                                 > /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  echo ""                                                                                                           >> /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                         >> /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  echo 'echo "Iniciada la ejecución del cron de cada semana el $vFechaDeEjec" >> /var/log/TareasCronCadaSemana.log' >> /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  echo ""                                                                                                           >> /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA SEMANA"                                         >> /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                       >> /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  echo ""                                                                                                           >> /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  echo ""
  echo "      Dando permiso de ejecución al archivo..."
  echo ""
  chmod +x /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  echo ""
  echo "      Creando enlace hacia el archivo en /etc/cron.weekly/ ..."
  echo ""
  ln -s /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh /etc/cron.weekly/TareasCronCadaSemana

# Preparar el script de tareas cada mes
  echo ""
  echo "    Creando el archivo para las tareas de cada mes..."
  echo ""
  echo '#!/bin/bash'                                                                                           > /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  echo ""                                                                                                     >> /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                   >> /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  echo 'echo "Iniciada la ejecución del cron de cada mes el $vFechaDeEjec" >> /var/log/TareasCronCadaMes.log' >> /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  echo ""                                                                                                     >> /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA MES"                                      >> /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                    >> /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  echo ""                                                                                                     >> /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  echo ""
  echo "      Dando permiso de ejecución al archivo..."
  echo ""
  chmod +x /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  echo ""
  echo "      Creando enlace hacia el archivo en /etc/cron.monthly/ ..."
  echo ""
  ln -s /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh /etc/cron.monthly/TareasCronCadaMes

# Dar permisos de lectura y ejecución sólo al propietario de los scripts
  echo ""
  echo "  Dando permisos de lectura y ejecución solo al propietario de los scripts..."
  echo ""
  # Si esto no se hace las tareas no se ejecutarán.
  chmod 700 /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  chmod 700 /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  chmod 700 /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  chmod 700 /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  chmod 700 /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  chmod 700 /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  chmod 700 /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
