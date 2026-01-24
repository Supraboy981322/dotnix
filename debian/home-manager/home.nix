{ config, pkgs, ... }:

let
  zen-browser = import (builtins.fetchTarball "https://github.com/youwen5/zen-browser-flake/archive/master.tar.gz") {
    inherit pkgs;
  };
in

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "super";
  home.homeDirectory = "/home/super";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  #home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  #];

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_:true);
    };
  };
  home = {
    packages = with pkgs; [
      #STABLE PKGS
      gh
      jq
      fd
      bc
      vim
      gdm
      git
      eza
      wev
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
      glibc
      loupe
      libva
      sshfs
      meson
      #clang
      hplip
      nitch
      dialog
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
      #      mesa.dev
      libglvnd
      obsidian
      hyprshot
      chromium #gross, I know, my school requires it
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
      alsa-utils
      hyprpicker
      openssl.dev
      xorg.libX11
      tor-browser
      libglibutil
      wl-clipboard
      brightnessctl
      bibata-cursors
      discord-canary
      ffmpeg.lib.dev
      xrandr
      qt5.qtbase.dev
      xorg.libX11.dev
      wayland-protocols
      hyprland-protocols
      hyprwayland-scanner
      gnome-system-monitor
      #javaPackages.openjfx23

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
      go
      lua
      zip
      bun
      gcc
      zig
      vlc
      mpv
      nasm
      #wine
      cmake
      rustc
      cargo
      socat
      samba
      emacs # might try this at some point
      nodejs
      #wine64
      lutris
      gradle
      libgcc
      #neovim
      ffmpeg-full
      busybox
      openvpn
      ghostty
      qrencode
      prettier
      luarocks
      tailscale
      distrobox
      signal-cli
      rpi-imager
      clang-tools
      tree-sitter
      superTuxKart
      prismlauncher
      signal-desktop
      mullvad-browser 
      zen-browser.default
      lua52Packages.cjson
      lua52Packages.luasec
      lua52Packages.luasocket
      #wine64Packages.waylandFull
      #wineWow64Packages.waylandFull

      # fonts
      noto-fonts-color-emoji
      fira-code
      nerd-fonts.fira-code
      nerd-fonts._0xproto
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      (pkgs.ffmpeg-full.override {
        withUnfree = true;
      })
    ];
    activation = {
      createScreensLink = ''
        mkdir -p "$HOME/IMG"
        ln -sfn "$HOME/Pictures/Screenshots" "$HOME/IMG/Screens"
      '';
    };
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 22;
    };
    file = {
      "machines" = {
        recursive = true;
        enable = true;
        force = true;
        source = ./configs/home/machines;
      };
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
    #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    #portalPackage = inputs.hyprland.pacakges.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  xdg.portal = {
    enable = true;
    #extraPortals = [ pkgs.xorg-desktop-portal-gtk ];
    config = {
      hyprland = {
        default = [ "hyprland" "gtk" ];
      };
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/super/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    NIXPKGS_ALLOW_UNFREE=1;
    PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/lib/x86_64-linux-gnu/pkgconfig/";
    CPATH="$CPATH:/usr/include:/usr/include/gtk-4.0";
  };

  # Let Home Manager install and manage itself.
  programs = { 
    home-manager.enable = true;
    #java = {
    #  enable = true;
    #  package = pkgs.jdk23.override {
    #    enableJavaFX = true;
    #  };
    #};
    firefox = {
      enable = true;
      #preferences = {
      #  # disable libadwaita theming for Firefox
      #  "widget.gtk.libadwaita-colors.enabled" = false;
      #};
    };
    chromium = {
      enable = false;
    };
    #nix-ld = {
    #  enable = true;
    #};
    #appimage = {
    #  enable = true;
    #  binfmt = true;
    #};
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    waybar = {
      enable = true;
    };
    #steam = {
    #  enable = true;
    #  remotePlay.openFirewall = true;
    #  dedicatedServer.openFirewall = true;
    #  localNetworkGameTransfers.openFirewall = true;
    #};
    tmux = {          #wanted to try-out tmux
      enable = false; #  suddenly don't have time
    };                #    may come back to this later
    #dconf.profiles.user.databases = [
    #  {
    #    settings."org/gnome/desktop/interface" = {
    #      gtk-theme = "Adwaita";
    #      icon-theme = "Flat-Remix-Red-Dark";
    #      font-name = "Noto Sans Medium 11";
    #      document-font-name = "Noto Sans Medium 11";
    #      monospace-font-name = "Noto Sans Mono Medium 11";
    #    };
    #  }
    #];
  };
}
