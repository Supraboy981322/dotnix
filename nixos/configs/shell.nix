{ pkgs, config, ... }:
let
  secrets = import ./../secrets.nix;
in {
  users.defaultUserShell = pkgs.bash;
  users.users.super.shell = pkgs.bash;


    #programs.zsh = {
    #  enable = false; #clunkiest shell I've ever used.
    #  syntaxHighlighting.enable = true;
    #  enableCompletion = false;
    #  autosuggestions.enable = false;
    #  setOptions = [
    #    "HIST_IGNORE_ALL_DUPS"
    #    "HIST_IGNORE_SPACE"
    #  ];
    #};

  # nice concept, horrible execution
  #  it doesn't remotely conform to standards
  #    it claims to. it's also super slow and 
  #      has non-standard arg parsing
  #        (am I the only one these days who likes a true POSIX shell?)
  programs.xonsh = {
    enable = false;
    config = /* py */''
      from xonsh.tools import format_color
      import time
      def __get_prompt_symbol():
        rtn = __xonsh__.history.rtns[-1] if __xonsh__.history.rtns else 0
        return "{ITALIC_#a7d169}?" if rtn == 0 else "{ITALIC_#ff757f}!"
      $PROMPT_FIELDS["status_symbol"] = __get_prompt_symbol
      $PROMPT_FIELDS["time"] = lambda: time.strftime("%I:%M%p").lower(  )
      $PROMPT_FIELDS["SHLVL"] = lambda: str($SHLVL)
      $PROMPT = (
        "\n {ITALIC_#86e1fc}╭[{ITALIC_#a2abb3}{time}{ITALIC_#86e1fc}] "
        "{ITALIC_#a2abb3}{{{{{ITALIC_#86e1fc}{SHLVL}{ITALIC_#a2abb3}}}}} "
        "{ITALIC_#ff757f}--> {ITALIC_#86e1fc}{cwd}\n "
        "{ITALIC_#86e1fc}╰({status_symbol}{ITALIC_#86e1fc}):{RESET} "
      )

      def _mkcd(args):
        mkdir @(args[0])
        cd @(args[0])
      aliases["mkcd"] = _mkcd

      def _cdls(args):
        cd @(args[0])
        ${pkgs.eza}/bin/eza @(args[0:])
      aliases["cdls"] = _cdls

      aliases |= {
        "ls": { "alias": [ "${pkgs.eza}/bin/eza", "--color=auto" ] },
        "ll": { "alias": [ "ls", "-alF" ] },
        "l": { "alias": [ "ls", "-F" ] },
        "dir": { "alias": [ "dir", "--color=auto" ] },
        "vdir": { "alias": [ "vdir", "--color=auto" ] },
        "grep": { "alias": [ "grep", "--color=auto" ] },
        "fgrep": { "alias": [ "fgrep", "--color=auto" ] },
        "egrep": { "alias": [ "egrep", "--color=auto" ] },
        "cls": { "alias": ["clear"] },
        "gettail": { "alias": [ "getTail" ] },
        ":q": { "alias": [ "exit" ] },
        ":Q": { "alias": [ "exit" ] },
        ":e": { "alias": [ "nvim" ] },
        "goNoCache": { "alias": [ "GOPROXY=direct", "go" ] },
        "laR": { "alias": [ "${pkgs.eza}/bin/eza", "-aR" ] },
        "vimdiff": { "alias": [ "nvim", "-d" ] },
        "ssh": { "alias": [ "TERM=xterm-256color", "ssh" ] },
        "ds": { "alias": [ "dir_size" ] },
        "nvimdiff": { "alias": [ "nvim", "-d" ] },
        "switch": { "alias": [ "sudo", "nixos-rebuild", "switch", "--impure" ] },
        "zen_confined": { "alias": [
          "nixGL", "firejail", "--netns=${secrets.vpn.wg.alt.provider}", "zen", "--profile"
        ] },
        "..": { "alias": [ "cd", ".." ] },
      }
    '';
  };

  programs.bash = {
    enable = true;
    completion.enable = false; #gross
    shellAliases = {
      ls = "${pkgs.eza}/bin/eza --color=auto";
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -F";
      dir = "dir --color=auto";
      vdir = "vdir --color=auto";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      clear=''printf "\033c"'';
      cls = "clear";
      clsls = "clear;ls";
      gettail = "getTail";
      ":q" = "exit";
      ":Q" = "exit";
      ":e" = "nvim";
      error = "(exit 1)";
      goNoCache = "GOPROXY=direct go";
      laR = "${pkgs.eza}/bin/eza -aR";
      CURDIR = ''basename "''${PWD}"'';
      vimdiff = "nvim -d";
      ssh = "TERM=xterm-256color ssh";
      ds = "dir_size";
      nvimdiff = "nvim -d";
      switch = "sudo nixos-rebuild switch --impure";
      zen_confined = "nixGL firejail --netns=${secrets.vpn.wg.alt.provider} zen --profile";
      ".." = "cd ..";
    };

    interactiveShellInit = ''
      ${
        builtins.concatStringsSep "\n" (
          builtins.map (opt: "shopt -s ${opt}") [
            "globstar"
            "extglob"
          ]
        )
      }
    '';
  };
  environment.variables = {
    VITASDK = "/usr/local/vitasdk";
    EDITOR = "nvim";
    VISUAL = "emacs";
    BUN_INSTALL = "$HOME/.bun";
    NVM_DIR="$HOME/.nvm";
    GOBIN = "$HOME/go/bin";
    PKG_CONFIG_PATH = [
      "$PKG_CONFIG_PATH"
      "/usr/lib/x86_64-linux-gnu/pkgconfig/"
    ];
    CPATH = [
      "$CPATH"
      "/usr/include"
      "/usr/include/gtk-4.0"
    ];
    PATH = [
      "$HOME/.bin"
      "$GOBIN"
      "$HOME/bin"
      "$HOME/scripts"
      "$HOME/.local/share/gem/ruby/3.3.0/bin"
      "$HOME/.local/bin"
      "$HOME/.npm-packages/bin"
      "$VITASDK/bin"
      "$BUN_INSTALL/bin"
    ];
    zen_confined = "nixGL firejail --netns=${secrets.vpn.wg.alt.provider} zen --profile";
  };
}
