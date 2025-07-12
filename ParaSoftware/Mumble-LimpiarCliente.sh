#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para BORRAR TODA LA CONFIGURACIÓN DEL CLIENTE MUMBLE EN DEBIAN
# ----------

# Borrar la base de datos (Lista de servidores, certificados de servidores, favoritos, amigos, tokens de acceso, comentarios, etc)
rm -f $HOME/.local/share/data/Mumble/Mumble/.mumble.sqlite

# Borrar la base de datos versión 1.3+
rm -f $HOME/.local/share/Mumble/Mumble/.mumble.sqlite

# Borrar la configuración
rm -f $HOME/.config/Mumble/Mumble.conf

