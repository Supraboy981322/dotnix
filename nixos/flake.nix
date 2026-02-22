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
  };

  outputs = {
    zig,
    self,
    nixpkgs,
    ghostty,
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
