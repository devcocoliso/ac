#!/bin/bash

# Update system
sudo apt update -y
sudo apt upgrade -y

# Install required dependencies
sudo apt install -y software-properties-common wget ufw

# Add ntopng repository
wget https://packages.ntop.org/apt/22.04/all/apt-ntop.deb
sudo dpkg -i apt-ntop.deb

# Update repositories and install ntopng
sudo apt update -y
sudo apt install -y pfring-dkms nprobe ntopng n2disk cento

# Configure ntopng
sudo cp /etc/ntopng/ntopng.conf /etc/ntopng/ntopng.conf.bak
sudo bash -c 'cat > /etc/ntopng/ntopng.conf <<EOF
# /etc/ntopng/ntopng.conf

# Interface to bind to
--interface=eth0

# Local networks
--local-networks="192.168.0.0/24"

# Set HTTP port
--http-port=3000

# Specify home directory
--data-dir=/var/lib/ntopng

# DNS mode
--dns-mode=1

# Admin user and password
--admin-user=admin
--admin-password=your_password_here
EOF'

# Replace 'your_password_here' with your desired password
sudo sed -i 's/your_password_here/YOUR_DESIRED_PASSWORD/g' /etc/ntopng/ntopng.conf

# Enable and start ntopng service
sudo systemctl enable ntopng
sudo systemctl start ntopng

# Configure firewall to allow only from specific IP
sudo ufw allow from 80.92.205.87 to any port 3000
sudo ufw enable

# Verify ntopng is running
sudo systemctl status ntopng

# Output ntopng web interface URL
echo "ntopng is installed and running. Access the web interface at http://localhost:3000 from IP 80.92.205.87"
