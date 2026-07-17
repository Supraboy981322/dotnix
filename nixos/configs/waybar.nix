{
  part_1 = {
    position = "top";
    height = 26;
    cursor = false;
    layer = "top";
    margin-left = 10;
    margin-right = 10;
    margin-top = 2;
    reload_style_on_change = true;
    spacing = 0;
    border-radius = 25;

    battery = {
      format = "{capacity}% {icon}";
      format-charging = "{icon}";
      format-discharging = "{icon}";
      format-full = "󰂅";
      format-icons = {
        charging = [ "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅" ];
        default = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
      };
      format-plugged = "";
      interval = 5;
      states = {
        critical = 10;
        warning = 20;
      };
      tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
      tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
    };

    bluetooth = {
      format = "";
      format-connected = "󰂱";
      format-disabled = "󰂲";
      format-no-controller = "";
      tooltip-format = "Devices connected: {num_connections}";
    };

    "clock#time" = {
      format = "  {:%I:%M %p }";
      tooltip = false;
    };

    "clock#date" = {
      format = " {:%A | %B %e }";
      tooltip = true;
      tooltip-format = "<tt><small>{calendar}</small></tt>";
    };

    cpu = {
      format = "󰍛 {usage}%";
      interval = 2;
    };

    memory = {
      format = " {percentage}%";
      interval = 2;
      tooltip = true;
      tooltip-format = "total (GiB): {used} / {total} ({percentage}%)\nswap (GiB): {swapUsed} / {swapTotal} ({swapPercentage}%)";
    };

    "custom/bt" = {
      format = "";
    };

    "custom/lock" = {
      format = " ";
      on-click = "hyprlock";
      tooltip = false;
    };

    "custom/nixos" = {
      format = "";
    };

    "custom/separator#pipe" = {
      format = "|";
      interval = "once";
      tooltip = false;
    };

    "custom/separator#blank" = {
      format = " ";
      interval = "once";
      tooltip = false;
    };

    "group/ctl" = {
      modules = [
        "custom/separator#blank"
        "bluetooth"
        "network"
        "custom/separator#pipe"
        "pulseaudio"
        "custom/separator#pipe"
        "cpu"
        "custom/separator#pipe"
        "memory"
        #"battery"
      ];
      orientation = "inherit";
    };

    "wlr/taskbar" = {
      format = "{icon}";
      all-outputs = false;
      active-first = true;
      justify = "center";
      tooltip-format = "{name}";
      ignore-list = [ "wofi" ];
    };

    "hyprland/workspaces" = {
      format = "{icon}";
      format-icons = {
        active = "";
        default = "";
      };
      on-click = "activate";
      persistent-workspaces = {
        "1" = [ ];
        "2" = [ ];
        "3" = [ ];
        "4" = [ ];
        "5" = [ ];
      };
    };

    modules-center = [
      "wlr/taskbar"
    ];

    modules-left = [
      "custom/nixos"
      "hyprland/workspaces"
    ];

    modules-right = [
      "group/ctl"
      "clock#date"
      "clock#time"
    ];

    network = {
      format = "{icon}";
      format-disconnected = "󰤮";
      format-ethernet = "󰀂";
      format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
      format-wifi = "{icon}";
      interval = 3;
      spacing = 1;
      tooltip-format-disconnected = "Disconnected";
      tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
      tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      format-icons = {
        default = [ "" " " " " ];
      };
      format-muted = "";
      on-click-right = "pamixer -t";
      scroll-step = 5;
      tooltip-format = "Playing at {volume}%";
    };

    tray = {
      icon-size = 12;
      spacing = 4;
    };
  };
  part_2 = /*css */ ''
    @define-color background rgba(34, 36, 54, 0.6);
    @define-color foreground rgba(200, 230, 255, 0.7);

    * {
      color: @foreground;
      border: none;
      border-radius: 25;
      min-height: 0;
      font-family: 'JetBrainsMono Nerd Font';
      font-size: 12px;
    }

    .modules-left {
      margin-left: 8px;
    }

    .modules-right {
      margin-right: 8px;
    }

    window#waybar {
      background-color: @background;
      transition-property: background-color;
      transition-duration: .5s;
      margin: 0;
    }

    window#waybar.empty #window {
      background: transparent;
      background-color: transparent;
      border: none;
      border-radius: 0;
      color: transparent;
      padding: 0;
      margin: 0;
    }
    #waybar.empty .modules-center {
      opacity: 0;
    }

    #workspaces {
      padding: 0px 5px;
      margin: 3.5 3.5px;
      border-radius: 16px;
      background-color: alpha(@foreground, 0.1);
      opacity: 0.95;
    }

    #workspaces button {
      all: initial;
      padding: 0 6px;
      margin: 0 1.5px;
      min-width: 9px;
    }

    #workspaces button.empty {
      opacity: 0.5;
    }

    #cpu, #battery, #memory, #pulseaudio, #custom-power {
      min-width: 12px;
      margin: 0 7.5px;
    }

    #taskbar button.active {
      background: alpha(@foreground, 0.3);
    }
    #taskbar button:hover {
      background: alpha(@foreground, 0.1);
    }

    #tray {
      background:alpha(@foreground, 0.0);
      border-radius: 16px;
      padding: 0px 5px;
      margin: 3.5 2px;
      margin-right: 1px;
    }

    #bluetooth {
      margin-right: 8px;
    }

    #network {
      margin-right: 9px;
    }

    /*#custom-expand-icon {
      margin-right: 10px;
    }*/

    tooltip {
      background: @background;
      border: 1px solid @foreground;
    }
    tooltip label {
      color: white;
    }


    #custom-update {
      font-size: 10px;
    }

    .hidden {
      opacity: 0;
    }

    #custom-lock, #clock, #mpris {
      font-weight: 800;
      background:alpha(@foreground, 0.1);
      border-radius: 16px;
      padding: 0px 5px;
      margin: 3.5 3.5px;
    }

    #custom-nixos {
      border-radius: 99px;
      margin:3px;
      padding-right:5px;
      padding-left: 1px;
    }

    #window {
      font-weight: 800;
      background:alpha(@foreground, 0.1);
      border-radius: 16px;
      padding: 0px 5px;
      margin: 3.5 2px;
    }

    #group-ctl, #group_ctl, #ctl {
      font-weight: 800;
      background:alpha(@foreground, 0.1);
      border-radius: 16px;
      padding: 0px 5px;
      margin: 3.5 2px;
    }
  '';

  #part_1 = {
  #  layer = "top";
  #  position = "top";
  #  autohide = true;
  #  autohide-blocked = false;
  #  exclusive = true;
  #  passthrough = false;
  #  gtk-layer-shell = true;
  #  /* === Modules Order === */
  #  modules-left = [
  #    "cpu"
  #    "battery"
  #    "memory"
  #  #    "temperature"
  #    "custom/notif_mode"
  #    "pulseaudio/slider"
  #    "pulseaudio"
  #    #    "hyprland/language"
  #  ];
  #  modules-center = [
  #    "hyprland/workspaces"
  #  ];
  #  modules-right = [
  #    "wlr/taskbar"
  #    "custom/nix_icon"
  #    "custom/clock"
  #  ];
  #  /* === Modules Left === */
  #  "custom/nix_icon" = {
  #    format = "";
  #    on-click = "wofi --show drun";
  #    tooltip = false;
  #  };
  #  "custom/clock" = {
  #    format = "{}";
  #    return-type = "json";
  #    exec = "~/scripts/clock_icon";
  #    interval = 5;
  #  };
  #  cpu = {
  #    format = "{usage}% ";
  #    tooltip = true;
  #    tooltip-format = "CPU usage: {usage}%\nCores: {cores}";
  #  };
  #  memory = {
  #    format = "| {}% ";
  #    tooltip = true;
  #    tooltip-format = "RAM usage (GiB): {used} / {total} ({percentage}%)\nSwap usage (GiB): {swapUsed} / {swapTotal} ({swapPercentage}%)";
  #  };
  #  battery = {
  #    format = "| {capacity}% {icon} ";
  #    format-icons = [ "" "" "" "" "" ];
  #    format-time = "{H}h{M}m";
  #    format-charging = "| {capacity}% ";
  #    signal = 8;
  #    interval = 30;
  #  };
  #  temperature = {
  #    format = "{temperatureC}°C {icon}";
  #    tooltip = true;
  #    tooltip-format = "temp: {temperatureC}°C\nCritical > 80°C";
  #    format-icons = [ "" ];
  #  };
  #  /* === Modules Center === */
  #  "hyprland/workspaces" = {
  #    format = "{icon}";
  #    format-icons = {
  #      default = "";
  #      active = "";
  #    };
  #    persistent-workspaces = { "*" = 2; };
  #    disable-scroll = true;
  #    all-outputs = true;
  #    show-special = true;
  #  };
  #  /* === Modules Right === */
  #  "wlr/taskbar" = {
  #    layer = "bottom";
  #    format = "{icon}";
  #    all-outputs = true;
  #    active-first = true;
  #    tooltip-format = "{name}";
  #    on-click = "activate";
  #    on-click-middle = "close";
  #    on-click-right = "minimize";
  #    ignore-list = [ "wofi" ];
  #    rewrite = {
  #      Ghostty = "Terminal";
  #    };
  #  };
  #  "custom/notif_mode" = {
  #    format = "{}  | ";
  #    exec = "~/scripts/notif_mode_icon";
  #    exec-on-event = true;
  #    on-click = "makoctl mode -t dnd";
  #    interval = 1;
  #    return-type = "json";
  #  };
  #  "pulseaudio/slider" = {
  #    format = "{volume}%";
  #    format-muted = " MUTE";
  #    step = 5;
  #    tooltip = false;
  #  };
  #  pulseaudio = {
  #    format = "{volume}% {icon}";
  #    format-muted = " {format_source}";
  #    format-icons = {
  #      default = [ "" "" ];
  #    };
  #  };
  #  network = {
  #    format = "{ifname}";
  #    format-ethernet = "{ifname} 󰈀";
  #    format-disconnected = " ";
  #    tooltip-format = " {ifname} via {gwaddr}";
  #    tooltip-format-ethernet = " {ifname} {ipaddr}/{cidr}";
  #    tooltip-format-disconnected = "Disconnected";
  #    max-length = 50;
  #  };
  #  "hyprland/language" = {
  #    format = "{} ";
  #    on-click = "hyprctl switchxkblayout at-translated-set-2-keyboard next";
  #    format-en = "ENG";
  #    tooltip = true;
  #    tooltip-format = "language";
  #  };
  #};
  #part_2 = /* css */ ''
  #  /* ==== Global rules ==== */
  #  * {
  #    border: none;
  #    font-family: "JetbrainsMono Nerd Font";
  #    font-size: 15px;
  #    min-height: 10px;
  #  }

  #  window#waybar {
  #    background: rgba(34, 36, 54, 0.6);
  #  }

  #  window#waybar.hidden {
  #    opacity: 0.2;
  #  }

  #  /* ==== General rules for visible modules ==== */
  #  #custom-nix_icon, #custom-clock, #custom-calendar, #cpu, #memory,
  #  #disk, #battery, #custom-notif_mode, #pulseaudio,
  #  #pulseaudio-slider, #network, #language {
  #    color: #b0ceff;
  #    background: rgba(0, 0, 0, 0.5);
  #    margin-top: 6px;
  #    margin-bottom: 6px;
  #    padding-left: 10px;
  #    padding-right: 10px;
  #    transition: none;
  #  }

  #  /* Separation to the left */
  #  #custom-nix_icon, #cpu,
  #  #custom-notif_mode {
  #    margin-left: 5px;
  #    border-top-left-radius: 10px;
  #    border-bottom-left-radius: 10px;
  #  }

  #  /* Separation to the right */
  #  #custom-clock, #memory, #pulseaudio {
  #    margin-right: 5px;
  #    border-top-right-radius: 10px;
  #    border-bottom-right-radius: 10px;
  #  }

  #  /* == Specific styles == */

  #  /* Modules left */
  #  #custom-nix_icon {
  #    font-size: 24px;
  #    color: rgba(0, 0, 0, 0.85);
  #    margin-left: 0;
  #    background: #89B4FA;
  #    padding-right: 17px;
  #  }

  #  #custom-calendar {
  #    margin-right: 10px;
  #    border-top: solid 0.2em #89B4FA;
  #    border-right: solid 0.2em #89B4FA;
  #    border-bottom: solid 0.2em #89B4FA;
  #  }

  #  #custom-clock {
  #    margin-right: 6px;
  #    margin-left: 0;
  #    padding-left: 10px;
  #    border-right: solid 0.2em #89B4FA;
  #    border-left: solid 0.2em #89B4FA;
  #    border-top: solid 0.2em #89B4FA;
  #    border-bottom: solid 0.2em #89B4FA;
  #  }

  #  #cpu {
  #    padding-right: 5px;
  #    margin-left: 6px;
  #    border-top: solid 0.2em #89B4FA;
  #    border-left: solid 0.2em #89B4FA;
  #    border-bottom: solid 0.2em #89B4FA;
  #  }

  #  #memory {
  #    padding-right: 16px;
  #    padding-left: 5px;
  #    border-top: solid 0.2em #89B4FA;
  #    border-right: solid 0.2em #89B4FA;
  #    border-bottom: solid 0.2em #89B4FA;
  #  }

  #  #disk {
  #    background: #ffffff;
  #  }

  #  #battery {
  #    padding-left: 0;
  #    padding-right: 5px;
  #    border-top: solid 0.2em #89B4FA;
  #    border-bottom: solid 0.2em #89B4FA;
  #  }

  #  /* === Modules center === */
  #  #workspaces {
  #    background: rgba(0, 0, 0, 0.5);
  #    border: solid 0.2em #89B4FA;
  #    border-radius: 10px;
  #    margin: 8px 5px;
  #    padding: 0px 6px;
  #  }

  #  #workspaces button {
  #    color: #B5E8E0;
  #    background: transparent;
  #    padding: 4px 4px;
  #    transition: color 0.3s ease, text-shadow 0.3s ease, transform 0.3s ease;
  #  }

  #  #workspaces button.occupied {
  #    color: #A6E3A1;
  #  }

  #  #workspaces button.active {
  #    color: #89B4FA;
  #    text-shadow: 0 0 4px #ABE9B3;
  #  }

  #  #workspaces button:hover {
  #    color: #89B4FA;
  #  }

  #  #workspaces button.active:hover {}

  #  /* Modules right */
  #  #taskbar {
  #  /*  border: solid 0.2em #89B4FA;*/
  #    background: rgba(0, 0, 0, 0.5);
  #    border-radius: 10px 0px 0px 10px;
  #    padding: 0px;
  #    margin: 10px 5px;
  #    margin-right: -10px;
  #    padding-right: 13px;
  #  }

  #  #taskbar button {
  #    padding: 0px 5px;
  #    margin: 3px 0px 3px 3px;
  #    border-radius: 6px;
  #    transition: background 0.3s ease;
  #  }

  #  #taskbar button.active {
  #    background: rgba(134, 153, 247, 0.5);
  #  }

  #  #taskbar button:hover {
  #    background: rgba(34, 36, 54, 0.5);
  #  }

  #  #custom-notif_mode {
  #    padding-right: 0;
  #    border-top: solid 0.2em #89B4FA;
  #    border-left: solid 0.2em #89B4FA;
  #    border-bottom: solid 0.2em #89B4FA;
  #  }

  #  #pulseaudio {
  #    padding-right: 11px;
  #    min-width: 50px;
  #    border-top: solid 0.2em #89B4FA;
  #    border-bottom: solid 0.2em #89B4FA;
  #    padding-left: 0px;
  #    border-right: solid 0.2em #89B4FA;
  #  }

  #  #pulseaudio-slider {
  #    padding-left: 0;
  #    border-top: solid 0.2em #89B4FA;
  #    border-bottom: solid 0.2em #89B4FA;
  #    min-width: 50px;
  #  }

  #  #pulseaudio-slider slider {}


  #  #network {
  #    background: #8caaee;
  #    padding-right: 13px;
  #  }

  #  #language {
  #    padding-left: 0;
  #    border-top: solid 0.2em #89B4FA;
  #    border-right: solid 0.2em #89B4FA;
  #    border-bottom: solid 0.2em #89B4FA;
  #    padding-right: 13px;
  #    padding-left: 0;
  #  }

  #  /* === Optional animation === */
  #  @keyframes blink {
  #    to {
  #      background-color: #BF616A;
  #      color: #B5E8E0;
  #    }
  #  }
  #'';
}
