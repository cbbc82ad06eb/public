# disable sshd password authentication
sudo tee /etc/ssh/sshd_config.d/sshd.conf <<eos
Port 22
AddressFamily inet
ListenAddress 0.0.0.0
PasswordAuthentication no
eos
sudo systemctl restart ssh
