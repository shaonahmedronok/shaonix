{ config, pkgs, lib, inputs, ... }:
{
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages                  = pkgs.linuxPackages_latest;
  boot.kernelModules                   = [ "i2c-dev" ];
  networking.hostName              = "shaonix";
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
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
  environment.shellAliases.ls = "ls --color=tty -lah";
  security.rtkit.enable          = true;
  hardware.graphics = {
    enable        = true;
    enable32Bit   = true;
    extraPackages = [ pkgs.intel-media-driver pkgs.intel-vaapi-driver pkgs.vpl-gpu-rt ];
  };
  hardware.cpu.intel.updateMicrocode = true;
  hardware.bluetooth = {
    enable      = true;
    powerOnBoot = true;
  };
  hardware.enableRedistributableFirmware = true;
  services.blueman.enable = true;
  programs.kdeconnect.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  hardware.i2c.enable                = true;
  fileSystems."/data" = {
    device  = "/dev/disk/by-uuid/17cf1740-c8e5-49b1-be2e-762f9a8f440a";
    fsType  = "ext4";
    options = [ "nofail" ];
  };

  services.jellyfin = {
    enable       = true;
    openFirewall = true;
  };
  systemd.services.jellyfin.unitConfig.RequiresMountsFor = "/data";
  users.users.jellyfin.extraGroups = [ "render" "video" ];
  services.pipewire = {
    enable             = true;
    alsa.enable        = true;
    pulse.enable       = true;
    jack.enable        = true;
    wireplumber.enable = true;
  };
  services.pipewire.wireplumber.extraConfig."99-default-sink" = {
    "monitor.alsa.rules" = [{
      matches = [{ "node.name" = "alsa_output.pci-0000_00_1f.3.analog-stereo"; }];
      actions  = { update-props = { "priority.session" = 2000; }; };
    }];
  };
  services.pipewire.wireplumber.extraConfig."51-bluez" = {
  "monitor.bluez.rules" = [{
     matches = [{ "node.name" = "~bluez_output.*"; }];
     actions  = { update-props = { "priority.session" = 3000; }; };
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
  # ---- extras merged from your pasted configs (adapted) ----
  programs.dconf.enable = true;
  i18n.inputMethod = {
    enable = true;
    type   = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [ fcitx5-mozc fcitx5-gtk fcitx5-openbangla-keyboard ];
      settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "mozc";
        };
        "Groups/0/Items/0".Name = "keyboard-us";
        "Groups/0/Items/1".Name = "mozc";
        "Groups/0/Items/2".Name = "openbangla";        
      };
    };
  };
  environment.pathsToLink = [ "/share/thumbnailers" ];
  services.dbus.packages = [ pkgs.sushi ];
  programs.nix-ld = {
    enable    = true;
    libraries = with pkgs; [ stdenv.cc.cc zlib libusb1 util-linux fuse3 icu nss openssl curl expat vulkan-loader ];
  };
  services.journald.extraConfig = "SystemMaxUse=200M\nSystemMaxFiles=5";
  boot.plymouth.enable = true;
  boot.consoleLogLevel = 3;
  boot.initrd.verbose  = false;
  boot.kernelParams    = [ "quiet" "splash" "udev.log_priority=3" "rd.udev.log_level=3" ];
  services.avahi = {
    enable     = true;
    nssmdns4   = true;
  };
  services.tailscale.enable = true;
  services.tailscale.openFirewall = true;
  programs.localsend = {
    enable       = true;
    openFirewall = true;
  };
  nix.optimise.automatic = true;
  services.printing.enable = true;
  services.flatpak.enable  = true;
  services.fstrim.enable   = true;
  services.fwupd.enable = true;
  services.smartd = {
    enable     = true;
    autodetect = true;
  };
  networking.networkmanager.wifi.powersave = false;
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  nix.registry.nixpkgs.flake   = inputs.nixpkgs;
  nix.nixPath                  = [ "nixpkgs=${inputs.nixpkgs}" ];
  services.earlyoom.enable = true;
  boot.tmp.cleanOnBoot     = true;
  security.sudo.execWheelOnly = true;
  networking.firewall.allowPing = false;
  boot.kernel.sysctl = {
  "kernel.dmesg_restrict"                  = 1;
  "kernel.kptr_restrict"                   = 2;
  "kernel.unprivileged_bpf_disabled"       = 1;
  "net.core.bpf_jit_harden"                = 2;
  "net.ipv4.conf.all.rp_filter"            = 2;
  "net.ipv4.conf.default.rp_filter"        = 2;
  "net.ipv4.conf.all.accept_redirects"     = 0;
  "net.ipv4.conf.default.accept_redirects" = 0;
  "net.ipv6.conf.all.accept_redirects"     = 0;
  "net.ipv4.conf.all.send_redirects"       = 0;
  };
  programs.fuse.userAllowOther = true;
  programs.gnupg.agent.enable  = true;
  networking.stevenblack.enable = true;
  fonts.packages = [
    pkgs.iosevka
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.fira-mono
    pkgs.corefonts
    pkgs.noto-fonts
    pkgs.noto-fonts-color-emoji
    pkgs.liberation_ttf
    pkgs.noto-fonts-cjk-sans
    pkgs.ipafont
  ];
  fonts.fontconfig.defaultFonts.monospace = [ "Iosevka Semibold" "Noto Sans Mono CJK JP" "Noto Sans Bengali" ];
  fonts.fontconfig.defaultFonts.sansSerif = [ "Inter" "Noto Sans Bengali" "Noto Sans CJK JP" "Iosevka Semibold" ];
  swapDevices = [{
    device   = "/var/lib/swapfile";
    size     = 8192;
    priority = 0;
  }];
  zramSwap.enable = true;
  systemd.tmpfiles.rules = [
    "d /home/shaonix/Wallpapers 0755 shaonix users -"
    "d /home/shaonix/screenshots 0755 shaonix users -"
    "f /home/shaonix/.config/noctalia/nightlight.toml 0644 shaonix users - [nightlight]\\ntemperature_night = 3000\\n"
  ];
  environment.variables.QT_QPA_PLATFORMTHEME = lib.mkForce "gtk2";
  environment.sessionVariables = {
    NIXOS_OZONE_WL                     = "1";
    _JAVA_AWT_WM_NONREPARENTING        = "1";
    XDG_CURRENT_DESKTOP                = "niri:GNOME";
    XDG_SESSION_TYPE                   = "wayland";
    XDG_SESSION_DESKTOP                = "niri";
    QT_QPA_PLATFORM                    = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION  = "1";
  };
  environment.systemPackages = with pkgs; [
    nautilus
    yazi
    git
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
    scrcpy
    android-tools
    sushi
    loupe
    celluloid
    mpv
    pwvucontrol
    pavucontrol
    playerctl
    btop
    fastfetch
    ripgrep
    fd
    bat
    eza
    fzf
    jq
    ffmpeg
    ffmpegthumbnailer
    yt-dlp
    zip
    unzip
    lsof
    libnotify
    curl
    wget
    vulkan-tools
    rclone
    restic
    freerdp

      (pkgs.writeShellScriptBin "nl-adjust" ''
      f="$HOME/.config/noctalia/nightlight.toml"
      step=250; min=1500; max=5500
      cur=$(${pkgs.gnugrep}/bin/grep -o '[0-9]\+' "$f" 2>/dev/null | head -n1)
      cur=''${cur:-3000}
      case "$1" in
        warmer) new=$((cur - step)) ;;
        cooler) new=$((cur + step)) ;;
        *) exit 1 ;;
      esac
      [ "$new" -lt "$min" ] && new=$min
      [ "$new" -gt "$max" ] && new=$max
      printf '[nightlight]\ntemperature_night = %s\n' "$new" > "$f"
    '')
      (pkgs.writeShellScriptBin "webcam" ''
      exec ${pkgs.mpv}/bin/mpv \
        --profile=low-latency --untimed --no-cache \
        --no-osc --no-osd-bar --no-input-default-bindings \
        --autofit=320x240 \
        --force-window=yes --title=webcam --wayland-app-id=webcam \
        av://v4l2:/dev/video10
    '')
    inputs.niri-float-sticky.packages.${pkgs.stdenv.hostPlatform.system}.default
    usbutils
    bluez        # gives you bluetoothctl, btmon, hcitool, sdptool
    bluez-tools  # bt-device, bt-adapter, bt-obex (file transfer!)
    smartmontools
];
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
      obs-backgroundremoval
    ];
  };
  # Two virtual cameras: video10 = phone, video13 = OBS
  boot.extraModprobeConfig = lib.mkForce ''
    options v4l2loopback devices=2 video_nr=10,13 card_label="Phone Cam,OBS Virtual Camera" exclusive_caps=1,1
  '';

  systemd.user.services.phonecam = {
    description = "Phone camera to virtual webcam";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.ffmpeg}/bin/ffmpeg -loglevel warning -fflags nobuffer \
          -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 5 \
          -i http://192.168.0.101:8080/video \
          -vf format=yuv420p -f v4l2 /dev/video10
      '';
      Restart = "always";
      RestartSec = 5;
    };
  };
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
          start = [
            "launcher"
            "wallpaper"
            "workspaces"
            "audio-vis"
          ];
          end = [
            "tray"
            "notifications"
            "clipboard"
            "privacy"
            "network"
            "bluetooth"
            "volume"
            "brightness"
            "nightlight"
            "battery"
            "control-center"
            "session"
          ];
        };
          widget.nightlight = {
          scroll_repeat = "steps";
          actions = {
            scroll_up = "exec /run/current-system/sw/bin/nl-adjust warmer";
            scroll_down = "exec /run/current-system/sw/bin/nl-adjust cooler";
          };
        };
        plugins.enabled = [
          "noctalia/wallhaven"
          "noctalia/world_clock"
          "noctalia/timer"
        ];
        idle.behavior.screen-off = {
          timeout = 600;
          command = "noctalia:dpms-off";
          resume_command = "noctalia:dpms-on";
        };
        idle.behavior.lock = {
          enabled = true;
          timeout = 660;
          command = "hyprlock";
        };
        shell = {
          time_format  = "{:%-I:%M %p}";
          polkit_agent = true;
          launcher.default_view = "all";
          panel = {
            transparency_mode      = "soft";
          };
          screen_corners = {
            enabled = true;
            size    = 24;
          };
        };
        widget.audio-vis = {
          type           = "audio_visualizer";
          width          = 64;
          bands          = 20;
          show_when_idle = true;
          actions = {
            left = "exec noctalia msg panel-toggle control-center media";
          };
        };
        widget.clock = {
          format         = "{:%-I:%M %p}";
          tooltip_format = "{:%A, %B %d, %Y}";
        };
        osd.position = "bottom_center";
        dock.enabled = false;
        wallpaper = {
          enabled = true;
          directory = "/home/shaonix/Wallpapers";
          default.path = "${pkgs.runCommand "plain.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''magick -size 64x64 xc:'#FDF6E3' $out''}";
        };
      };
    };
    xdg.configFile."noctalia/palettes/Gruvbox.json".text = ''
      {
        "dark": {
          "mPrimary": "#b8bb26",
          "mOnPrimary": "#282828",
          "mSecondary": "#fabd2f",
          "mOnSecondary": "#282828",
          "mTertiary": "#83a598",
          "mOnTertiary": "#282828",
          "mError": "#fb4934",
          "mOnError": "#282828",
          "mSurface": "#282828",
          "mOnSurface": "#fbf1c7",
          "mSurfaceVariant": "#3c3836",
          "mOnSurfaceVariant": "#ebdbb2",
          "mOutline": "#57514e",
          "mShadow": "#282828",
          "mHover": "#83a598",
          "mOnHover": "#282828",
          "terminal": {
            "background": "#282828",
            "foreground": "#ebdbb2",
            "cursor": "#ebdbb2",
            "cursorText": "#282828",
            "selectionBg": "#3c3836",
            "selectionFg": "#ebdbb2",
            "normal": {
              "black": "#282828",
              "red": "#cc241d",
              "green": "#98971a",
              "yellow": "#d79921",
              "blue": "#000000",
              "magenta": "#b16286",
              "cyan": "#689d6a",
              "white": "#a89984"
            },
            "bright": {
              "black": "#928374",
              "red": "#fb4934",
              "green": "#b8bb26",
              "yellow": "#fabd2f",
              "blue": "#83a598",
              "magenta": "#d3869b",
              "cyan": "#8ec07c",
              "white": "#ebdbb2"
            }
          }
        },
        "light": {
          "mPrimary": "#b8bb26",
          "mOnPrimary": "#282828",
          "mSecondary": "#fabd2f",
          "mOnSecondary": "#282828",
          "mTertiary": "#83a598",
          "mOnTertiary": "#282828",
          "mError": "#fb4934",
          "mOnError": "#282828",
          "mSurface": "#282828",
          "mOnSurface": "#fbf1c7",
          "mSurfaceVariant": "#3c3836",
          "mOnSurfaceVariant": "#ebdbb2",
          "mOutline": "#57514e",
          "mShadow": "#282828",
          "mHover": "#83a598",
          "mOnHover": "#282828",
          "terminal": {
            "background": "#282828",
            "foreground": "#ebdbb2",
            "cursor": "#ebdbb2",
            "cursorText": "#282828",
            "selectionBg": "#3c3836",
            "selectionFg": "#ebdbb2",
            "normal": {
              "black": "#282828",
              "red": "#cc241d",
              "green": "#98971a",
              "yellow": "#d79921",
              "blue": "#000000",
              "magenta": "#b16286",
              "cyan": "#689d6a",
              "white": "#a89984"
            },
            "bright": {
              "black": "#928374",
              "red": "#fb4934",
              "green": "#b8bb26",
              "yellow": "#fabd2f",
              "blue": "#83a598",
              "magenta": "#d3869b",
              "cyan": "#8ec07c",
              "white": "#ebdbb2"
            }
          }
        }
      }
    '';
    xdg.configFile."noctalia/palettes/Cream.json".text = ''
      {
        "dark": {
          "mPrimary": "#000000",
          "mOnPrimary": "#FDF6E3",
          "mSecondary": "#000000",
          "mOnSecondary": "#FDF6E3",
          "mTertiary": "#000000",
          "mOnTertiary": "#FDF6E3",
          "mError": "#000000",
          "mOnError": "#FDF6E3",
          "mSurface": "#FDF6E3",
          "mOnSurface": "#000000",
          "mSurfaceVariant": "#EEE8D5",
          "mOnSurfaceVariant": "#000000",
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
              "red": "#000000",
              "green": "#000000",
              "yellow": "#000000",
              "blue": "#000000",
              "magenta": "#000000",
              "cyan": "#000000",
              "white": "#D9D3C3"
            },
            "bright": {
              "black": "#000000",
              "red": "#000000",
              "green": "#000000",
              "yellow": "#000000",
              "blue": "#000000",
              "magenta": "#000000",
              "cyan": "#000000",
              "white": "#EEE8D5"
            }
          }
        },
        "light": {
          "mPrimary": "#000000",
          "mOnPrimary": "#FDF6E3",
          "mSecondary": "#000000",
          "mOnSecondary": "#FDF6E3",
          "mTertiary": "#000000",
          "mOnTertiary": "#FDF6E3",
          "mError": "#000000",
          "mOnError": "#FDF6E3",
          "mSurface": "#FDF6E3",
          "mOnSurface": "#000000",
          "mSurfaceVariant": "#EEE8D5",
          "mOnSurfaceVariant": "#000000",
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
              "red": "#000000",
              "green": "#000000",
              "yellow": "#000000",
              "blue": "#000000",
              "magenta": "#000000",
              "cyan": "#000000",
              "white": "#D9D3C3"
            },
            "bright": {
              "black": "#000000",
              "red": "#000000",
              "green": "#000000",
              "yellow": "#000000",
              "blue": "#000000",
              "magenta": "#000000",
              "cyan": "#000000",
              "white": "#EEE8D5"
            }
          }
        }
      }
    '';
    xdg.autostart.enable = true;
    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-light";
    gtk = {
      enable    = true;
      iconTheme = {
        name    = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
    };
    home.pointerCursor = {
      package    = pkgs.bibata-cursors;
      name       = "Bibata-Modern-Ice";
      size       = 24;
      gtk.enable = true;
    };
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
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
        "application/x-gnome-saved-search"   = [ "org.gnome.Nautilus.desktop" ];
        "text/plain"                         = [ "helix.desktop" ];
        "text/x-nix"                         = [ "helix.desktop" ];
        "text/markdown"                      = [ "helix.desktop" ];
        "application/json"                   = [ "helix.desktop" ];
        "text/x-shellscript"                 = [ "helix.desktop" ];
        "text/x-org"                         = [ "helix.desktop" ];
        "application/pdf"                    = [ "org.pwmt.zathura.desktop" ];
        "application/xhtml+xml"              = [ "firefox.desktop" ];
        "text/html"                          = [ "firefox.desktop" ];
        "x-scheme-handler/http"              = [ "firefox.desktop" ];
        "x-scheme-handler/https"             = [ "firefox.desktop" ];
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
          warp-mouse-to-focus
      }
      cursor {
          xcursor-theme "Bibata-Modern-Ice"
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
              active-color   "#000000"
              inactive-color "#D9D3C3"
          }
          border {
              width 3
              active-color   "#000000"
              inactive-color "#D9D3C3"
          }
      }
      prefer-no-csd
      clipboard {
          disable-primary
      }
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
      window-rule {
          match app-id="org.keepassxc.KeePassXC"
          block-out-from "screencast"
      }
      window-rule {
          match app-id="webcam"
          open-floating true
          default-column-width { fixed 320; }
          default-window-height { fixed 240; }
          default-floating-position x=20 y=20 relative-to="bottom-right"
      }
      spawn-at-startup "udiskie" "-t"
      spawn-at-startup "noctalia"
      spawn-at-startup "niri-float-sticky" "-app-id" "webcam"
      spawn-at-startup "fcitx5" "-d"
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
          Mod+Shift+V { spawn "webcam"; }
          Mod+Shift+F { fullscreen-window; }
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
          Mod+1       { focus-workspace 1; }
          Mod+Shift+1 { move-column-to-workspace 1; }
          Mod+2       { focus-workspace 2; }
          Mod+Shift+2 { move-column-to-workspace 2; }
          Mod+3       { focus-workspace 3; }
          Mod+Shift+3 { move-column-to-workspace 3; }
          Mod+4       { focus-workspace 4; }
          Mod+Shift+4 { move-column-to-workspace 4; }
          Mod+5       { focus-workspace 5; }
          Mod+Shift+5 { move-column-to-workspace 5; }
          Mod+6       { focus-workspace 6; }
          Mod+Shift+6 { move-column-to-workspace 6; }
          Mod+7       { focus-workspace 7; }
          Mod+Shift+7 { move-column-to-workspace 7; }
          Mod+8       { focus-workspace 8; }
          Mod+Shift+8 { move-column-to-workspace 8; }
          Mod+9       { focus-workspace 9; }
          Mod+Shift+9 { move-column-to-workspace 9; }
          Mod+Tab        { toggle-overview; }
          Mod+Ctrl+H     { set-column-width "-5%"; }
          Mod+Ctrl+L     { set-column-width "+5%"; }
          Mod+Ctrl+J     { set-window-height "-5%"; }
          Mod+Ctrl+K     { set-window-height "+5%"; }
          Mod+WheelScrollDown      { focus-column-left; }
          Mod+WheelScrollUp        { focus-column-right; }
          Mod+Ctrl+WheelScrollDown { focus-workspace-down; }
          Mod+Ctrl+WheelScrollUp   { focus-workspace-up; }
          Mod+Ctrl+T     { spawn-sh "noctalia msg plugin noctalia/timer:timer all start 25"; }
          Mod+Shift+T    { spawn-sh "noctalia msg plugin noctalia/timer:timer all cancel"; }
          Mod+Shift+Slash { show-hotkey-overlay; }
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
        colors.cursor    = { text = "#FDF6E3"; cursor = "#000000"; };
        colors.selection = { text = "#FDF6E3"; background = "#000000"; };
        colors.normal = {
          black = "#000000"; red = "#000000"; green = "#000000"; yellow = "#000000";
          blue  = "#000000"; magenta = "#000000"; cyan = "#000000"; white = "#D9D3C3";
        };
        colors.bright = {
          black = "#000000"; red = "#000000"; green = "#000000"; yellow = "#000000";
          blue  = "#000000"; magenta = "#000000"; cyan = "#000000"; white = "#EEE8D5";
        };
      };
    };
    programs.vesktop = {
      enable = true;
      settings = {
        arRPC = true;
        hardwareAcceleration = true;
        minimizeToTray = true;
        checkUpdates = true;
        tray = true;
        discordBranch = "canary";
      };
      vencord.settings = {
        autoUpdate = true;
        autoUpdateNotification = true;
        notifyAboutUpdates = false;
        plugins = {
          MessageLogger = {
            enabled = true;
            ignoreSelf = true;
          };
          FixSpotifyEmbeds.enabled = true;
          SpotifyControls.enabled = true;
          SpotifyCrack.enabled = true;
          SilentTyping.enabled = true;
          USRBG.enabled = true;
          ValidUser.enabled = true;
          YoutubeAdblock.enabled = true;
          ShowHiddenChannels.enabled = true;
          PlatformIndicators.enabled = true;
          Translate.enabled = true;
          FakeNitro.enabled = true;
        };
      };
    };
    programs.zathura = {
      enable = true;
      options = {
        adjust-open           = "best-fit";
        database              = "sqlite";
        page-padding          = 4;
        scroll-page-aware     = true;
        selection-clipboard   = "clipboard";
        statusbar-home-tilde  = true;
        window-title-basename = true;
      };
    };
    programs.firefox = {
      enable = true;
      profiles.default = {
        search = {
          force          = true;
          default        = "ddg";
          privateDefault = "ddg";
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "channel"; value = "26.05"; }
                  { name = "query";   value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "Nix Options" = {
              urls = [{
                template = "https://search.nixos.org/options";
                params = [
                  { name = "channel"; value = "26.05"; }
                  { name = "query";   value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };
            "NixOS Wiki" = {
              urls = [{
                template = "https://wiki.nixos.org/w/index.php";
                params = [{ name = "search"; value = "{searchTerms}"; }];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nw" ];
            };
          };
        };
      };
      policies = {
        DisableTelemetry      = true;
        DisableFormHistory    = true;
        DisablePasswordReveal = true;
        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            install_url       = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
            private_browsing  = true;
          };
        };
      };
    };  
    programs.helix = {
      enable        = true;
      defaultEditor = true;
      settings.editor.line-number        = "relative";
      settings.editor.clipboard-provider = "wayland";
      settings.theme = "bw";
      themes.bw = {
        "ui.background"          = { bg = "#FDF6E3"; fg = "#000000"; };
        "ui.text"                = "#000000";
        "ui.cursor"              = { bg = "#000000"; fg = "#FDF6E3"; };
        "ui.cursor.primary"      = { bg = "#000000"; fg = "#FDF6E3"; };
        "ui.selection"           = { bg = "#D9D3C3"; };
        "ui.cursorline.primary"  = { bg = "#EEE8D5"; };
        "ui.linenr"              = "#000000";
        "ui.linenr.selected"     = { fg = "#000000"; modifiers = [ "bold" ]; };
        "ui.statusline"          = { bg = "#D9D3C3"; fg = "#000000"; };
        "ui.statusline.inactive" = { bg = "#EEE8D5"; fg = "#000000"; };
        "ui.popup"               = { bg = "#EEE8D5"; fg = "#000000"; };
        "ui.menu"                = { bg = "#EEE8D5"; fg = "#000000"; };
        "ui.menu.selected"       = { bg = "#000000"; fg = "#FDF6E3"; };
        "ui.virtual"             = "#D9D3C3";
        keyword                  = { modifiers = [ "bold" ]; };
        comment                  = { modifiers = [ "italic" ]; };
      };
      settings.editor.cursorline = true;
      settings.editor.soft-wrap.enable = true;
      settings.editor.end-of-line-diagnostics = "error";
      settings.editor.inline-diagnostics.cursor-line = "hint";
      settings.editor.cursor-shape = { insert = "bar"; normal = "block"; select = "underline"; };
      settings.keys.normal.space."=" = ":format";
      extraPackages = [ pkgs.nixd pkgs.nixfmt ];
    };
  };
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    download-buffer-size  = 524288000;
    warn-dirty            = false;
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };
  nixpkgs.config.allowUnfree          = true;
  system.stateVersion = "26.05";
}
