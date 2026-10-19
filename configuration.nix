{ config, pkgs, lib, inputs, ... }:
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
  hardware.bluetooth = {
    enable      = true;
    powerOnBoot = true;
  };
  hardware.enableRedistributableFirmware = true;
  services.blueman.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
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
  fonts.fontconfig.defaultFonts.monospace = [ "Iosevka Semibold" ];
  fonts.fontconfig.defaultFonts.sansSerif = [ "Iosevka Semibold" ];
  swapDevices = [{
    device   = "/var/lib/swapfile";
    size     = 8192;
    priority = 0;
  }];
  zramSwap.enable = true;
  systemd.tmpfiles.rules = [
    "d /home/shaonix/Wallpapers 0755 shaonix users -"
    "d /home/shaonix/screenshots 0755 shaonix users -"
  ];
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
    google-chrome
    xwayland-satellite
    qt5.qtwayland
    qt6.qtwayland
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
    evtest
    imv
    zathura
    usbutils
    bluez        # gives you bluetoothctl, btmon, hcitool, sdptool
    bluez-tools  # bt-device, bt-adapter, bt-obex (file transfer!)
];
  home-manager.users.shaonix = {
    imports = [ inputs.noctalia.homeModules.default ];
    programs.noctalia = {
      enable = true;
      settings = {
        theme = {
          mode           = "light";
          source         = "custom";
          custom_palette = "Cream";
        };
        bar.default = {
          margin_ends = 0;
          margin_edge = 0;
          end = [
            "media"
            "tray"
            "notifications"
            "clipboard"
            "network"
            "bluetooth"
            "volume"
            "brightness"
            "battery"
            "control-center"
            "session"
          ];
        };
        plugins.enabled = [
          "noctalia/wallhaven"
          "noctalia/world_clock"
          "noctalia/timer"
        ];
        wallpaper = {
          enabled = true;
          directory = "/home/shaonix/Wallpapers";
          default.path = "/etc/nixos/wallpaper.jpg";
        };
      };
    };
    xdg.configFile."noctalia/palettes/Cream.json".text = ''
      {
        "dark": {
          "mPrimary": "#458588",
          "mOnPrimary": "#FDF6E3",
          "mSecondary": "#689D6A",
          "mOnSecondary": "#FDF6E3",
          "mTertiary": "#B16286",
          "mOnTertiary": "#FDF6E3",
          "mError": "#CC241D",
          "mOnError": "#FDF6E3",
          "mSurface": "#FDF6E3",
          "mOnSurface": "#000000",
          "mSurfaceVariant": "#EEE8D5",
          "mOnSurfaceVariant": "#3C3836",
          "mOutline": "#D9D3C3",
          "mShadow": "#B8B2A2",
          "mHover": "#E6DFC8",
          "mOnHover": "#000000",
          "terminal": {
            "background": "#FDF6E3",
            "foreground": "#000000",
            "cursor": "#000000",
            "cursorText": "#FDF6E3",
            "selectionBg": "#D9D3C3",
            "selectionFg": "#000000",
            "normal": {
              "black": "#000000",
              "red": "#CC241D",
              "green": "#98971A",
              "yellow": "#D79921",
              "blue": "#458588",
              "magenta": "#B16286",
              "cyan": "#689D6A",
              "white": "#D9D3C3"
            },
            "bright": {
              "black": "#555555",
              "red": "#9D0006",
              "green": "#79740E",
              "yellow": "#B57614",
              "blue": "#076678",
              "magenta": "#8F3F71",
              "cyan": "#427B58",
              "white": "#EEE8D5"
            }
          }
        },
        "light": {
          "mPrimary": "#458588",
          "mOnPrimary": "#FDF6E3",
          "mSecondary": "#689D6A",
          "mOnSecondary": "#FDF6E3",
          "mTertiary": "#B16286",
          "mOnTertiary": "#FDF6E3",
          "mError": "#CC241D",
          "mOnError": "#FDF6E3",
          "mSurface": "#FDF6E3",
          "mOnSurface": "#000000",
          "mSurfaceVariant": "#EEE8D5",
          "mOnSurfaceVariant": "#3C3836",
          "mOutline": "#D9D3C3",
          "mShadow": "#B8B2A2",
          "mHover": "#E6DFC8",
          "mOnHover": "#000000",
          "terminal": {
            "background": "#FDF6E3",
            "foreground": "#000000",
            "cursor": "#000000",
            "cursorText": "#FDF6E3",
            "selectionBg": "#D9D3C3",
            "selectionFg": "#000000",
            "normal": {
              "black": "#000000",
              "red": "#CC241D",
              "green": "#98971A",
              "yellow": "#D79921",
              "blue": "#458588",
              "magenta": "#B16286",
              "cyan": "#689D6A",
              "white": "#D9D3C3"
            },
            "bright": {
              "black": "#555555",
              "red": "#9D0006",
              "green": "#79740E",
              "yellow": "#B57614",
              "blue": "#076678",
              "magenta": "#8F3F71",
              "cyan": "#427B58",
              "white": "#EEE8D5"
            }
          }
        }
      }
    '';
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
      window-rule {
          match app-id="dev.noctalia.Noctalia"
          open-floating true
          default-column-width { fixed 1080; }
          default-window-height { fixed 920; }
      }
      debug {
          honor-xdg-activation-with-invalid-serial
      }
      screenshot-path "~/screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
      spawn-at-startup "udiskie" "-t"
      spawn-at-startup "noctalia"
      spawn-at-startup "wlsunset" "-t" "4500" "-T" "4500"
      spawn-at-startup "xwayland-satellite"
      binds {
          Mod+Return { spawn "alacritty"; }
          Mod+Space  { spawn-sh "noctalia msg panel-toggle launcher"; }
          Mod+D      { spawn "fuzzel"; }
          Mod+S      { spawn-sh "noctalia msg panel-toggle control-center"; }
          Mod+Comma  { spawn-sh "noctalia msg settings-toggle"; }
          Mod+W      { spawn-sh "noctalia msg panel-toggle noctalia/wallhaven:browser"; }
          Mod+Shift+W { spawn-sh "noctalia msg wallpaper-random"; }
          Mod+T       { spawn-sh "noctalia msg panel-toggle noctalia/timer:panel"; }
          Mod+Y       { spawn-sh "noctalia msg panel-toggle noctalia/world_clock:panel"; }
          Alt+Tab    { spawn-sh "noctalia msg window-switcher hold"; }
          Print      { screenshot; }
          Ctrl+Print { screenshot-screen; }
          Alt+Print  { screenshot-window; }
          Mod+Shift+S { spawn "sh" "-c" "f=\"$HOME/screenshots/region-$(date +%F_%H-%M-%S).png\"; grim -g \"$(slurp)\" \"$f\" && wl-copy < \"$f\""; }
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
          XF86AudioMute        { spawn-sh "noctalia msg volume-mute"; }
          XF86AudioLowerVolume { spawn-sh "noctalia msg volume-down"; }
          XF86AudioRaiseVolume { spawn-sh "noctalia msg volume-up"; }
          XF86MonBrightnessUp   { spawn-sh "noctalia msg brightness-up"; }
          XF86MonBrightnessDown { spawn-sh "noctalia msg brightness-down"; }
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
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };
  nixpkgs.config.allowUnfree          = true;
  system.stateVersion = "26.05";
}
