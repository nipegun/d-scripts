#!/bin/bash

# curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Archivos-Modificados-PorFecha-Mostrar.sh | sed 's-xxx-/home-g' | bash

vRuta='xxx'

find "$vRuta" -type f -printf "%T@ %p\n" | sort -nr
