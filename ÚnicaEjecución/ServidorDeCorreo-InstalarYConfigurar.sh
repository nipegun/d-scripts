#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# https://networkgeekstuff.com/networking/tutorial-email-server-for-a-small-company-including-imap-for-mobiles-spf-and-dkim/

#----------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar el servidor de correo electrónico
#----------------------------------------------------------------------------------

ColorVerde="\033[1;32m"
FinColor="\033[0m"

apt-get -y update 2> /dev/null
apt-get -y install dialog 2> /dev/null

menu=(dialog --timeout 5 --checklist "Elige la versión de Debian:" 22 76 16)
  opciones=(1 "Debian  8" off
            2 "Debian  9" off
            3 "Debian 10" off
            4 "Debian 11" off)
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  clear

  for choice in $choices
    do
      case $choice in

        1)

        ;;

        2)

        ;;

        3)
          apt-get -y install exim4
          apt-get -y install courier-imap
          
          # Crear la carpeta mail en cada carpeta de usuario
          maildirmake /etc/skel/Maildir
          maildirmake ~root/Maildir
          chown root:root ~root/Maildir -R
          
          # Reconfigurar Exim4
          dpkg-reconfigure exim4-config
          
          # Generar el certificado SSL
          /usr/share/doc/exim4-base/examples/exim-gencert
          
          # Activar TLS
          echo "MAIN_TLS_ENABLE = true" > /etc/exim4/exim4.conf.localmacros
          echo "tls_on_connect_ports = 465" >> /etc/exim4/exim4.conf.localmacros
          sed -i -e "s|SMTPLISTENEROPTIONS=''|SMTPLISTENEROPTIONS='-oX 465:25:587 -oP /var/run/exim4/exim.pid'|g" /etc/default/exim4
          echo "MAIN_TLS_ENABLE = yes" >> /etc/exim4/exim4.conf.template
          echo "tls_on_connect_ports=465" >> /etc/exim4/exim4.conf.template
          echo "rfc1413_query_timeout = 0s" >> /etc/exim4/exim4.conf.template
          
          # Instalar el daemon SaslAuth
          apt-get -y install sasl2-bin
          sed -i -e 's|START=no|START=yes|g' /etc/default/saslauthd
          adduser Debian-exim sasl
          
          # Borrar 7 líneas después de "# plain_saslauthd_server:"
          sed -i -e '/# plain_saslauthd_server:/{n;N;N;N;N;N;N;N;d}' /etc/exim4/exim4.conf.template
          
          # Descomentar la línea "# plain_saslauthd_server:" y agregar el resto de líneas antes borradas pero ahora descomentadas
          sed -i -e 's|# plain_saslauthd_server:|\
          plain_saslauthd_server: \
            driver = plaintext \
            public_name = PLAIN \
            server_condition = ${if saslauthd{{$auth2}{$auth3}}{1}{0}} \
            server_set_id = $auth2 \
            server_prompts = : \
            .ifndef AUTH_SERVER_ALLOW_NOTLS_PASSWORDS \
            server_advertise_condition = ${if eq{$tls_in_cipher}{}{}{*}} \
            .endif|g' /etc/exim4/exim4.conf.template
          
          # Configurar IMAP
          rm -rf /etc/courier/*.pem
          make-ssl-cert /usr/share/ssl-cert/ssleay.cnf /etc/courier/imapd.pem
          service courier-imap restart
          service courier-imap-ssl restart
          service courier-authdaemon restart

          netstat -atupln | grep 465
          
          # Instalar y configurar SpamAssassin
          apt-get -y install spamassassin
          systemctl enable spamassassin.service
          
          echo ""
          echo "Sistema instalado."
          echo ""
          echo "Para crear un usuario sin acceso al shell ejecuta:"
          echo "/root/scripts/d-scripts/UsuarioNuevoSinShell.sh"
          echo ""
          
        ;;

        4)

        ;;

      esac

done

