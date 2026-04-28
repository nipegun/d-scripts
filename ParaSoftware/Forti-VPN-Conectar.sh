#!/bin/bash

# Variables
  vHost="xxx"
  vPort="xxx"
  vUsername="xxx"
  #vPassword="xxx"
  vTrustedCert="xxx"

# Comprobar si el paquete openfortivpn está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s openfortivpn 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete openfortivpn no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install openfortivpn
    echo ""
  fi

# Crear el archivo de configuración
  echo "host = $vHost"                | sudo tee    /etc/openfortivpn/config
  echo "port = $vPort"                | sudo tee -a /etc/openfortivpn/config
  echo "username = $vUsername"        | sudo tee -a /etc/openfortivpn/config
  #echo "password = $vPassword"       | sudo tee -a /etc/openfortivpn/config
  echo "trusted-cert = $vTrustedCert" | sudo tee -a /etc/openfortivpn/config

# Conectar
  #sudo openfortivpn -v --trusted-cert "$vTrustedCert"
  sudo openfortivpn -v
