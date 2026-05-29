{ config, pkgs, ... }:

let

  # creates (eg)
  #  "--foo bar --baz qux"
  # from
  #  {
  #    foo = "bar";
  #    baz = "qux";
  #  }
  mk_args = stuff:
    builtins.concatStringsSep " " (
      builtins.attrValues (
          builtins.mapAttrs (opt: val: "--${opt}=${val}") stuff
      )
    );

  #helper to enable for just one tty
  enable_tty = tty_num: {
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-user-sessions.service" ];
    serviceConfig = {
      ExecStart = pkgs.lib.mkForce (
        "${pkgs.kmscon}/bin/kmscon " + (
          builtins.concatStringsSep " " [
            (mk_args {
              seats = "seat0";
              vt = "${toString tty_num}";
              multi-monitor = "largest";
            })
            (builtins.concatStringsSep " " [
              "--no-switchvt "
              "--term xterm-256color"
              "--login -- ${pkgs.shadow}/bin/login -p"
            ])
          ]
        ));
      Restart = "always";
    };
  };
in { 

  # NOTE: disabling globally prevents WM (or DE) clobbering
  services.kmscon.enable = false;

  environment.systemPackages = [ pkgs.kmscon ];

  #systemd.units."kmsconvt@tty4.service".enable = true;
  systemd.services = builtins.listToAttrs(map (num: {
    name = "kmsconvt@tty${toString num}";
    value = enable_tty num;
  }) [
    4
    5
  ]);
}
