{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.root = {
    home = {
      stateVersion = "18.09";
      file = {
        ".config" = {
      	  force = true;
      	  enable = true;
      	  recursive = true;
      	  source = ./configs/config;
      	};
      	".bashrc" = {
      	  enable = true;
      	  source = ./configs/home/bashrc;
      	};
      	".mkps1.sh" = {
      	  executable = true;
      	  enable = true;
      	  source = ./configs/home/mkps1.sh;
      	};
      };
    };
  };

  home-manager.users.super = {
    programs.firefox = {
      enable = true;
    };
    home = {
      stateVersion = "18.09";
      file = {
        ".config" = {
      	  force = true;
          enable = true;
      	  recursive = true;
          source = ./configs/config;
      	};
      	".local" = {
      	  enable = true;
      	  recursive = true;
      	  source = ./configs/local;
      	};
      	"Pictures" = {
      	  enable = true;
      	  recursive = true;
      	  source = ./configs/Pictures;
      	};
      	".bashrc" = {
      	  enable = true;
      	  source = ./configs/home/bashrc;
      	};
      	".mkps1.sh" = {
      	  executable = true;
      	  enable = true;
      	  source = ./configs/home/mkps1.sh;
      	};
      	".profile" = {
      	  enable = true;
      	  source = ./configs/home/profile;
      	};
        "zen-mods-export.json" = {
          enable = true;
          source = ./configs/home/zen-mods-export.json;
        };
      };
    };
    #rest of home-manager config
  };
}
