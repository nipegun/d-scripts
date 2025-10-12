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
#
# NOTAS:
#   -w             = watch (vigilar archivo o carpeta)
#   -p r           = permiso a vigilar (read)
#   -a always,exit = registrar cada ejecución del binario
#   -k             = etiqueta (clave) para identificar el evento en los logs
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Ver si auditd está instalado
  if ! systemctl list-unit-files | grep -q auditd.service; then
    echo ""
    echo -e "${cColorRojo}  El servicio auditd no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/AuditD-InstalarYConfigurar.sh | sed 's-sudo--g' | bash
    echo ""
  fi

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
      1 "Reglas para observación de integridad de auditd"    on
      2 "Reglas para observación básica de Debian"           on
      3 "Reglas para observación de Debian como CortaFuegos" off
      4 "Reglas para observación de gnome-desktop"           off
      5 "Reglas para observación de mate-desktop"            off
      6 "Reglas para observación de escalada de privilegios" off
      7 "Reglas para observación de apache2"                 off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

      1)

        echo ""
        echo "  Instalando reglas para la observación de la integridad de auditd..."
        echo ""

        echo ''                                            | sudo tee    /etc/audit/rules.d/debian-auditd.rules
        echo '# Archivos del propio auditd'                | sudo tee -a /etc/audit/rules.d/debian-auditd.rules
        echo '-w /etc/audit/         -p wa -k auditconfig' | sudo tee -a /etc/audit/rules.d/debian-auditd.rules
        echo '-w /etc/audit/rules.d/ -p wa -k auditrules'  | sudo tee -a /etc/audit/rules.d/debian-auditd.rules

        echo ""
        echo "    El archivo /etc/audit/rules.d/debian-auditd.rules ha quedado así"
        echo ""

      ;;

      2)

        echo ""
        echo "  Instalando reglas para la observación básica de Debian..."
        echo ""

        echo ''                                                                                 | sudo tee    /etc/audit/rules.d/debian-base.rules
        echo '# Integridad del sistema'                                                         | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '-w /etc/group           -p wa -k cambios_group'                                   | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '-w /etc/gshadow         -p wa -k cambios_gshadow'                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '-w /etc/passwd          -p wa -k usermgmt'                                        | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '-w /etc/shadow          -p wa -k usermgmt'                                        | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '-w /etc/ssh/sshd_config -p wa -k cambios_sshd'                                    | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '-w /etc/systemd/        -p wa -k cambios_systemd'                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo ''                                                                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '# sudo'                                                                           | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '-w /etc/sudoers    -p wa -k cambios_sudoers'                                      | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '-w /etc/sudoers.d/ -p wa -k cambios_sudoersd'                                     | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo ''                                                                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '# Cambios de atributos o permisos'                                                | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -k cambios_permisos'    | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -k cambios_propietario' | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo ''                                                                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '# Creación o eliminación de usuarios'                                             | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '-w /usr/sbin/useradd -p x -k useradd'                                             | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '-w /usr/sbin/userdel -p x -k userdel'                                             | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '-w /usr/sbin/usermod -p x -k usermod'                                             | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo ''                                                                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '# Ejecución de comandos como root'                                                | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo '-a exit,always -F arch=b64 -F euid=0 -S execve -k ejecucion_comomroot'            | sudo tee -a /etc/audit/rules.d/debian-base.rules
        echo ''                                                                                 | sudo tee -a /etc/audit/rules.d/debian-base.rules

      ;;

      3)

        echo ""
        echo "  Instalando reglas para la observación de Debian como CortaFuegos..."
        echo ""

        echo '# Cambios en iptables'                                                                     | sudo tee    /etc/audit/rules.d/debian-firewall.rules
        echo '-w /sbin/iptables      -p x -k firewall'                                                   | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
        echo '-w /usr/sbin/iptables  -p x -k firewall'                                                   | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
        echo '-w /usr/sbin/ip6tables -p x -k firewall'                                                   | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
        echo '#   Cambios en reglas persistentes'                                                        | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
        echo '-w /etc/iptables/ -p wa -k firewall'                                                       | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
        echo ''                                                                                          | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
        echo '# Cambios en nftables'                                                                     | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
        echo '-w /usr/sbin/nft      -p x -k firewall'                                                    | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
        echo '-w /etc/nftables.conf -p wa -k firewall'                                                   | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
        echo ''                                                                                          | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
        echo '# Cambios de interfaces de red'                                                            | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
        echo '-w /etc/network/interfaces    -p wa -k network'                                            | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
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
        echo '-w /sbin/ifconfig  -p x -k nettools'                                                       | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
        echo '-w /sbin/ip        -p x -k nettools'                                                       | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
        echo '-w /usr/bin/nmap   -p x -k scanner'                                                        | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
        echo '-w /usr/bin/netcat -p x -k scanner'                                                        | sudo tee -a /etc/audit/rules.d/debian-firewall.rules
        echo '-w /bin/nc         -p x -k scanner'                                                        | sudo tee -a /etc/audit/rules.d/debian-firewall.rules

      ;;

      4)

        echo ""
        echo "  Instalando reglas para Debian GNOME Desktop..."
        echo ""
        echo ''                                              | sudo tee    /etc/audit/rules.d/debian-gnome.rules
        echo '# Autenticación y sudo'                        | sudo tee -a /etc/audit/rules.d/debian-gnome.rules
        echo '-w /var/log/faillog  -p wa -k auth'            | sudo tee -a /etc/audit/rules.d/debian-gnome.rules
        echo '-w /var/log/lastlog  -p wa -k auth'            | sudo tee -a /etc/audit/rules.d/debian-gnome.rules
        echo '-w /var/log/tallylog -p wa -k auth'            | sudo tee -a /etc/audit/rules.d/debian-gnome.rules
        echo ''                                              | sudo tee -a /etc/audit/rules.d/debian-gnome.rules
        echo '# Configuración de GNOME'                      | sudo tee -a /etc/audit/rules.d/debian-gnome.rules
        echo '-w /etc/gdm3/           -p wa -k gdm'          | sudo tee -a /etc/audit/rules.d/debian-gnome.rules
        echo '-w /etc/NetworkManager/ -p wa -k netcfg'       | sudo tee -a /etc/audit/rules.d/debian-gnome.rules
        echo '-w /etc/pam.d/          -p wa -k pam'          | sudo tee -a /etc/audit/rules.d/debian-gnome.rules
        echo '-w /usr/share/gnome/    -p wa -k gnome_config' | sudo tee -a /etc/audit/rules.d/debian-gnome.rules
        echo '-w /etc/dconf/          -p wa -k dconf'        | sudo tee -a /etc/audit/rules.d/debian-gnome.rules

      ;;

      5)

        echo ""
        echo "  Instalando reglas para observación de mate-desktop..."
        echo ""

        echo ''                                                          | sudo tee    /etc/audit/rules.d/debian-mate.rules
        echo '# Autenticación y sudo'                                    | sudo tee -a /etc/audit/rules.d/debian-mate.rules
        echo '-w /etc/sudoers    -p wa -k sudo'                          | sudo tee -a /etc/audit/rules.d/debian-mate.rules
        echo '-w /etc/sudoers.d/ -p wa -k sudo'                          | sudo tee -a /etc/audit/rules.d/debian-mate.rules
        echo ''                                                          | sudo tee -a /etc/audit/rules.d/debian-mate.rules
        echo '# Configuración de MATE'                                   | sudo tee -a /etc/audit/rules.d/debian-mate.rules
        echo '-w /usr/share/mate/             -p wa -k mate_config'      | sudo tee -a /etc/audit/rules.d/debian-mate.rules
        echo '-w /usr/share/glib-2.0/schemas/ -p wa -k gsettings'        | sudo tee -a /etc/audit/rules.d/debian-mate.rules
        echo '-w /etc/dconf/                  -p wa -k dconf'            | sudo tee -a /etc/audit/rules.d/debian-mate.rules
        echo '-w /usr/bin/mate-session        -p x -k mate_session_exec' | sudo tee -a /etc/audit/rules.d/debian-mate.rules

      ;;

      6)

        echo ""
        echo "  Instalando reglas para observación de escalada de privilegios..."
        echo ""

        echo ''                                                                         | sudo tee    /etc/audit/rules.d/debian-privesc.rules
        echo '# Intento de determinar el usuario actual'                                | sudo tee -a /etc/audit/rules.d/debian-privesc.rules
        echo '-a always,exit -F path=/usr/bin/pwd    -F perm=x -k ejecucion_pwd'        | sudo tee -a /etc/audit/rules.d/debian-privesc.rules
        echo '-a always,exit -F path=/usr/bin/whoami -F perm=x -k ejecucion_whoami'     | sudo tee -a /etc/audit/rules.d/debian-privesc.rules
        echo ''                                                                         | sudo tee -a /etc/audit/rules.d/debian-privesc.rules
        echo '# Listado de la carpeta /home'                                            | sudo tee -a /etc/audit/rules.d/debian-privesc.rules
        echo '-w /home -p r -k listado_home'                                            | sudo tee -a /etc/audit/rules.d/debian-privesc.rules
        echo ''                                                                         | sudo tee -a /etc/audit/rules.d/debian-privesc.rules
        echo '# Lecturas de passwd y shadow'                                            | sudo tee -a /etc/audit/rules.d/debian-privesc.rules
        echo '-w /etc/passwd -p r -k lectura_passwd'                                    | sudo tee -a /etc/audit/rules.d/debian-privesc.rules
        echo '-w /etc/shadow -p r -k lectura_shadow'                                    | sudo tee -a /etc/audit/rules.d/debian-privesc.rules
        echo ''                                                                         | sudo tee -a /etc/audit/rules.d/debian-privesc.rules
        echo '# Ejecución binarios en carpetas temporales'                              | sudo tee -a /etc/audit/rules.d/debian-privesc.rules
        echo '-a always,exit -F dir=/tmp     -F perm=x -k ejecucion_tmp'                | sudo tee -a /etc/audit/rules.d/debian-privesc.rules
        echo '-a always,exit -F dir=/var/tmp -F perm=x -k ejecucion_vartmp'             | sudo tee -a /etc/audit/rules.d/debian-privesc.rules
        echo ''                                                                         | sudo tee -a /etc/audit/rules.d/debian-privesc.rules
        echo '# Cambios de privilegios o escaladas (root)'                              | sudo tee -a /etc/audit/rules.d/debian-privesc.rules
        echo '-a always,exit -F arch=b64 -S execve -C uid!=euid -F euid=0 -k privilege' | sudo tee -a /etc/audit/rules.d/debian-privesc.rules
        echo '-a always,exit -F arch=b64 -S execve -F euid=0 -k exec_root'              | sudo tee -a /etc/audit/rules.d/debian-privesc.rules

      ;;

      7)

        echo ""
        echo "  Instalando reglas para la observación de apache2..."
        echo ""

        echo ''                                              | sudo tee    /etc/audit/rules.d/debian-apache2.rules
        echo '# Apache y webroot'                            | sudo tee -a /etc/audit/rules.d/debian-apache2.rules
        echo '-w /etc/apache2/ -p wa -k cambios_apache_conf' | sudo tee -a /etc/audit/rules.d/debian-apache2.rules
        echo '-w /var/www/     -p wa -k cambios_webroot'     | sudo tee -a /etc/audit/rules.d/debian-apache2.rules

      ;;

    esac
  done

# Aplicar las reglas
  echo ""
  echo -e "${cColorVerde}  Aplicando las reglas seleccionadas...${cFinColor}"
  echo ""
  sudo augenrules --load
  sudo systemctl restart auditd
  echo ""
  echo -e "${cColorVerde}  Las reglas se han aplicado correctamente.${cFinColor}"
  echo ""
  echo "    Archivos de reglas generados:"
  echo ""
  ls -1 /etc/audit/rules.d/ | grep debian- | sort
  echo ""
