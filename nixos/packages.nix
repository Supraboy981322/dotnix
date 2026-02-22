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
    bat
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
    zpaq
    less
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
    yt-dlp
    brotli
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
    busybox
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
    qemu_kvm
    highlight
    html-tidy
    stdenv.cc
    spice-gtk
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
    libX11.dev
    hyprpicker
    pkg-config
    clang-tools
    tree-sitter
    openssl.dev
    tor-browser
    libglibutil
    virt-manager
    superTuxKart
    wl-clipboard
    brightnessctl
    cascadia-code
    protonvpn-gui
    prismlauncher
    signal-desktop
    bibata-cursors
    discord-canary
    qt5.qtbase.dev
    proton-vpn-cli
    hyprpolkitagent
    mullvad-browser 
    wireguard-tools
    github-linguist
    nodePackages.asar
    wayland-protocols
    hyprland-protocols
    hyprwayland-scanner
    lua52Packages.cjson
    lua52Packages.luasec
    gnome-system-monitor
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
  ]) ++ [
      browsers.zen.re-wrapped
      browsers.firefox.re-wrapped
    ];
}
