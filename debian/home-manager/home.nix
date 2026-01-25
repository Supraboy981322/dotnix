{ config, pkgs, ... }:

let
  # my web browser of choice is not in NixPKGs
  zen-browser = import (
    builtins.fetchTarball
        "https://github.com/youwen5/zen-browser-flake/archive/master.tar.gz"
  ) { inherit pkgs; };

  # fixes some graphical problems I have
  nixgl = import (
    builtins.fetchTarball
        "https://github.com/nix-community/nixGL/archive/main.tar.gz"
  ) { inherit pkgs; };
in

{
  home.username = "super"; # long story
  home.homeDirectory = "/home/super";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # prefered default font for the strange
  #  and slightly annoying emoji thing that
  #    some people (and AI) do
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  
  # I need several non-open packages for school,
  #  it's easier to just add them to the list with
  #    the rest of my packages and mark them as "for school"
  #      so I can remove them later
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_:true);
    };
  };

  home = {
    packages = with pkgs; [

      #UNSTABLE PKGS
      go
      gh
      jq
      fd
      bc
      vim
      gdm
      git
      eza
      wev
      lua
      zip
      bun
      gcc
      zig
      vlc
      mpv
      jdk
      wget
      swww
      wofi
      nmap
      file
      zlib
      ruby
      gimp
      mako
      glib
      nasm
      cmake
      rustc
      cargo
      socat
      samba
      emacs # might try this at some point
      glibc
      loupe
      libva
      sshfs
      meson
      hplip
      nitch
      nodejs
      lutris
      gradle
      libgcc
      dialog
      xrandr
      yt-dlp
      zenity
      libdrm
      libcap
      waybar
      docker
      espeak
      podman
      freerdp
      udisks2
      ripgrep
      xdotool
      python3
      gparted
      gnumake
      busybox
      openvpn
      ghostty
      qrencode
      prettier
      luarocks
      libglvnd
      obsidian
      hyprshot
      chromium #gross, I know, my school requires it;  TODO: delete it
      hyprland
      hyprlang
      iproute2
      zlib.dev
      html-tidy
      stdenv.cc
      glibc.dev
      libnotify
      nfs-utils
      hyprutils
      sdbus-cpp
      hyprpaper
      playerctl
      libnotify
      libxcrypt
      fastfetch
      distrobox
      signal-cli
      rpi-imager
      alsa-utils
      hyprpicker
      clang-tools
      tree-sitter
      openssl.dev
      xorg.libX11
      tor-browser
      libglibutil
      superTuxKart
      wl-clipboard
      brightnessctl
      prismlauncher
      signal-desktop
      bibata-cursors
      discord-canary
      qt5.qtbase.dev
      xorg.libX11.dev
      mullvad-browser 
      wayland-protocols
      hyprland-protocols
      hyprwayland-scanner
      zen-browser.default
      lua52Packages.cjson
      lua52Packages.luasec
      gnome-system-monitor
      lua52Packages.luasocket
      nixgl.auto.nixGLDefault

      #stuff I prefer from KDE
      kdePackages.kate
      kdePackages.qtsvg
      kdePackages.dolphin
      kdePackages.konsole
      kdePackages.gwenview
      kdePackages.kio-fuse
      kdePackages.kio-extras
      kdePackages.kde-cli-tools

      # TODO: debug
      #  mesa.dev
      #  wine
      #  wine64
      #  wine64Packages.waylandFull
      #  wineWow64Packages.waylandFull
      #  javaPackages.openjfx23
      #  clang

      # fonts
      noto-fonts-color-emoji
      fira-code
      nerd-fonts.fira-code
      nerd-fonts._0xproto
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only

      # "overrides"
      (pkgs.ffmpeg-full.override {
        withUnfree = true;
      })
    ];

    # create some directories I use a lot 
    activation = {
      createScreensLink = ''
        mkdir -p "$HOME/IMG"
        ln -sfn "$HOME/Pictures/Screenshots" "$HOME/IMG/Screens"

        mkdir -p \
            "$HOME/machines" \
            "$HOME/tmp/moreTmp" \
            "$HOME/projects" \
            "$HOME/assignments"
      '';
    };

    # the default cursor os gross
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 22;
    };

    # various directories and dotfiles
    file = {
      "scripts" = {
        source = ./scripts;
        force = true;
        enable = true;
        recursive = true;
        executable = true;
      };
      ".gtkrc-2.0" = {
        force = true;
        enable = true;
        source = ./configs/home/gtkrc-2.0;
      };
      ".config" = {
        force = true;
        enable = true;
        recursive = true;
        source = ./configs/home/config;
      };
      ".local" = {
        enable = true;
        recursive = true;
        source = ./configs/home/local;
      };
      "Pictures" = {
        enable = true;
        recursive = true;
        source = ./configs/home/Pictures;
      };
      ".bashrc" = {
        enable = true;
        source = ./configs/home/bashrc;
      };
      ".profile" = {
        enable = true;
        source = ./configs/home/profile;
      };
      ".psh_rc" = {
        enable = true;
        source = ./configs/home/psh_rc;
      };
    };
  };
  
  wayland.windowManager.hyprland = { 
    enable = true;
  };

  xdg.portal = {
    enable = true;
    config = {
      hyprland = {
        default = [ "hyprland" "gtk" ];
      };
    };
  };

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = 1;
    PKG_CONFIG_PATH = "$PKG_CONFIG_PATH:/usr/lib/x86_64-linux-gnu/pkgconfig/";
    CPATH = "$CPATH:/usr/include:/usr/include/gtk-4.0";

    WLR_NO_HARDWARE_CURSORS = 1;
  };

  programs = { 
    home-manager.enable = true;

    # browsers
    chromium.enable = false; # for school;  TODO: delete it
    firefox.enable = true;

    waybar.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
    };
    tmux = {          #wanted to try-out tmux
      enable = false; #  suddenly don't have time
    };                #    may come back to this later

    # TODO: debug
    #  nix-ld.enable = true;
    #  appimage = {
    #    enable = true;
    #    binfmt = true;
    #  };
    #  java = {
    #    enable = true;
    #    package = pkgs.jdk23.override {
    #      enableJavaFX = true;
    #    };
    #  };
    #  steam = {
    #    enable = true;
    #    remotePlay.openFirewall = true;
    #    dedicatedServer.openFirewall = true;
    #    localNetworkGameTransfers.openFirewall = true;
    #  };
    #  dconf.profiles.user.databases = [
    #    {
    #      settings."org/gnome/desktop/interface" = {
    #        gtk-theme = "Adwaita";
    #        icon-theme = "Flat-Remix-Red-Dark";
    #        font-name = "Noto Sans Medium 11";
    #        document-font-name = "Noto Sans Medium 11";
    #        monospace-font-name = "Noto Sans Mono Medium 11";
    #      };
    #    }
    #  ];
  };
}
