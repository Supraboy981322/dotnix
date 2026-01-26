{ ... }:

# various directories and dotfiles
let

  print = str: builtins.trace str;

  pkgs = import <nixpkgs> {};
  lib = import <nixpkgs/lib>;

  stuff = [
    [ ".gtkrc-2.0" ./configs/home/gtkrc-2.0 ]
    [ "Pictures"   ./configs/home/Pictures  ]
    [ "scripts"    ./scripts                  "executable" ]
    [ ".config"    ./configs/home/config    ]
    [ ".local"     ./configs/home/local     ]
    [ ".bashrc"    ./configs/home/bashrc    ]
    [ ".profile"   ./configs/home/profile   ]
    [ ".psh_rc"    ./configs/home/psh_rc    ]
  ];

  is_dir = p:
    let res = pkgs.runCommand "check-is-dir" { } ''
      if [ -d ${toString p} ]; then printf "_"; fi
    '';
    in res == "_";

  expand = spec:
    let
      name = lib.elemAt spec 0;
      src = lib.elemAt spec 1;
      flags = lib.drop 2 spec;
    in
      if is_dir src then
        map (n: [ "${name}/${n}" "${src}/${n}" ] ++ flags)
            (builtins.attrNames (builtins.readDir src))
      else spec;

  gen_stuff = spec:
    lib.listToAttrs (map (thing: {
      name = (lib.elemAt thing 0);
      value = {
        source = (lib.elemAt thing 1);
        #enabled = true;
      } // (lib.genAttrs (lib.drop 2 thing) (_: true));
    }) spec );
in

{
  home.file = gen_stuff (expand stuff);
}
