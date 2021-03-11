#!/bin/bash

echo ""
echo "Actualizando la lista de paquetes..."
echo ""
apt-get -y update

echo ""
echo "Instalando nginx..."
echo ""
apt-get -y install nginx

echo ""
echo "Instalando y configurando PHP..."
echo ""
apt-get -y install php-fpm
sed -i -e 's|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|g' /etc/php/7.3/fpm/php.ini

echo ""
echo "Configurando el sitio principal para que también sirva PHP..."
echo ""
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
echo "server {"                                                         > /etc/nginx/sites-available/default
echo "  listen 80 default_server;"                                     >> /etc/nginx/sites-available/default
echo "  listen [::]:80 default_server;"                                >> /etc/nginx/sites-available/default
echo ""                                                                >> /etc/nginx/sites-available/default
echo "  #listen 443 ssl default_server;"                               >> /etc/nginx/sites-available/default
echo "  #listen [::]:443 ssl default_server;"                          >> /etc/nginx/sites-available/default
echo ""                                                                >> /etc/nginx/sites-available/default
echo "  #include snippets/snakeoil.conf;"                              >> /etc/nginx/sites-available/default
echo ""                                                                >> /etc/nginx/sites-available/default
echo "  root /var/www/html;"                                           >> /etc/nginx/sites-available/default
echo ""                                                                >> /etc/nginx/sites-available/default
echo "  index index.php index.html index.htm index.nginx-debian.html;" >> /etc/nginx/sites-available/default
echo ""                                                                >> /etc/nginx/sites-available/default
echo "  server_name _;"                                                >> /etc/nginx/sites-available/default
echo ""                                                                >> /etc/nginx/sites-available/default
echo "  location / {"                                                  >> /etc/nginx/sites-available/default
echo "    try_files "'$uri'" "'$uri'"/ =404;"                          >> /etc/nginx/sites-available/default
echo "  }"                                                             >> /etc/nginx/sites-available/default
echo ""                                                                >> /etc/nginx/sites-available/default
echo "  location ~ \.php$ {"                                           >> /etc/nginx/sites-available/default
echo "    include snippets/fastcgi-php.conf;"                          >> /etc/nginx/sites-available/default
echo "    fastcgi_pass unix:/run/php/php7.3-fpm.sock;"                 >> /etc/nginx/sites-available/default
echo "  }"                                                             >> /etc/nginx/sites-available/default
echo ""                                                                >> /etc/nginx/sites-available/default
echo "  location ~ /\.ht {"                                            >> /etc/nginx/sites-available/default
echo "    deny all;"                                                   >> /etc/nginx/sites-available/default
echo "  }"                                                             >> /etc/nginx/sites-available/default
echo ""                                                                >> /etc/nginx/sites-available/default
echo "}"                                                               >> /etc/nginx/sites-available/default

