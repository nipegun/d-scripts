#!/bin/bash

# Comprobar si el script está corriendo como root
  if [[ $EUID -ne 0 ]]; then # Comprueba si los privilegios son root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi
