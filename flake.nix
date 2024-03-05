{
  description = "Personal nixOS setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    disko.url = "github:nix-community/disko/v1.3.0";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    microvm.url = "github:astro/microvm.nix/v0.4.1";
    microvm.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
  };

  outputs = { self, nixpkgs, disko, nixos-hardware, home-manager, sops-nix, microvm, plasma-manager }: let
    hostnames = [ "radon" ];
  in {
    nixosConfigurations = builtins.listToAttrs (map (hostname: {
      name = hostname;
      value = let
        architecture = (import ./per-hostname/${hostname}/architecture.nix);
        pkgs = import nixpkgs {
          system = "${architecture}-linux";
          config.allowUnfree = true;
          overlays = (import ./per-hostname/${hostname}/overlays.nix);
        };
      in nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit nixpkgs pkgs disko nixos-hardware home-manager sops-nix microvm plasma-manager hostname architecture;
        };
        modules = [ ./global/modules/base-system.nix ];
      };
    }) hostnames);
    diskoConfigurations = builtins.listToAttrs (map (hostname: {
      name = hostname;
      value = (import ./global/functions/create-disks.nix (import ./per-hostname/${hostname}/disks.nix));
    }) hostnames);
  };
}