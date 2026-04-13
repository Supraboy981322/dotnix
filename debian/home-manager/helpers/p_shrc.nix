{ pkgs, ... }:
let
  mk_rc = {
    aliases,
  }: ''
    aliases=(
      ${
        pkgs.lib.concatLines (pkgs.lib.mapAttrsToList (name: value:
          "\t" + ''${name}=${value}''
        ) aliases)
      })
  '';
in {
  mk_rc = mk_rc;
}
