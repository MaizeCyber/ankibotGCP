#!/bin/bash

echo "Waiting for apt locks to be released..."
while fuser /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock /var/cache/apt/archives/lock >/dev/null 2>&1; do
    echo "System updates are in progress. Waiting 5 seconds..."
    sleep 5
done
echo "Apt is free. Proceeding with installation."
# Exit immediately if a command fails
set -e

TARGET_USER=$(whoami)
HOME_DIR="/home/$TARGET_USER"

echo "Running apt update"
sudo apt-get update

if ! command -v startplasma-x11 &> /dev/null; then
  # Install Chrome Remote Desktop
  echo "downloading Chrome RDP"
  curl https://dl.google.com/linux/linux_signing_key.pub \
      | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/chrome-remote-desktop.gpg
  echo "deb [arch=amd64] https://dl.google.com/linux/chrome-remote-desktop/deb stable main" \
      | sudo tee /etc/apt/sources.list.d/chrome-remote-desktop.list
  sudo apt-get update
  sudo DEBIAN_FRONTEND=noninteractive \
      apt-get install --assume-yes chrome-remote-desktop

  # Install KDE Desktop environment
  echo "Installing KDE Desktop environment"
  sudo DEBIAN_FRONTEND=noninteractive \
      apt install --assume-yes  task-kde-desktop

  # Set KDE as default for Chrome RD
  echo "Setting KDE as Chrome RD default"
  sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/startplasma-x11" > /etc/chrome-remote-desktop-session'

  # Authorize Chrome RD Account
  echo "Running authorization script"
  DISPLAY= /opt/google/chrome-remote-desktop/start-host --code="4/0ATX87lN7Rz9LbxNoA7xWNN4OkjEIjBgiyHfd2AAB8a02mXcfmqlsiW27Eg0qmyv_pOQ5jg" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$(hostname)
fi

if ! command -v anki &> /dev/null; then
  # Get Anki Installable
  echo "Installing Anki"
  wget https://github.com/ankitects/anki/releases/download/25.09/anki-launcher-25.09-linux.tar.zst
  tar xaf anki-launcher-25.09-linux.tar.zst
  cd anki-launcher-25.09-linux
  sudo ./install.sh

  # Add anki to autostart
  echo "Adding anki to autostart"
  mkdir -p ~/.config/autostart
  cat <<EOF > ~/.config/autostart/anki.desktop
[Desktop Entry]
Type=Application
Exec=anki
Name=Anki
Comment=Start Anki on login
X-GNOME-Autostart-enabled=true
EOF

fi
echo "Startup script complete"