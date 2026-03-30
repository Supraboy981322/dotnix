{ pkgs, config, ... }:
let
  secrets = import ./../secrets.nix;
in {
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = false;
    autosuggestions.enable = false;
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
      "HIST_IGNORE_SPACE"
    ];
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
    };
    interactiveShellInit = /* sh */ ''
      bindkey -v
      set -o vi
      bindkey -r "^R"
      bindkey "^R" history-incremental-search-backward
      bindkey -M viins "^?" backward-delete-char
      bindkey -M viins "^[^?" backward-delete-char
    '';
    shellInit = /* sh */ ''
      #mkdir then cd into it
      function mkcd() {
        mkdir "$1"
        cd "$1"
      }
      #cd into dir then eza
      function cdls() {
        cd "$1"
        ${pkgs.eza}/bin/eza ''${@:2}
      }
    '';
    promptInit = /* sh */ '';
      autoload -Uz add-zsh-hook
      function __mkps1() {
        #get return status of previous cmd 
        local EXIT_CODE="$?"
        #create empty $PS1

        #define colors
        local BG_GRAY=$'\033[48;2;75;75;75m'
        local white=$'\033[38;2;255;255;255m'
        #local yellow=`tput setaf 221`
        local yellow=$'\033[38;2;255;216;171m'
        local grey=`tput setaf 249`
        #local cyan=`tput setaf 45`
        local cyan=$'\033[38;2;134;225;252m'
        local bold=`tput bold`
        #local red=`tput setaf 1`
        local red=$'\033[38;2;255;117;127m'
        #local green=`tput setaf 34`
        local green=$'\033[38;2;195;232;141m'
        local reset=`tput sgr0`
        local green2=`tput setaf 70`
        local timeStamp="$(date +%I:%M%P)"
        local prompt_color="$green"
        local italic=$'\033[3m'

        local p="?"
        #makes the prompt symbol red if bad return code 
        if (( $EXIT_CODE )); then
          prompt_color="$red" ; p="!"
        fi
        
        #get current dir
        local curDir="$(pwd)"
        #check if dir is within $HOME
        if [[ "$curDir" == "$HOME"* ]]; then
          curDir="''${curDir/$HOME/~}" #replace $HOME with '~'
        fi
        
        #adjust printed dir based on term width 
        local term_width=$((`tput cols`-1))
        local pre_line=" ╭[00:00xx] $HOSTNAME {$SHLVL} --> "
        local pre_len=''${#pre_line}
        #length of full first line
        local total_len=$((''${#curDir}+$pre_len))
        if [[ $total_len -gt $term_width ]]; then
          local pre_len_diff=$((term_width-pre_len))
          #cut-off string and add '...' to beginning 
            curDir=''${curDir: -$((pre_len_diff-3))}
            curDir="...$curDir"
        fi

        # ╭[07:10pm] keeper {1} --> ~
        # ╰(!):
        # new PS1
        PS1=$'\n'
        PS1+=" %{$italic$cyan%}╭[%{$grey%}"
        PS1+="$timeStamp%{$cyan%}]%{$reset$italic%}"
        PS1+=" %{$yellow%}%m %{$grey%}{"
        PS1+="$cyan%}$SHLVL%{$grey%}}%{$reset$italic%}"
        PS1+=" %{$red%}-->%{$reset$italic%} "
        PS1+="%{$cyan%}$curDir"$'\n'"%{$italic$cyan%}"
        PS1+=" ╰(%{$reset$italic$prompt_color%}$p"
        PS1+="%{$reset$italic$cyan%}):%{$reset%} "
      }
      add-zsh-hook precmd __mkps1
    '';
  };
  environment.variables = {
    VITASDK = "/usr/local/vitasdk";
    EDITOR = "nvim";
    # TODO: change this
    VISUAL = "/usr/bin/nvim";
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
