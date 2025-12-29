#!/bin/bash

echo "Waiting for apt locks to be released..."
while fuser /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock /var/cache/apt/archives/lock >/dev/null 2>&1; do
    echo "System updates are in progress. Waiting 5 seconds..."
    sleep 5
done
echo "Apt is free. Proceeding with installation."
# Exit immediately if a command fails
set -e

#!/bin/bash
set -e

# --- DISK MOUNTING LOGIC ---
DEVICE_NAME="google-anki-data-disk"
MOUNT_PATH="/home"
DISK_PATH="/dev/disk/by-id/$DEVICE_NAME"

echo "Checking for persistent disk at $DISK_PATH..."

# 1. Wait for the disk to be attached by GCP
while [ ! -b "$DISK_PATH" ]; do
  echo "Waiting for disk $DEVICE_NAME to attach..."
  sleep 2
done

# 2. Format the disk only if it doesn't have a filesystem yet
if ! blkid "$DISK_PATH" > /dev/null; then
  echo "New disk detected. Formatting with ext4..."
  mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard "$DISK_PATH"
fi

# 3. Mount the disk to a temporary location first if /home is not empty
# (This ensures we don't lose the initial user directory created by GCP)
mkdir -p /mnt/tmp_home
mount "$DISK_PATH" /mnt/tmp_home

# 4. If the disk is empty, move existing home data into it
if [ -z "$(ls -A /mnt/tmp_home)" ]; then
  echo "Persistent disk is empty. Initializing with current /home data..."
  cp -a /home/. /mnt/tmp_home/
fi

# 5. Unmount and perform the final mount to /home
umount /mnt/tmp_home
mount "$DISK_PATH" "$MOUNT_PATH"

# 6. Ensure it mounts automatically on reboots
if ! grep -qs "$MOUNT_PATH" /etc/fstab; then
  echo "$DISK_PATH $MOUNT_PATH ext4 discard,defaults,nofail 0 2" >> /etc/fstab
fi

echo "Persistent disk mounted successfully to $MOUNT_PATH"

# --- REST OF YOUR INSTALLATION SCRIPT ---
# Proceed with apt updates, KDE, Chrome RD, and Anki...

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

chown -R "$TARGET_USER:$TARGET_USER" "$HOME_DIR"
echo "Startup script complete"