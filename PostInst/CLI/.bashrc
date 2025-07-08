
# Mostrar prompt con el usuario en uno u otro color, dependiendo de sus permisos
# rojo = root
# naranja = usuarios con permisos sudo, sin ser el root
# blanco = usuarios sin privilegios sudo, y sin ser root

# Detectar entorno chroot (opcional)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# Asignar color según privilegios (256 colors)
if [ "$UID" -eq 0 ]; then
  vTextColor='\[\e[38;5;196m\]'  # Root → rojo
  vPromptSymbol="#"
elif id -nG "$USER" | grep -qw sudo; then
  vTextColor='\[\e[38;5;226m\]'  # Usuario con sudo → amarillo
  vPromptSymbol="$"
else
  vTextColor='\[\e[38;5;46m\]'   # Usuario sin sudo → verde
  vPromptSymbol="$"
fi

# Función para mostrar ruta relativa o absoluta
prompt_path() {
  local pwd="$PWD"
  if [[ "$pwd" == "$HOME" ]]; then
    echo "~"
  elif [[ "$pwd" == "$HOME/"* ]]; then
    echo "~${pwd#$HOME}"
  else
    echo "$pwd"
  fi
}

# Definir prompt final con ruta azul suave
PS1="\${debian_chroot:+(\$debian_chroot)}-${vTextColor}\u\[\e[0m\]@\h-\[\e[38;5;39m\][\$(prompt_path)]\[\e[0m\]\n$vPromptSymbol "


# Inficar que los alias personales están en ~/.bash_aliases
  if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
  fi


