#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar reglas de auditd en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/AuditD-Reglas-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/AuditD-Reglas-Instalar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/AuditD-Reglas-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/AuditD-Reglas-Instalar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/AuditD-Reglas-Instalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Crear el menú
 # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install dialog
      echo ""
    fi
  menu=(dialog --checklist "Marca las reglas que quieras instalar:" 22 80 16)
    opciones=(
      1 "Reglas para Debian Base"          on
      2 "Reglas para Debian Desktop"       off
      3 "Reglas para Debian Firewall"      off
      4 "Reglas para Debian Server Apache" off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Instalando reglas de auditd para Debian Server..."
          echo ""


          echo ''                                                                                 | sudo tee    /etc/audit/rules.d/debian-base.rules
          echo '# Integridad del sistema'                                                         | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-w /etc/group -p wa -k cambios_group'                                             | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-w /etc/gshadow -p wa -k cambios_gshadow'                                         | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-w /etc/sudoers -p wa -k cambios_sudoers'                                         | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-w /etc/ssh/sshd_config -p wa -k cambios_sshd'                                    | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-w /etc/audit/ -p wa -k cambios_audit'                                            | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-w /etc/systemd/ -p wa -k cambios_systemd'                                        | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo ''                                                                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '#   Cambios de atributos o permisos'                                              | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -k cambios_permisos'    | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -k cambios_propietario' | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo ''                                                                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '# Creación o eliminación de usuarios'                                             | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-w /usr/sbin/useradd -p x -k useradd'                                             | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-w /usr/sbin/userdel -p x -k userdel'                                             | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-w /usr/sbin/usermod -p x -k usermod'                                             | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo ''                                                                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '# Intentos de elevación'                                                          | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo ''                                                                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '#   Lecturas de passwd y shadow'                                                  | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-w /etc/passwd -p r -k lectura_passwd'                                            | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-w /etc/shadow -p r -k lectura_shadow'                                            | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo ''                                                                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '#   Lectura de la carpeta /home'                                                  | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-w /home -p r -k listado_home'                                                    | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo ''                                                                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '#   Intento de determinar el usuario actual'                                      | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-a always,exit -F path=/usr/bin/pwd -F perm=x -k ejecucion_pwd'                   | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-a always,exit -F path=/usr/bin/whoami -F perm=x -k ejecucion_whoami'             | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo ''                                                                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '#   Ejecución binarios en carpetas temporales'                                    | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-a always,exit -F dir=/tmp -F perm=x -k ejecucion_tmp'                            | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-a always,exit -F dir=/var/tmp -F perm=x -k ejecucion_vartmp'                     | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo ''                                                                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '# Cambios de privilegios o escaladas (root)'                                      | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-a always,exit -F arch=b64 -S execve -C uid!=euid -F euid=0 -k privilege'         | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-a always,exit -F arch=b64 -S execve -F euid=0 -k exec_root'                      | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-w /etc/sudoers -p wa -k sudo'                                                    | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-w /etc/sudoers.d/ -p wa -k sudo'                                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo ''                                                                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '# Ficheros de logs y auditoría del propio auditd'                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-w /var/log/audit/     -p wa -k auditlog'                                         | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-w /etc/audit/         -p wa -k auditconfig'                                      | sudo tee -a /etc/audit/rules.d/debian-base.rules
          echo '-w /etc/audit/rules.d/ -p wa -k auditconfig'                                      | sudo tee -a /etc/audit/rules.d/debian-base.rules

        ;;

        2)

          echo ""
          echo "  Instalando reglas de auditd para Debian Desktop..."
          echo ""

        ;;

        3)

          echo ""
          echo "  Instalando reglas de auditd para Debian Firewall..."
          echo ""
          echo ''                                                                                          | sudo tee    /etc/audit/rules.d/debian-firewall.rules
          echo '# Cambios en iptables'                                                                     | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-w /sbin/iptables -p x -k firewall'                                                        | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-w /usr/sbin/iptables -p x -k firewall'                                                    | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-w /usr/sbin/ip6tables -p x -k firewall'                                                   | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo ''                                                                                          | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '# Cambios en nftables'                                                                     | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-w /usr/sbin/nft -p x -k firewall'                                                         | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-w /etc/nftables.conf -p wa -k firewall'                                                   | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo ''                                                                                          | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '# Cambios en reglas persistentes'                                                          | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-w /etc/iptables/ -p wa -k firewall'                                                       | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo ''                                                                                          | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '# Cambios de interfaces de red'                                                            | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-w /etc/network/interfaces -p wa -k network'                                               | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-w /etc/network/interfaces.d/ -p wa -k network'                                            | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo ''                                                                                          | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '# Cambios de configuración de resolv.conf'                                                 | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-w /etc/resolv.conf -p wa -k network'                                                      | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo ''                                                                                          | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '# Modificación de rutas y ajustes de red'                                                  | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-a always,exit -F arch=b64 -S sethostname,setdomainname -k netconfig'                      | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-a always,exit -F arch=b64 -S socket,connect,bind,accept -F exe=/usr/sbin/sshd -k netconn' | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo ''                                                                                          | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '# Cambios en sysctl que alteran el forwarding o parámetros de red'                         | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-w /etc/sysctl.conf -p wa -k sysctl'                                                       | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-w /etc/sysctl.d/ -p wa -k sysctl'                                                         | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo ''                                                                                          | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '# Cambios en modprobe (carga de módulos como nf_conntrack)'                                | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-w /etc/modprobe.d/ -p wa -k modules'                                                      | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo ''                                                                                          | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '# Binarios de red y administración'                                                        | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-w /sbin/ifconfig -p x -k nettools'                                                        | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-w /sbin/ip -p x -k nettools'                                                              | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-w /usr/bin/nmap -p x -k scanner'                                                          | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-w /usr/bin/netcat -p x -k scanner'                                                        | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
          echo '-w /bin/nc -p x -k scanner'                                                                | sudo tee -a /etc/audit/rules.d/debian-firewall.rules

        ;;

        4)
        # Apache
          echo '# Configuración de apache'                                                        | sudo tee -a /etc/audit/rules.d/debian-server.rules
          echo '-w /etc/apache2/ -p wa -k cambios_apache_conf'                                    | sudo tee -a /etc/audit/rules.d/debian-server.rules
          echo '-w /var/www/ -p wa -k cambios_webroot'                                            | sudo tee -a /etc/audit/rules.d/debian-server.rules
        ;;
    esac

done

