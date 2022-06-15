#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar el servidor nrpe de Nagios Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Nagios-InstalarYConfigurar.sh | bash
#----------------------------------------------------------------------------------------------------------------------------

ColorAzul="\033[0;34m"
ColorVerde='\033[1;32m'
ColorRojo='\033[1;31m'
FinColor='\033[0m'

# Determinar la versión de Debian

  if [ -f /etc/os-release ]; then
    # Para systemd y freedesktop.org
      . /etc/os-release
      OS_NAME=$NAME
      OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
      OS_NAME=$(lsb_release -si)
      OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then
    # Para algunas versiones de Debian sin el comando lsb_release
      . /etc/lsb-release
      OS_NAME=$DISTRIB_ID
      OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then
    # Para versiones viejas de Debian.
      OS_NAME=Debian
      OS_VERS=$(cat /etc/debian_version)
  else
    # Para el viejo uname (También funciona para BSD)
      OS_NAME=$(uname -s)
      OS_VERS=$(uname -r)
  fi


if [ $OS_VERS == "7" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor nrpe para Debian 7 (Wheezy)..."
  echo "----------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor nrpe para Debian 8 (Jessie)..."
  echo "----------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor nrpe para Debian 9 (Stretch)..."
  echo "-----------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor nrpe para Debian 10 (Buster)..."
  echo "-----------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor nrpe para Debian 11 (Bullseye)..."
  echo "-----------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Instalando paquetes necesarios..."
  echo ""
  apt-get -y update
  apt-get -y install monitoring-plugins
  apt-get -y install nagios-nrpe-server

  echo ""
  echo "  Agregando comandos..."
  echo ""
  sed -i -e 's|command\[check_users]=|#command\[check_users]=|g'               /etc/nagios/nrpe.cfg
  sed -i -e 's|command\[check_load]=|#command\[check_load]=|g'                 /etc/nagios/nrpe.cfg
  sed -i -e 's|command\[check_hda1]=|#command\[check_hda1]=|g'                 /etc/nagios/nrpe.cfg
  sed -i -e 's|command\[check_zombie_procs]=|#command\[check_zombie_procs]=|g' /etc/nagios/nrpe.cfg
  sed -i -e 's|command\[check_total_procs]=|#command\[check_total_procs]=|g'   /etc/nagios/nrpe.cfg

  # Usuarios
    echo "command[check_users]=/usr/lib/nagios/plugins/check_users -w 5 -c 10"                         >> /etc/nagios/nrpe.d/comandos.cfg
  # Actualizaciones
    echo "command[check_apt]=/usr/lib/nagios/plugins/check_apt"                                        >> /etc/nagios/nrpe.d/comandos.cfg
  # Carga de trabajo
    echo "command[check_load]=/usr/lib/nagios/plugins/check_load -r -w .15,.10,.05 -c .30,.25,.20"     >> /etc/nagios/nrpe.d/comandos.cfg
  # Procesos
    echo "command[check_zombie_procs]=/usr/lib/nagios/plugins/check_procs -w 5 -c 10 -s Z"             >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_total_procs]=/usr/lib/nagios/plugins/check_procs -w 150 -c 200"                >> /etc/nagios/nrpe.d/comandos.cfg
  # Discos IDE
    echo "command[check_hda1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hda1"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_hda2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hda2"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_hda3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hda3"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_hda4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hda4"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_hdb1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdb1"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_hdb2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdb2"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_hdb3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdb3"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_hdb4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdb4"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_hdc1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdc1"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_hdc2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdc2"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_hdc3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdc3"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_hdc4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdc4"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_hdd1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdd1"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_hdd2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdd2"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_hdd3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdd3"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_hdd4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hdd4"           >> /etc/nagios/nrpe.d/comandos.cfg
  # Discos SATA
    echo "command[check_sda1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sda1"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_sda2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sda2"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_sda3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sda3"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_sda4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sda4"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_sdb1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdb1"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_sdb2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdb2"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_sdb3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdb3"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_sdb4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdb4"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_sdc1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdc1"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_sdc2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdc2"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_sdc3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdc3"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_sdc4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdc4"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_sdd1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdd1"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_sdd2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdd2"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_sdd3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdd3"           >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_sdd4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sdd4"           >> /etc/nagios/nrpe.d/comandos.cfg
  # Discos NVMe
    echo "command[check_nvme0n1p1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme0n1p1" >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_nvme0n1p2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme0n1p2" >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_nvme0n1p3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme0n1p3" >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_nvme0n1p4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme0n1p4" >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_nvme1n1p1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme1n1p1" >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_nvme1n1p2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme1n1p2" >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_nvme1n1p3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme1n1p3" >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_nvme1n1p4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme1n1p4" >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_nvme2n1p1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme2n1p1" >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_nvme2n1p2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme2n1p2" >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_nvme2n1p3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme2n1p3" >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_nvme2n1p4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme2n1p4" >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_nvme3n1p1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme3n1p1" >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_nvme3n1p2]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme3n1p2" >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_nvme3n1p3]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme3n1p3" >> /etc/nagios/nrpe.d/comandos.cfg
    echo "command[check_nvme3n1p4]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/nvme3n1p4" >> /etc/nagios/nrpe.d/comandos.cfg

 
  # Comandos con argumentos acarrean riesgos de seguridad
  # Sólo pueden ser usados si se configura dont_blame_nrpe=1 en el archivo de configuración
  command[check_users]=/usr/lib/nagios/plugins/check_users $ARG1$
  command[check_load]=/usr/lib/nagios/plugins/check_load $ARG1$
  command[check_disk]=/usr/lib/nagios/plugins/check_disk $ARG1$
  command[check_swap]=/usr/lib/nagios/plugins/check_swap $ARG1$
  command[check_cpu_stats]=/usr/lib/nagios/plugins/check_cpu_stats.sh $ARG1$
  command[check_mem]=/usr/lib/nagios/plugins/custom_check_mem -n $ARG1$
  command[check_init_service]=sudo /usr/lib/nagios/plugins/check_init_service $ARG1$
  command[check_services]=/usr/lib/nagios/plugins/check_services -p $ARG1$
  command[check_all_procs]=/usr/lib/nagios/plugins/custom_check_procs
  command[check_procs]=/usr/lib/nagios/plugins/check_procs $ARG1$
  command[check_open_files]=/usr/lib/nagios/plugins/check_open_files.pl $ARG1$
  command[check_netstat]=/usr/lib/nagios/plugins/check_netstat.pl -p $ARG1$ $ARG2$

  echo ""
  echo "  Reiniciando el servidor nrpe..."
  echo ""
  systemctl restart nagios-nrpe-server

  echo ""
  echo "  La lista de comandos para ser llamados desde Nagios es:"
  echo ""
  cat /etc/nagios/nrpe.d/comandos.cfg | cut -d ']' -f1 | cut -d '[' -f2

fi
