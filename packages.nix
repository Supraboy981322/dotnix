{ pkgs, ... }:

# NOTE:
#  I have a lot of packages, so
#    I put them in a separate file

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
  home.packages = with pkgs; [
    # unstable pkgs
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
    inkscape
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
    alacritty
    fastfetch
    distrobox
    #signal-cli
    rpi-imager
    alsa-utils
    hyprpicker
    pkg-config
    clang-tools
    tree-sitter
    openssl.dev
    xorg.libX11
    tor-browser
    libglibutil
    superTuxKart
    wl-clipboard
    brightnessctl
    cascadia-code
    prismlauncher
    #signal-desktop #reinstalled manually so I can modify it 
    bibata-cursors
    discord-canary
    qt5.qtbase.dev
    xorg.libX11.dev
    mullvad-browser 
    github-linguist
    nodePackages.asar
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
}
