#!/bin/bash

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then # Comprueba si el usuario es únicamente root
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse únicamente como root.${cFinColor}"
    echo ""
    exit
  fi
