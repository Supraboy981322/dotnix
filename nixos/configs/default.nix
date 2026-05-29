{ ... }:
{
  imports = [
    #./hyprland.nix # NOTE: imported by home-manager
    ./shell.nix
    ./zen_confined.nix
    ./vim.nix
    ./emacs.nix
    #./fastfetch.nix # NOTE: imported by home-manager
    ./kmscon.nix
  ];
}
