{ config, pkgs, ... }:

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
 
  imports = [
    ./files.nix
    # I have a lot of packages, so I
    #   import them from a separate file
    ./packages.nix
  ];

  home = {
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
