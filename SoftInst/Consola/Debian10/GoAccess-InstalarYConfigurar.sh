#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA INSTALAR Y CONFIGURAR LAS ESTADÍSTICAS WEB GOACCESS
#------------------------------------------------------------------------------

CantArgsCorrectos=2
ArgsInsuficientes=65

if [ $# -ne $CantArgsCorrectos ]
  then
    echo ""
    echo "------------------------------------------------------------------------------"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 [CarpetaDeLogs] [CarpetaDeStats]"
    echo ""
    echo "Ejemplo:"
    echo ' $0 /var/www/pepe.com/logs /var/www/pepe.com/stats'
    echo "------------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    echo ""
    echo "--------------------------------------"
    echo "  INSTALANDO Y CONFIGURANDO GOACCESS"
    echo "--------------------------------------"
    echo ""
    echo "deb http://deb.goaccess.io/ buster main" | tee -a /etc/apt/sources.list.d/goaccess.list
    wget -O - http://deb.goaccess.io/gnugpg.key | apt-key add -
    apt-get -y update
    mkdir -p /root/paquetes/libssl/
    ArchivoDeb=$(curl -s http://ftp.debian.org/debian/pool/main/o/openssl1.0/ | grep amd64 | grep -v crypto | grep -v dev | grep -v udeb | cut -d\" -f8)
    wget -O /root/paquetes/libssl/$ArchivoDeb http://ftp.debian.org/debian/pool/main/o/openssl1.0/$ArchivoDeb
    dpkg -i /root/paquetes/libssl/$ArchivoDeb
    apt-get -y install goaccess
    cp /etc/goaccess/goaccess.conf /etc/goaccess/goaccess.conf.bak
    sed -i -e 's|#time-format %H:%M:%S|time-format %H:%M:%S|g' /etc/goaccess/goaccess.conf
    sed -i -e 's|#date-format %d/%b/%Y|date-format %d/%b/%Y|g' /etc/goaccess/goaccess.conf
    sed -i -e 's|#log-format %h %^\[%d:%t %^] "%r" %s %b "%R" "%u"|log-format %h %^[%d:%t %^] "%r" %s %b "%R" "%u"|g' /etc/goaccess/goaccess.conf
    #sed -i -e '/NCSA Combined Log Format/!b;n;clog-format %h %^[%d:%t %^] "%r" %s %b "%R" "%u"' /etc/goaccess/goaccess.conf
    sed -i -e 's|#html-prefs {"theme":"bright","perPage":5,"layout":"horizontal","showTables":true,"visitors":{"plot":{"chartType":"bar"}}}|html-prefs {"theme":"bright","perPage":20,"layout":"vertical","showTables":true,"visitors":{"plot":{"chartType":"bar"}}}|g' /etc/goaccess/goaccess.conf
    sed -i -e 's|#html-report-title My Awesome Web Stats|html-report-title Estadísticas de la Web|g' /etc/goaccess/goaccess.conf
    sed -i -e 's|#daemonize false|daemonize true|g' /etc/goaccess/goaccess.conf
    sed -i -e 's|ignore-crawlers false|ignore-crawlers true|g' /etc/goaccess/goaccess.conf
    sed -i -e 's|ignore-panel REFERRERS|#ignore-panel REFERRERS|g' /etc/goaccess/goaccess.conf
    sed -i -e 's|ignore-panel KEYPHRASES|#ignore-panel KEYPHRASES|g' /etc/goaccess/goaccess.conf
    echo "#!/bin/bash" > /root/scripts/ArrancarStats.sh
    echo "" >> /root/scripts/ArrancarStats.sh
    echo "goaccess -p /etc/goaccess/goaccess.conf -f $1/access.log -o $2/index.html --real-time-html" >> /root/scripts/ArrancarStats.sh
    chmod +x /root/scripts/ArrancarStats.sh
    /root/scripts/ArrancarStats.sh
    echo "" >> /root/scripts/ComandosPostArranque.sh
    echo "# Arrancar estadísticas de la web" >> /root/scripts/ComandosPostArranque.sh
    echo "/root/scripts/ArrancarStats.sh" >> /root/scripts/ComandosPostArranque.sh
    echo "" >> /root/scripts/ComandosPostArranque.sh
    
    echo "RewriteEngine On" > $2/.htaccess
    echo "" >> $2/.htaccess
    echo "# Si alguien llega a la web desde otro lugar que no sea lapropiaweb.com" >> $2/.htaccess
    echo "RewriteCond %{HTTP_REFERER} !^http://(www\.)?lapropiaweb\.com/ [NC]" >> $2/.htaccess
    echo "" >> $2/.htaccess
    echo "#, pide directamente por un archivo con extensión .html" >> $2/.htaccess
    echo "RewriteCond %{REQUEST_URI} !hotlink\.(html) [NC]" >> $2/.htaccess
    echo "" >> $2/.htaccess
    echo "# y no tiene la sesión iniciada en WordPress" >> $2/.htaccess
    echo "RewriteCond %{HTTP_COOKIE} !^.*wordpress_logged_in.*$ [NC]" >> $2/.htaccess
    echo "" >> $2/.htaccess
    echo "# Redirigirlo a google.com" >> $2/.htaccess
    echo "RewriteRule .*\.(log)$ http://google.com/ [NC]" >> $2/.htaccess
    echo ""
    
    echo ""
    echo "GoAcces instalado. Recuerda editar el archivo $2/.htaccess para poner la web correcta"
    echo ""

fi

