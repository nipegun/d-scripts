#!/bin/bash

#############################
# script no terminado

############################

  mkdir -p /root/aptkeys/
  # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install wget
      echo ""
    fi
  wget -q -O- https://packages.grafana.com/gpg.key > /root/aptkeys/grafana.key
  # Comprobar si el paquete gnupg2 está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s gnupg2 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete gnupg2 no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install gnupg2
      echo ""
    fi
  gpg --dearmor /root/aptkeys/grafana.key
  cp /root/aptkeys/grafana.key.gpg /etc/apt/keyrings/grafana.gpg

  echo ""
  echo "  Agregando repositorio..." 
  echo ""
  echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee -a /etc/apt/sources.list.d/grafana.list

