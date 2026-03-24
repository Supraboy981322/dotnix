{ inputs, config, pkgs, home-manager, ... }:
let
  nix-alien-pkgs = import (builtins.fetchTarball
    "https://github.com/thiagokokada/nix-alien/tarball/master"
  ) { };
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
          )
          printf "installing go packages...\n" 1>&2
          for url in "''${go_pkg_urls[@]}"; do 
            printf "\t%s\n" "$url" 1>&2
            go install $url@latest 2>&1 | sed 's/^/\t   /g' 1>&2
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
      };
    };

    # hath ye been bamboozled?
    xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON {
      logo = {
        source = "LFS"; # neat logo
        color = {
          "1" = "yellow";
          "2" = "blue";
          "3" = "red";
        };
      };
      modules = [
        "title"
        "separator"
        {
          type = "os";
          key = "OS";
          keyColor = "blue";
          format = "no idea";
        }
        {
          keyColor = "red";
          type = "kernel";
          key = "Kernel";
        }
        {
          type = "memory";
          key = "Memory";
          keyColor = "green";
          percent = {
            type = 3;
            green = 30;
            yellow = 70;
          };
        }
        {
          type = "uptime";
          keyColor = "white";
          format = "6 years, 350 days, 3 hours (PLEASE RESTART)";
        }
        {
          type = "packages";
          keyColor = "white";
          format = "where the heck are your packages?";
        }
        {
          type = "shell";
          keyColor = "white";
        }
        {
          type = "wm";
          keyColor = "white";
          format = "not entirely sure";
        }
        {
          type = "icons";
          keyColor = "white";
        }
        {
          type = "font";
          keyColor = "white";
        }
        {
          type = "cursor";
          keyColor = "white";
          format = "i would never.";
        }
        {
          type = "terminal";
          keyColor = "white";
          format = "NeoVim?";
        }
        {
          type = "terminalfont";
          keyColor = "white";
          format = "{name} (5,652,733pt, VERY SMALL)";
        }
        {
          type = "cpu";
          keyColor = "white";
          key = "CPU 1";
        }
        {
          type = "custom";
          keyColor = "white";
          key = "CPU 2-94";
          format = "some sand";
        }
        {
          type = "gpu";
          keyColor = "white";
        }
        {
          type = "custom";
          keyColor = "white";
          key = "GPU 3";
          format = "2.56 pound of raw quartz";
        }
        {
          type = "swap";
          keyColor = "white";
        }
        {
          type = "break";
          keyColor = "white";
        }
      ];
    };
  }/*;
}*/
