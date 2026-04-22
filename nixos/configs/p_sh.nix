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
      start_in_previous_dir = true;
    };

    env = {
      PS1 = let 
        BG_GRAY=''\e[48;2;75;75;75m'';
        white=''\e[38;2;255;255;255m'';
        yellow=''\e[38;2;255;216;171m'';
        cyan=''\e[38;2;134;225;252m'';
        bold=''\e[1m'';
        red=''\e[38;2;255;117;127m'';
        green=''\033[38;2;195;232;141m'';
        reset=''\e[0m'';
        italic=''\e[3m'';
        grey=''\e[38;2;150;150;150m'';
      in ''

\e[${italic}${cyan}╭[${grey}{time}${cyan}] ${yellow}${italic}keepernix${grey} {{${cyan}$SHLVL${grey}}} ${red}-->${cyan} {cwd}
╰({char}${cyan}):'';
    };
  }
