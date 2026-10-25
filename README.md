```
sudo nixos-generate-config

git clone https://github.com/shaonahmedronok/shaonix /tmp/nixconf

cd /tmp/nixconf
sudo nix flake update
sudo nixos-rebuild switch --flake /tmp/nixconf#shaonix
nh clean all --keep 3

```
