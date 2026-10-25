# Generate the machine-specific hardware configuration
sudo nixos-generate-config

# Clone your flake repository
git clone https://github.com/shaonahmedronok/shaonix /tmp/nixconf

# Copy the hardware configuration into your repo folder
sudo cp /etc/nixos/hardware-configuration.nix /tmp/nixconf/

# Navigate into the repo directory, update flakes, and rebuild
cd /tmp/nixconf
sudo nix flake update
sudo nixos-rebuild switch --flake /tmp/nixconf#shaonix

# Clean up old generations keeping the last 3
nh clean all --keep 3
