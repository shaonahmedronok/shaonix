# 1. Generate the machine-specific hardware configuration
sudo nixos-generate-config

# 2. Clone your flake repository to /tmp
git clone https://github.com/shaonahmedronok/shaonix /tmp/nixconf

# 3. Copy the generated hardware configuration into your cloned repo folder
sudo cp /etc/nixos/hardware-configuration.nix /tmp/nixconf/

# 4. Navigate into the repo directory, update flakes, and rebuild
cd /tmp/nixconf
sudo nix flake update
sudo nixos-rebuild switch --flake /tmp/nixconf#shaonix

# 5. Clean up old generations keeping the last 3
nh clean all --keep 3
