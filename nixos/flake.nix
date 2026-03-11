{
  description = "nix flakes suck";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zig.url = "github:mitchellh/zig-overlay";

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
  };

  outputs = {
    zig,
    self,
    nixpkgs,
    ghostty,
    home-manager,
    zen-browser_pkg,
    vpn-confinement,
    nixpkgs-unstable,
    ...
  }@inputs: 
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux"; 
      pkgs = nixpkgs.legacyPackages.${system};
      pkgsUnstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      specialArgs = {
        inherit inputs;
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
        (final: prev: { zig_0_15 = zig; })
      ];

      nixosConfigurations.keepernix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            environment.systemPackages = (with pkgs; [
              # may put something here at some point
            ]) ++ (with nixpkgs-unstable; [
              zig
              ghostty
            ]);
          }
          ./configuration.nix
          vpn-confinement.nixosModules.default

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.super = import ./home.nix;
          }
        ];
        specialArgs = {
          pkgs-unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
          inherit inputs;
          inherit nixpkgs-unstable;
          #          inherit zig_0_15;
        };
      };
    };
}
