


#
#
#  SCRIPT NO FUNCIONAL
#
#

https://gist.github.com/heinoldenhuis/f8164f73e5bff048e76fb4fff2e824e1



  # Desinstalar posibles versiones previas
    echo ""
    echo "    Desinstalando posibles versiones previas..."
    echo ""
    apt-get -y remove docker
    apt-get -y remove docker-engine
    apt-get -y remove docker.io
    apt-get -y remove containerd
    apt-get -y remove runc
    rm -rf /var/lib/docker
    rm -rf /var/lib/containerd
 
  # Agregar el repositorio de Docker
    echo ""
    echo "    Agregando repositorio de docker..."
    echo ""
    apt-get -y update
    apt-get -y install ca-certificates
    apt-get -y install curl
    apt-get -y install gnupg
    apt-get -y install lsb-release
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get -y update
    chmod a+r /etc/apt/keyrings/docker.gpg
    apt-get -y update

  # Instalar Docker Engine
    echo ""
    echo "    Instalando docker engine..."
    echo ""
    apt-get -y install docker-ce
    apt-get -y install docker-ce-cli
    apt-get -y install containerd.io
    apt-get -y install docker-compose-plugin
    # Comprobar que docker-engine se instaló
      # docker run hello-world

  # Crear usuario y grupo
    echo ""
    echo "    Creando el usuario vaultwarden..."
    echo ""
    adduser vaultwarden
    #echo ""
    #echo "    Asignando contraseña al usuario bitwarden..."    #echo ""
    #passwd vaultwarden
    echo ""
    echo "    Creando el grupo docker..."
    echo ""
    groupadd docker
    echo ""
    echo "    Agregando el usuario vaultwarden al grupo docker..."
    echo ""
    usermod -aG docker vaultwarden
    echo ""
    echo "    Creando la carpeta de instalación para vaultwarden..."
    echo ""
    mkdir /opt/vaultwarden
    chmod -R 700 /opt/vaultwarden
    chown -R vaultwarden:vaultwarden /opt/vaultwarden

  # Instalar bitwarden desde el script oficial
    echo ""
    echo "    Instalando el docker de BitWarden..."
    echo ""
    docker pull vaultwarden/server:latest
    docker run -d --name vaultwarden -v /vw-data/:/data/ -p 80:80 vaultwarden/server:latest

  # Agregando bitwarden a los ComandosPostArranque
    echo ""                                    >> /root/scripts/ComandosPostArranque.sh
    echo "# Iniciar BitWarden"                 >> /root/scripts/ComandosPostArranque.sh
    echo "  /opt/bitwarden/bitwarden.sh start" >> /root/scripts/ComandosPostArranque.sh
    echo ""                                    >> /root/scripts/ComandosPostArranque.sh
