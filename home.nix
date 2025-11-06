{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
  nix-alien-pkgs = import (
    builtins.fetchTarball "https://github.com/thiagokokada/nix-alien/tarball/master"
  ) { };
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.root = {
    home = {
      stateVersion = "18.09";
      file = {
        ".config/nvim" = {
      	  force = true;
      	  enable = true;
      	  recursive = true;
      	  source = ./configs/home/config/nvim;
      	};
      };
    };
  };

  home-manager.users.super = {
    home = {
      stateVersion = "18.09";
      packages = with nix-alien-pkgs; [
        nix-alien
      ];
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
      	".mkps1.sh" = {
      	  enable = true;
      	  executable = true;
      	  source = ./configs/home/mkps1.sh;
      	};
      	".profile" = {
      	  enable = true;
      	  source = ./configs/home/profile;
       	};
      };
    };
  };
}
