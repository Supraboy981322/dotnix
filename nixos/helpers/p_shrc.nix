{ pkgs, ... }:
let
  mk_rc = {
    aliases,
    general,
  }: ''
    aliases=[
      ${
        pkgs.lib.concatLines (pkgs.lib.mapAttrsToList (name: value:
          "\t" + ''${name}=${builtins.toJSON value}''
        ) aliases)
      }]
    general=[
      ${
        pkgs.lib.concatLines (pkgs.lib.mapAttrsToList (name: value:
          "\t" + ''${name}=${builtins.toJSON value}''
        ) general)
      }]
  '';
in {
  mk_rc = mk_rc;
}
