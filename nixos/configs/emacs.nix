{ config, pkgs, ... }:
let 

in {
  nixpkgs.config.packageOverrides = pkgs: rec {
    memacs = pkgs.emacs.pkgs.withPackages (epkgs: (with epkgs; [
      org
      nix-mode
      vterm
      tree-sitter
      tree-sitter-langs
      (treesit-grammars.with-grammars (grammars: (with grammars; [
        tree-sitter-nix #why aren't there more languages like Nix? (I know about GUIX)
        tree-sitter-zig #great language
        tree-sitter-c
        tree-sitter-bash
        tree-sitter-go #feels like a toy
        tree-sitter-jq
        tree-sitter-cpp
        tree-sitter-css
        tree-sitter-kdl #I prefer Bartholomew, but close enough
        tree-sitter-lua
        tree-sitter-org #why even use MD?
        tree-sitter-php #not sure how to feel about PHP
        tree-sitter-make
        tree-sitter-json
        tree-sitter-java #sadly I must write it for school
        tree-sitter-diff
        tree-sitter-xml
        tree-sitter-html
        tree-sitter-vim #why not?
        tree-sitter-latex
        tree-sitter-elisp
        tree-sitter-cmake
        tree-sitter-yaml
        tree-sitter-wren #a neat language
        tree-sitter-vala
        tree-sitter-toml
        tree-sitter-scss
        tree-sitter-odin #ehh
        tree-sitter-perl
        tree-sitter-pascal #I have some curiosity about PASCAL, I might try it
        tree-sitter-kotlin
        tree-sitter-nginx
        tree-sitter-markdown
        tree-sitter-hyprlang #hyprland Lua update when?
        tree-sitter-gitignore
        tree-sitter-gdscript #tried it briefly
        tree-sitter-c-sharp #I have to learn this soon for school
        tree-sitter-commonlisp #Lisp curious
        tree-sitter-javascript #sadly nothing else has the DOM api in a browser
        tree-sitter-typescript #it's just JS
      ])))
    ]));
  };
  environment.systemPackages = with pkgs; [
    memacs
    (aspellWithDicts (dicts: with dicts; [
      en
      en-computers
      en-science
    ]))
  ];
}
