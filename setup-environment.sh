#!/bin/bash

username=$1
#check if username is provided
if [ -z "$username" ]; then
  echo "Please provide a username"
  exit 1
fi

#check if user exists
if ! id -u $username &>/dev/null; then
  echo "User $username does not exist"
  exit 1
fi
#check if user directory exists
if [ ! -d /home/$username ]; then
  echo "User directory /home/$username does not exist"
  exit 1
fi

#update the package list
apt update -y
#download latest vscode package .deb
wget -q https://go.microsoft.com/fwlink/?LinkID=760868 -O /tmp/vscode.deb
#install required packages
apt install -y jq yq curl tmux wget zsh unzip git ansible stow alacritty python3 python3-pip python3-venv apt-transport-https ca-certificates curl software-properties-common net-tools build-essential
#install starship prompt
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y
#create font directory on home user
mkdir -p /home/$username/.local/share/fonts
#copy font to the font directory
cp ./dotfiles/fonts/* /home/$username/.local/share/fonts
#update the font cache
fc-cache -f -v

fzfurl=$(curl -s https://api.github.com/repos/junegunn/fzf/releases/latest | jq -r '.assets[] | select(.name | contains("linux_amd64")) | .browser_download_url')
#download fzf
wget -q $fzfurl -O /tmp/fzf.tar.gz
#extract fzf
tar -xzf /tmp/fzf.tar.gz -C /tmp
#move fzf to /usr/local/bin
mv /tmp/fzf /usr/local/bin
#make fzf executable
chmod +x /usr/local/bin/fzf

#set zsh as default shell
chsh -s $(which zsh) $username
