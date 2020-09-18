#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------
#  Script de NiPeGun para instalar y configurar Fail2Ban
#---------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Instalando Fail2Ban...${FinColor}"
apt-get -y install fail2ban sendmail

echo "[INCLUDES]"                                             > /etc/fail2ban/filter.d/JaulaInCrescendo.conf
echo "before = common.conf"                                  >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
echo "[Definition]"                                          >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
echo "failregex = \]\s+Unban\s+<HOST>"                       >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
echo "ignoreregex = \[JaulaInCrescendo.*\]\s+Unban\s+<HOST>" >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
echo "[DEFAULT]"                                                                          > /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "# 3 contraseñas erróneas en 1 minuto, crear un baneo de 10 minutos"                >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "maxretry = 1"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "findtime = 5m"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "bantime = 10m"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "[JaulaInCrescendo2]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "# Si ocurren 2 baneos de 10 minutos en 30 minutos, crear un nuevo baneo de 1 hora" >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "findtime = 30m"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "bantime = 1h"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "[JaulaInCrescendo3]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "# Si ocurren 2 baneos de 1h en un día, crear un nuevo baneo de 1 día"              >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "findtime = 1d"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "bantime = 1d"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "[JaulaInCrescendo4]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "# Si ocurren 2 baneos de 1 día en 1 semana, crear un nuevo baneo de 1 semana"      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "findtime = 1w"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "bantime = 1w"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "[JaulaInCrescendo5]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "# Si ocurren 2 baneos de 1 semana en 1 mes, crear un nuevo baneo de 1 mes"         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "findtime = 1mo"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "bantime = 1mo"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local

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

service fail2ban restart
# tail -f /var/log/fail2ban.log

