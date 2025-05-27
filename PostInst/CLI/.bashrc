
# Mostrar prompt con el usuario en uno u otro color, dependiendo de sus permisos
# rojo = root
# naranja = usuarios con permisos sudo, sin ser el root
# blanco = usuarios sin privilegios sudo, y sin ser root

if [ "$UID" -eq 0 ]; then
  PS1='\[\e[31m\]\u\[\e[0m\]@\h\$ '       # Root → rojo
elif id -nG "$USER" | grep -qw sudo; then
  PS1='\[\e[38;5;208m\]\u\[\e[0m\]@\h\$ ' # Usuario con sudo → naranja
else
  PS1='\u@\h\$ '                          # Usuario sin  → sin color
fi
