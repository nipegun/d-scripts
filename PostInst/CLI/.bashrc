
# Mostrar prompt con el usuario en uno u otro color, dependiendo de sus permisos
# rojo = root
# naranja = usuarios con permisos sudo, sin ser el root
# blanco = usuarios sin privilegios sudo, y sin ser root

if [ "$UID" -eq 0 ]; then
  # Root → rojo
  PS1='\[\e[1;31m\]\u\[\e[0m\]@\h\$ '
elif id -nG "$USER" | grep -qw sudo; then
  # Usuario con sudo → naranja (código 38;5;208 = naranja en 256 colores)
  PS1='\[\e[38;5;208m\]\u\[\e[0m\]@\h\$ '
else
  # Usuario sin sudo → sin color
  PS1='\u@\h\$ '
fi
