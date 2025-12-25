# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

/* >[!NOTE]
 * >RUN THE FOLLOWING COMMANDS TO PREVENT `nixos-unstable` err:
 * ```sh
 * sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
 * sudo nix-channel --update
 * ```
 * 
 * Also, make sure to rebuild with `--impure`
 * ```sh
 * sudo nixos-rebuild switch --impure
 * ```
 * 
 * <sub>yeah, md in my configuration.nix comments</sub>
 */

{ config, pkgs, lib, inputs, ... }:

let
  unstable = import <nixos-unstable> {
   config = { allowUnfree = true; };
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./home.nix
    ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
   };
  };

  fileSystems = {
    "/mnt/nfs" = {
      device = "100.98.9.96:/mnt";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "noauto"
      ];
    };
    "/mnt/Games" = {
      device = "/dev/disk/by-uuid/8a6b2cd0-0d95-4a57-a8b0-b55661cdfa66";
      fsType = "ext4";
      options = [
        "users"
        "nofail"
      ];
    };
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 25*1024;
    }
  ];

  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        libva-vdpau-driver
      ];
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  # Bootloader.
  boot = {
    loader = { 
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      supportedFilesystems = [
        "nfs"
      ];
      kernelModules = [
        "nfs"
      ];
    };
    supportedFilesystems = [
      "nfs"
    ];
  };
  
  networking = {
    # Define hostname.
    hostName = "dont_nix";
    networkmanager.enable = true;
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  };

  # Set your time zone.
  time = {
    timeZone = "America/Chicago";
    hardwareClockInLocalTime = false;
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
    
  security = {
    rtkit.enable = true;
  };

  systemd = {
    services = {
      tailscaled.enable = true;
      tailscaled.serviceConfig.TimeoutStopSec = "1s";
    };
  };

  services = {
    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };
    blueman.enable = true;
    displayManager = {
      enable = true;
      cosmic-greeter.enable = false;
    };
    desktopManager = {
      cosmic = {
        enable = false;
      };
    };
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };
    # Enable CUPS to print documents.
    printing.enable = true;
    # Enable sound with pulseaudio.
    pulseaudio = {
      enable = false;
      support32Bit = false;
    };
    # Configure keymap in X11
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      videoDrivers = ["nvidia"];
      displayManager = {
        lightdm.enable = false;
        gdm.enable = true;
      };
      excludePackages = with pkgs; [
        xterm
      ];
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      wireplumber.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
  
      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.super = {
    isNormalUser = true;
    description = "don't";
    extraGroups = [ 
      "networkmanager"
      "wheel"
      "podman"
      "docker"
      "audio"
    ];
    subUidRanges = [
      {
        count = 65536;
        startUid = 100000;
      }
    ];
    subGidRanges = [
      {
        count = 65536;
        startGid = 100000;
      }
    ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      chromium = {
        commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
      };
    };
  };
  programs = {
    java = {
      enable = true;
      package = pkgs.jdk23.override {
        enableJavaFX = true;
      };
    };
    firefox = {
      enable = true;
      preferences = {
        # disable libadwaita theming for Firefox
        "widget.gtk.libadwaita-colors.enabled" = false;
      };
    };
    chromium = {
      enable = false;
    };
    nix-ld = {
      enable = true;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    waybar = {
      enable = true;
    };
    hyprland = {
      enable = true;
      xwayland.enable =  true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    tmux = {          #wanted to try-out tmux
      enable = false; #  suddenly don't have time
    };                #    may come back to this later
    dconf.profiles.user.databases = [
      {
        settings."org/gnome/desktop/interface" = {
          gtk-theme = "Adwaita";
          icon-theme = "Flat-Remix-Red-Dark";
          font-name = "Noto Sans Medium 11";
          document-font-name = "Noto Sans Medium 11";
          monospace-font-name = "Noto Sans Mono Medium 11";
        };
      }
    ];
  };

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    podman = {
      enable = true;
      #      dockerCompat = true;
    };
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-color-emoji
      fira-code
      nerd-fonts.fira-code
      nerd-fonts._0xproto
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway";
    };
    enableAllTerminfo = true;
    systemPackages = (with pkgs; [
      #STABLE PKGS
      gh
      jq
      bc
      vim
      gdm
      git
      eza
      wev
      wget
      swww
      wofi
      nmap
      file
      ruby
      gimp
      mako
      glib
      gtk3
      glibc
      loupe
      libva
      sshfs
      meson
      clang
      jdk23
      nitch
      dialog
      yt-dlp
      zenity
      libdrm
      libcap
      waybar
      docker
      podman
      freerdp
      udisks2
      ripgrep
      xdotool
      python3
      gnumake
      obsidian
      hyprshot
      chromium #gross, I know, my school requires it
      hyprland
      hyprlang
      iproute2
      libnotify
      nfs-utils
      hyprutils
      sdbus-cpp
      hyprpaper
      playerctl
      libnotify
      libxcrypt
      fastfetch
      pkg-config
      alsa-utils
      hyprpicker
      tor-browser
      libglibutil
      wl-clipboard
      brightnessctl
      bibata-cursors
      discord-canary
      wayland-protocols
      hyprland-protocols
      hyprwayland-scanner
      gnome-system-monitor
      javaPackages.openjfx23

      #stuff I prefer from KDE
      kdePackages.kate
      kdePackages.qtsvg
      kdePackages.dolphin
      kdePackages.konsole
      kdePackages.gwenview
      kdePackages.kio-fuse
      kdePackages.kio-extras
      kdePackages.kde-cli-tools

      #UNSTABLE PKGS
      unstable.go
      unstable.lua
      unstable.zip
      unstable.bun
      unstable.gcc
      unstable.zig
      unstable.vlc
      unstable.mpv
      unstable.wine
      unstable.rustc
      unstable.cargo
      unstable.socat
      unstable.samba
      unstable.wine64
      unstable.lutris
      unstable.libgcc
      unstable.neovim 
      unstable.ffmpeg
      unstable.busybox
      unstable.openvpn
      unstable.makemkv
      unstable.ghostty
      unstable.luarocks
      unstable.tailscale
      unstable.distrobox
      unstable.tree-sitter
      unstable.prismlauncher
      unstable.wine64Packages.waylandFull
      unstable.wineWow64Packages.waylandFull

      #WRAPPERS
      (pkgs.wrapFirefox
        (pkgs.firefox-unwrapped.override {
          pipewireSupport = true;
        }) 
      {})
      (lutris.override {
        extraLibraries = pkgs: [
          #add missing libs here
        ];
        extraPkgs = pkgs: [
          #missing package deps here
        ];
      })
    ]);
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
