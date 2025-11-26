{
  description = "nixos flakes suck";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zig.url = "github:mitchellh/zig-overlay";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ghostty, zig, nixpkgs-unstable, ... }@inputs: 
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
    in
    {
      nixpkgs.overlays = [
        (final: prev: {
          zig_0_15 = zig;
        })
      ];
      nixosConfigurations.zane-desktop-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            environment.systemPackages = (with pkgs; [

            ])++
              (with nixpkgs-unstable; [
                zig
                ghostty
              ]);
          }
          ./configuration.nix
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
