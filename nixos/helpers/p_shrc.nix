{ pkgs, ... }:
let
  mk_pairs = set:
    pkgs.lib.concatLines (pkgs.lib.mapAttrsToList (name: value:
      "\t" + ''${name}=${builtins.toJSON value}''
    ) set);

  mk_rc = {
    aliases ? {},
    general ? {},
    env ? {}
  }: ''
    aliases=[
      ${mk_pairs aliases}]
    general=[
      ${mk_pairs general}]
    env=[
      ${mk_pairs env}]
  '';
in {
  mk_rc = mk_rc;
}
