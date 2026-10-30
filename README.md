```
sudo nixos-generate-config

git clone https://github.com/shaonahmedronok/shaonish

sudo nix flake update
sudo nixos-rebuild switch --flake /etc/nixos#shaonish
nh clean all --keep 3

```
