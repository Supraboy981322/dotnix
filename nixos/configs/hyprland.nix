{ config, pkgs, ... }:
let
  mainMod = "SUPER";
  secrets = import ../secrets.nix;
  zen = "nixGL zen --profile";
  home_dir = "/home/super";
  waybar = import ./waybar.nix { pkgs = pkgs; };
in {

  xdg = {
    portal = {
      enable = true;
      config.hyprland.default = [ "hyprland" "gtk" ];
    };
    configFile = {
      "hypr/waybar.jsonc".text =  builtins.toJSON waybar.part_1;
      "hypr/waybar.css".text = waybar.part_2;
      "hypr/wofi.css".text = import ./wofi.nix;
    };
  };

  services.hyprpaper = {
    enable = true;
    settings.wallpaper = [{
      monitor = "";
      path = "~/Pictures/themes/Formula_1_Tyre_Evolution_image.1.webp"; 
      fit_mode = "cover";
    }];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''--foo''; #silences a Nix warning
    configType = "lua";
  };
}
