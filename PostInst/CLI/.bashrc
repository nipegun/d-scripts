
# No poner en el historial líneas duplicadas o líneas que comiencen por un espacio.
  HISTCONTROL=ignoreboth

# Anexar líneas al archivo bash_history. No sobreescribirlo.
  shopt -s histappend

# Aumentar a 5000 el límite de comandos almacenados en memoria RAM
  HISTSIZE=5000

# Aumentar a 5000 el número de líneas a guardar en el archivo ~/.bash_history en disco.
  HISTFILESIZE=5000

# Escribir en el historial inmediatamente y recargar el externo (útil para que lo que lo se escriba en una terminal se vea al instante en otra.
  #PROMPT_COMMAND='history -a; history -n'

# Revisar el tamaño de la ventana antes de ejecutar cada comando. Si es necesario, actualizar los valores de LINES y COLUMNS.
  shopt -s checkwinsize

# Detectar entorno chroot (opcional)
  if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
  fi

# Asignar color al prompt dependiendo de los privilegios del usuario
  # rojo     = root
  # amarillo = usuarios con permisos sudo, sin ser el root
  # verde    = usuarios sin privilegios sudo, y sin ser root
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
  vPromptPath() {
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
  PS1="┌─\${debian_chroot:+(\$debian_chroot)}${vTextColor}\u\[\e[0m\]@\h\[\e[38;5;39m\][\$(vPromptPath)]\[\e[0m\]\n└─$vPromptSymbol "

# Indicar que los alias personales están en ~/.bash_aliases
  if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
  fi

