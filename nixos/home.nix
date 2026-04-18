{ inputs, config, pkgs, home-manager, ... }:
let
  nix-alien-pkgs = import (builtins.fetchTarball
    "https://github.com/thiagokokada/nix-alien/tarball/master"
  ) { };
  secrets = import ./secrets.nix;
in /*{

  home-manager.users.root = {
    home = {
      enableNixpkgsReleaseCheck = false;
      stateVersion = "18.09";
      file = {
        ".bashrc" = {
      	  enable = true;
      	  source = ./configs/root/bashrc;
      	};
        ".config/nvim" = {
      	  force = true;
      	  enable = true;
      	  recursive = true;
      	  source = ./configs/home/config/nvim;
      	};
      };
    };
  };

  home-manager.users.super = */{
    imports = [
      ./configs/hyprland.nix
      ./configs/fastfetch.nix
    ];
    home = {
      enableNixpkgsReleaseCheck = false;
      stateVersion = "18.09";
      activation = import ./activation.nix { pkgs = pkgs; };
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
        ".ssh/config" = {
          enable = true;
          source = 
            let
              white_list_host = name: ''
                Host ${name}
                  UserKnownHostsFile /dev/null
                  StrictHostKeyChecking no
                  LogLevel ERROR
              '';
              white_list = [
                "::1"
                "127.0.0.1"
                "seizure"
                "localhost"
              ];
            in
              pkgs.writeText "ssh_config" (builtins.concatStringsSep "\n" (
                builtins.map white_list_host white_list
              ));
        };
      	".profile" = {
      	  enable = true;
      	  source = ./configs/home/profile;
       	};
        ".p_shrc" = {
          enable = true;
          text = import ./configs/p_sh.nix { pkgs = pkgs; };
        };
        "scripts/browser.sh" = {
          enable = true;
          source = pkgs.writeShellScript "browser.sh" /* bash */ ''
            being_watched() {
              makoctl mode \
                | grep 'dnd' &>/dev/null
            }

            if being_watched; then
              nixGL \
                firejail \
                  --netns=${secrets.vpn.wg.alt.provider} \
                zen \
                  --profile "/home/super/.zen/confined_profile"
            else
              nixGL \
                zen \
                  --profile "/home/super/.zen/mainProfile"
            fi
          '';
        };
      };
    };
  }/*;
}*/
