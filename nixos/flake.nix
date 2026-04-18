{
  description = "nix flakes suck";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zig_overlay.url = "github:mitchellh/zig-overlay";

    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    
    vpn-confinement = {
      url = "github:Maroka-chan/VPN-Confinement";
    };

    # my web browser of choice is not in NixPKGs
    zen-browser_pkg = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs = {
    self,
    nixpkgs,
    ghostty,
    nix-flatpak,
    zig_overlay,
    home-manager,
    zen-browser_pkg,
    vpn-confinement,
    nixpkgs-unstable,
    ...
  }@inputs: 
    let
      lib = nixpkgs.lib;

      system = "x86_64-linux"; 

      #zig = zig.packages.${system}.default;

      pkgs = nixpkgs.legacyPackages.${system};

      pkgsUnstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      specialArgs = {
        inherit inputs;
        inherit zig_overlay;
        pkgs-unstable = pkgsUnstable;
      };

      nixosConfig = { configPath, useUnstable ? false }:
        let
          nixpkgsSrc = if useUnstable then nixpkgs-unstable else nixpkgs;
        in
          nixpkgsSrc.lib.nixosSystem {
            modules = [ configPath ];
          };

    in {

      homeConfigurations.myuser = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home.nix
          ./configs/hyprland.nix
        ];
      };

      nixpkgs.overlays = [
        (final: prev: { zig = zig_overlay.packages.${system}.default; })
      ];

      nixosConfigurations.keepernix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            environment.systemPackages = (with pkgs; [
              # may put something here at some point
            ]) ++ (with nixpkgs-unstable; [
              zig_overlay.packages.${system}.default
              ghostty
            ]);
          }

          ./configuration.nix

          nix-flatpak.nixosModules.nix-flatpak
          vpn-confinement.nixosModules.default

          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.super = import ./home.nix;
            };
          }

          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              (final: prev: {
                zig = zig_overlay.packages.${system}.default;
              })
            ];
          })
        ];
        specialArgs = {
          pkgs-unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
          inherit inputs;
          inherit zig_overlay;
          inherit nixpkgs-unstable;
          #          inherit zig_0_15;
        };
      };
    };
}
