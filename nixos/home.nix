{ inputs, config, pkgs, home-manager, ... }:
let
  nix-alien-pkgs = import (builtins.fetchTarball
    "https://github.com/thiagokokada/nix-alien/tarball/master"
  ) { };
  secrets = import ./secrets.nix;
in {
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
        enable = true;
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 22;
      };
      file = {
        mnt = {
          source = config.lib.file.mkOutOfStoreSymlink /mnt;
        };
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
        ".config/hypr/stubs" = {
          enable = true;
          force = true;
          recursive = true;
          source = "${pkgs.hyprland}/share/hypr/stubs";
        };
        ".config/prog_launcher.rc" = {
          enable = true;
          force = true;
          source = pkgs.writeText "prog_launcher.rc" ''
            colorscheme (these are the default colors, but you can put whatever (valid) hex codes)
             colors
              window color
              bg #0f1528ee

              primary color
              fg #fff

              input box and modeline
              bar #ffffffac

              highlighted list entry colors
              hl_bg #afafafac
              hl_fg #0f0f2fff
            }

            prefix added when executing command
            exec prefix nixGL }

            what type of messages are logged (defaults to everything)
            log
              debug
              info
              warn
            ]

            override startup mode (defaults to normal)
            start mode insert }

            filter for program list
            blacklist ${builtins.concatStringsSep "\n" secrets.filters.prog_launcher} ]
          '';
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

              new_ident = { file, alias, host ? "${alias}.com" }: ''
                Host ${alias}
                  HostName ${host}
                  User git
                  IdentityFile ${file}
              '';
              white_list = [
                "::1"
                "127.0.0.1"
                "seizure"
                "localhost"
              ];
            in
              pkgs.writeText "ssh_config" (builtins.concatStringsSep "\n" (
                (builtins.map white_list_host white_list)
                ++
                (builtins.map new_ident secrets.accounts.git.ssh_keys)
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
              nixGL firefox --profile ~/.config/mozilla/firefox/'AA9rSOKT.Profile 1'
              #nixGL \
              #   zen \
              #     --profile "/home/super/.zen/mainProfile"
            fi
          '';
        };
      };
    };
  }/*;
}*/
