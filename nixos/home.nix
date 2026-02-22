{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";

  nix-alien-pkgs = import (builtins.fetchTarball
    "https://github.com/thiagokokada/nix-alien/tarball/master"
  ) { };
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

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

  home-manager.users.super = {
    home = {
      enableNixpkgsReleaseCheck = false;
      stateVersion = "18.09";
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
    xdg.configFile."fastfetch/config.jsonc".text = ''
      {
        "logo": {
          "source": "LFS",
          "color": {
            "1": "yellow",
            "2": "blue",
            "3": "red"
          }
        },
        "modules": [
          "title",
          "separator",
          {
              "type": "os",
              "key": "OS",
              "keyColor": "blue",
              "format": "no idea"
          },
          {
            "keyColor": "red",
            "type": "kernel",
            "key": "Kernel"
          },
          {
            "type": "memory",
            "key": "Memory",
            "keyColor": "green",
            "percent": {
                "type": 3,     // Show both percentage number and bar
                "green": 30,   // Values below 30% in green
                "yellow": 70   // 30-70% in yellow, >70% in red
            }
          },
          {
            "type": "uptime",
            "keyColor": "white",
            "format": "6 years, 350 days, 3 hours (PLEASE RESTART)"
          },
          {
            "type": "packages",
            "keyColor": "white",
            "format": "where the heck are your packages?"
          },
          {
            "type": "shell",
            "keyColor": "white"
          },
          {
            "type": "wm",
            "keyColor": "white",
            "format": "not entirely sure"
          },
          {
            "type": "icons",
            "keyColor": "white"
          },
          {
            "type": "font",
            "keyColor": "white"
          },
          {
            "type": "cursor",
            "keyColor": "white",
            "format": "i would never."
          },
          {
            "type": "terminal",
            "keyColor": "white",
            "format": "NeoVim?"
          },
          {
            "type": "terminalfont",
            "keyColor": "white",
            "format": "{name} (5,652,733pt, VERY SMALL)"
          },
          {
            "type": "cpu",
            "keyColor": "white",
            "key": "CPU 1"
          },
          {
            "type": "custom",
            "keyColor": "white",
            "key": "CPU 2-94",
            "format": "some sand"
          },
          {
            "type": "gpu",
            "keyColor": "white"
          },
          {
            "type": "custom",
            "keyColor": "white",
            "key": "GPU 3",
            "format": "2.56 pound of raw quartz"
          },
          {
            "type": "swap",
            "keyColor": "white"
          },
          {
            "type": "break",
            "keyColor": "white"
          },
          {
            "type": "colors"
          }
        ]
      }
    '';
  };
}
