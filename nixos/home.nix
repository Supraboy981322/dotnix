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
      activation = {
        createDirs = /* bash */ ''
          mkdir -p "$HOME/IMG"
          ln -sfn "$HOME/Pictures/Screenshots" "$HOME/IMG/Screens"

          mkdir -p \
              "$HOME/machines" \
              "$HOME/tmp/moreTmp" \
              "$HOME/projects" \
              "$HOME/assignments"
        '';
        # fetches latest version of yt-dlp from GitHub (newer than nixpkgs unstable)
        get_latest_yt-dlp = /* bash */ ''
          ${pkgs.curl}/bin/curl -L \
              https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
              -o ~/scripts/yt-dlp
          chmod a+rx ~/scripts/yt-dlp
        '';
        # can't be bothered to make a flake for these
        install_unversioned_go_pkgs = /* bash */ ''
          export HOME="/home/super"
          export GOPATH="/home/super/go"
          export PATH=$PATH:${pkgs.gcc}/bin:${pkgs.busybox}/bin:${pkgs.go}/bin
          go_pkg_urls=(
            "github.com/Supraboy981322/d/src/d"
            "github.com/Supraboy981322/misc-scripts/dir_size"
            "github.com/Supraboy981322/misc-scripts/in_out"
            "github.com/Supraboy981322/misc-scripts/strip_ansi"
            "github.com/Supraboy981322/misc-scripts/bytes_to_human"
          )
          printf "installing go packages...\n" 1>&2
          for url in "''${go_pkg_urls[@]}"; do
            printf "\t%s\n" "$url" 1>&2
            go install $url@latest 2>&1 | sed 's/^/\t\t/g' 1>&2
          done
        '';
      };
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
        ".psh_rc" = {
          enable = true;
          source = ./configs/home/psh_rc;
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
