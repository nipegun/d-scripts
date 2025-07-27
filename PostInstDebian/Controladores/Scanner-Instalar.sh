#!/bin/bash

vIPDelScanner="$1"

# Actualizar lista de paquetes disponibles en los repositorios
  sudo apt update

# Sane
  # Instalar paquete
    sudo apt install sane-utils
  #Indicar IP del scanner
    echo "$vIPDelScanner" | sudo -a /etc/sane.d/net.conf
  # Asegurarnos de que la línea net esté presente y descomentada en /etc/sane.d/dll.conf
    sudo sed -i '/^[[:space:]]*#[[:space:]]*net[[:space:]]*$/s/^#//; $a\net' /etc/sane.d/dll.conf
  # Reiniciar el servicio
    sudo systemctl restart saned.socket
    sudo saned -d

# AirScan
  # Instalar paquetes
    sudo apt -y install ipp-usb
    sudo apt -y install airscan

