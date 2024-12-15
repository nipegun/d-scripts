apt-get -y update
apt-get -y install cockpit
# Paquete para realizar un histórico de métricas
  apt-get -y install cockpit-pcp

# Permitir el acceso root
  echo "auth sufficient pam_rootok.so" >> /etc/pam.d/cockpit

