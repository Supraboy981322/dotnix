{ pkgs, ... }: 
{
  createDirs = /* bash */ ''
    mkdir -p "/home/super/IMG" 1>&2
    ln -sfn "/home/super/Pictures/Screenshots" "/home/super/IMG/Screens" 1>&2

    mkdir -p \
        "/home/super/machines" \
        "/home/super/tmp/moreTmp" \
        "/home/super/projects" \
        "/home/super/assignments" 1>&2
  '';

  #fetches latest version of yt-dlp from GitHub (newer than nixpkgs unstable)
  get_latest_yt-dlp = /* bash */ ''
    ${pkgs.curl}/bin/curl -L \
        https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
        -o /home/super/scripts/yt-dlp 1>&2
    chmod a+rx /home/super/scripts/yt-dlp 1>&2
  '';

  #can't be bothered to make a flake for these
  install_unversioned_go_pkgs = /* bash */ ''
    export HOME="/home/super"
    export GOPATH="/home/super/go"
    export PATH=$PATH:${pkgs.gcc}/bin:${pkgs.busybox}/bin:${pkgs.go}/bin
    go_pkg_urls=(
      "github.com/Supraboy981322/d/src/d"
      "github.com/Supraboy981322/misc-scripts/dir_size"
      "github.com/Supraboy981322/misc-scripts/in_out"
      "github.com/Supraboy981322/misc-scripts/strip_ansi"
      "github.com/Supraboy981322/misc-scripts/bytes_to_human"
    )
    printf "installing go packages...\n" 1>&2
    for url in "''${go_pkg_urls[@]}"; do
      printf "\t%s\n" "$url" 1>&2
      go install $url@latest 2>&1 | sed 's/^/\t\t/g' 1>&2
    done
  '';
}
