{
  description = "raddebugger";

  inputs = {
    pkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        packages.default = pkgs.clangStdenv.mkDerivation (finalAttrs: {

          pname = "raddebugger";
          version = "0.9.29-alpha";
          strictDeps = true;
          __structuredAttrs = true;
          src = pkgs.fetchFromGitHub {
            owner = "EpicGames";
            repo = "raddebugger";
            tag = "v${finalAttrs.version}";
            hash = "sha256-IQNicRWKdIamDeQU1RRceRR2QgoUlomQYoeCgepO10w=";
          };

          nativeBuildInputs = with pkgs; [
            bash
            makeWrapper
            copyDesktopItems
          ];
          buildInputs = with pkgs; [
            freetype
            libx11
            libxext
            libxfixes
            libGL
          ];

          postPatch = ''
            patchShebangs build.sh

            substituteInPlace build.sh \
              --replace-fail '$(git describe --always --dirty)' 'v${finalAttrs.version}' \
              --replace-fail '$(git rev-parse HEAD)' 'v${finalAttrs.version}'
          '';

          buildPhase = ''
            runHook preBuild

            ./build.sh '${pkgs.clangStdenv.cc.cc.pname}' release raddbg radlink radbin torture

            runHook postBuild
          '';

          doCheck = false; # fails on my machine

          checkPhase = ''
            runHook preCheck

            ./build/torture '*'

            runHook postCheck
          '';

          installPhase = ''
            runHook preInstall

            install -Dm755 -t "$out/bin" build/{raddbg,radlink,radbin}
            install -Dm644 data/logo.png "$out/share/icons/hicolor/256x256/raddbg.png"

            runHook postInstall
          '';

          postFixup = ''
            for prog in "$out/bin/"*; do
              wrapProgram "$prog" \
                --prefix PATH : "${
                  pkgs.lib.makeBinPath [
                    pkgs.zenity
                    pkgs.libllvm
                  ]
                }"
            done
          '';

          desktopItems = [
            (pkgs.makeDesktopItem {
              name = "raddbg";
              desktopName = "RAD Debugger";
              genericName = "Debugger";
              comment = "Graphical debugger";
              icon = "raddbg";
              exec = "raddbg %U";
              terminal = false;
              categories = [
                "Development"
                "Debugger"
              ];
              startupNotify = true;
              startupWMClass = "RADDBG";
            })
          ];

          passthru = {
            #tests.raddebugger-gcc = raddebugger { clangStdenv = pkgs.gccStdenv; };
            updateScript = pkgs.nix-update-script { };
          };

          meta = {
            homepage = "https://github.com/EpicGames/raddebugger";
            description = "A native, user-mode, multi-process, graphical debugger.";
            license = pkgs.lib.licenses.mit;
            platforms = [ "x86_64-linux" ];
            mainProgram = "raddbg";
          };
        });
      })
    );
}
