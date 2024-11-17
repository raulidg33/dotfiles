#!/bin/zsh

sudo -v

# keyboard layout
sudo rm -r /Library/Keyboard\ Layouts/*
sudo cp -r ../extras/ENS.bundle /Library/Keyboard\ Layouts/
sudo mv ~/Library/Preferences/com.apple.HIToolbox.plist ~/Library/Preferences/com.apple.HIToolbox.bak.plist
sudo cp ../extras/com.apple.HIToolbox.plist ~/Library/Preferences/
sudo chown root:wheel ~/Library/Preferences/com.apple.HIToolbox.plist; sudo chmod 644 ~/Library/Preferences/com.apple.HIToolbox.plist

# installing nix
sh <(curl -L https://nixos.org/nix/install) --yes

# run stow
cd ../
stow --adopt .

# reload config
source ~/.zshrc

# initializing nix-darwin
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ../.config/nix"#main"

killall Dock
