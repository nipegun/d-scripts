#!/bin/bash

vPuntoDeMontaje=$1
vPuntoDeMontaje='/mnt/btrfs'

# escanea los bloques y verifica su integridad
  sudo btrfs scrub start -Bd "$vPuntoDeMontaje"

# Eliminar snapshots viejos
  # Primero listar los subvolúmenes:
    sudo btrfs subvolume list "$vPuntoDeMontaje"
  # Eliminar
    sudo btrfs subvolume delete "$vPuntoDeMontaje"/@snapshots/2025-07-01

# Balancear el sistema de archivos (reorganiza los bloques internos para reducir fragmentación y consolidar espacio)
  sudo btrfs balance start "$vPuntoDeMontaje"

# Eliminar archivos huérfanos o espacio no reclamado
  sudo btrfs filesystem defragment -r -clzo "$vPuntoDeMontaje"

