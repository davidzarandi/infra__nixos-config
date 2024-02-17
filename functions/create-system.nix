{ nixpkgs, disko, home-manager, microvm, hostname }: let
  hostConfiguration = (import ../per-hostname/${hostname}/host.nix);
  pkgs = import nixpkgs {
    system = "${hostConfiguration.architecture}-linux";
    config.allowUnfree = true;
    overlays = (import ../overlays/pkgs.nix);
  };
  users = (import ../per-hostname/${hostname}/users.nix { inherit pkgs; });
  systemConfiguration = (import ../per-hostname/${hostname}/system.nix { inherit pkgs; });
in {
  modules = [
    (import ./create-disks.nix hostConfiguration.disks)
    (import ./create-users.nix users)
    disko.nixosModules.disko
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.user = (import ./create-user-home.nix users.user) // {
        home.stateVersion = hostConfiguration.stateVersion;
      };
    }
    {
      nixpkgs.hostPlatform = nixpkgs.lib.mkDefault "${hostConfiguration.architecture}-linux";
      networking.hostName = hostname;
      boot = hostConfiguration.boot;
      time.timeZone = hostConfiguration.timeZone;
      i18n.defaultLocale = hostConfiguration.locale;
      system.stateVersion = hostConfiguration.stateVersion;
      services = {
        xserver.layout = hostConfiguration.keyboard.layout;
        xserver.xkbOptions = hostConfiguration.keyboard.xkbOptions;
      } // systemConfiguration.services;
    }
    {
      networking.networkmanager.enable = true;
    }
    {
      environment.systemPackages = systemConfiguration.packages;
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
    }
  ] ++ (if systemConfiguration ? virtualization.enable && systemConfiguration.virtualization.enable then (
    if systemConfiguration.virtualization ? isHost && systemConfiguration.virtualization.isHost then [
      microvm.nixosModules.host
    ] else [
      microvm.nixosModules.microvm
      {
        microvm = systemConfiguration.vmConfiguration;
      }
    ]
  ) else []);
}