let
  new_config = { host, user, ident_file, hostname }: ''
    Host ${host}
      HostName ${hostname}
      User ${user}
      IdentityFile ${ident_file}
  '';
  new_git_config = { nick ? null, hostname, file ? null }:  
    let
      name =
        if nick != null then
          nick
        else
          hostname;
    in
      new_config {
        host = name;
        user = "git";
        ident_file = if file != null then file else "~/.ssh/${name}";
        hostname = hostname;
      };
in {

  new_config = config: new_config config;
  new_git_config = config: new_git_config config;

  configs = configs: (builtins.map (conf: new_config conf) configs);
  git_configs = configs: (builtins.map (conf: new_git_config conf) configs);
}
