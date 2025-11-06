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
  
  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
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

  services = {
    blueman.enable = true;
    displayManager = {
      enable = true;
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
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  programs = {
    firefox = {
      enable = true;
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
      xwayland.enable = true;
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
    enableAllTerminfo = true;
    systemPackages = with pkgs; [
      vim
      tailscale
      wl-clipboard
      hyprland-protocols
      hyprpicker
      swww
      hyprland
      hyprlang
      gdm
      hyprutils
      hyprwayland-scanner
      libdrm
      libcap
      sdbus-cpp
      wayland-protocols
      hyprpaper
      waybar
      neovim 
      git
      ghostty
      eza
      jq
      bun
      go
      wofi
      jdk23
      discord-canary
      ruby
      gnumake
      libgcc
      zig
      clang
      python3
      yt-dlp
      gh
      wget
      kitty
      libxcrypt
      bibata-cursors
      kdePackages.gwenview
      kdePackages.kate
      kdePackages.konsole
      kdePackages.kio-fuse
      kdePackages.kio-extras
      kdePackages.qtsvg
      kdePackages.dolphin
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
