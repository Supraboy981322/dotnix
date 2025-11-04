{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    git
    gh
    curl
    jq
    tailscale
  ];
  system.activationScripts.setupScript = {
    text = builtins.readFile ./scripts/setup.sh;
  };
}
