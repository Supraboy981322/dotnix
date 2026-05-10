{ config, home, pkgs, ... }:
{
  home.file.".ssh/config" = {
    enable = true;
    text =
      let
        helper = import ../helpers/ssh.nix;
      in
        builtins.concatStringsSep "\n" (helper.git_configs [
          {
            nick = "codeberg";
            hostname = "codeberg.org";
          }
        ]);
  };
}
