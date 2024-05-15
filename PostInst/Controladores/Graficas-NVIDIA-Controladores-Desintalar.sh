#!/bin/bash

# Crear archivo con lista de paquetes a desinstalador
  apt-cache search nvidia | grep nvidia | sort | cut -d' ' -f1 | sed 's- --g'    > /tmp/PaquetesADesinstalar.txt.sh

# Crear script de desinstalación
  # Insertar apt-get -y autoremove al principio de cada línea
    cat /tmp/PaquetesADesinstalar.txt.sh | sed 's|^|apt-get -y autoremove |' > /tmp/DesinstalarControladoresNvidia.sh
  # Insertar el shebang al principio del script
    sed -i '1s|^|#!/bin/bash\n|' original_file.txt
  # Asignar permisos de ejecución al script
    chmod +x /tmp/DesinstalarControladoresNvidia.sh

# Ejecutar script
  /tmp/DesinstalarControladoresNvidia.sh

