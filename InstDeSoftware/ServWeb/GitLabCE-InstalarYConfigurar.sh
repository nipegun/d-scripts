#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar GitLabCE en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#  https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/GitLabCE-InstalarYConfigurar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#  https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/GitLabCE-InstalarYConfigurar.sh | sed 's-sudo--g' | bash
#
# NOTAS:
#   Más info aquí: https://about.gitlab.com/install/#debian
# ----------

vFQDNGitLab="gitlab.home.arpa"

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

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

if [ $cVerSO == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de GitLabCE para Debian 13 (Trixie)...${cFinColor}"
  echo ""

  # Actualizar el sistema
    sudo apt-get -y update
    sudo apt-get -y upgrade

  # Instalar paquetes necesarios
    sudo apt-get -y install curl
    sudo apt-get -y install ca-certificates
    sudo apt-get -y install gnupg2
    sudo apt-get -y install lsb-release

  # Instalar postfix para el sistema de mails
    sudo apt-get -y install postfix

  # Añadir el repo
    curl -fsSL https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
    # Cambiar repo trixie por bookworm (temporal haasta que haya uno oficial)
      sudo sed -i 's-trixie-bookworm-g' /etc/apt/sources.list.d/gitlab_gitlab-ce.list
    # Actualizar lista de paquetes del repo
      sudo apt-get -y update

  # Instlar paquete principal
    sudo apt-get -y install gitlab-ce

  # Configurar el DNS
    echo "127.0.0.1 $vFQDNGitLab" | sudo tee -a /etc/hosts
    #sed -i -e "s|external_url 'http://gitlab.example.com'|'http://gitlab.example.com'|g" /etc/gitlab/gitlab.rb

  # Reconfigurar gitlab
    # Cambios para contenedor LXC sin privilegios
      sudo sed -i '/^package\[\x27modify_kernel_parameters\x27\]/d' /etc/gitlab/gitlab.rb
      echo "package['modify_kernel_parameters'] = false" | sudo tee -a /etc/gitlab/gitlab.rb
      # Desactivar el stack de monitorización
        echo "prometheus_monitoring['enable'] = false" | sudo tee -a /etc/gitlab/gitlab.rb
        echo "node_exporter['enable'] = false"         | sudo tee -a /etc/gitlab/gitlab.rb
        echo "redis_exporter['enable'] = false"        | sudo tee -a /etc/gitlab/gitlab.rb
        echo "postgres_exporter['enable'] = false"     | sudo tee -a /etc/gitlab/gitlab.rb
        echo "gitlab_exporter['enable'] = false"       | sudo tee -a /etc/gitlab/gitlab.rb
        echo "alertmanager['enable'] = false"          | sudo tee -a /etc/gitlab/gitlab.rb
    sudo gitlab-ctl reconfigure

  # Notificar password
    echo ""
    echo "    Para loguearte usa el usuario root y el password que está en el archivo /etc/gitlab/initial_root_password."
    echo ""
    echo "    Mostrando el contenido del archivo /etc/gitlab/initial_root_password..."
    echo ""
    sudo cat /etc/gitlab/initial_root_password

  # Notificar fin de ejecución del script
    echo ""
    echo "    Ejecución del script, finalizada."
    echo ""
    vIPLocal=$(hostname -I | sed 's- --g' )
    echo "      Para acceder a la web:"
    echo ""
    echo "        http://$vIPLocal:80"
    echo ""
    echo "          o"
    echo ""
    echo "        http://$vIPLocal:443"
    echo ""
    echo "      Para desactivar la recolección y el envío de eventos a la gente de GitLab:"
    echo ""
    echo "        - Despliega la barra lateral izquierda (si no estña desplegada) y abajo a la derecha haz click en Admin"
    echo "        - Pasa el ratón por Settings y haz click en Metrics and profiling."
    echo "        - Expande Event tracking, deselecciona Enable event tracking y haz clock en el botón Save changes."
    echo ""
    echo "      Para cambiar la web de puerto hay que modificar el archivo /etc/gitlab/gitlab.rb"
    echo "        y cambiar external_url 'http://gitlab.ejemplo.com por external_url 'https://gitlab.ejemplo.com:8443"
    echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de GitLabCE para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de GitLabCE para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  # Actualizar la lista de paquetes
    apt-get -y update

  # Instalar paquetes requeridos
    apt-get -y install curl
    apt-get -y install openssh-server
    apt-get -y install ca-certificates
    apt-get -y install perl

  # Instalar postfix para el sistema de mails
    apt-get -y install postfix

  # Agregar el repositorio
    curl -sL https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | bash

  # Instalar paquete
    apt-get -y install gitlab-ee

  # Configurar el DNS
    echo "127.0.0.1 gitlab.example.com" >> /etc/hosts
    #sed -i -e "s|external_url 'http://gitlab.example.com'|'http://gitlab.example.com'|g" /etc/gitlab/gitlab.rb

  # Reconfigurar girlab
    gitlab-ctl reconfigure

  # Notificar password
    echo ""
    echo "    Para loguearte usa el usuario root y el password que está en el archivo /etc/gitlab/initial_root_password."
    echo ""
    echo "    Mostrando el contenido del archivo /etc/gitlab/initial_root_password..."
    echo ""
    cat /etc/gitlab/initial_root_password



elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de GitLabCE para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de GitLabCE para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de GitLabCE para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de GitLabCE para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

fi

