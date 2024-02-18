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
  };

  outputs = { self, nixpkgs, disko, nixos-hardware, home-manager, sops-nix, microvm }: let
    hostnames = [ "radon" ];
  in {
    nixosConfigurations = builtins.listToAttrs (map (hostname: {
      name = hostname;
      value = let
        host = (import ./per-hostname/${hostname}.nix);
        pkgs = import nixpkgs {
          system = "${host.architecture}-linux";
          config.allowUnfree = true;
          overlays = host.overlays;
        };
      in nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit nixpkgs pkgs disko nixos-hardware home-manager sops-nix microvm hostname host;
        };
        modules = [ ./global/modules/base-system.nix ];
      };
    }) hostnames);
  };
}