# Chrome Remote Desktop installation
curl https://dl.google.com/linux/linux_signing_key.pub \
    | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/chrome-remote-desktop.gpg
echo "deb [arch=amd64] https://dl.google.com/linux/chrome-remote-desktop/deb stable main" \
    | sudo tee /etc/apt/sources.list.d/chrome-remote-desktop.list
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive \
    apt-get install --assume-yes chrome-remote-desktop

# KDE Plasma Installation
sudo DEBIAN_FRONTEND=noninteractive \
    apt install --assume-yes  task-kde-desktop

# Set Chrome Remote Desktop to use KDE Plasma
sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/startplasma-x11" > /etc/chrome-remote-desktop-session'

# Install Chrome Remote Desktop

# Install Anki requirements
sudo apt install --assume-yes libxcb-xinerama0 libxcb-cursor0 libnss3 xdg-utils libatomic1 libxkbcommon-x11-0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0

# Install Anki
cd ~/Desktop
wget https://github.com/ankitects/anki/releases/download/25.09/anki-launcher-25.09-linux.tar.zst
tar xaf Desktop/anki-launcher-25.09-linux.tar.zst
cd anki-launcher-25.09-linux
sudo ./install.sh
