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

        ;;

    esac

done
