<div align="center">

[![NixOS](https://img.shields.io/badge/NixOS-26.05-FDF6E3?style=for-the-badge&logo=nixos&logoColor=FFFFFF&labelColor=000000)](https://nixos.org)
[![Flakes](https://img.shields.io/badge/Flakes-Enabled-FDF6E3?style=for-the-badge&logo=nixos&logoColor=FFFFFF&labelColor=000000)](https://nixos.wiki/wiki/Flakes)
[![Home Manager](https://img.shields.io/badge/Home_Manager-26.05-FDF6E3?style=for-the-badge&logoColor=FFFFFF&labelColor=000000)](https://nix-community.github.io/home-manager/)
[![Website](https://img.shields.io/badge/shaon.neocities.org-FDF6E3?style=for-the-badge&labelColor=000000)](https://shaon.neocities.org)

</div>

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

