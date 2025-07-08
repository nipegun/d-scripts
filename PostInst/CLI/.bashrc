
# Mostrar prompt con el usuario en uno u otro color, dependiendo de sus permisos
# rojo = root
# naranja = usuarios con permisos sudo, sin ser el root
# blanco = usuarios sin privilegios sudo, y sin ser root

# Prompt personalizado según privilegios y ruta
if [ "$UID" -eq 0 ]; then
  COLOR='\[\e[31m\]'  # Root → rojo
elif id -nG "$USER" | grep -qw sudo; then
  COLOR='\[\e[38;5;208m\]'  # Usuario con sudo → naranja
else
  COLOR='\[\e[37m\]'  # Usuario sin sudo → gris claro
fi

# Función para calcular ruta relativa o absoluta
vPathDelPrompt() {
  local pwd="$PWD"
  if [[ "$pwd" == "$HOME" ]]; then
    echo "~"
  elif [[ "$pwd" == "$HOME/"* ]]; then
    echo "~${pwd#$HOME}"
  else
    echo "$pwd"
  fi
}

# Definir el prompt con evaluación dinámica y colores
PS1="${COLOR}\u\[\e[0m\]@\h\[\e[36m\][\$(vPathDelPrompt)]\[\e[0m\]: "

