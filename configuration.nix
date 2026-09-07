{ config, pkgs, lib, ... }:
{
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages                  = pkgs.linuxPackages_latest;
  boot.kernelModules                   = [ "i2c-dev" ];
  networking.hostName              = "shaonix";
  networking.networkmanager.enable = true;
  networking.firewall.enable       = true;
  time.timeZone      = "Asia/Dhaka";
  i18n.defaultLocale = "en_US.UTF-8";
  users.users.shaonix = {
    isNormalUser = true;
    description  = "shaonix";
    extraGroups  = [ "networkmanager" "wheel" "video" "input" "storage" "i2c" ];
    shell        = pkgs.bash;
  };
  security.pam.services.hyprlock = {};
  security.polkit.enable         = true;
  security.rtkit.enable          = true;
  hardware.graphics = {
    enable        = true;
    extraPackages = [ pkgs.intel-media-driver ];
  };
  hardware.cpu.intel.updateMicrocode = true;
  hardware.i2c.enable                = true;
  services.pipewire = {
    enable             = true;
    alsa.enable        = true;
    pulse.enable       = true;
    wireplumber.enable = true;
  };
  services.pipewire.wireplumber.extraConfig."99-default-sink" = {
    "monitor.alsa.rules" = [{
      matches = [{ "node.name" = "alsa_output.pci-0000_00_1f.3.analog-stereo"; }];
      actions  = { update-props = { "priority.session" = 2000; }; };
    }];
  };
  programs.niri.enable     = true;
  programs.xwayland.enable = true;
  xdg.portal = {
    enable        = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config.niri = {
      default                                   = [ "gnome" "gtk" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast"  = [ "gnome" ];
      "org.freedesktop.impl.portal.Screenshot"  = [ "gnome" ];
    };
  };
  services.greetd = {
    enable   = true;
    settings = {
      default_session = {
        user    = "greeter";
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd niri-session";
      };
    };
  };
  services.gvfs.enable                = true;
  services.gnome.gnome-keyring.enable = true;
  services.udisks2.enable             = true;
  fonts.packages = [ pkgs.iosevka ];
  fonts.fontconfig.defaultFonts.monospace = [ "Iosevka" ];
  fonts.fontconfig.defaultFonts.sansSerif = [ "Iosevka" ];
  swapDevices = [{
    device   = "/var/lib/swapfile";
    size     = 8192;
    priority = 0;
  }];
  zramSwap.enable = true;
  environment.variables.QT_QPA_PLATFORMTHEME = lib.mkForce "gtk2";
  environment.sessionVariables = {
    NIXOS_OZONE_WL                     = "1";
    XDG_CURRENT_DESKTOP                = "niri:GNOME";
    XDG_SESSION_TYPE                   = "wayland";
    XDG_SESSION_DESKTOP                = "niri";
    QT_QPA_PLATFORM                    = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION  = "1";
  };
  environment.systemPackages = with pkgs; [
    nautilus
    git
    firefox
    xwayland-satellite
    qt5.qtwayland
    qt6.qtwayland
    swaybg
    hyprlock
    fuzzel
    wl-clipboard
    wiremix
    wireplumber
    pulseaudio
    slurp
    grim
    wlsunset
    ddcutil
    networkmanagerapplet
    nh
    udiskie
    keepassxc
    imv
    zathura
  ];
  home-manager.users.shaonix = {
    home.stateVersion = "26.05";
    programs.home-manager.enable = true;
    systemd.user.sessionVariables = {
      GDK_BACKEND                        = "wayland,x11";
    };
    xdg.desktopEntries.helix = {
      name        = "Helix";
      genericName = "Text Editor";
      exec        = "alacritty -e hx %F";
      terminal    = false;
      categories  = [ "Utility" "TextEditor" ];
      mimeType    = [
        "text/plain" "text/x-nix" "text/markdown"
        "application/json" "text/x-shellscript" "text/x-org"
      ];
    };
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory"                    = [ "org.gnome.Nautilus.desktop" ];
        "application/x-gnome-saved-search" = [ "org.gnome.Nautilus.desktop" ];
        "text/plain"                         = [ "helix.desktop" ];
        "text/x-nix"                         = [ "helix.desktop" ];
        "text/markdown"                      = [ "helix.desktop" ];
        "application/json"                   = [ "helix.desktop" ];
        "text/x-shellscript"                 = [ "helix.desktop" ];
        "text/x-org"                         = [ "helix.desktop" ];
        "application/pdf"                    = [ "zathura.desktop" ];
      };
    };
    xdg.configFile."niri/config.kdl".text = ''
      input {
          keyboard {
              xkb {
                  layout "us"
              }
              repeat-delay 300
              repeat-rate  50
          }
          focus-follows-mouse
      }
      cursor {
          xcursor-theme "Adwaita"
          xcursor-size 24
      }
      output "HDMI-A-2" {
          mode "1280x1024@75"
      }
      layout {
          gaps 6
          center-focused-column "never"
          preset-column-widths {
              proportion 0.33333
              proportion 0.5
              proportion 0.66667
          }
          default-column-width { proportion 0.5; }
          struts {
              left   9
              right  9
              top    9
              bottom 9
          }
          focus-ring {
              width 3
              active-color   "#458588"
              inactive-color "#D9D3C3"
          }
          border {
              width 3
              active-color   "#458588"
              inactive-color "#D9D3C3"
          }
      }
      prefer-no-csd
      window-rule {
          geometry-corner-radius 8
          clip-to-geometry true
      }
      window-rule {
          match app-id="xdg-desktop-portal-gtk"
          open-floating true
      }
      window-rule {
          match title="File Operation Progress"
          open-floating true
      }
      window-rule {
          match title="Confirm to replace files"
          open-floating true
      }
      window-rule {
          match app-id="imv"
          open-floating true
      }
      spawn-at-startup "udiskie" "-t"
      spawn-at-startup "swaybg" "-i" "/etc/nixos/wallpaper.jpg" "-m" "fill"
      spawn-at-startup "wlsunset" "-t" "4500" "-T" "4500"
      spawn-at-startup "xwayland-satellite"
      binds {
          Mod+Return { spawn "alacritty"; }
          Mod+Space  { spawn "fuzzel"; }
          Mod+B      { spawn "firefox"; }
          Mod+C         { close-window; }
          Mod+F         { maximize-column; }
          Mod+Shift+Space { toggle-window-floating; }
          Mod+H     { focus-column-left; }
          Mod+J     { focus-window-or-workspace-down; }
          Mod+K     { focus-window-or-workspace-up; }
          Mod+L     { focus-column-right; }
          Mod+Left  { focus-column-left; }
          Mod+Down  { focus-window-or-workspace-down; }
          Mod+Up    { focus-window-or-workspace-up; }
          Mod+Right { focus-column-right; }
          Mod+Shift+H      { move-column-left; }
          Mod+Shift+J      { move-window-down-or-to-workspace-down; }
          Mod+Shift+K      { move-window-up-or-to-workspace-up; }
          Mod+Shift+L      { move-column-right; }
          Mod+Shift+Left   { move-column-left; }
          Mod+Shift+Down   { move-window-down-or-to-workspace-down; }
          Mod+Shift+Up     { move-window-up-or-to-workspace-up; }
          Mod+Shift+Right  { move-column-right; }
          XF86AudioMute        { spawn "sh" "-c" "pactl set-sink-mute @DEFAULT_SINK@ toggle"; }
          XF86AudioLowerVolume { spawn "sh" "-c" "pactl set-sink-volume @DEFAULT_SINK@ -2%"; }
          XF86AudioRaiseVolume { spawn "sh" "-c" "pactl set-sink-volume @DEFAULT_SINK@ +2%"; }
          Mod+Shift+X { spawn "hyprlock"; }
          Mod+Shift+E { quit; }
      }
    '';
programs.alacritty = {
      enable = true;
      settings = {
        font.normal = { family = "Iosevka"; style = "Regular"; };
        font.size   = 18;
        window.padding = { x = 10; y = 10; };
        colors.primary = {
          background = "#FDF6E3";
          foreground = "#000000";
        };
      };
    };
    programs.helix = {
      enable        = true;
      defaultEditor = true;
      settings.editor.line-number        = "relative";
      settings.editor.clipboard-provider = "wayland";
      settings.theme = "papercolor-light";
      extraPackages = [ pkgs.nixd ];
    };
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree          = true;
  system.stateVersion = "26.05";
}
