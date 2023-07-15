#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  SCRIPT DE NIPEGUN PARA OBTENER LA LISTA DE IPS DE NODOS TOR
#  QUE LLEGAN A LA IP WAN Y GENERAR UNA CONFIGURACIÓN DE APACHE
#  PARA USAR ESA LISTA DE ALGUN MODO.
#
#  PARA BLOQUEAR TRÁFICO DESDE ESOS NODOS HACIA APACHE"
#  MEDIANTE EL .htaccess USA ALGUNO DE ÉSTOS EJEMPLOS:"
#
#  # Bloquear el acceso total a la web"
#  <Directory />"
#    Include /etc/apache2/NodosTORQueEntran.conf"
#  </Directory>"
#
#  # Bloquear el acceso a una ubicación específica y a su contenido"
#  <Location /carpetanopermitida>"
#    Include /etc/apache2/NodosTORQueEntran.conf"
#  </Location>"
#
#  # Bloquear el acceso a un archivo específico"
#  <Files my-files.html>"
#    Include /etc/apache2/NodosTORQueEntran.conf"
#  </Files>"
# ----------

lisnodtor

echo ""
echo "  CREANDO EL ARCHIVO DE CONFIGURACIÓN PARA APACHE..."
echo ""
cat /root/NodosTORQueEntran.list | sed "s/^/  Require not ip /g; 1i\<RequireAll\>\n  Require all granted" | sed '$a\<\/RequireAll\>' > /etc/apache2/NodosTORQueEntran.conf

echo ""
echo "  Archivo: /etc/apache2/NodosTORQueEntran.conf creado correctamente"
echo ""

