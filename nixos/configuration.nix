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

{ config, pkgs, lib, inputs, options, ... }:

let
  unstable = import <nixos-unstable> {
    config = { allowUnfree = true; };
  };
  secrets = import ./secrets.nix;
  browsers = import ./browsers.nix;
in {
  imports = [
    ./hardware-configuration.nix
    #./home.nix
    ./packages.nix
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
    uinput.enable = true;
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
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
    kernelModules = [
      #"vboxdrv"
      #"vboxnetflt"
      #"vboxnetadp"
      #"vboxpci"
      "kvm-amd"
      "uinput"
    ];
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
    #firewall.checkReversePath = true;
    # Define hostname.
    hostName = "keeper_nix";
    networkmanager.enable = true;
    nat = {
      enable = true;
      internalInterfaces = [ "virbr0" ];
    };
    firewall = {
      checkReversePath = "loose";
      trustedInterfaces = [ "virbr0" ];
    };
  };

  vpnNamespaces.${secrets.vpn.wg.alt.provider} = {
    enable = true;
    wireguardConfigFile = secrets.vpn.wg.alt.conf_path;
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
      tailscaled = {
        enable = true;
        serviceConfig.TimeoutStopSec = "1s";
      };
        #zen_browser_confined = {
        #  description = "Zen Browser in a vpnNamespace";
        #  wantedBy = [ "graphical-session.target" ];
        #  serviceConfig = {
        #    Type = "simple";
        #    User = "super";
        #    StateDirectory = "zen_browser_confined";
        #    ExecStart = "${browsers.zen_browser}/bin/zen";
        #    Restart = "on-failure";
        #  };
        #  preStart = ''
        #    ${pkgs.sudo}/bin/sudo -n ${pkgs.wg-namespace}/bin/wg-namespace ${secrets.vpn.wg.alt.provider}
        #  '';
        #};
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
        gutenprint
        gutenprintBin
        hplip
        brlaser
        cnijfilter2
        epson-escpr2
        epson-escpr
      ];
    };
    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };
    blueman.enable = true;
    displayManager = {
      enable = true;
      cosmic-greeter.enable = false;
    };
    kanata = {
      enable = true;
      keyboards.me_keyboard.config = /* clojure */ ''
        (defsrc
          caps lsft rsft lmet
          z y
          1 2 3 4 5 6 7 8 9 0
          \ ` [ ]
        )

        (defalias
          ;;aliases that press shift and toggle number layer
          lshf_num (multi lsft (layer-toggle numbers))
          rshf_num (multi rsft (layer-toggle numbers))

          ;;super key
          sup (multi lmet (layer-toggle super-layer))
        )

        (deflayer default
          ;;remap caps to esc and set shift and super keys to aliases
          esc @lshf_num @rshf_num @sup

          y z ;;qwertz

          ;;swap shift layer of top-row numbers
          S-1 S-2 S-3 S-4 S-5 S-6 S-7 S-8 S-9 S-0

          S-\ ;;swap shift layer of pipe
          S-` S-[ S-]
        )
        
        (deflayer super-layer
          _ _ _ (unmod lsft) (unmod rsft) _
          1 2 3 4 5 6 7 8 9 0
          _ _ _ _
        )

        (deflayer numbers ;;shift layer
          _ _ _ _ _ _ ;;leave these untouched

          ;;use unmodified key signals for anything modified
          (unmod 1) (unmod 2) (unmod 3) (unmod 4) (unmod 5)
          (unmod 6) (unmod 7) (unmod 8) (unmod 9) (unmod 0)
          (unmod \) (unmod `) (unmod [) (unmod ])
        )
      '';
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
    # Enable sound with pulseaudio.
    pulseaudio = {
      enable = false;
      support32Bit = false;
    };
    displayManager = {
      gdm.enable = true;
    };
    # Configure keymap in X11
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      videoDrivers = [ "nvidia" ];
      excludePackages = with pkgs; [
        xterm
      ];
      displayManager.lightdm.enable = false;
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
  users = {
    groups = {
      libvirtd.members = [ "super" ];
      netns.members = [ "super" ];
    };
    extraGroups.vboxusers.members = [ "super" ];
    users.super = {
      isNormalUser = true;
      description = "keeper";
      extraGroups = [ 
        "networkmanager"
        "wheel"
        "podman"
        "docker"
        "audio"
        "libvirtd"
        "netns"
        "input"
        "uinput"
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
    hyprlock.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable =  true;
    };
    virt-manager.enable = true;
    java = {
      enable = true;
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
    bash.shellAliases = {
      zen_confined = "systemctl --user start zen_browser_confined.service";
    };
  };

  virtualisation = {
    virtualbox = {
      host.enable = true;
    };
    spiceUSBRedirection = {
      enable = true;
    };
    libvirtd = {
      enable = false;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
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
      noto-fonts-color-emoji
      fira-code
      cascadia-code
      nerd-fonts.fira-code
      nerd-fonts._0xproto
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      nerd-fonts.caskaydia-cove
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
      NIXOS_OZONE_WL = "1";
    };
    enableAllTerminfo = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}

