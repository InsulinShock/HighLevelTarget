#!/bin/bash

# sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# sudo chmod +x /usr/local/bin/docker-compose


# Install Python and PIP.
apt-get install -y python python-pip

# Install Docker Compose into your user's home directory.
pip install --user docker-compose



echo "export PATH=\"$PATH:$HOME/.local/bin\"" >> ~/.profile

source ~/.profile

