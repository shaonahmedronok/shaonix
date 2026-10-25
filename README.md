```
sudo nixos-generate-config

git clone https://github.com/shaonahmedronok/shaonix

sudo nix flake update
sudo nixos-rebuild switch --flake /etc/nixos#shaonix
nh clean all --keep 3

```
