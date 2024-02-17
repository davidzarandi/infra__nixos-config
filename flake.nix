{
  description = "Nix setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    disko.url = "github:nix-community/disko/v1.3.0";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    microvm.url = "github:astro/microvm.nix/v0.4.1";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, home-manager, microvm }: let
    hostnames = [ "example" ];
  in {
    nixosConfigurations = builtins.listToAttrs (map (hostname: {
      name = hostname;
      value = nixpkgs.lib.nixosSystem (import ./functions/create-system.nix {
        inherit nixpkgs disko home-manager microvm hostname;
      });
    }) hostnames);
  };
}