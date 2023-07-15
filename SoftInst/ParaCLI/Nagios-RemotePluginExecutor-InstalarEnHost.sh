#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar el servidor nrpe de Nagios Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Nagios-RemotePluginExecutor-InstalarEnHost.sh | bash
# ----------

ColorAzul="\033[0;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

# Determinar la versión de Debian

  if [ -f /etc/os-release ]; then
    # Para systemd y freedesktop.org
      . /etc/os-release
      cNomSO=$NAME
      cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
      cNomSO=$(lsb_release -si)
      cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then
    # Para algunas versiones de Debian sin el comando lsb_release
      . /etc/lsb-release
      cNomSO=$DISTRIB_ID
      cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then
    # Para versiones viejas de Debian.
      cNomSO=Debian
      cVerSO=$(cat /etc/debian_version)
  else
    # Para el viejo uname (También funciona para BSD)
      cNomSO=$(uname -s)
      cVerSO=$(uname -r)
  fi


if [ $cVerSO == "7" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor nrpe para Debian 7 (Wheezy)..."  echo "----------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor nrpe para Debian 8 (Jessie)..."  echo "----------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor nrpe para Debian 9 (Stretch)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor nrpe para Debian 10 (Buster)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor nrpe para Debian 11 (Bullseye)..."
  echo ""

  echo ""
  echo "  Instalando paquetes necesarios..." 
echo ""
  apt-get -y update
  apt-get -y install nagios-nrpe-server
  apt-get -y install nagios-nrpe-plugin
  apt-get -y install monitoring-plugins
  apt-get -y install monitoring-plugins-contrib
  apt-get -y install nagios-snmp-plugins
            
  echo ""
  echo "  Agregando comandos..." 
echo ""
  sed -i -e 's|command\[check_users]=|#command\[check_users]=|g'               /etc/nagios/nrpe.cfg
  sed -i -e 's|command\[check_load]=|#command\[check_load]=|g'                 /etc/nagios/nrpe.cfg
  sed -i -e 's|command\[check_hda1]=|#command\[check_hda1]=|g'                 /etc/nagios/nrpe.cfg
  sed -i -e 's|command\[check_zombie_procs]=|#command\[check_zombie_procs]=|g' /etc/nagios/nrpe.cfg
  sed -i -e 's|command\[check_total_procs]=|#command\[check_total_procs]=|g'   /etc/nagios/nrpe.cfg

  rm -f /etc/nagios/nrpe.d/comandos.cfg 2> /dev/null
  touch /etc/nagios/nrpe.d/comandos.cfg

  echo "# Memoria"                                                                                     >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_memory]=/usr/lib/nagios/plugins/check_memory -w 20% -c 10%"                      >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# Antivirus"                                                                                   >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_clamav]=/usr/lib/nagios/plugins/check_clamav"                                    >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_clamd]=/usr/lib/nagios/plugins/check_clamd"                                      >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# Impresoras"                                                                                  >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_cups]=/usr/lib/nagios/plugins/check_cups"                                        >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# UpTime"                                                                                      >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_uptime]=/usr/lib/nagios/plugins/check_uptime"                                    >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# Kernel"                                                                                      >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_running_kernel]=/usr/lib/nagios/plugins/check_running_kernel"                    >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# Ping"                                                                                        >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_localping]=/usr/lib/nagios/plugins/check_ping -H localhost -w 10:20% -c 10:100%" >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# SSH"                                                                                         >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_ssh]=/usr/lib/nagios/plugins/check_ssh -H localhost"                             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# Mail"                                                                                        >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_imap]=/usr/lib/nagios/plugins/check_imap -H localhost"                           >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_pop]=/usr/lib/nagios/plugins/check_pop -H localhost"                             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_smtp]=/usr/lib/nagios/plugins/check_smtp -H localhost"                           >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# Sensores (Hace falta instalar el paquete lm-sensors)"                                        >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sensors]=/usr/lib/nagios/plugins/check_sensors -H localhost"                     >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# Usuarios"                                                                                    >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_users]=/usr/lib/nagios/plugins/check_users -w 5 -c 10"                           >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# Actualizaciones"                                                                             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_apt]=/usr/lib/nagios/plugins/check_apt"                                          >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# Carga de trabajo"                                                                            >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_load]=/usr/lib/nagios/plugins/check_load -r -w .15,.10,.05 -c .30,.25,.20"       >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# Procesos"                                                                                    >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_zombie_procs]=/usr/lib/nagios/plugins/check_procs -w 5 -c 10 -s Z"               >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_total_procs]=/usr/lib/nagios/plugins/check_procs -w 150 -c 200"                  >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# Swap"                                                                                        >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_swap]=/usr/lib/nagios/plugins/check_swap -w 50% -c 20%"                          >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# Oracle"                                                                                      >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_oracle]=/usr/lib/nagios/plugins/check_oracle"                                    >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# MySQL"                                                                                       >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_mysql]=/usr/lib/nagios/plugins/check_mysql"                                      >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_mysql_query]=/usr/lib/nagios/plugins/check_mysql_query"                          >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# DHCP"                                                                                        >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_dhcp_local]=/usr/lib/nagios/plugins/check_dhcp -s 127.0.0.1"                     >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# DNS"                                                                                         >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_dig]=/usr/lib/nagios/plugins/check_dig"                                          >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_dns]=/usr/lib/nagios/plugins/check_dns"                                          >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# HTTP"                                                                                        >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_http]=/usr/lib/nagios/plugins/check_http -H localhost"                           >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# Discos"                                                                                      >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_mp_root]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /"                  >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_mp_home]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /home/"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_mp_var]=/usr/lib/nagios/plugins/check_disk  -w 20% -c 10% -p /var/"              >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# Discos IDE"                                                                                  >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_hda1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hda1"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_hda2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hda2"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_hda3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hda3"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_hda4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hda4"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_hdb1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdb1"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_hdb2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdb2"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_hdb3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdb3"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_hdb4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdb4"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_hdc1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdc1"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_hdc2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdc2"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_hdc3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdc3"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_hdc4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdc4"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_hdd1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdd1"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_hdd2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdd2"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_hdd3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdd3"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_hdd4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdd4"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# Discos SATA"                                                                                 >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sda1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sda1"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sda2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sda2"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sda3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sda3"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sda4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sda4"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sdb1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdb1"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sdb2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdb2"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sdb3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdb3"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sdb4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdb4"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sdc1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdc1"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sdc2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdc2"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sdc3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdc3"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sdc4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdc4"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sdd1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdd1"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sdd2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdd2"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sdd3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdd3"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sdd4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdd4"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sde1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sde1"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sde2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sde2"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sde3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sde3"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_sde4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sde4"             >> /etc/nagios/nrpe.d/comandos.cfg
  echo "# Discos NVMe"                                                                                 >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_nvme0n1p1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme0n1p1"   >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_nvme0n1p2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme0n1p2"   >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_nvme0n1p3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme0n1p3"   >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_nvme0n1p4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme0n1p4"   >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_nvme1n1p1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme1n1p1"   >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_nvme1n1p2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme1n1p2"   >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_nvme1n1p3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme1n1p3"   >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_nvme1n1p4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme1n1p4"   >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_nvme2n1p1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme2n1p1"   >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_nvme2n1p2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme2n1p2"   >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_nvme2n1p3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme2n1p3"   >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_nvme2n1p4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme2n1p4"   >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_nvme3n1p1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme3n1p1"   >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_nvme3n1p2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme3n1p2"   >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_nvme3n1p3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme3n1p3"   >> /etc/nagios/nrpe.d/comandos.cfg
  echo "command[check_nvme3n1p4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme3n1p4"   >> /etc/nagios/nrpe.d/comandos.cfg
  
  # Comandos con argumentos acarrean riesgos de seguridad
  # Sólo pueden ser usados si se configura dont_blame_nrpe=1 en el archivo de configuración
  #command[check_mem]=/usr/lib/nagios/plugins/custom_check_mem -n $ARG1$
  #command[check_init_service]=sudo /usr/lib/nagios/plugins/check_init_service $ARG1$
  #command[check_services]=/usr/lib/nagios/plugins/check_services -p $ARG1$
  #command[check_all_procs]=/usr/lib/nagios/plugins/custom_check_procs
  #command[check_procs]=/usr/lib/nagios/plugins/check_procs $ARG1$
  #command[check_open_files]=/usr/lib/nagios/plugins/check_open_files.pl $ARG1$
  #command[check_netstat]=/usr/lib/nagios/plugins/check_netstat.pl -p $ARG1$ $ARG2$

  apt-get -y update && apt-get -y install lm-sensors

  echo ""
  echo "  Reiniciando el servidor nrpe..." 
echo ""
  systemctl restart nagios-nrpe-server

  echo ""
  echo "  La lista de comandos para ser llamados desde Nagios es:"
  echo ""
  cat /etc/nagios/nrpe.d/comandos.cfg | cut -d ']' -f1 | cut -d '[' -f2 | grep -v "#"

fi
