{ ... }:

# various directories and dotfiles

{
  home.file = {
    "scripts" = {
      source = ./scripts;
      force = true;
      enable = true;
      recursive = true;
      executable = true;
    };
    ".gtkrc-2.0" = {
      force = true;
      enable = true;
      source = ./configs/home/gtkrc-2.0;
    };
    ".config" = {
      force = true;
      enable = true;
      recursive = true;
      source = ./configs/home/config;
    };
    ".local" = {
      enable = true;
      recursive = true;
      source = ./configs/home/local;
    };
    "Pictures" = {
      enable = true;
      recursive = true;
      source = ./configs/home/Pictures;
    };
    ".bashrc" = {
      enable = true;
      source = ./configs/home/bashrc;
    };
    ".profile" = {
      enable = true;
      source = ./configs/home/profile;
    };
    ".psh_rc" = {
      enable = true;
      source = ./configs/home/psh_rc;
    };
  };
}
