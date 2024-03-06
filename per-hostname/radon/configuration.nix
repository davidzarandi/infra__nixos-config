{ pkgs, lib, config, nixos-hardware, ... }: {
  extraModules = [
    (import ../../global/modules/services/zerotierone.nix { inherit pkgs config lib; })
    nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
  ];

  system = {
    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
      initrd.kernelModules = [ "amdgpu" ];
      kernelModules = [ "amdgpu" "kvm-amd" ];
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
      xserver.videoDrivers = [ "amdgpu" ];
      xserver.modules = [ pkgs.xorg.xf86videoamdgpu ];
      xserver.displayManager.sddm.enable = true;
      xserver.displayManager.defaultSession = "plasmawayland";
      xserver.desktopManager.plasma5.enable = true;

      printing.enable = true;
      printing.drivers = [ pkgs.cnijfilter2 ];
      avahi.enable = true;
      avahi.nssmdns = true;
      avahi.openFirewall = true;

      pipewire.enable = true;
      pipewire.alsa.enable = true;
      pipewire.alsa.support32Bit = true;
      pipewire.pulse.enable = true;
      pipewire.wireplumber.enable = true;

      pcscd.enable = true;
    };

    packages = with pkgs; [
      git
      neovim
      microcodeAmd
      pinentry
      pinentry-qt
      libsForQt5.xdg-desktop-portal-kde
      libsForQt5.breeze-qt5
      libsForQt5.breeze-gtk
      libsForQt5.breeze-icons
    ];

    variables = {
      TERMINAL = "konsole";
      EDITOR = "nvim";
      VISUAL = "kate";
    };

    extraOptions = {
      hardware.cpu.amd.updateMicrocode = true;
      hardware.enableRedistributableFirmware = true;
      hardware.bluetooth.enable = true;
      security.rtkit.enable = true;

      xdg.portal.enable = true;
      xdg.portal.xdgOpenUsePortal = true;
      xdg.portal.config = {
        common.default = "kde";
      };
      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-kde ];

      programs.dconf.enable = true;
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryFlavor = "qt";
      };

      fonts.packages = with pkgs; [
        hack-font
        dina-font
        unicode-emoji
        font-awesome
      ];
      fonts.fontDir.enable = true;

      nix.settings.auto-optimise-store = true;
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 3d";
      };
    };
  };

  user = {
    shell = pkgs.zsh;

    extraGroups = [ ];

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
        };
        plasma = {
          enable = true;
          workspace = {
            clickItemTo = "select";
            lookAndFeel = "org.kde.breezedark.desktop";
            theme = "breeze-dark";
            colorScheme = "Breeze Dark";
          };
          kwin.titlebarButtons = {
            left = [ "close" "maximize" "minimize" ];
            right = [ ];
          };
          shortcuts.kwin = {
            "Switch Window Down" = "Meta+J";
            "Switch Window Left" = "Meta+H";
            "Switch Window Right" = "Meta+L";
            "Switch Window Up" = "Meta+K";
          };
          configFile = {
            "kdeglobals"."General" = {
              "font" = "Hack,10,-1,5,50,0,0,0,0,0";
              "menuFont" = "Hack,10,-1,5,50,0,0,0,0,0";
              "smallestReadableFont" = "Hack,8,-1,5,50,0,0,0,0,0";
              "toolBarFont" = "Hack,10,-1,5,50,0,0,0,0,0";
            };
            "kdeglobals"."WM"."activeFont" = "Hack,10,-1,5,50,0,0,0,0,0";
          };
        };
        git = {
          enable = true;
          signing = {
            key = "2B82DB8BC26A0574";
            signByDefault = true;
          };
          userEmail = "noreply@zdaav.eu";
          userName = "Dávid J. Zarándi";
        };
      };

      packages = with pkgs; [
        webstorm
        datagrip
        qutebrowser
        keepassxc
      ];

      extraOptions = {
        qt.enable = true;
        qt.platformTheme = "kde";
        qt.style.name = "Breeze";
      };
    };
  };

  virtualization = {
    enable = true;
    isHost = true;
  };

  secrets = {
    zerotier_network_id = {
      owner = "root";
    };
    "syncthing/cert.pem.bin" = {
      owner = "user";
      format = "binary";
      sopsFile = ../../global/secrets/syncthing/cert.pem.bin;
      path = "/home/user/.config/syncthing/config/cert.pem";
    };
    "syncthing/config.xml.bin" = {
      owner = "user";
      format = "binary";
      sopsFile = ../../global/secrets/syncthing/config.xml.bin;
      path = "/home/user/.config/syncthing/config/config.xml";
    };
    "syncthing/config.xml.v0.bin" = {
      owner = "user";
      format = "binary";
      sopsFile = ../../global/secrets/syncthing/config.xml.v0.bin;
      path = "/home/user/.config/syncthing/config/config.xml.v0";
    };
    "syncthing/https-cert.pem.bin" = {
      owner = "user";
      format = "binary";
      sopsFile = ../../global/secrets/syncthing/https-cert.pem.bin;
      path = "/home/user/.config/syncthing/config/https-cert.pem";
    };
    "syncthing/https-key.pem.bin" = {
      owner = "user";
      format = "binary";
      sopsFile = ../../global/secrets/syncthing/https-key.pem.bin;
      path = "/home/user/.config/syncthing/config/https-key.pem";
    };
    "syncthing/key.pem.bin" = {
      owner = "user";
      format = "binary";
      sopsFile = ../../global/secrets/syncthing/key.pem.bin;
      path = "/home/user/.config/syncthing/config/key.pem";
    };
    "keepassxc/keepassxcrc.bin" = {
      owner = "user";
      format = "binary";
      sopsFile = ../../global/secrets/keepassxc/keepassxcrc.bin;
      path = "/home/user/.config/KeePassXCrc";
    };
    "keepassxc/keepassxc.ini.bin" = {
      owner = "user";
      format = "binary";
      sopsFile = ../../global/secrets/keepassxc/keepassxc.ini.bin;
      path = "/home/user/.config/keepassxc/keepassxc.ini";
    };
  };

  # DO NOT TOUCH THIS!!!
  # https://nixos.org/manual/nixos/stable/options.html#opt-system.stateVersion
  stateVersion = "23.11";
}
