{
  architecture = "x86_64";
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

  # DO NOT TOUCH THIS!!!
  # https://nixos.org/manual/nixos/stable/options.html#opt-system.stateVersion
  stateVersion = "23.11";
}