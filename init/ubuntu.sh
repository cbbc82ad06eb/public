# enable firewall
sudo ufw enable

# disable sshd password authentication
sudo tee /etc/ssh/sshd_config.d/sshd.conf <<eos
Port 22
AddressFamily inet
ListenAddress 0.0.0.0
PasswordAuthentication no
eos
sudo systemctl restart ssh

# disable cups, avahi, dns stub listener
sudo systemctl stop cups.service cups-browsed.service avahi-daemon.service avahi-daemon.socker
sudo systemctl disable cups.service cups-browsed.service avahi-daemon.service avahi-daemon.socker
sudo sed -i -e 's/^#\(DNSStubListener=\)yes$/\1no/' /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved

# install updates
sudo apt update
sudo apt full-upgrade -y
sudo snap refresh

# install qemu guest agent
sudo apt install -y qemu-guest-agent

# install docker engine
wget -O get-docker.sh https://get.docker.com/
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker

# install brave browser
sudo apt install curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

# install vscode
sudo apt-get install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y code
