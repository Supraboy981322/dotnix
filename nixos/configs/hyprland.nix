{ config, pkgs, ... }:
let
  mainMod = "SUPER";
  secrets = import ../secrets.nix;
  zen = "nixGL zen --profile";
  home_dir = "/home/super";
  vars = {
    zen_confined = "nixGL firejail --netns=${secrets.vpn.wg.alt.provider} zen --profile";
    terminal = "alacritty";
    fileManager = "dolphin";
    menu = "wofi --show drun --style ${home_dir}/.config/hypr/wofi.css";
    #personalBrowser = "${zen} '${home_dir}/.zen/mainProfile'";
    personalBrowser = "${home_dir}/scripts/browser.sh";
    schoolBrowser = "${zen} '${home_dir}/.zen/schoolProfile'";
    chat = "element-desktop";
    otherChat = "signal-desktop";
    alternativeBrowser = "${zen} ${home_dir}/.zen/zs3f6ux8.viv";
    anotherBrowser = "${zen} ${home_dir}/.zen/x4qqcuev";
    torBrowser = "tor-browser";
    togWaybar = "${home_dir}/scripts/toggleWaybar.sh";
    noteProg = "obsidian";
    people_who_dont_use_signal = "discord";
    org_mode_is_pretty_good = "emacs";
    restart_waybar = "${home_dir}/scripts/restart_waybar.sh";
    d_client = "${home_dir}/.bin/d_client";
    do_not_disturb = "makoctl mode -t dnd";
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
  home.packages = with pkgs; [ lua54Packages.cjson ];
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''--foo''; #silences a Nix warning
    configType = "lua";
  };
}
