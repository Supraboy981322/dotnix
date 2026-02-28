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
  # standard packages
  home.packages = with pkgs; [
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
    kanata
    podman
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
    hyprpicker
    pkg-config
    clang-tools
    tree-sitter
    openssl.dev
    xorg.libX11
    tor-browser
    libglibutil
    virt-manager
    superTuxKart
    wl-clipboard
    brightnessctl
    cascadia-code
    prismlauncher
    netcat-openbsd
    signal-desktop
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

    # stuff my school forces me to use
    # TODO: delete as soon as possible
    chromium
    jetbrains.idea-community
    
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
