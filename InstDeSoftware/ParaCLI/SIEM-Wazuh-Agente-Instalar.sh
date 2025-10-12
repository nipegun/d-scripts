#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar el agente de Wazuh en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/SIEM-Wazuh-Agente-Instalar.sh | bash -s '[IPDelWazuhServer]'
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/SIEM-Wazuh-Agente-Instalar.sh | sed 's-sudo--g' | bash -s '[IPDelWazuhServer]'
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/SIEM-Wazuh-Agente-Instalar.sh | nano -
# ----------

vVersWazuh='4.x'
vArchivoDeb='wazuh-agent_4.13.1-1_amd64.deb'
vWazuhServerIP="$1"

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
  menu=(dialog --checklist "Donde quieres instalar wazuh-agent:" 22 80 16)
    opciones=(
      1 "En un Debian baremetal o MV de Debian" off
      2 "En un contenedor LXC de Debian"        off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Instalando wazuh-agent en un Debain Baremetal o MV de Debian..."
          echo ""

          # Instalar paquetes necesarios para el correcto funcionamiento del agente
            sudo apt-get -y update
            sudo apt-get -y install net-tools

          # Descargar el script de instalación
            cd /tmp/
            # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}  El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install wget
                echo ""
              fi
            wget https://packages.wazuh.com/"$vVersWazuh"/apt/pool/main/w/wazuh-agent/"$vArchivoDeb"

          # Lanzar el script de instalación
            sudo WAZUH_MANAGER="$vWazuhServerIP" apt -y install ./"$vArchivoDeb"

          # Iniciar el servicio
            sudo systemctl daemon-reload
            sudo systemctl enable wazuh-agent
            sudo systemctl start wazuh-agent
            sleep 3
            sudo systemctl status wazuh-agent --no-pager

          # Conectar con auditd
            sudo mkdir -p /var/ossec/etc/rules/ 2> /dev/null
            echo '<group name="auditd,">'                                          | sudo tee    /var/ossec/etc/rules/local_rules.xml
            echo '  <rule id="100501" level="10">'                                 | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '    <if_sid>80700</if_sid>'                                      | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '    <field name="audit.key">lectura_passwd</field>'              | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '    <description>Lectura del archivo /etc/passwd</description>'  | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '  </rule>'                                                       | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo ''                                                                | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '  <rule id="100502" level="12">'                                 | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '    <if_sid>80700</if_sid>'                                      | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '    <field name="audit.key">lectura_shadow</field>'              | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '    <description>Lectura del archivo /etc/shadow</description>'  | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '  </rule>'                                                       | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo ''                                                                | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '  <rule id="100503" level="8">'                                  | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '    <if_sid>80700</if_sid>'                                      | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '    <field name="audit.key">listado_home</field>'                | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '    <description>Intento de listado de /home (ls)</description>' | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '  </rule>'                                                       | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo ''                                                                | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '  <rule id="100504" level="5">'                                  | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '    <if_sid>80700</if_sid>'                                      | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '    <field name="audit.key">ejecucion_pwd</field>'               | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '    <description>Ejecución del comando pwd</description>'        | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '  </rule>'                                                       | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo ''                                                                | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '  <rule id="100505" level="5">'                                  | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '    <if_sid>80700</if_sid>'                                      | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '    <field name="audit.key">ejecucion_whoami</field>'            | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '    <description>Ejecución del comando whoami</description>'     | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '  </rule>'                                                       | sudo tee -a /var/ossec/etc/rules/local_rules.xml
            echo '</group>'                                                        | sudo tee -a /var/ossec/etc/rules/local_rules.xml

          # Agregar el archivo de log de audit
            sudo sed -i -e s'|</ossec_config>|  <localfile>\n    <log_format>audit</log_format>\n    <location>/var/log/audit/audit.log</location>\n  </localfile>\n\n</ossec_config>|' /var/ossec/etc/ossec.conf

          # Reinciar wazuh-manager
            sudo systemctl restart wazuh-agent

        ;;

        2)

          echo ""
          echo "  Instalando wazuh-agent en un contendor LXC de Proxmox..."
          echo ""

          # Instalar paquetes necesarios para el correcto funcionamiento del agente
            sudo apt-get -y update
            sudo apt-get -y install net-tools

          # Descargar el script de instalación
            cd /tmp/
            # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}  El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install wget
                echo ""
              fi
            wget https://packages.wazuh.com/"$vVersWazuh"/apt/pool/main/w/wazuh-agent/"$vArchivoDeb"

          # Lanzar el script de instalación
            sudo WAZUH_MANAGER="$vWazuhServerIP" apt -y install ./"$vArchivoDeb"

          # Iniciar el servicio
            sudo systemctl daemon-reload
            sudo systemctl enable wazuh-agent
            sudo systemctl start wazuh-agent
            sleep 3
            sudo systemctl status wazuh-agent --no-pager

          # Preparar el archivo de configuraciópn para contenedores LXC
            vArchivoConf="/var/ossec/etc/ossec.conf"
            # Desactivar rootcheck
              sudo sed -i '/<rootcheck>/,/<\/rootcheck>/s|<disabled>no</disabled>|<disabled>yes</disabled>|' "$vArchivoConf"
            # Desactivar SCA
              sudo sed -i '/<sca>/,/<\/sca>/s|<enabled>yes</enabled>|<enabled>no</enabled>|' "$vArchivoConf"
            # Mantener syscollector activo y sin hardware
              sed -i '/<wodle name="syscollector">/,/<\/wodle>/{
                s|<disabled>yes</disabled>|<disabled>no</disabled>|
                s|<hardware>yes</hardware>|<hardware>no</hardware>|
              }' "$vArchivoConf"
            # Eliminar cualquier bloque <localfile> con /var/log/audit/audit.log
              sed -i '/<localfile>/,/<\/localfile>/{
                /<location>\/var\/log\/audit\/audit.log<\/location>/,/<\/localfile>/d
              }' "$vArchivoConf"
            # Reescribir sección syscheck completa
              sed -i '/<syscheck>/,/<\/syscheck>/c\
                <syscheck>\n\
                  <disabled>no</disabled>\n\
                  <frequency>3600</frequency>\n\
                  <scan_on_start>yes</scan_on_start>\n\
                  <directories>/etc,/var/www,/home</directories>\n\
                  <ignore type="sregex">.log$|.swp$</ignore>\n\
                  <skip_nfs>yes</skip_nfs>\n\
                  <skip_dev>yes</skip_dev>\n\
                  <skip_proc>yes</skip_proc>\n\
                  <skip_sys>yes</skip_sys>\n\
                  <process_priority>10</process_priority>\n\
                  <max_eps>50</max_eps>\n\
                </syscheck>' "$vArchivoConf"
            # Asegurar que active-response quede habilitado
              sed -i '/<active-response>/,/<\/active-response>/s|<disabled>yes</disabled>|<disabled>no</disabled>|' "$vArchivoConf"
            # Añadir logs básicos si no existen
              if ! grep -q '/var/log/syslog' "$vArchivoConf"; then
                echo "  <localfile>"                              | sudo tee -a "$vArchivoConf"
                echo "    <log_format>syslog</log_format>"        | sudo tee -a "$vArchivoConf"
                echo "    <location>/var/log/syslog</location>"   | sudo tee -a "$vArchivoConf"
                echo "  </localfile>"                             | sudo tee -a "$vArchivoConf"
                echo ""                                           | sudo tee -a "$vArchivoConf"
                echo "  <localfile>"                              | sudo tee -a "$vArchivoConf"
                echo "    <log_format>syslog</log_format>"        | sudo tee -a "$vArchivoConf"
                echo "    <location>/var/log/auth.log</location>" | sudo tee -a "$vArchivoConf"
                echo "  </localfile>"                             | sudo tee -a "$vArchivoConf"
                echo ""                                           | sudo tee -a "$vArchivoConf"
              fi
            # Limpiar líneas vacías repetidas
              sed -i '/^[[:space:]]*$/N;/^\n$/D' "$vArchivoConf"

          # Crear nuevas reglas
            /var/ossec/etc/rules/lxc_rules.xml

          # Reinciar wazuh-manager
            sudo systemctl restart wazuh-agent


        ;;

    esac

done
