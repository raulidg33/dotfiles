#!/bin/zsh

sudo -v

# keyboard layout
sudo rm -r /Library/Keyboard\ Layouts/*
sudo cp -r ENS.bundle /Library/Keyboard\ Layouts/
sudo mv ~/Library/Preferences/com.apple.HIToolbox.plist ~/Library/Preferences/com.apple.HIToolbox.bak.plist
sudo cp com.apple.HIToolbox.plist ~/Library/Preferences/
sudo chown root:wheel ~/Library/Preferences/com.apple.HIToolbox.plist; sudo chmod 644 ~/Library/Preferences/com.apple.HIToolbox.plist

# installing nix
curl -L https://nixos.org/nix/install | sh --yes

# run stow
cd ../
stow --adopt 

# reload config
source ~/.zshrc

# initializing nix-darwin
nix run nix-darwin --extra-experimental-feature "nix-command flakes" -- switch --flake ~/.config/nix"#main"
