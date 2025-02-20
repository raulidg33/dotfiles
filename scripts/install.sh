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

# reload zsh
exec zsh

# initializing nix-darwin
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/dotfiles/.config/nix"#main"

# run stow
cd ../
stow --adopt .

# copy preferences
cp ../extras/preferences/* ~/Library/Preferences/

# open some apps
open /Applications/AeroSpace.app
open /Applications/Ice.app
open /Applications/Setapp.app
