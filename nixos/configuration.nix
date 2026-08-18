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

  hyprland_nixpkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  secrets = import ./secrets.nix;
  browsers = import ./browsers.nix;
in {
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./configs
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  fileSystems = {
    "/mnt/nfs" = {
      device = "100.98.9.96:/mnt";
      fsType = "nfs";
      options = [
        "x-system.automount"
        "noauto"
      ];
    };
    "/mnt/Games (HDD)" = {
      device = "/dev/disk/by-uuid/8a6b2cd0-0d95-4a57-a8b0-b55661cdfa66";
      fsType = "ext4";
      options = [
        "users"
        "nofail"
        "exec"
      ];
    };
    "/mnt/Games (SSD)" = {
      device = "/dev/disk/by-uuid/b7168a0c-8645-4f7b-8aca-5392aa8b4ae0";
      fsType = "ext4";
      options = [
        "users"
        "nofail"
        "exec"
      ];
    };
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 50*1024;
      priority = 999;
    }
      # TODO: new swap drive for desktop
      # {
      #   device = "/dev/mmcblk0";
      #   priority = 10;
      # }
  ];

  hardware = {
    enableAllFirmware = true;
    uinput.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = (with pkgs; [
        libvdpau-va-gl
        libva-vdpau-driver
      ]);
    };
    steam-hardware.enable = true;
    cpu.amd.updateMicrocode = true;
  };

  # Bootloader
  boot = {
    kernelModules = [
      "kvm-amd"
      "uinput"
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      supportedFilesystems = [ "nfs" ];
      kernelModules = [ "nfs" ];
    };
    supportedFilesystems = [ "nfs" ];
    binfmt = {

      registrations = {
        go-src = {
          recognitionType = "extension";
          magicOrExtension = "go";
          interpreter = pkgs.writeShellScript "go-run" ''
            go run "$1" -- "$@"
          '';
          wrapInterpreterInShell = false;
          fixBinary = true;
        };
        zig-src = {
          recognitionType = "extension";
          magicOrExtension = "zig";
          interpreter = pkgs.writeShellScript "zig-run" ''
            zig run "$1" -- "$@"
          '';
          wrapInterpreterInShell = false;
          fixBinary = true;
        };
        c-src = {
          recognitionType = "extension";
          magicOrExtension = "c";
          interpreter = pkgs.writeShellScript "cc-run" ''
            out_file="/tmp/cc-run_$(${pkgs.coreutils}/bin/date '+%s_%N')"
            gcc -x c "$1" -o "$out_file" && $out_file "$@"
            rm $out_file
          '';
          wrapInterpreterInShell = false;
          fixBinary = true;
        };
      };

      #why not?
      emulatedSystems =
        builtins.filter (itm: itm != pkgs.stdenv.hostPlatform.system)
          options.boot.binfmt.emulatedSystems.type.nestedTypes.elemType.functor.payload.values;
    };
  };

  networking = {
    hostName = "keepernix";
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

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  security.rtkit.enable = true;

  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    udev = {
      packages = [ pkgs.steam ];
      extraRules = ''
        KERNEL=="uinput", GROUP="input", TAG+="uaccess"
      '';
    };
      # TODO: did I need this? (it suddenly broke)
      #avahi = {
      #  enable = true;
      #  nssmdns4 = true;
      #  openFirewall = true;
      #};
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
    kanata = {
      enable = true;
      keyboards.me_keyboard.config = /* clojure */ ''
        (defsrc
          caps lsft rsft lmet ralt
          z y
          1 2 3 4 5 6 7 8 9 0
          \ ` [ ]
          q w e r t u i o p a s d f g h j k l x c v b n m
        )

        (defalias
          ;;aliases that press shift and toggle number layer
          lshf_num (multi lsft (layer-toggle numbers))

          ;;super key
          sup (multi lmet (layer-toggle super-layer))
          altgr (layer-toggle altgr-layer)
        )

        ;;default layer
        (deflayer default
          ;;remap caps to esc and set shift and super keys to aliases
          esc @lshf_num @altgr @sup lalt

          y z ;;qwertz

          ;;swap shift layer of top-row numbers
          S-1 S-2 S-3 S-4 S-5 S-6 S-7 S-8 S-9 S-0

          S-\ ;;swap shift layer of pipe
          S-` S-[ S-]
          q w e r t u i o p a s d f g h j k l x c v b n m
        )

        ;;super key layer
        (deflayer super-layer
          _ _ _ (unmod lsft) _ _ _
          1 2 3 4 5 6 7 8 9 0
          _ _ _ _
          _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
        )

        ;;shift layer
        (deflayer numbers
          _ _ _ _ _ _ _ ;;leave these untouched

          ;;use unmodified key signals for anything modified
          (unmod 1) (unmod 2) (unmod 3) (unmod 4) (unmod 5)
          (unmod 6) (unmod 7) (unmod 8) (unmod 9) (unmod 0)
          (unmod \) (unmod `) (unmod [) (unmod ])

          _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
        )

        ;;altgr with Polish characters
        ;; TODO: capital Polish letters
        (deflayer altgr-layer
          _ _ _ _ _
          (unicode ż) (unicode ź)
          ;;use unmodified key signals for anything modified
          AG-1 AG-2 AG-3 AG-4 AG-5
          AG-6 AG-7 AG-8 AG-9 AG-0
          AG-\ AG-` AG-[ AG-]
          AG-q AG-w (unicode ę) AG-r AG-t AG-u
          AG-i (unicode ó) AG-p (unicode ą) (unicode ś) AG-d
          AG-f AG-g AG-h AG-j AG-k (unicode ł)
          AG-x (unicode ć) AG-v AG-b (unicode ń) AG-m
        )
      '';
    };
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
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
        "plugdev"
        "uinput"
        "kvm"
        "ydotool"
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

  systemd.services = {
    ydotoold = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      serviceConfig = let
        sock = "/run/ydotoold/socket";
        daemon = "${pkgs.ydotool}/bin/ydotoold";
      in {
        ExecStart = pkgs.lib.mkDefault "${daemon} --socket-path=${sock} --socket-perm=0660";
        Restart = "always";
      };
    };
  };

  programs = {
    ydotool.enable = true;
    hyprlock.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable =  true;
    };
    virt-manager.enable = true;

      # NOTE: may need for school again
      #  java = {
      #    enable = true;
      #  };

    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
      ];
    };

    firefox.enable = true;
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
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };
    tmux.enable = false; #utterly useless just use a scrolling tiling window manager
    dconf = {
      enable = true;
      profiles.user.databases = [
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
  };

  virtualisation = {
      #virtualbox = {
      #  host.enable = true;
      #};
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

  environment = {
    sessionVariables =
      let
        cc = pkgs.stdenv.cc;
      in {
        GOPATH = "/home/super/go";
        YDOTOOL_SOCKET = "/run/ydotoold/socket";
        WLR_NO_HARDWARE_CURSORS = "1";
        AQ_NO_ATOMIC = "1";
        WLR_DRM_NO_ATOMIC = "1";
        MOZ_WEBRENDER = "0";
        MANPAGER = "less";
        XDG_DATA_DIRS = [
          "$HOME/.local/share/flatpak/exports/share"
          "/var/lib/flatpak/exports/share"
          "${pkgs.gsettings-desktop-schemas}/share/gsettigs-schemas/${pkgs.gsettings-desktop-schemas.name}"
        ];
        MOZ_ACCELERATED = "0";

        LD_LIBRARY_PATH = "${cc.cc}/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${cc.version}";
        LIBRARY_PATH = [
          "${pkgs.mpfr.out}/lib"
          "${pkgs.gmp.out}/lib"
          "${pkgs.gtk4.out}/lib"
          "${pkgs.glibc.out}/lib"
          "${pkgs.curl.out}/lib"
        ];
        CPATH =
          let
            glibc = pkgs.glibc.dev;

            common_dir_includes = base: rest: (
              pkgs.lib.forEach rest (p: "${base}/${p}")
            );

            cc_includes =
              (common_dir_includes "${cc.cc}/include" [
                "c++/${cc.version}"
                "c++/${cc.version}/${pkgs.stdenv.hostPlatform.config}"
                "${cc.system}-linux-gnu"
              ]) ++ ([
                "${pkgs.mpfr.dev}/include"
                "${pkgs.gmp.dev}/include"
                "${pkgs.gtk4.dev}/include"
              ]);

            constructed_list = [ "${glibc}/include" ] ++ cc_includes;
          in
            constructed_list;
        AROCC_FLAGS = "-I${pkgs.glibc.dev}/include";
      };
    enableAllTerminfo = true;
    etc = import ./configs/etc.nix { pkgs = pkgs; config = config; };
    shellAliases = {
      "confine" = "nixGL firejail --quiet --netns=${secrets.vpn.wg.alt.provider}";
    };
  };

  system.activationScripts = import ./activation.nix { pkgs = pkgs; };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
