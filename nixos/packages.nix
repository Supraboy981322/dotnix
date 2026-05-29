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
    sd
    jq
    fd
    xz
    bc
    nh
    gdb
    bat
    tea
    gdm
    zig
    git
    SDL
    eza
    wev
    lua
    zip
    bun
    gcc
    vlc
    mpv
    wine
    wget
    vala
    awww
    mesa
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
    gleam
    cmake
    rustc
    cargo
    socat
    samba
    glibc
    loupe
    libva
    unzip
    sshfs
    meson
    xonsh
    hplip
    brave
    kitty
    nitch
    clang
    wine64
    waybar
    brotli
    nodejs
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
    openvpn
    discord
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
    rpi-imager
    alsa-utils
    libX11.dev
    hyprpicker
    libXcursor
    pkg-config
    proton-vpn
    pavucontrol
    forgejo-cli
    clang-tools
    tree-sitter
    openssl.dev
    tor-browser
    imagemagick
    libglibutil
    libXinerama
    virt-manager
    supertuxkart
    wl-clipboard
    libxkbcommon
    brightnessctl
    cascadia-code
    prismlauncher
    signal-desktop
    bibata-cursors
    coreutils-full
    qt5.qtbase.dev
    proton-vpn-cli
    netcat-openbsd
    hyprpolkitagent
    mullvad-browser 
    element-desktop
    wireguard-tools
    github-linguist
    wayland-protocols
    hyprland-protocols
    hyprwayland-scanner
    lua52Packages.cjson
    lua52Packages.luasec
    gnome-system-monitor
    vala-language-server
    lua52Packages.luasocket
    nixgl.auto.nixGLDefault
    wine64Packages.waylandFull
    wineWow64Packages.waylandFull

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
    #  lutris

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
  
  #services.flatpak = {
  #  enable = true;
  #  update.auto.enable = true;
  #  packages = [ "com.valvesoftware.Steam" ];
  #};
}
