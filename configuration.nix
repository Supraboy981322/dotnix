# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

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

  fileSystems."/mnt/Games" = {
    device = "/dev/disk/by-uuid/8a6b2cd0-0d95-4a57-a8b0-b55661cdfa66";
    fsType = "ext4";
    options = [
      "users"
      "nofail"
    ];
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
  };
  
  networking = {
    # Define hostname.
    hostName = "zane-desktop-pc";
    networkmanager.enable = true;
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

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
    };
    # Enable CUPS to print documents.
    printing.enable = true;
    # Enable sound with pipewire.
    pulseaudio.enable = false;
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
      alsa.enable = true;
      alsa.support32Bit = true;
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
    description = "zane";
    extraGroups = [ "networkmanager" "wheel" "podman" "docker" ];
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
  nixpkgs.config = {
    allowUnfree = true;
    chromium = {
      commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
    };
  };
  programs = {
    firefox = {
      enable = true;
      preferences = {
        # disable libadwaita theming for Firefox
        "widget.gtk.libadwaita-colors.enabled" = false;
      };
    };
    chromium = {
      enable = true;
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
    podman = {
      enable = true;
      dockerCompat = true;
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
    systemPackages = with pkgs; [
      vim
      chromium #gross, I know, my school requires it
      distrobox
      tailscale
      sshfs
      wl-clipboard
      hyprland-protocols
      hyprpicker
      swww
      hyprland
      hyprlang
      gdm
      hyprutils
      hyprshot
      hyprwayland-scanner
      libdrm
      libcap
      udisks2
      sdbus-cpp
      bc
      wayland-protocols
      hyprpaper
      ripgrep
      waybar
      neovim 
      git
      ghostty
      eza
      jq
      bun
      go
      wev
      wofi
      xdotool
      ffmpeg
      jdk23 #for school, I swear
      discord-canary
      ruby
      gnumake
      alsa-utils
      playerctl
      libgcc
      mako
      meson
      zig
      clang
      python3
      libva
      yt-dlp
      gh
      vlc
      mpv
      loupe
      wget
      zenity
      nodejs
      libnotify
      libxcrypt
      fastfetch
      brightnessctl
      tor-browser
      bibata-cursors
      kdePackages.gwenview
      kdePackages.kate
      kdePackages.konsole
      kdePackages.kio-fuse
      kdePackages.kio-extras
      kdePackages.qtsvg
      kdePackages.dolphin
      kdePackages.kde-cli-tools
      (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true;}) {})
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
