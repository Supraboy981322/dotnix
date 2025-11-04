#!/bin/sh

set -eu

PATH=/run/current-system/sw/bin:$PATH

printf "\n\nsetup script started...\n"

wgetFunc() {
  wget -q --show-progress --progress=bar:force:noscroll "$@" 
}

privateRepoApiURL="https://api.github.com/repos/Supraboy981322/dotfiles/contents"
scriptsRepoDirApiURL="${privateRepoApiURL}/etc/scripts"
browserRemote="https://github.com/zen-browser/desktop/releases/latest/download/zen-x86_64.AppImage"
browserDlLoc="/home/super/appimages/zen.AppImage"
if [ ! -f /etc/nixos/.secrets/ghToken/setup-gh-token ]; then
  printf "GitHub token missing\n" >&2
  exit 1
fi
ghToken=$(cat /etc/nixos/.secrets/ghToken/setup-gh-token)

printf "  ensuring all dirs are created\n" 
#make sure all dirs are created
for dir in /home/super/appimages /etc/scripts; do
  if [ ! -d "${dir}" ]; then
    printf "    %s dir does not exist; creating it\n" "${dir}"
    mkdir -p "${dir}"
  fi
done

printf "  dl browser appimage\n    "
if ! wgetFunc "${browserRemote}" -O "${browserDlLoc}"; then
  printf "  failed to download browser!\n" >&2
  printf "    status:\n" >&2
  printf "    url:\n" >&2
  printf "      ${browserRemote}\n" >&2
  printf "    dl path:\n" >&2
  printf "      ${browserDlLoc}\n" >&2
fi
printf "    browser appimage loc:\n      "
ls "${browserDlLoc}"
printf "    making browser appimage executable...\n"
chmod a+x "${browserDlLoc}"

#dl script binaries from a private repo
printf "  dl scripts:\n"
scriptsJSON=$(curl -s -H "Authorization: token ${ghToken}" ${scriptsRepoDirApiURL})
printf "${scriptsJSON}\n" \
  | jq -r '.[] | .path + " " + .download_url? // empty' \
  | while IFS=" " read -r file_path download_url; do
  if [ -z "${download_url}" ]; then
    printf "    dl: ${file_path}\n"
    printf "      no url found for this script!\n"
    printf "      skipping script...\n"
  else 
    mkdir -p "$(dirname "${file_path}")"
    printf "    dl: ${file_path}\n"
    curl -sSL -o "${file_path}" "${download_url}"
    printf "      making script executable...\n"
    chmod a+x "${file_path}"
  fi
done
printf "  scripts dl-ed\n"

printf "done.\n\n"
