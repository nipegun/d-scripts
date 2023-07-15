#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para cambiar la contraseña de un usuario de MongoDB
#
#  Ejecución remota
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/MongoDB-CambiarPasswordDelUsuario.sh | bash
#
# ----------

varBaseDeDatos=$1
varUsuario=$2

echo "use $varBaseDeDatos"                                     > /tmp/CambiarPasswordMongo.js
echo 'db.changeUserPassword("$varUsuario", passwordPrompt())' >> /tmp/CambiarPasswordMongo.js

echo ""
echo "  Cambiando la contraseña del usuario $varUsuario de la base de datos $varBaseDeDatos..."
echo ""
mongosh --quiet < /tmp/CambiarPasswordMongo.js

