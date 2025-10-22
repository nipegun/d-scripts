#!/bin/bash

# Detectar si el script se está ejecutando dentro de un contendor LXC
  if [ "$(systemd-detect-virt)" = "lxc" ]; then
    echo "Contenedor LXC detectado"
  fi

