#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para desinstalar todos los controladores de NVIDIA de Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-Todos-Desinstalar.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-Desinstalar.sh | bash
# ----------

# Crear archivo con lista de paquetes a desinstalador
  apt-cache search nvidia  | grep nvidia  | sort | cut -d' ' -f1 | sed 's- --g'    > /tmp/PaquetesADesinstalar.txt.sh
  apt-cache search cuda    | grep cuda    | sort | cut -d' ' -f1 | sed 's- --g'   >> /tmp/PaquetesADesinstalar.txt.sh
  apt-cache search nouveau | grep nouveau | sort | cut -d' ' -f1 | sed 's- --g'   >> /tmp/PaquetesADesinstalar.txt.sh

# Crear script de desinstalación
  # Insertar apt-get -y autoremove al principio de cada línea
    cat /tmp/PaquetesADesinstalar.txt.sh | sed 's|^|apt-get -y autoremove --purge |' > /tmp/DesinstalarControladoresNvidia.sh
  # Insertar el shebang al principio del script
    sed -i '1s|^|#!/bin/bash\n|' /tmp/DesinstalarControladoresNvidia.sh
  # Insertar la línea para autoclean:
    echo "apt-get -y autoclean" >> /tmp/DesinstalarControladoresNvidia.sh
  # Asignar permisos de ejecución al script
    chmod +x /tmp/DesinstalarControladoresNvidia.sh

# Ejecutar script
  sudo /tmp/DesinstalarControladoresNvidia.sh

# Borrar controladores web
  #curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-DeWeb-Desinstalar.sh | bash
  #curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-DeWeb-CUDAToolkit-Desinstalar.sh | bash

# Blacklistear nouveau
  echo 'blacklist nouveau' | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
  sudo update-initramfs -u -k all

# Borrar carpetas archivos y enlaces que tengan nvidia en su nombre, sin recorrer otros sistemas de archivos
  sudo find / -xdev -depth -type d -iname '*nvidia*' -exec rm -rf -- {} +
  sudo find / -xdev \( -type f -o -type l \) -iname '*nvidia*' -exec rm -f -- {} +

# Borrar carpetas archivos y enlaces que tengan cuda en su nombre, sin recorrer otros sistemas de archivos
  sudo find / -xdev -depth -type d -iname '*cuda*' -exec rm -rf -- {} +
  sudo find / -xdev \( -type f -o -type l \) -iname '*cuda*' -exec rm -f -- {} +

# Notificar fin de ejecución del script
  echo ""
  echo "  Ejecución del script, finalizada."
  echo ""
