{ pkgs, ... }:
let
  mainMod = "SUPER";
  vars = {
    terminal = "alacritty";
    fileManager = "dolphin";
    menu = "wofi --show drun --style /home/super/.config/hypr/wofi.css";
    personalBrowser = "nixGL zen --profile '/home/super/.zen/mainProfile'";
    schoolBrowser = "nixGL zen --profile '/home/super/.zen/schoolProfile'";
    chat = "signal-desktop";
    alternativeBrowser = "nixGL zen --profile /home/super/.zen/zs3f6ux8.viv";
    anotherBrowser = "nixGL zen --profile /home/super/.zen/x4qqcuev";
    torBrowser = "tor-browser";
    togWaybar = "/home/super/scripts/toggleWaybar.sh";
    noteProg = "obsidian";
    people_who_dont_use_signal = "discordcanary";
    org_mode_is_pretty_good = "/home/super/.config/emacs/bin/doom emacs";
    restart_waybar = "/home/super/scripts/restart_waybar.sh";
  };

  not_stupid_to_str = v:
    if (builtins.typeOf v) == "bool" then
      if v then "true" else "false"
    else
      toString v
    ;

  new_anonrule = attrset:
    builtins.concatStringsSep "," (
      builtins.map(name:
        "${name} ${not_stupid_to_str attrset.${name}}"
      ) (builtins.attrNames attrset)
    );

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

  repetative_binds = binds: 
    pkgs.lib.flatten (
      pkgs.lib.mapAttrsToList (dispatcher: bindings:
        let
          cleanBindings = builtins.removeAttrs bindings [ "mod" ];
        in
          pkgs.lib.mapAttrsToList (key: argument: {
            key = key;
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
  xdg.portal = {
    enable = true;
    config = {
      hyprland = {
        default = [ "hyprland" "gtk" ];
      };
    };
  };
  
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
    bind = builtins.map new_bind ([
      {
        key = "T";
        dispatcher = {
          name = "exec";
          args = vars.terminal;
        };
      }
      {
        key = "escape";
        dispatcher.name = "killactive";
      }
      {
        key = "M";
        dispatcher.name = "exit";
      }
      {
        key = "E";
        dispatcher = {
          name = "exec";
          args = vars.fileManager;
        };
      }
      {
        key = "C";
        dispatcher = {
          name = "exec";
          args = vars.chat;
        };
      }
      {
        key = "D";
        dispatcher = {
          name = "exec";
          args = vars.people_who_dont_use_signal;
        };
      }
      {
        key = "V";
        dispatcher.name = "togglefloating";
      }
      {
        key = "Space";
        dispatcher = {
          name = "exec";
          args = vars.menu;
        };
      }
      { # dwindle
        key = "P";
        dispatcher.name = "pseudo";
      }
      { # dwindle
        key = "J";
        dispatcher.name = "togglesplit";
      }
      {
        mod = "SHIFT";
        key = "F";
        dispatcher = {
          name = "exec";
          args = vars.schoolBrowser;
        };
      }
      {
        key = "F";
        dispatcher = {
          name = "exec";
          args = vars.personalBrowser;
        };
      }
      {
        key = "F";
        mod = "CTRL";
        dispatcher = {
          name = "exec";
          args = vars.anotherBrowser;
        };
      }
      {
        key = "F";
        mod = "ALT";
        dispatcher = {
          name = "exec";
          args = vars.alternativeBrowser;
        };
      }
      {
        key = "F";
        mod = "ALT SHIFT";
        dispatcher = {
          name = "exec";
          args = vars.torBrowser;
        };
      }
      {
        key = "L";
        dispatcher = {
          name = "exec";
          args = "loginctl lock-session";
        };
      }
      {
        key = "H";
        dispatcher = {
          name = "exec";
          args = "wpctl set-default 75";
        };
      }
      {
        key = "N";
        dispatcher = {
          name = "exec";
          args = vars.noteProg;
        };
      }
      {
        key = "E";
        mod = "SHIFT";
        dispatcher = {
          name = "exec";
          args = vars.org_mode_is_pretty_good;
        };
      }
      {
        key = "W";
        mod = "SHIFT";
        dispatcher = {
          name = "exec";
          args = vars.restart_waybar;
        };
      }
      {
        key = "R";
        mod = "SHIFT";
        dispatcher = {
          name = "exec";
          args = "~/scripts/re_start-hypr.sh";
        };
      }
      {
        key = "B";
        dispatcher = {
          name = "exec";
          args = vars.togWaybar;
        };
      }
      {
        key = "page_down";
        dispatcher = {
          name = "movetoworkspacesilent";
          args = 8;
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
      resizeactive = {
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

    general = {
      gaps_in = 5;
      gaps_out = 20;

      border_size = 2;

      # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";

      # Set to true enable resizing windows by clicking and dragging on borders and gaps
      resize_on_border = false;

      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      allow_tearing = false;

      #  layout = dwindle;
      layout = "scrolling";
    };
    
    decoration = {
      rounding = 10;
      rounding_power = 2;

      # Change transparency of focused and unfocused windows
      active_opacity = 1.0;
      inactive_opacity = 1.0;

      shadow = {
        enabled = true;
        range = 4;
        render_power = 3;
        color = "rgba(1a1a1aee)";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#blur
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
        vibrancy = 0.1696;
      };
    };

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
      force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
      disable_hyprland_logo = false;
    };

    # https://wiki.hyprland.org/Configuring/Variables/#input
    input = {
      kb_layout = "us";

      # NOTE: this is now handled by kanata
      # kb_options = "caps:swapescape";
    
      follow_mouse = 1;
      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

      touchpad = {
        natural_scroll = false;
      };
    };

    # Autostart necessary processes (like notifications daemons, status bars, etc.)
    exec-once = [
      "~/scripts/./start-hypr.sh"
    ];

    # See https://wiki.hyprland.org/Configuring/Environment-variables/
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
        "desc:LG Electronics LG ULTRAGEAR 209NTNH3L775, 1920x1080@144, 0x0, 1"
        "desc:Hewlett Packard HP w2207 3CQ82426KK, 1680x1050, 1920x-190, 1, transform, 1"
        ", preferred, auto, 1"
      ];
    };
  };
}
