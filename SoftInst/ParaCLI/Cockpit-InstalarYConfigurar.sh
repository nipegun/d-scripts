apt-get -y update
apt-get -y install cockpit


# Cockpit user interface for 389 Directory Server
  apt-get -y install cockpit-389-ds
# Cockpit bridge server-side component
  apt-get -y install cockpit-bridge
# Cockpit deployment and developer guide
  apt-get -y install cockpit-doc
# Cockpit user interface for virtual machines
  apt-get -y install cockpit-machines
# Cockpit user interface for networking
  apt-get -y install cockpit-networkmanager
# Cockpit user interface for packages
  apt-get -y install cockpit-packagekit
# Cockpit PCP integration (para métricas)
  apt-get -y install cockpit-pcp
# Cockpit component for Podman containers
  apt-get -y install cockpit-podman
# Cockpit user interface for diagnostic reports
  apt-get -y install cockpit-sosreport
# Cockpit user interface for storage
  apt-get -y install cockpit-storaged
# Cockpit admin interface for a system
  apt-get -y install cockpit-system
# Tests for Cockpit
  apt-get -y install cockpit-tests
# Cockpit Web Service
  apt-get -y install cockpit-ws

# Instalar soporte NFS
  apt-get -y install nfs-common

# Permitir el acceso root
  echo "auth sufficient pam_rootok.so" >> /etc/pam.d/cockpit

