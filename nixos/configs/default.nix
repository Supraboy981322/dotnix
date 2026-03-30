{ ... }:
{
  imports = [
    #./hyprland.nix # NOTE: imported by home-manager
    ./shell.nix
    ./zen_confined.nix
  ];
}
