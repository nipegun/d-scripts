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

#vVersWazuh='4.x'
vVersWazuh="$(curl -sL https://documentation.wazuh.com/current/installation-guide/wazuh-agent/wazuh-agent-package-linux.html | grep release-notes | grep index- | cut -d'>' -f3 | cut -d '<' -f1 | head -n1)"

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
          echo "  Instalando wazuh-agent en un Debian Baremetal o MV de Debian..."
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
            curl -L https://packages.wazuh.com/"$vVersWazuh"/apt/pool/main/w/wazuh-agent/"$vArchivoDeb" -o /tmp/wazuh-agent.deb

          # Lanzar el script de instalación
            sudo WAZUH_MANAGER="$vWazuhServerIP" apt -y install /tmp/wazuh-agent.deb

          # Aumentar el tamaño del buffer
            sudo sed -i 's|<queue_size>5000</queue_size>|<queue_size>100000</queue_size>|g'                          /var/ossec/etc/ossec.conf
            sudo sed -i 's|<events_per_second>500</events_per_second>|<events_per_second>1000</events_per_second>|g' /var/ossec/etc/ossec.conf



sudo usermod -aG systemd-journal wazuh
sudo chown -R wazuh:wazuh /var/ossec

User=ossec
Group=ossec


          # Iniciar el servicio
            sudo systemctl daemon-reload
            sudo systemctl enable wazuh-agent
            sudo systemctl start wazuh-agent
            sleep 3
            sudo systemctl status wazuh-agent --no-pager

        ;;

        2)

          echo ""
          echo "  Instalando wazuh-agent en un contendor LXC de Proxmox..."
          echo ""

          # Instalar paquetes necesarios para el correcto funcionamiento del agente
            sudo apt-get -y update
            sudo apt-get -y install net-tools
            sudo apt-get -y install curl

          # Desinstalar auditd
            curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/AuditD-Desinstalar.sh | sed 's-sudo--g' | bash

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

          # Aumentar el tamaño del buffer
            sudo sed -i 's|<queue_size>5000</queue_size>|<queue_size>100000</queue_size>|g'                          /var/ossec/etc/ossec.conf
            sudo sed -i 's|<events_per_second>500</events_per_second>|<events_per_second>1000</events_per_second>|g' /var/ossec/etc/ossec.conf

          # Preparar el archivo de configuración para contenedores LXC
            sudo cp -v /var/ossec/etc/ossec.conf /var/ossec/etc/ossec.conf.bak
            sudo tee /var/ossec/etc/ossec.conf > /dev/null <<-'EOF'
<!--
  Wazuh - Agent - Configuración optimizada para contenedores LXC sin privilegios
  NiPeGun - Debian 12/13
-->

<ossec_config>
  <client>
    <server>
      <address>10.10.0.250</address>
      <port>1514</port>
      <protocol>tcp</protocol>
    </server>
    <config-profile>debian, debian12</config-profile>
    <notify_time>20</notify_time>
    <time-reconnect>60</time-reconnect>
    <auto_restart>yes</auto_restart>
    <crypto_method>aes</crypto_method>
  </client>

  <client_buffer>
    <disabled>no</disabled>
    <queue_size>5000</queue_size>
    <events_per_second>500</events_per_second>
  </client_buffer>

  <rootcheck>
    <disabled>yes</disabled>
  </rootcheck>

  <wodle name="osquery">
    <disabled>yes</disabled>
  </wodle>

  <wodle name="syscollector">
    <disabled>no</disabled>
    <interval>1h</interval>
    <scan_on_start>yes</scan_on_start>
    <hardware>no</hardware>
    <os>yes</os>
    <network>yes</network>
    <packages>yes</packages>
    <ports all="yes">yes</ports>
    <processes>yes</processes>
    <synchronization>
      <max_eps>10</max_eps>
    </synchronization>
  </wodle>

  <sca>
    <enabled>no</enabled>
  </sca>

  <syscheck>
    <disabled>no</disabled>
    <frequency>3600</frequency>
    <scan_on_start>yes</scan_on_start>
    <directories>/etc,/var/www,/home</directories>
    <ignore>/etc/mtab</ignore>
    <ignore>/etc/hosts.deny</ignore>
    <ignore>/etc/adjtime</ignore>
    <ignore type="sregex">.log$|.swp$</ignore>
    <skip_nfs>yes</skip_nfs>
    <skip_dev>yes</skip_dev>
    <skip_proc>yes</skip_proc>
    <skip_sys>yes</skip_sys>
    <process_priority>10</process_priority>
    <max_eps>50</max_eps>
    <synchronization>
      <enabled>yes</enabled>
      <interval>5m</interval>
      <max_eps>10</max_eps>
    </synchronization>
  </syscheck>

  <localfile>
    <log_format>journald</log_format>
    <location>journald</location>
  </localfile>

  <localfile>
    <log_format>syslog</log_format>
    <location>/var/log/auth.log</location>
  </localfile>

  <localfile>
    <log_format>syslog</log_format>
    <location>/var/log/syslog</location>
  </localfile>

  <localfile>
    <log_format>apache</log_format>
    <location>/var/log/apache2/error.log</location>
  </localfile>

  <localfile>
    <log_format>apache</log_format>
    <location>/var/log/apache2/access.log</location>
  </localfile>

  <active-response>
    <disabled>no</disabled>
    <ca_store>etc/wpk_root.pem</ca_store>
    <ca_verification>yes</ca_verification>
  </active-response>

  <logging>
    <log_format>plain</log_format>
  </logging>
</ossec_config>
EOF

          # Crear nuevas reglas
            sudo mkdir -p /var/ossec/etc/rules/
            sudo tee /var/ossec/etc/rules/lxc_rules.xml > /dev/null <<-'EOF'
<!--
  Reglas personalizadas para agente Wazuh en contenedor LXC Debian sin privilegios
  NiPeGun - 2025
-->

<group name="local,">
  
  <!-- ========================================= -->
  <!--  SSH: intentos fallidos y fuerza bruta    -->
  <!-- ========================================= -->
  <group name="ssh,authentication,">
    <rule id="100100" level="5">
      <if_sid>5710</if_sid>
      <description>SSH: intento fallido de inicio de sesión dentro del contenedor LXC</description>
      <group>ssh,authentication,invalid_login,</group>
    </rule>

    <rule id="100101" level="8" frequency="5" timeframe="300">
      <if_matched_sid>5710</if_matched_sid>
      <description>SSH: múltiples intentos fallidos de inicio de sesión dentro del contenedor LXC</description>
      <group>ssh,authentication,bruteforce,</group>
    </rule>
  </group>

  <!-- ========================================= -->
  <!--  Dpkg / APT: instalación y eliminación    -->
  <!-- ========================================= -->
  <group name="apt,dpkg,">
    <rule id="100110" level="4">
      <decoded_as>syslog</decoded_as>
      <match>install</match>
      <description>Paquete instalado dentro del contenedor Debian</description>
    </rule>

    <rule id="100111" level="4">
      <decoded_as>syslog</decoded_as>
      <match>upgrade</match>
      <description>Paquete actualizado dentro del contenedor Debian</description>
    </rule>

    <rule id="100112" level="7">
      <decoded_as>syslog</decoded_as>
      <match>remove</match>
      <description>Paquete desinstalado dentro del contenedor Debian</description>
    </rule>
  </group>

  <!-- ========================================= -->
  <!--  Sistema: reinicio detectado              -->
  <!-- ========================================= -->
  <group name="system,">
    <rule id="100120" level="5">
      <match>systemd.*Starting.*hostname.service</match>
      <description>El contenedor LXC Debian se está reiniciando (hostname.service)</description>
    </rule>
  </group>

  <!-- ========================================= -->
  <!--  Red: nuevos puertos en escucha           -->
  <!-- ========================================= -->
  <group name="network,ports,">
    <rule id="100130" level="7">
      <match>LISTEN</match>
      <description>Nuevo puerto en escucha detectado dentro del contenedor LXC</description>
    </rule>
  </group>

  <!-- ========================================= -->
  <!--  Procesos sospechosos o shell abierta     -->
  <!-- ========================================= -->
  <group name="process,">
    <rule id="100140" level="8">
      <match>bash</match>
      <description>Shell interactiva iniciada dentro del contenedor LXC</description>
    </rule>

    <rule id="100141" level="10">
      <match>nc\ |netcat|nmap|masscan|socat</match>
      <description>Herramienta de red potencialmente maliciosa detectada dentro del contenedor LXC</description>
    </rule>
  </group>

  <!-- ========================================= -->
  <!--  Integridad de archivos del contenedor    -->
  <!-- ========================================= -->
  <group name="syscheck,integrity,">
    <rule id="100150" level="7">
      <if_sid>550</if_sid>
      <description>Archivo de configuración modificado dentro del contenedor LXC</description>
    </rule>
  </group>

</group>
EOF

          # Iniciar el servicio
            sudo systemctl daemon-reload
            sudo systemctl enable wazuh-agent
            sudo systemctl start wazuh-agent
            sleep 3
            sudo systemctl status wazuh-agent --no-pager

        ;;

    esac

done
