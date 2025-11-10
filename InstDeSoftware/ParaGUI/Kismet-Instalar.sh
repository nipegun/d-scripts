#!/bin/bash

# ----------
# Script de niPeGun para instalar kismet
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaGUI/Kismet-Instalar.sh | bash


# Borrar paques viejos
  sudo rm -rfv /usr/local/bin/kismet* /usr/local/share/kismet* /usr/local/etc/kismet*

# Agregar el repo
  wget -O - https://www.kismetwireless.net/repos/kismet-release.gpg.key --quiet | gpg --dearmor | sudo tee /usr/share/keyrings/kismet-archive-keyring.gpg >/dev/null
  echo 'deb [signed-by=/usr/share/keyrings/kismet-archive-keyring.gpg] https://www.kismetwireless.net/repos/apt/release/bookworm bookworm main' | sudo tee /etc/apt/sources.list.d/kismet.list >/dev/null

# Actualizar lista de paquetes disponibles en el repo
  sudo apt-get -y update

# instalar
  sudo apt-get -y install kismet

