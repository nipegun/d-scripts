#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para preparar los comandos post-arranque (antiguo rc.local)
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/ComandosPostArranque-Preparar.sh | bash
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

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org
       . /etc/os-release
       OS_NAME=$NAME
       OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
       OS_NAME=$(lsb_release -si)
       OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       OS_NAME=$DISTRIB_ID
       OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
       OS_NAME=Debian
       OS_VERS=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD)
       OS_NAME=$(uname -s)
       OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------------"
  echo "  Iniciando el script para preparar los comandos post-arranque en Debian 7 (Wheezy)..."
  echo "----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------------"
  echo "  Iniciando el script para preparar los comandos post-arranque en Debian 8 (Jessie)..."
  echo "----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------"
  echo "  Iniciando el script para preparar los comandos post-arranque en Debian 9 (Stretch)..."
  echo "-----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo -e "${ColorVerde}Configurando el servicio...${FinColor}"
  echo ""
  echo "[Unit]"                                   > /etc/systemd/system/rc-local.service
  echo "Description=/etc/rc.local Compatibility" >> /etc/systemd/system/rc-local.service
  echo "ConditionPathExists=/etc/rc.local"       >> /etc/systemd/system/rc-local.service
  echo ""                                        >> /etc/systemd/system/rc-local.service
  echo "[Service]"                               >> /etc/systemd/system/rc-local.service
  echo "Type=forking"                            >> /etc/systemd/system/rc-local.service
  echo "ExecStart=/etc/rc.local start"           >> /etc/systemd/system/rc-local.service
  echo "TimeoutSec=0"                            >> /etc/systemd/system/rc-local.service
  echo "StandardOutput=tty"                      >> /etc/systemd/system/rc-local.service
  echo "RemainAfterExit=yes"                     >> /etc/systemd/system/rc-local.service
  echo "SysVStartPriority=99"                    >> /etc/systemd/system/rc-local.service
  echo ""                                        >> /etc/systemd/system/rc-local.service
  echo "[Install]"                               >> /etc/systemd/system/rc-local.service
  echo "WantedBy=multi-user.target"              >> /etc/systemd/system/rc-local.service

  echo ""
  echo -e "${ColorVerde}Creando el archivo /etc/rc.local ...${FinColor}"
  echo ""
  echo '#!/bin/bash'                            > /etc/rc.local
  echo ""                                      >> /etc/rc.local
  echo "/root/scripts/ComandosPostArranque.sh" >> /etc/rc.local
  echo "exit 0"                                >> /etc/rc.local
  chmod +x                                        /etc/rc.local

  echo ""
  echo -e "${ColorVerde}Creando el archivo para meter los comandos...${FinColor}"
  echo ""
  mkdir -p /root/scripts/ 2> /dev/null
  echo '#!/bin/bash'                                                                                          > /root/scripts/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ComandosPostArranque.sh
  echo "vColorRojo='\033[1;31m'"                                                                             >> /root/scripts/ComandosPostArranque.sh
  echo "vColorVerde='\033[1;32m'"                                                                            >> /root/scripts/ComandosPostArranque.sh
  echo "vFinColor='\033[0m'"                                                                                 >> /root/scripts/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ComandosPostArranque.sh
  echo 'vFechaDeEjec=$(date +A%YM%mD%d@%T)'                                                                  >> /root/scripts/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ComandosPostArranque.sh
  echo 'echo "Iniciada la ejecución del script post-arranque el $vFechaDeEjec" >> /var/log/PostArranque.log' >> /root/scripts/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ComandosPostArranque.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR DESPUÉS DE CADA ARRANQUE"                     >> /root/scripts/ComandosPostArranque.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                   >> /root/scripts/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ComandosPostArranque.sh
  chmod 700                                                                                                    /root/scripts/ComandosPostArranque.sh

  echo ""
  echo -e "${ColorVerde}Activando y arrancando el servicio...${FinColor}"
  echo ""
  systemctl enable rc-local
  systemctl start rc-local.service

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------"
  echo "  Iniciando el script para preparar los comandos post-arranque en Debian 10 (Buster)..."
  echo "-----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo -e "${ColorVerde}Configurando el servicio...${FinColor}"
  echo ""
  echo "[Unit]"                                   > /etc/systemd/system/rc-local.service
  echo "Description=/etc/rc.local Compatibility" >> /etc/systemd/system/rc-local.service
  echo "ConditionPathExists=/etc/rc.local"       >> /etc/systemd/system/rc-local.service
  echo ""                                        >> /etc/systemd/system/rc-local.service
  echo "[Service]"                               >> /etc/systemd/system/rc-local.service
  echo "Type=forking"                            >> /etc/systemd/system/rc-local.service
  echo "ExecStart=/etc/rc.local start"           >> /etc/systemd/system/rc-local.service
  echo "TimeoutSec=0"                            >> /etc/systemd/system/rc-local.service
  echo "StandardOutput=tty"                      >> /etc/systemd/system/rc-local.service
  echo "RemainAfterExit=yes"                     >> /etc/systemd/system/rc-local.service
  echo "SysVStartPriority=99"                    >> /etc/systemd/system/rc-local.service
  echo ""                                        >> /etc/systemd/system/rc-local.service
  echo "[Install]"                               >> /etc/systemd/system/rc-local.service
  echo "WantedBy=multi-user.target"              >> /etc/systemd/system/rc-local.service

  echo ""
  echo -e "${ColorVerde}Creando el archivo /etc/rc.local ...${FinColor}"
  echo ""
  echo '#!/bin/bash'                            > /etc/rc.local
  echo ""                                      >> /etc/rc.local
  echo "/root/scripts/ComandosPostArranque.sh" >> /etc/rc.local
  echo "exit 0"                                >> /etc/rc.local
  chmod +x                                        /etc/rc.local

  echo ""
  echo -e "${ColorVerde}Creando el archivo para meter los comandos...${FinColor}"
  echo ""
  mkdir -p /root/scripts/ 2> /dev/null
  echo '#!/bin/bash'                                                                                          > /root/scripts/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ComandosPostArranque.sh
  echo "vColorRojo='\033[1;31m'"                                                                             >> /root/scripts/ComandosPostArranque.sh
  echo "vColorVerde='\033[1;32m'"                                                                            >> /root/scripts/ComandosPostArranque.sh
  echo "vFinColor='\033[0m'"                                                                                 >> /root/scripts/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ComandosPostArranque.sh
  echo 'vFechaDeEjec=$(date +A%YM%mD%d@%T)'                                                                  >> /root/scripts/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ComandosPostArranque.sh
  echo 'echo "Iniciada la ejecución del script post-arranque el $vFechaDeEjec" >> /var/log/PostArranque.log' >> /root/scripts/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ComandosPostArranque.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR DESPUÉS DE CADA ARRANQUE"                     >> /root/scripts/ComandosPostArranque.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                   >> /root/scripts/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ComandosPostArranque.sh
  chmod 700                                                                                                    /root/scripts/ComandosPostArranque.sh

  echo ""
  echo -e "${ColorVerde}Activando y arrancando el servicio...${FinColor}"
  echo ""
  systemctl enable rc-local
  systemctl start rc-local.service

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------------"
  echo "  Iniciando el script para preparar los comandos post-arranque en Debian 11 (Bullseye)..."
  echo "-------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo -e "${ColorVerde}Configurando el servicio...${FinColor}"
  echo ""
  echo "[Unit]"                                   > /etc/systemd/system/rc-local.service
  echo "Description=/etc/rc.local Compatibility" >> /etc/systemd/system/rc-local.service
  echo "ConditionPathExists=/etc/rc.local"       >> /etc/systemd/system/rc-local.service
  echo ""                                        >> /etc/systemd/system/rc-local.service
  echo "[Service]"                               >> /etc/systemd/system/rc-local.service
  echo "Type=forking"                            >> /etc/systemd/system/rc-local.service
  echo "ExecStart=/etc/rc.local start"           >> /etc/systemd/system/rc-local.service
  echo "TimeoutSec=0"                            >> /etc/systemd/system/rc-local.service
  echo "StandardOutput=tty"                      >> /etc/systemd/system/rc-local.service
  echo "RemainAfterExit=yes"                     >> /etc/systemd/system/rc-local.service
  echo "SysVStartPriority=99"                    >> /etc/systemd/system/rc-local.service
  echo ""                                        >> /etc/systemd/system/rc-local.service
  echo "[Install]"                               >> /etc/systemd/system/rc-local.service
  echo "WantedBy=multi-user.target"              >> /etc/systemd/system/rc-local.service

  echo ""
  echo -e "${ColorVerde}Creando el archivo /etc/rc.local ...${FinColor}"
  echo ""
  echo '#!/bin/bash'                            > /etc/rc.local
  echo ""                                      >> /etc/rc.local
  echo "/root/scripts/ComandosPostArranque.sh" >> /etc/rc.local
  echo "exit 0"                                >> /etc/rc.local
  chmod +x                                        /etc/rc.local

  echo ""
  echo -e "${ColorVerde}Creando el archivo para meter los comandos...${FinColor}"
  echo ""
  mkdir -p /root/scripts/ 2> /dev/null
  echo '#!/bin/bash'                                                                                          > /root/scripts/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ComandosPostArranque.sh
  echo "vColorRojo='\033[1;31m'"                                                                             >> /root/scripts/ComandosPostArranque.sh
  echo "vColorVerde='\033[1;32m'"                                                                            >> /root/scripts/ComandosPostArranque.sh
  echo "vFinColor='\033[0m'"                                                                                 >> /root/scripts/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ComandosPostArranque.sh
  echo 'vFechaDeEjec=$(date +A%YM%mD%d@%T)'                                                                  >> /root/scripts/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ComandosPostArranque.sh
  echo 'echo "Iniciada la ejecución del script post-arranque el $vFechaDeEjec" >> /var/log/PostArranque.log' >> /root/scripts/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ComandosPostArranque.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR DESPUÉS DE CADA ARRANQUE"                     >> /root/scripts/ComandosPostArranque.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                   >> /root/scripts/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ComandosPostArranque.sh
  chmod 700                                                                                                    /root/scripts/ComandosPostArranque.sh

  echo ""
  echo -e "${ColorVerde}Activando y arrancando el servicio...${FinColor}"
  echo ""
  systemctl enable rc-local
  systemctl start rc-local.service

elif [ $OS_VERS == "12" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script para preparar los comandos post-arranque en Debian 12 (Bookworm)...${vFinColor}"
  echo ""

  echo ""
  echo "    Configurando el servicio..."
  echo ""
  echo "[Unit]"                                   > /etc/systemd/system/rc-local.service
  echo "Description=/etc/rc.local Compatibility" >> /etc/systemd/system/rc-local.service
  echo "ConditionPathExists=/etc/rc.local"       >> /etc/systemd/system/rc-local.service
  echo ""                                        >> /etc/systemd/system/rc-local.service
  echo "[Service]"                               >> /etc/systemd/system/rc-local.service
  echo "Type=forking"                            >> /etc/systemd/system/rc-local.service
  echo "ExecStart=/etc/rc.local start"           >> /etc/systemd/system/rc-local.service
  echo "TimeoutSec=0"                            >> /etc/systemd/system/rc-local.service
  echo "StandardOutput=tty"                      >> /etc/systemd/system/rc-local.service
  echo "RemainAfterExit=yes"                     >> /etc/systemd/system/rc-local.service
  echo "SysVStartPriority=99"                    >> /etc/systemd/system/rc-local.service
  echo ""                                        >> /etc/systemd/system/rc-local.service
  echo "[Install]"                               >> /etc/systemd/system/rc-local.service
  echo "WantedBy=multi-user.target"              >> /etc/systemd/system/rc-local.service

  echo ""
  echo "    Creando el archivo /etc/rc.local ..."
  echo ""
  echo '#!/bin/bash'                            > /etc/rc.local
  echo ""                                      >> /etc/rc.local
  echo "/root/scripts/ComandosPostArranque.sh" >> /etc/rc.local
  echo "exit 0"                                >> /etc/rc.local
  chmod +x                                        /etc/rc.local

  echo ""
  echo "    Creando el archivo para meter los comandos..."
  echo ""
  mkdir -p /root/scripts/EsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                                          > /root/scripts/EsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/EsteDebian/ComandosPostArranque.sh
  echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                  >> /root/scripts/EsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/EsteDebian/ComandosPostArranque.sh
  echo 'echo "Iniciada la ejecución del script post-arranque el $vFechaDeEjec" >> /var/log/PostArranque.log' >> /root/scripts/EsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/EsteDebian/ComandosPostArranque.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR DESPUÉS DE CADA ARRANQUE"                     >> /root/scripts/EsteDebian/ComandosPostArranque.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                   >> /root/scripts/EsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/EsteDebian/ComandosPostArranque.sh
  chmod 700                                                                                                     /root/scripts/EsteDebian/ComandosPostArranque.sh

  echo ""
  echo "    Activando y arrancando el servicio..."
  echo ""
  systemctl enable rc-local
  systemctl start rc-local.service

fi

