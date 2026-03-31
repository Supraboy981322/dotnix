{ pkgs, inputs, nixpkgs-unstable, ... }:

# NOTE:
#  I have a lot of packages, so
#    I put them in a separate file

let
  unstable = import <nixos-unstable> {
    config = { allowUnfree = true; };
  };

  # fixes some graphical problems I have
  nixgl = import (
    builtins.fetchTarball
        "https://github.com/nix-community/nixGL/archive/main.tar.gz"
  ) { inherit pkgs; };

  # browsers preconfigured to my liking
  browsers = import ./browsers.nix;
in {
  # standard packages
  environment.systemPackages = (with pkgs; [#]) ++ (with nixpkgs-unstable; [
    go
    gh
    jq
    fd
    xz
    bc
    #zsh TODO: try this
    bat
    #vim
    gdm
    git
    SDL
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
    vala
    swww
    wofi
    nmap
    file
    zlib
    ruby
    iamb
    gimp
    mako
    glib
    nasm
    zpaq
    sdl3
    SDL2
    less
    gtk4
    libXi
    delta
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
    brave
    steam
    nitch
    #yt-dlp #installed via a home-manager script
    waybar
    brotli
    nodejs
    lutris
    gradle
    libgcc
    dialog
    xrandr
    sdlpop
    zenity
    libdrm
    libcap
    waybar
    docker
    espeak
    podman
    libX11
    gnutar
    libvirt
    freerdp
    udisks2
    ripgrep
    xdotool
    python3
    gparted
    gnumake
    wayland
    #busybox # switched to coreutils
    openvpn
    #ghostty # just discovered Alacritty's Vi mode, might switch back to Ghostty if they add it an equivalent
    qrencode
    prettier
    luarocks
    libglvnd
    obsidian
    hyprshot
    hyprland
    hyprlang
    iproute2
    zlib.dev
    inkscape
    libglvnd
    qemu_kvm
    coreutils
    html-tidy
    highlight
    html-tidy
    stdenv.cc
    spice-gtk
    glibc.dev
    libnotify
    nfs-utils
    hyprutils
    libXrandr
    sdbus-cpp
    hyprpaper
    playerctl
    libnotify
    libxcrypt
    alacritty
    fastfetch
    distrobox
    #signal-cli
    rpi-imager
    alsa-utils
    libX11.dev
    hyprpicker
    libXcursor
    pkg-config
    forgejo-cli
    clang-tools
    tree-sitter
    openssl.dev
    tor-browser
    libglibutil
    libXinerama
    virt-manager
    supertuxkart
    wl-clipboard
    libxkbcommon
    brightnessctl
    cascadia-code
    protonvpn-gui
    prismlauncher
    signal-desktop
    bibata-cursors
    discord-canary
    qt5.qtbase.dev
    proton-vpn-cli
    netcat-openbsd
    hyprpolkitagent
    mullvad-browser 
    element-desktop
    wireguard-tools
    github-linguist
    nodePackages.asar
    wayland-protocols
    hyprland-protocols
    hyprwayland-scanner
    lua52Packages.cjson
    lua52Packages.luasec
    gnome-system-monitor
    vala-language-server
    lua52Packages.luasocket
    nixgl.auto.nixGLDefault

    # stuff my school forces me to use
    # TODO: delete as soon as possible
    chromium
    jetbrains.idea-oss
    
    #stuff I prefer from KDE
    kdePackages.kate
    kdePackages.qtsvg
    kdePackages.dolphin
    kdePackages.gwenview
    kdePackages.kdenlive
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.kde-cli-tools

    # TODO: debug
    mesa
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
  ]) ++ [
    browsers.zen.re-wrapped
    browsers.firefox.re-wrapped
  ];
}
