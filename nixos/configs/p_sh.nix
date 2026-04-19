{ pkgs, ... }:
let
  p_shrc = import ../helpers/p_shrc.nix { pkgs = pkgs; };
  secrets = import ../secrets.nix;
in
  p_shrc.mk_rc {
    aliases = {
      #clear = "printf \"\x1bc\"";
      cls = "clear";
      ls = "${pkgs.eza}/bin/eza --color=auto";
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -F";
      grep = "grep --color=auto";
      ":q" = "exit";
      ":Q" = "exit";
      ":e" = "nvim";
      error = "(exit 1)";
      laR = "ls -aR";
      vimdiff = "nvim -d";
      ds = "dir_size";
      nvimdiff = "nvim -d";
      switch = "sudo nixos-rebuild switch --impure";
      zen_confined = "nixGL firejail --netns=${secrets.vpn.wg.alt.provider} zen --profile";

      #clsls = "clear;ls"; # TODO: multi-command aliases

      # TODO: defining env vars
      # goNoCache = "GOPROXY=direct go"; 
      # ssh = "TERM=xterm-256color ssh";
    };
    general = {
      colorizing_level = 2;
    };
  }
