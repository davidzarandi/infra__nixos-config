{
  architecture = "x86_64";
  overlays = [
    (import ../global/overlays/webstorm.nix)
    (import ../global/overlays/datagrip.nix)
  ];
  getConfiguration = {
    pkgs, lib, config, ...
  }: {
    extraModules = [
      # (import ../global/modules/services/zerotierone.nix { inherit pkgs config lib; })
    ];

    system = {
      disks = {
        "/dev/nvme0n1" = [
          { label = "NIX_BOOT"; type = "ef00"; size = "300M"; fileSystem = "vfat"; mountPoint = "/boot"; }
          { label = "NIX_ROOT"; type = "8300"; size = "100%"; fileSystem = "ext4"; mountPoint = "/"; }
        ];
        "/dev/nvme1n1" = [
          { label = "NIX_SWAP"; type = "8200"; size = "38G"; fileSystem = "swap"; }
          { label = "NIX_HOME"; type = "8300"; size = "100%"; fileSystem = "ext4"; mountPoint = "/home"; }
        ];
      };

      boot = {
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;
        initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
        initrd.kernelModules = [ ];
        kernelModules = [ "kvm-amd" ];
        extraModulePackages = [ ];
      };

      keyboard = {
        layout = "us";
        xkbOptions = "eurosign:e,caps:escape";
      };

      timeZone = "Europe/Amsterdam";
      locale = "en_US.UTF-8";

      services = {
        xserver.enable = true;
        xserver.displayManager.sddm.enable = true;
        xserver.displayManager.defaultSession = "none+openbox";
        xserver.windowManager.openbox.enable = true;

        printing.enable = true;
        printing.drivers = [ pkgs.cnijfilter2 ];
        avahi.enable = true;
        avahi.nssmdns = true;
        avahi.openFirewall = true;

        pipewire.enable = true;
        pipewire.alsa.enable = true;
        pipewire.alsa.support32Bit = true;
        pipewire.pulse.enable = true;
      };

      packages = with pkgs; [
        neovim
        pipecontrol
        dolphin
        konsole
        libsForQt5.xdg-desktop-portal-kde
        libsForQt5.kate
      ];

      variables = {
        TERMINAL = "konsole";
        EDITOR = "nvim";
        VISUAL = "kate";
      };

      extraOptions = {
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        hardware.bluetooth.enable = true;
        security.rtkit.enable = true;

        xdg.portal.enable = true;
        xdg.portal.xdgOpenUsePortal = true;
        xdg.portal.config = {
          common.default = "kde";
        };
        xdg.portal.extraPortals = [ pkgs.libsForQt5.xdg-desktop-portal-kde ];
      };
    };

    user = {
      shell = pkgs.zsh;

      extraGroups = [];

      home = {
        services = {
          syncthing.enable = true;
          syncthing.extraOptions = [
            "--config=/home/user/.config/syncthing/config"
            "--data=/home/user/.config/syncthing/data"
          ];
        };

        programs = {
          zsh = {
            enable = true;
            dotDir = "/home/user/.config/zsh";
            history.path = "/home/user/.config/zsh/.zsh_history";
            shellAliases = {
              "nx-check" = "nix flake check";
              "nx-rebuild" = "nixos-rebuild --flake davidzarandi/infra__nixos-config#";
            };
          };
        };

        packages = with pkgs; [
          webstorm
          #datagrip
          qutebrowser-qt5
        ];

        extraOptions = {
          qt.enable = true;
          qt.platformTheme = "kde";
          qt.style.name = "breeze";
        };
      };
    };

    virtualization = {
      enable = true;
      isHost = true;
    };

    secrets = {
      syncthing_id = {
        owner = "user";
      };
      zerotier_network_id = {
        owner = "root";
      };
    };

    # DO NOT TOUCH THIS!!!
    # https://nixos.org/manual/nixos/stable/options.html#opt-system.stateVersion
    stateVersion = "23.11";
  };
}