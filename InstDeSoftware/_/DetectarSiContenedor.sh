#!/bin/bash

# Detectar si el script se está ejecutando dentro de un contendor LXC
  if [ "$(systemd-detect-virt)" = "lxc" ]; then
    echo "Contenedor lxc detectado"
  elif [ "$(systemd-detect-virt)" = "systemd-nspawn" ]; then
    echo "Contenedor systemd-nspawn detectado"
  fi

