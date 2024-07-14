#!/usr/bin/env bash

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
	echo "This script should not be executed as root! Exiting..."
	exit 1
fi

scriptdir=$(realpath "$(dirname "$0")")
currentUser=$(logname)

pushd "$scriptdir"&> /dev/null || exit
echo "Im Stuck! 1"
# Delete dirs that conflict with home-manager
if [ -f "~/.mozilla/firefox/profiles.ini" ]; then
	sudo cp -f ~/.mozilla/firefox/profiles.ini ~/.mozilla/firefox/a/
fi
sudo rm -f ~/.mozilla/firefox/profiles.ini
sudo rm -rf ~/.gtkrc-*
sudo rm -rf ~/.config/gtk-*
sudo rm -rf ~/.config/cava
echo "Im Stuck! 2"
# replace username variable in flake.nix with $USER
sed -i -e 's/username = \".*\"/username = \"'$currentUser'\"/' "$scriptdir/flake.nix"
echo "Im Stuck! 3"
# rm -f $scriptdir/hosts/Default/hardware-configuration.nix &>/dev/null
if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
	cat "/etc/nixos/hardware-configuration.nix" > "$scriptdir/hosts/Default/hardware-configuration.nix"
	cat "/etc/nixos/hardware-configuration.nix" > "$scriptdir/hosts/Desktop/hardware-configuration.nix"
	cat "/etc/nixos/hardware-configuration.nix" > "$scriptdir/hosts/Laptop/hardware-configuration.nix"
else
	# Generate new config
	clear
	nix-shell --command "echo GENERATING CONFIG! | figlet -cklno | lolcat -F 0.3 -p 2.5 -S 300"
	sudo nixos-generate-config --show-hardware-config > "$scriptdir/hosts/Default/hardware-configuration.nix"
	sudo nixos-generate-config --show-hardware-config > "$scriptdir/hosts/Desktop/hardware-configuration.nix"
	sudo nixos-generate-config --show-hardware-config > "$scriptdir/hosts/Laptop/hardware-configuration.nix"
fi
echo "Im Stuck! 4"
#nix-shell --command "git -C $scriptdir add *"
echo "Hello?"
clear
nix-shell --command "echo BUILDING! | figlet -cklnoW | lolcat -F 0.3 -p 2.5 -S 300"
echo "hi"
sudo nixos-rebuild switch --flake "$scriptdir#Default" --show-trace



popd "$scriptdir" &> /dev/null || if [ -f "~/.mozilla/firefox/profiles.ini" ]; then
	echo "meh"
else

	sudo cp -f ~/.mozilla/firefox/a/profiles.ini ~/.mozilla/firefox/
	exit
fi

