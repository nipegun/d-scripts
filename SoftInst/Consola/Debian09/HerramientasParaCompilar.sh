      sleep 2
      apt-get -y install linux-headers-$(uname -r) make gcc build-essential module-assistant git libsqlite3-dev libssl-dev
      m-a prepare
