#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para desinstalar todos los controladores de NVIDIA de Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-Todos-Desintalar.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-Desintalar.sh | bash
# ----------

# Crear archivo con lista de paquetes a desinstalador
  apt-cache search nvidia | grep nvidia | sort | cut -d' ' -f1 | sed 's- --g'    > /tmp/PaquetesADesinstalar.txt.sh

# Crear script de desinstalación
  # Insertar apt-get -y autoremove al principio de cada línea
    cat /tmp/PaquetesADesinstalar.txt.sh | sed 's|^|apt-get -y autoremove |' > /tmp/DesinstalarControladoresNvidia.sh
  # Insertar el shebang al principio del script
    sed -i '1s|^|#!/bin/bash\n|' /tmp/DesinstalarControladoresNvidia.sh
  # Insertar la línea para borrar cuda-toolkit
    echo "apt-get -y autoremove nvidia-cuda-toolkit"  >> /tmp/DesinstalarControladoresNvidia.sh
  # Insertar la línea para purgar paquetes:
    echo "apt-get -y purge"     >> /tmp/DesinstalarControladoresNvidia.sh
  # Insertar la línea para autoclean:
    echo "apt-get -y autoclean" >> /tmp/DesinstalarControladoresNvidia.sh
  # Asignar permisos de ejecución al script
    chmod +x /tmp/DesinstalarControladoresNvidia.sh

# Ejecutar script
  sudo /tmp/DesinstalarControladoresNvidia.sh
  /tmp/DesinstalarControladoresNvidia.sh

# Borrar controladores web
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-DeWeb-Desinstalar.sh | bash
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-CUDAToolkit-DeWeb-Desinstalar.sh | bash
