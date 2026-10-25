# Install NixOS minimal, then generate hardware config
sudo nixos-generate-config

# Clone repo
git clone https://github.com/shaonahmedronok/shaonix /tmp/nixconf

# Copy hardware configuration into repo folder
sudo cp /etc/nixos/hardware-configuration.nix /tmp/nixconf/

# Rebuild
cd /tmp/nixconf
sudo nix flake update
sudo nixos-rebuild switch --flake /tmp/nixconf#shaonix
nh clean all --keep 3
