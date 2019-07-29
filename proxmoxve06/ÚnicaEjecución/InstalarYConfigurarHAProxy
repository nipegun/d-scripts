#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar HAProxy en ProxmoxVE.
#
#  El objetivo es correr muchos serviores web en PVE y routear el tráfico que llega al host Proxmox hacia cada servidor web
#  correspondiente basándose en el nombre de dominio (SNI).
#
#  Deberás modificar el script cambiando web1 y web2 por los correspondientes dominios. En el caso de necesitar más,
#  simplemente agrégalos siguiéndo la lógica.
#----------------------------------------------------------------------------------------------------------------------------

# Actualizar los repositorios
apt-get -y update

# Instalar el paquete necesario
apt-get -y install haproxy

# Hacer copia de seguridad del archivo de configuración
cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.bak

# Realizar cambios en la configuración
echo "global" > /etc/haproxy/haproxy.cfg
echo "  log /dev/log    local0" >> /etc/haproxy/haproxy.cfg
echo "  log /dev/log    local1 notice" >> /etc/haproxy/haproxy.cfg
echo "  chroot /var/lib/haproxy" >> /etc/haproxy/haproxy.cfg
echo "  stats socket /run/haproxy/admin.sock mode 660 level admin" >> /etc/haproxy/haproxy.cfg
echo "  stats timeout 30s" >> /etc/haproxy/haproxy.cfg
echo "  maxconn 4096" >> /etc/haproxy/haproxy.cfg
echo "  user haproxy" >> /etc/haproxy/haproxy.cfg
echo "  group haproxy" >> /etc/haproxy/haproxy.cfg
echo "  daemon" >> /etc/haproxy/haproxy.cfg
echo "" >> /etc/haproxy/haproxy.cfg
echo "defaults" >> /etc/haproxy/haproxy.cfg
echo "  log     global" >> /etc/haproxy/haproxy.cfg
echo "  option  dontlognull" >> /etc/haproxy/haproxy.cfg
echo "  timeout connect 15s" >> /etc/haproxy/haproxy.cfg
echo "  timeout client  15s" >> /etc/haproxy/haproxy.cfg
echo "  timeout server  15s" >> /etc/haproxy/haproxy.cfg
echo "  errorfile 400 /etc/haproxy/errors/400.http" >> /etc/haproxy/haproxy.cfg
echo "  errorfile 403 /etc/haproxy/errors/403.http" >> /etc/haproxy/haproxy.cfg
echo "  errorfile 408 /etc/haproxy/errors/408.http" >> /etc/haproxy/haproxy.cfg
echo "  errorfile 500 /etc/haproxy/errors/500.http" >> /etc/haproxy/haproxy.cfg
echo "  errorfile 502 /etc/haproxy/errors/502.http" >> /etc/haproxy/haproxy.cfg
echo "  errorfile 503 /etc/haproxy/errors/503.http" >> /etc/haproxy/haproxy.cfg
echo "  errorfile 504 /etc/haproxy/errors/504.http" >> /etc/haproxy/haproxy.cfg
echo "" >> /etc/haproxy/haproxy.cfg
echo "frontend wan-http-in" >> /etc/haproxy/haproxy.cfg
echo "  bind *:80" >> /etc/haproxy/haproxy.cfg
echo "  mode http" >> /etc/haproxy/haproxy.cfg
echo "  redirect scheme https code 301 if !{ ssl_fc }" >> /etc/haproxy/haproxy.cfg
echo "" >> /etc/haproxy/haproxy.cfg
echo "frontend wan-https-in" >> /etc/haproxy/haproxy.cfg
echo "  bind *:443" >> /etc/haproxy/haproxy.cfg
echo "  mode tcp" >> /etc/haproxy/haproxy.cfg
echo "  option tcplog" >> /etc/haproxy/haproxy.cfg
echo "  acl tls req.ssl_hello_type 1" >> /etc/haproxy/haproxy.cfg
echo "  tcp-request inspect-delay 5s" >> /etc/haproxy/haproxy.cfg
echo "  tcp-request content accept if tls" >> /etc/haproxy/haproxy.cfg
echo "" >> /etc/haproxy/haproxy.cfg
echo "  # Webs" >> /etc/haproxy/haproxy.cfg
echo "  use_backend be-https-sitio1 if { req_ssl_sni -i sitio1.com } or { req_ssl_sni -i www.sitio1.com }" >> /etc/haproxy/haproxy.cfg
echo "  use_backend be-https-sitio2 if { req_ssl_sni -i sitio2.com } or { req_ssl_sni -i www.sitio2.com }" >> /etc/haproxy/haproxy.cfg
echo "" >> /etc/haproxy/haproxy.cfg
echo "# BackEnds HTTPS" >> /etc/haproxy/haproxy.cfg
echo "backend be-https-sitio1" >> /etc/haproxy/haproxy.cfg
echo "  mode tcp" >> /etc/haproxy/haproxy.cfg
echo "  option ssl-hello-chk" >> /etc/haproxy/haproxy.cfg
echo "  server srv-https-sitio1 192.168.0.11" >> /etc/haproxy/haproxy.cfg
echo "" >> /etc/haproxy/haproxy.cfg
echo "backend be-https-sitio2" >> /etc/haproxy/haproxy.cfg
echo "  mode tcp" >> /etc/haproxy/haproxy.cfg
echo "  option ssl-hello-chk" >> /etc/haproxy/haproxy.cfg
echo "  server srv-https-sitio2 192.168.0.12" >> /etc/haproxy/haproxy.cfg
echo "" >> /etc/haproxy/haproxy.cfg

# Reiniciar HAProxy
service haproxy restart

