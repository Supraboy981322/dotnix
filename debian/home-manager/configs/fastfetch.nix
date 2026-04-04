{ ... }:

# hath ye been bamboozled?

{
  xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON {
    logo = {
      source = "LFS";
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
           type = 3;     # Show both percentage number and bar
           green = 30;   # Values below 30% in green
           yellow = 70;  # 30-70% in yellow, >70% in red
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
        format = "{name} (5;652,733pt, VERY SMALL)";
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
      {
        type = "colors";
      }
    ];
  };

}
