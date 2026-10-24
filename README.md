---

**First time on a new machine:**

# Install NixOS minimal, then generate hardware config
sudo nixos-generate-config

# Clone repo
git clone https://github.com/shaonahmedronok/shaonix /tmp/nixconf

# Rebuild

sudo nix flake update
sudo nixos-rebuild switch --flake /etc/nixos#shaonix
nh clean all --keep 3

