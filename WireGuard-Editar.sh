#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para editar la configuración de la interfaz wg0
# ----------

# Tirar la interfaz wg0
  echo ""
  echo "  Tirando la conexión wg0 antes de hacer los cambios en el archivo /etc/wireguard/wg0.conf..." 
echo ""
  wg-quick down wg0

# Editar el archivo /etc/wireguard/wg0.conf
  echo ""
  echo "  Editando el archivo /etc/wireguard/wg0.conf..." 
echo ""
  nano /etc/wireguard/wg0.conf

# Levantar la interfaz wg0
  echo ""
  echo "  Volviendo a levantar la conexión wg0..." 
echo ""
  wg-quick up wg0

