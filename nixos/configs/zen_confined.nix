{ config, pkgs, lib, inputs, options, ... }:
let secrets = import ../secrets.nix; in { 
  programs.firejail.enable = true;
  environment.shellAliases = {
    zen_confined = "nixGL firejail --netns=${secrets.vpn.wg.alt.provider} zen";
  };
  vpnNamespaces.${secrets.vpn.wg.alt.provider} = {
    enable = true;
    wireguardConfigFile = secrets.vpn.wg.alt.conf_path;
  };
}
