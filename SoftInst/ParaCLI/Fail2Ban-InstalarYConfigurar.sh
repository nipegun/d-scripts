#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Fail2Ban en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Fail2Ban-InstalarYConfigurar.sh | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Fail2Ban para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Fail2Ban para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Fail2Ban para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""


elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Fail2Ban para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Fail2Ban para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  echo ""
  echo "  Instalando paquetes..." 
echo ""
  apt-get -y update
  apt-get -y install fail2ban
  #apt-get -y install sendmail

  # Crear el archivo de configuración
    echo "[INCLUDES]"                                             > /etc/fail2ban/filter.d/JaulaInCrescendo.conf
    echo "before = common.conf"                                  >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
    echo "[Definition]"                                          >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
    echo "failregex = \]\s+Unban\s+<HOST>"                       >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
    echo "ignoreregex = \[JaulaInCrescendo.*\]\s+Unban\s+<HOST>" >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
  # Crear la jaula
    echo "[DEFAULT]"                                                                          > /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# 3 contraseñas erróneas en 1 minuto, crear un baneo de 1 minuto"                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 3"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 1m"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 1m"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo2]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 1 minuto en 5 minutos, crear un nuevo baneo de 5 minutos" >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 5m"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 5m"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo3]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 5 minutos en 30 minutos, crear un nuevo baneo 30 minutos" >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 30m"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 30m"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo4]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 30 minutos en 1 día, crear un nuevo baneo de 1 día"       >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 1d"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 1d"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo5]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 1 día en 1 semana, crear un nuevo baneo de 1 semana"      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 1w"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 1w"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo6]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 1 semana en 1 mes, crear un nuevo baneo de 1 mes"         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 1mo"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 1mo"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local

  # Modificar debian defaults
    #echo "ignoreip = 127.0.0.1"        >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "maxretry = 3"                >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "bantime = 10m"               >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "findtime = 5m"               >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo ""                            >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "# Mail"                      >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#destemail = mail@gmail.com" >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#sender = mail@gmail.com"    >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#sendername = Fail2Ban"      >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#mta = sendmail"             >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#action = %(action_mwl)s"    >> /etc/fail2ban/jail.d/defaults-debian.conf

  # Reiniciar el servicio
    service fail2ban reload
    service fail2ban restart
    # tail -f /var/log/fail2ban.log

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Fail2Ban para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  echo ""
  echo "  Instalando paquetes..." 
echo ""
  apt-get -y update
  apt-get -y install fail2ban
  #apt-get -y install sendmail

  # Crear el archivo de configuración
    echo "[INCLUDES]"                                             > /etc/fail2ban/filter.d/JaulaInCrescendo.conf
    echo "before = common.conf"                                  >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
    echo "[Definition]"                                          >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
    echo "failregex = \]\s+Unban\s+<HOST>"                       >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
    echo "ignoreregex = \[JaulaInCrescendo.*\]\s+Unban\s+<HOST>" >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
  # Crear la jaula
    echo "[DEFAULT]"                                                                          > /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# 3 contraseñas erróneas en 1 minuto, crear un baneo de 1 minuto"                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 3"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 1m"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 1m"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo2]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 1 minuto en 5 minutos, crear un nuevo baneo de 5 minutos" >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 5m"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 5m"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo3]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 5 minutos en 30 minutos, crear un nuevo baneo 30 minutos" >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 30m"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 30m"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo4]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 30 minutos en 1 día, crear un nuevo baneo de 1 día"       >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 1d"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 1d"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo5]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 1 día en 1 semana, crear un nuevo baneo de 1 semana"      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 1w"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 1w"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo6]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 1 semana en 1 mes, crear un nuevo baneo de 1 mes"         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 1mo"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 1mo"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local

  # Modificar debian defaults
    #echo "ignoreip = 127.0.0.1"        >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "maxretry = 3"                >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "bantime = 10m"               >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "findtime = 5m"               >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo ""                            >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "# Mail"                      >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#destemail = mail@gmail.com" >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#sender = mail@gmail.com"    >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#sendername = Fail2Ban"      >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#mta = sendmail"             >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#action = %(action_mwl)s"    >> /etc/fail2ban/jail.d/defaults-debian.conf

  # Crear los archivos de logs
    touch /var/log/auth.log      # Necesario para que inicie el servicio
    touch /var/log/fail2ban.log

  # Reiniciar el servicio
    systemctl restart fail2ban
    systemctl --no-pager status fail2ban
    # tail -f /var/log/fail2ban.log

fi

