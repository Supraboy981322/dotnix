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
  environment.systemPackages = (with pkgs; [
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
    zls
    lua
    zip
    bun
    gcc
    vlc
    mpv
    gmp

    mame
    cc65
    mgba
    wine
    eden
    mpfr
    odin
    wget
    fasm
    vala
    btop
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
    mesen
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

    stella
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
    stdenv
    gnutar

    ataripp
    libvirt
    freerdp
    udiskie
    udisks2
    ripgrep
    xdotool
    python3
    gparted
    gnumake
    wayland
    openvpn
    ryubing
    discord

    usbutils
    qrencode
    prettier
    luarocks
    libglvnd
    obsidian
    hyprshot
    hyprland
    hyprlang
    iproute2
    curl.dev
    zlib.dev
    inkscape
    libglvnd
    qemu_kvm
    quickemu

    fira-code
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

    galculator
    rpi-imager
    alsa-utils
    libX11.dev
    hyprpicker
    libXcursor
    pkg-config
    proton-vpn

    pavucontrol
    protonup-qt
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
    glibc.static
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

    kdePackages.kate

    kdePackages.qtsvg
    wayland-protocols

    adwaita-icon-theme
    hyprland-protocols

    nerd-fonts._0xproto
    kdePackages.dolphin
    hyprwayland-scanner
    lua52Packages.cjson
    lua51Packages.cjson

    nerd-fonts.fira-code
    lua52Packages.luasec
    gnome-system-monitor
    vala-language-server
    kdePackages.gwenview
    kdePackages.kdenlive
    kdePackages.kio-fuse

    kdePackages.kio-extras
    noto-fonts-color-emoji

    nerd-fonts.symbols-only
    coreboot-toolchain.i386
    lua52Packages.luasocket
    nixgl.auto.nixGLDefault

    kdePackages.kde-cli-tools
    nerd-fonts.jetbrains-mono
    gsettings-desktop-schemas

    nerd-fonts.droid-sans-mono
    wine64Packages.waylandFull

    wineWow64Packages.waylandFull


    # "overrides"
    (pkgs.ffmpeg-full.override {
      withUnfree = true;
    })

    (pkgs.lutris.override  {
      extraLibraries = pkgs: [ ];
      extraPkgs = pkgs: [ ];
    })

  ]) ++ [
    browsers.zen.re-wrapped
    browsers.firefox.re-wrapped

    inputs.intInfo.packages.${builtins.currentSystem}.default
  ];

  #services.flatpak = {
  #  enable = true;
  #  update.auto.enable = true;
  #  packages = [ "com.valvesoftware.Steam" ];
  #};
}
