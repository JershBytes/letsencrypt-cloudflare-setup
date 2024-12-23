#!/bin/bash


function install_python_debian {
    sudo apt-get update && sudo apt-get install -y python3 python3-venv libaugeas0
}

function install_python_redhat {
    sudo dnf install -y python3 && sudo dnf install -y augeas-libs
}
function certbot_installer {
    # Create a virtual environment for Certbot
    sudo python3 -m venv /opt/certbot/
    # Upgrade pip to the latest version
    sudo /opt/certbot/bin/pip install --upgrade pip
    # Install Certbot
    sudo /opt/certbot/bin/pip install certbot
    # Create a symbolic link to the Certbot binary
    sudo ln -s /opt/certbot/bin/certbot /usr/bin/certbot
    # Install the Cloudflare DNS plugin for Certbot
    sudo /opt/certbot/bin/pip install certbot-dns-cloudflare
}

function create_cloudflare_ini {
    read -rp "Enter your Cloudflare token: " CLOUDFLARE_API_KEY
    echo "dns_cloudflare_api_key = $CLOUDFLARE_API_KEY" >> /root/.secrets/certbot/cloudflare.ini
    chmod 600 /root/.secrets/certbot/cloudflare.ini
}

if [ -f /etc/debian_version ]; then
    echo "Running on a Debian-based system, installing Certbot"
    install_python_debian
    certbot_installer
    create_cloudflare_ini
elif [ -f /etc/redhat-release ]; then
    echo "Running on a RHEL-based system, installing Certbot"
    install_python_redhat
    certbot_installer
    create_cloudflare_ini
else
    echo "Unknown system"
    exit 1
fi



