
# Actualizar el distema
  apt-get -y update && apt-get -y upgrade 

# Instalar depndicias
  apt-get -y install build-essential
  apt-get -y install wget
  apt-get -y install gnupg
  apt-get -y install graphviz
  apt-get -y install libapache2-mod-perl2
  apt-get -y install libcrypt-ssleay-perl
  apt-get -y install libdate-manip-perl
  apt-get -y install libdbi-perl
  apt-get -y install libdbix-searchbuilder-perl
  apt-get -y install libexpat1-dev
  apt-get -y install libfcgi-perl
  apt-get -y install libgettext-perl
  apt-get -y install libmath-random-isaac-perl
  apt-get -y install libmath-random-isaac-xs-perl
  apt-get -y install libmysqlclient-dev
  apt-get -y install libnet-ldap-perl
  apt-get -y install libtemplate-perl
  apt-get -y install libtemplate-perl
  apt-get -y install libxml-parser-perl
  apt-get -y install lynx
  apt-get -y install mariadb-server
  apt-get -y install netcat-traditional
  apt-get -y install patch
  apt-get -y install procmail
  apt-get -y install make 

# Descargar y descomprimir RequestTracker
  mkdir -p ~/SoftInst/
  cd ~/SoftInst/
  vUltVers=$(curl -sL https://download.bestpractical.com/pub/rt/release/ |  sed 's->->\n-g' | grep href | grep -v rt-ir| grep -v RTIR | cut -d'"' -f2 | grep rt-[0-9] | grep -v .asc | head -n1)
  wget https://download.bestpractical.com/pub/rt/release/"$vUltVers"
  tar -xzvf "$vUltVers"

# Instalar
  vCarpeta=$(echo $vUltVers | sed 's-.tar.gz--g')
  cd $vCarpeta
  ./configure --prefix=/opt/rt5 --with-db-type=mysql --enable-graphviz
  make -j $(nproc)
  make install 
https://ipv6.rs/tutorial/Debian_Latest/Request_Tracker/
https://download.bestpractical.com/pub/rt/release/
