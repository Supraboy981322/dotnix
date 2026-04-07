{ pkgs, ... }:
let
  mainMod = "SUPER";

  #variables used directly in hyprland config
  #  (easier to find for changes when it's just in a table at the top)
  vars = {
    terminal = "alacritty";
    fileManager = "dolphin";
    menu = "wofi --show drun --style /home/super/.config/hypr/wofi.css";
    personalBrowser = "nixGL zen --profile '/home/super/.zen/mainProfile'";
    schoolBrowser = "nixGL zen --profile '/home/super/.zen/schoolProfile'";
    chat = "element-desktop";
    otherChat = "signal-desktop";
    alternativeBrowser = "nixGL zen --profile /home/super/.zen/zs3f6ux8.viv";
    anotherBrowser = "nixGL zen --profile /home/super/.zen/x4qqcuev";
    torBrowser = "tor-browser";
    togWaybar = "/home/super/scripts/toggleWaybar.sh";
    noteProg = "obsidian";
    people_who_dont_use_signal = "discordcanary";
    org_mode_is_pretty_good = "/home/super/.config/emacs/bin/doom emacs";
    restart_waybar = "/home/super/scripts/restart_waybar.sh";
    d_client = "/home/super/scripts/d_client";
  };

  #why the hell does 'builtins.toString' for a bool create an empty string for 'false'?
  not_stupid_to_str = v:
    if (builtins.typeOf v) == "bool" then
      if v then "true" else "false"
    else
      toString v
    ;

  #helper to create a new anonomous rule string
  new_anonrule = attrset:
    builtins.concatStringsSep "," (
      builtins.map(name:
        "${name} ${not_stupid_to_str attrset.${name}}"
      ) (builtins.attrNames attrset)
    );

  #helper to create a new keybind string
  new_bind = opts:
    let
      mod = "${mainMod}${if opts ? mod then " ${toString opts.mod}"  else ""}";
      dispatcher_args =
        if opts.dispatcher ? args then
          toString opts.dispatcher.args
        else 
          ""
        ;
    in
      "${mainMod}${mod}, ${opts.key}, ${opts.dispatcher."name"}, ${dispatcher_args}";

  #helper to repetative keybinds
  #  NOTE: usage:
  #   command = {
  #     mod = "[key]"; (optional)
  #     [key 1] = [arguments for key 1];
  #     [key 2] = [arguments for key 2];
  #     [...]
  #   };
  repetative_binds = binds: 
    pkgs.lib.flatten (
      pkgs.lib.mapAttrsToList (dispatcher: bindings:
        let
          cleanBindings = builtins.removeAttrs bindings [ "mod" ];
        in
          pkgs.lib.mapAttrsToList (key: argument: {
            key = key;
            mod = (if bindings ? mod then bindings.mod else null);
            dispatcher = {
              name = dispatcher;
              args = argument;
            };
          } // (
            if bindings ? mod then
              { mod = bindings.mod; }
            else
              { }
          )) cleanBindings
      ) binds);

in {

  # TODO: migrate additional hyprland stuff to Nix
  # programs = {
  #   waybar = {
  #     enable = true;
  #     systemd.enable = true;
  #     settings = [
  #       {
  #       }
  #     ];
  #   };
  # };

  xdg = 
    let
      waybar = import ./waybar.nix;
    in {
    #enable desktop portal and set hyprland to default
    portal = {
      enable = true;
      config = {
        hyprland = {
          default = [ "hyprland" "gtk" ];
        };
      };
    };

    #waybar part 1
    configFile."hypr/waybar.jsonc".text =  builtins.toJSON waybar.part_1;
    configFile."hypr/waybar.css".text = waybar.part_2;
    configFile."hypr/wofi.css".text = import ./wofi.nix;
  };

  services.hyprpaper = {
    enable = true;
    settings = {

      # NOTE: old config (hyprlang)
      #  #preload = /home/super/Pictures/themes/Formula_1_Tyre_Evolution_image.1.webp
      #  #wallpaper = eDP-1, /home/super/Pictures/themes/Formula_1_Tyre_Evolution_image.1.webp
      #  #splash = true
      #  #ipc = off
      #  wallpaper {
      #    monitor =
      #    path = ~/Pictures/themes/Formula_1_Tyre_Evolution_image.1.webp
      #    fit_mode = cover
      #  }

      wallpaper = [
        {
          monitor = "";
          path = "~/Pictures/themes/Formula_1_Tyre_Evolution_image.1.webp"; 
          fit_mode = "cover";
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      #keybinds (obviously, the most important part)
      bind = builtins.map new_bind ([
        {
          #terminal
          key = "T";
          dispatcher = {
            name = "exec";
            args = vars.terminal;
          };
        }
        {
          #lock the desktop
          key = "L";
          dispatcher = {
            name = "exec";
            args = "hyprlock";
          };
        }
        {
          #close current window
          key = "escape";
          dispatcher.name = "killactive";
        }
        {
          #exit Hyprland (to TTY)
          key = "M";
          dispatcher.name = "exit";
        }
        {
          #a small electron (gross) program I wrote for logging things
          key = "D";
          mod = "SHIFT";
          dispatcher = {
            name = "exec";
            args = vars.d_client;
          };
        }
        {
          #a graphical file manager (just in case I "need" one)
          key = "E";
          mod = "SHIFT";
          dispatcher = {
            name = "exec";
            args = vars.fileManager;
          };
        }
        {
          #Matrix (I run bridges to Discord and Signal)
          key = "C";
          dispatcher = {
            name = "exec";
            args = vars.chat;
          };
        }
        {
          #Signal
          key = "C";
          mod = "SHIFT";
          dispatcher = {
            name = "exec";
            args = vars.otherChat;
          };
        }
        {
          #Discord
          key = "D";
          dispatcher = {
            name = "exec";
            args = vars.people_who_dont_use_signal;
          };
        }
        {
          #screenshot
          key = "S";
          dispatcher = {
            name = "exec";
            args = "~/scripts/./screenshot.sh";
          };
        }
        {
          #region selection screenshot
          key = "S";
          mod = "SHIFT";
          dispatcher = {
            name = "exec";
            args = "~/scripts/./screenshot.sh select";
          };
        }
        {
          #toggle current window floating mode
          key = "V";
          dispatcher.name = "togglefloating";
        }
        {
          #script to kill and then re-start the script that's dispatched with 'exec-once'
          key = "R";
          mod = "SHIFT";
          dispatcher = {
            name = "exec";
            args = "~/scripts/re_start-hypr.sh";
          };
        }
        {
          #wofi
          key = "Space";
          dispatcher = {
            name = "exec";
            args = vars.menu;
          };
        }
        {
          #something with dwindle, forgot what 'pseudo' and can't be bothered to check
          #  (mostly here incase I decide to go back from scrolling)
          key = "P";
          dispatcher.name = "pseudo";
        }
        {
          #see "P"
          key = "J";
          dispatcher.name = "togglesplit";
        }
        {
          #school browser profile
          mod = "SHIFT";
          key = "F";
          dispatcher = {
            name = "exec";
            args = vars.schoolBrowser;
          };
        }
        {
          #personal (focused) browser profile
          key = "F";
          dispatcher = {
            name = "exec";
            args = vars.personalBrowser;
          };
        }
        {
          #personal (non-focused) browser profile
          key = "F";
          mod = "CTRL";
          dispatcher = {
            name = "exec";
            args = vars.anotherBrowser;
          };
        }
        {
          #this profile changes purpose on occasion,
          #  mostly used as for alternative YouTube recommendations
          key = "F";
          mod = "ALT";
          dispatcher = {
            name = "exec";
            args = vars.alternativeBrowser;
          };
        }
        {
          #for those links that you don't want to modify your algorithm
          key = "F";
          mod = "ALT SHIFT";
          dispatcher = {
            name = "exec";
            args = vars.torBrowser;
          };
        }
        {
          #I have no idea what this does
          key = "H";
          dispatcher = {
            name = "exec";
            args = "wpctl set-default 75";
          };
        }
        {
          #I forgot I have this, it's Obsidian at the moment, might remove it
          key = "N";
          dispatcher = {
            name = "exec";
            args = vars.noteProg;
          };
        }
        {
          #Emacs
          key = "E";
          dispatcher = {
            name = "exec";
            args = vars.org_mode_is_pretty_good;
          };
        }
        {
          # FIXME: no longer works
          key = "W";
          mod = "SHIFT";
          dispatcher = {
            name = "exec";
            args = vars.restart_waybar;
          };
        }
        {
          #toggles Waybar visibility
          key = "B";
          dispatcher = {
            name = "exec";
            args = vars.togWaybar;
          };
        }
        {
          #moves workspace to the 8th workspace without switching to it
          #  (mostly for when I "have" to have an IDE opened for school but I can just use NeoVim)
          key = "page_down";
          dispatcher = {
            name = "movetoworkspacesilent";
            args = 8;
          };
        }
        {
          #expands window to fill screen
          key = "E";
          mod = "CONTROL";
          dispatcher = {
            name = "layoutmsg";
            args = "colresize 1";
          };
        }
      ] ++ (repetative_binds {

        # switch windows
        movefocus = {
          left = "l";
          right = "r";
          up = "u";
          down = "d";
        };

        # Switch workspaces with mainMod + [0-9]
        workspace = builtins.listToAttrs (map (n:
          { "name" = (toString n); value = (toString n); }
        ) (pkgs.lib.lists.range 1 9)) // {
          "0" = "10";
        };

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        movetoworkspace = builtins.listToAttrs (map (n:
          { "name" = (toString n); value = (toString n); }
        ) (pkgs.lib.lists.range 1 9)) // {
          mod = "SHIFT";
          "0" = "10";
        };

        # Move active window around with mainMod + SHIFT + arrow-keys
        movewindow = {
          mod = "SHIFT";
          up = "u";
          left = "l";
          right = "r";
          down = "d";
        };

      }));

      binde = builtins.map new_bind (repetative_binds {
        #resize current window
        resizeactive = {
          mod = "CONTROL";
          down = "0 10";
          up = "0 -10";
          left = "-10 0";
          right = "10 0";
        };
      });

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];

      #media keys
      bindel = [
        # Laptop multimedia keys for volume and LCD brightness
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];
      bindl = [
        # Requires playerctl
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      #"general" (as opposed to?)
      general = {

        #window gaps (been thinking about reducing these)
        gaps_in = 5;
        gaps_out = 20;

        #border thickness (might decrease this too)
        border_size = 2;

        #window border colors;
        #  url included in default config (for some reason):
        #    https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        #  TODO: experiment with some other colors
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        #  layout = "dwindle"; # NOTE: this is what I was running previously, if I want to go back, set to this
        layout = "scrolling";
      };
      
      decoration = {
        # TODO: experiment with decreasing the radius
        rounding = 10;
        rounding_power = 2;

        # Change transparency of focused and unfocused windows
        #  ^~> NO
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        # TODO: shadow? where?
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        # TODO: THERE's A BLUR? on what?
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      #the most sane direction for tiling to scroll
      scrolling = {
        direction = "right";
      };

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true; 
        preserve_split = true;
      };

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master = {
        new_status = "master";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers (gladly)
        disable_hyprland_logo = false; # NOTE: when hyprpaper breaks, this is very helpful to have
      };

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        kb_layout = "us"; #?

        # NOTE: this is now handled by Kanata
        # kb_options = "caps:swapescape";
      
        follow_mouse = 1;
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification. TODO: figure out what *exactly* this does

        touchpad = {
          natural_scroll = false; #as opposed to?
        };
      };

      # Autostart necessary processes (like notifications daemons, status bars, etc.)
      exec-once = [
        "~/scripts/./start-hypr.sh" #remember that script I mentioned for that keybind from before?
        "discordcanary --start-minimized" # to make sure I don't miss anything
      ];

      # See https://wiki.hyprland.org/Configuring/Environment-variables/
      # TODO: what else can I put here? where are they visible?
      env = [
        "HYPRCURSOR_THEME,Bibata-Modern-Ice"
        "HYPRCURSOR_SIZE,12"
        "XCURSOR_THEME,Bibata-Modern-Ice"
        "XCURSOR_SIZE,12"
      ];

      # fixes cursor flickering and misalignment
      cursor = {
        no_hardware_cursors = true;
      };

      # See https://wiki.hyprland.org/Configuring/Permissions/
      # Please note permission changes here require a Hyprland restart and are not applied on-the-fly
      # for security reasons
      ecosystem = {
      #   enforce_permissions = 1;
        no_update_news = true;
      };

      windowrule = builtins.map new_anonrule [
        # Ignore maximize requests from apps. You'll probably like this.
        {
          "match:class" = ".*";
          suppress_event = "maxmize";
        }
        # Fix some dragging issues with XWayland
        {
          "match:class" = "^$";
          "match:title" = "^$";
          "match:xwayland" = true;
          "match:float" = true;
          "match:fullscreen" = true;
          "match:pin" = true;
          no_focus = true;
        }
      ];

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = [
        #primary desktop monitor (landscape, like a sane person)
        "desc:LG Electronics LG ULTRAGEAR 209NTNH3L775, 1920x1080@144, 0x0, 1"

        #secondary desktop monitor (portrait, I don't have the space for another landscape monitor)
        "desc:Hewlett Packard HP w2207 3CQ82426KK, 1680x1050, 1920x-190, 1, transform, 1"

        ", preferred, auto, 1"
      ];
      
      #gross, but nice when they're sped-up
      #   TODO: relearn what these mean
      animations = {
        enabled = "yes, please :)"; # why is this the syntax?

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };
    };
  };
}
