{
  nixpkgs, lib, config,
  pkgs, disko, nixos-hardware, home-manager, sops-nix, microvm, plasma-manager,
  hostname, architecture, ...
}: let
  hostConfiguration = (import ../../per-hostname/${hostname}/configuration.nix { inherit nixpkgs nixos-hardware pkgs lib config; });
in {
  imports = [
    disko.nixosModules.disko
    sops-nix.nixosModules.sops
    hostConfiguration.system.extraOptions
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.sharedModules = [
        plasma-manager.homeManagerModules.plasma-manager
      ];
      home-manager.users.user = {
        home.username = "user";
        home.homeDirectory = "/home/user";
        services = hostConfiguration.user.home.services;
        programs = hostConfiguration.user.home.programs;
        home.packages = hostConfiguration.user.home.packages;
        home.stateVersion = hostConfiguration.stateVersion;
        home.file = (import ../../per-hostname/${hostname}/dotfiles.nix);
      } // hostConfiguration.user.home.extraOptions;
    }
    (import ../functions/create-disks.nix (import ../../per-hostname/${hostname}/disks.nix))
  ] ++ hostConfiguration.extraModules ++ (
    if hostConfiguration.virtualization.enable && hostConfiguration.virtualization.isHost then [
      microvm.nixosModules.host
    ] else [
      microvm.nixosModules.microvm
      {  }
    ]
  );

  nixpkgs.hostPlatform = lib.mkDefault "${architecture}-linux";
  networking.hostName = hostname;
  boot = hostConfiguration.system.boot;
  time.timeZone = hostConfiguration.system.timeZone;
  i18n.defaultLocale = hostConfiguration.system.locale;
  environment.systemPackages = hostConfiguration.system.packages ++ [
    pkgs.sops
  ];
  environment.variables = hostConfiguration.system.variables;
  services = {
    xserver.layout = hostConfiguration.system.keyboard.layout;
    xserver.xkbOptions = hostConfiguration.system.keyboard.xkbOptions;
  } // hostConfiguration.system.services;
  system.stateVersion = hostConfiguration.stateVersion;
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  sops.defaultSopsFile = ../secrets/nixos.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/user/.config/sops/age/keys.txt";
  sops.secrets = hostConfiguration.secrets // {
    root-password.neededForUsers = true;
    user-password.neededForUsers = true;
  };

  users.users.root = {
    uid = 0;
    hashedPasswordFile = config.sops.secrets.root-password.path;
  };
  users.users.user = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "networkmanager" ] ++ hostConfiguration.user.extraGroups;
    hashedPasswordFile = config.sops.secrets.user-password.path;
    shell = hostConfiguration.user.shell;
  };
  programs."${(builtins.parseDrvName hostConfiguration.user.shell.name).name}".enable = true;
}
