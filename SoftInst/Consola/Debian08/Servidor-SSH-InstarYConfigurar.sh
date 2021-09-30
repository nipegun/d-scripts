      apt-get -y install tasksel
      tasksel install ssh-server
      apt-get -y install sshpass
      echo ""
      echo "Match Group enjaulados" >> /etc/ssh/sshd_config
      echo "  ChrootDirectory /home" >> /etc/ssh/sshd_config
      echo "  AllowTCPForwarding no" >> /etc/ssh/sshd_config
      echo "  X11Forwarding no" >> /etc/ssh/sshd_config
      echo "  ForceCommand internal-sftp -u 002" >> /etc/ssh/sshd_config
      echo ""
