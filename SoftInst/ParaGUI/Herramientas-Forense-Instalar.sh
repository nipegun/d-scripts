
# dd
  apt-get -y install coreutils
# AFF (Advanced Forensic Format)
  apt-get -y install afflib-tools
# EWF (Expert Witness Format)
  apt-get -y install libewf-tools
# dc3dd
  apt-get -y install dc3dd


# Desactivar el automontaje de unidades de Gnome
  gsettings set org.gnome.desktop.media-handling automount false

# O se puede optar por instalar el paquete:
  apt-get -y install forensics-all # Debian Forensics Environment - essential components (metapackage)
