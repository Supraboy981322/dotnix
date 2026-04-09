{
  part_1 = {
    layer = "top";
    position = "top";
    autohide = true;
    autohide-blocked = false;
    exclusive = true;
    passthrough = false;
    gtk-layer-shell = true;
    /* === Modules Order === */
    modules-left = [
      "cpu"
      "battery"
      "memory"
    #    "temperature"
      "idle_inhibitor"
      "pulseaudio/slider"
      "pulseaudio"
      #    "hyprland/language"
    ];
    modules-center = [
      "hyprland/workspaces"
    ];
    modules-right = [
      "wlr/taskbar"
      "custom/debian_icon"
      "custom/clock"
    ];
    /* === Modules Left === */
    "custom/debian_icon" = {
      format = "";
      on-click = "wofi --show drun";
      tooltip = false;
    };
    "custom/clock" = {
#    timezone = "America/Chicago";
      #format = "{:%I:%M%p | %b %d}";
      format = "{}";
      exec = "date '+%I:%M%P | %b %d'";
      tooltip = true;
      tooltip-format = "{calendar}";
      interval = 5;
      calendar = {
        mode = "month";
      };
    };
    cpu = {
      format = "{usage}% ";
      tooltip = true;
      tooltip-format = "CPU usage: {usage}%\nCores: {cores}";
    };
    memory = {
      format = "| {}% ";
      tooltip = true;
      tooltip-format = "RAM usage (GiB): {used} / {total} ({percentage}%)\nSwap usage (GiB): {swapUsed} / {swapTotal} ({swapPercentage})%";
    };
    battery = {
      format = "| {capacity}% {icon} ";
      format-icons = [ "" "" "" "" "" ];
      format-time = "{H}h{M}m";
      format-charging = "| {capacity}% ";
      signal = 8;
      interval = 30;
    };
    temperature = {
      format = "{temperatureC}°C {icon}";
      tooltip = true;
      tooltip-format = "temp: {temperatureC}°C\nCritical > 80°C";
      format-icons = [ "" ];
    };
    /* === Modules Center === */
    "hyprland/workspaces" = {
      format = "{icon}";
      format-icons = {
        default = "";
        active = "";
      };
      persistent-workspaces = { "*" = 2; };
      disable-scroll = true;
      all-outputs = true;
      show-special = true;
    };
    /* === Modules Right === */
    "wlr/taskbar" = {
      layer = "bottom";
      format = "{icon}";
      all-outputs = true;
      active-first = true;
      tooltip-format = "{name}";
      on-click = "activate";
      on-click-middle = "close";
      on-click-right = "minimize";
      ignore-list = [ "wofi" ];
      rewrite = {
        Ghostty = "Terminal";
      };
    };
    idle_inhibitor = {
      format = "{icon}  | ";
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };
    "pulseaudio/slider" = {
      format = "{volume}%";
      format-muted = " MUTE";
      step = 5;
      tooltip = false;
    };
    pulseaudio = {
      format = "{volume}% {icon}";
      format-muted = " {format_source}";
      format-icons = {
        default = [ "" "" ];
      };
    };
    network = {
      format = "{ifname}";
      format-ethernet = "{ifname} 󰈀";
      format-disconnected = " ";
      tooltip-format = " {ifname} via {gwaddr}";
      tooltip-format-ethernet = " {ifname} {ipaddr}/{cidr}";
      tooltip-format-disconnected = "Disconnected";
      max-length = 50;
    };
    "hyprland/language" = {
      format = "{} ";
      on-click = "hyprctl switchxkblayout at-translated-set-2-keyboard next";
      format-en = "ENG";
      tooltip = true;
      tooltip-format = "language";
    };
  };
  part_2 = /* css */ ''
    /* ==== Global rules ==== */
    * {
      border: none;
      font-family: "JetbrainsMono Nerd Font";
      font-size: 10px;
      min-height: 6px;
    }

    window#waybar {
      background: rgba(34, 36, 54, 0.0);
      border-bottom: none;
      margin: 0;
      padding: 0;
    }

    window#waybar.hidden {
      opacity: 0.2;
    }

    /* ==== General rules for visible modules ==== */
    #custom-debian_icon, #custom-clock, #custom-calendar, #cpu, #memory,
    #disk, #battery, #idle_inhibitor, #pulseaudio,
    #pulseaudio-slider, #network, #language {
      color: #b0ceff;
      background: rgba(0, 0, 0, 0.75);
      margin-top: 6px;
      padding-left: 10px;
      padding-right: 10px;
      transition: none;
    }

    /* Separation to the left */
    #custom-debian_icon, #cpu,
    #idle_inhibitor {
      margin-left: 5px;
      border-top-left-radius: 10px;
      border-bottom-left-radius: 10px;
    }

    /* Separation to the right */
    #custom-clock, #memory, #pulseaudio {
      margin-right: 5px;
      border-top-right-radius: 10px;
      border-bottom-right-radius: 10px;
    }

    /* == Specific styles == */

    /* Modules left */
		#custom-debian_icon {
      font-size: 15px;
      color: rgba(0, 0, 0, 0.85);
      margin-left: 0;
      background: #89B4FA;
      padding-right: 17px;
    }

		#custom-calendar {
      margin-right: 10px;
      border-top: solid 0.2em #89B4FA;
      border-right: solid 0.2em #89B4FA;
      border-bottom: solid 0.2em #89B4FA;
    }

		#custom-clock {
      margin-right: 6px;
      margin-left: 0;
      padding-left: 10px;
      border-right: solid 0.2em #89B4FA;
      border-left: solid 0.2em #89B4FA;
      border-top: solid 0.2em #89B4FA;
      border-bottom: solid 0.2em #89B4FA;
    }

		#cpu {
      padding-right: 5px;
      margin-left: 6px;
      border-top: solid 0.2em #89B4FA;
      border-left: solid 0.2em #89B4FA;
      border-bottom: solid 0.2em #89B4FA;
    }

		#memory {
      padding-right: 16px;
      padding-left: 5px;
      border-top: solid 0.2em #89B4FA;
      border-right: solid 0.2em #89B4FA;
      border-bottom: solid 0.2em #89B4FA;
    }

		#disk {
      background: #ffffff;
    }

		#battery {
      padding-left: 0;
      padding-right: 5px;
      border-top: solid 0.2em #89B4FA;
      border-bottom: solid 0.2em #89B4FA;
    }

    /* === Modules center === */
		#workspaces {
      background: rgba(0, 0, 0, 0.5);
      border: solid 0.2em #89B4FA;
      border-radius: 10px;
      margin: 8px 5px 0px 5px;
      padding: 0px 6px;
    }

		#workspaces button {
      color: #B5E8E0;
      background: transparent;
      padding: 4px 4px;
      transition: color 0.3s ease, text-shadow 0.3s ease, transform 0.3s ease;
    }

		#workspaces button.occupied {
      color: #A6E3A1;
    }

		#workspaces button.active {
      color: #89B4FA;
      text-shadow: 0 0 4px #ABE9B3;
    }

		#workspaces button:hover {
      color: #89B4FA;
    }

		#workspaces button.active:hover {}

    /* Modules right */
		#taskbar {
    /*  border: solid 0.2em #89B4FA;*/
      background: rgba(0, 0, 0, 0.75);
      border-radius: 10px 0px 0px 10px;
      padding: 0px;
      margin: 10px 5px 0px 5px;
      margin-right: -10px;
      padding-right: 13px;
    }

		#taskbar button {
      padding: 0px 5px;
      margin: 3px 0px 0px 3px;
      border-radius: 6px;
      transition: background 0.3s ease;
    }

		#taskbar button.active {
      background: rgba(134, 153, 247, 0.75);
    }

		#taskbar button:hover {
      background: rgba(34, 36, 54, 0.75);
    }

		#idle_inhibitor {
      padding-right: 0;
      border-top: solid 0.2em #89B4FA;
      border-left: solid 0.2em #89B4FA;
      border-bottom: solid 0.2em #89B4FA;
    }

		#pulseaudio {
      padding-right: 11px;
      min-width: 50px;
      border-top: solid 0.2em #89B4FA;
      border-bottom: solid 0.2em #89B4FA;
      padding-left: 0px;
      border-right: solid 0.2em #89B4FA;
    }

		#pulseaudio-slider {
      padding-left: 0;
      border-top: solid 0.2em #89B4FA;
      border-bottom: solid 0.2em #89B4FA;
      min-width: 50px;
    }

		#pulseaudio-slider slider {}


		#network {
      background: #8caaee;
      padding-right: 13px;
    }

		#language {
      padding-left: 0;
      border-top: solid 0.2em #89B4FA;
      border-right: solid 0.2em #89B4FA;
      border-bottom: solid 0.2em #89B4FA;
      padding-right: 13px;
      padding-left: 0;
    }

    /* === Optional animation === */
    @keyframes blink {
      to {
        background-color: #BF616A;
        color: #B5E8E0;
      }
    }
  '';
}
